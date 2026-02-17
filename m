Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04078280CC1;
	Tue, 17 Feb 2026 20:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361664; cv=none; b=h+0ZJME58DKEfTlPy3SDlCHCMCASb948F6XL8CAI5VBSzhUmp408miVLtjxO3gTgBsT0SkfasHi1+nHTksbIxwLevszczJarU130KzbILqxyGPpyH7vpWDTOBxWGKAq9Wpn8nJyK0lz9xraIVQhbrUOhKP+zkZjOW7WjtK+UUdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361664; c=relaxed/simple;
	bh=NSpH+uJJHJfhpdjY60d9a27uKRrTQQwpxAgcGzLf4bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+vVHVszH371j9Rlxzb/B2MEdQeOAsrfqSs7NucE2PuyAEzXfZdw8WUlNY8yaEo4mz5dK20GDVbdpfr11ZNG5VC/XrxjjgLZfWsQ3fPPxJePaLmrvs+NChDb8JTis04jnze+kEUlSc8YgonbRA6xb95oQ6jti7UsN7fhAE+P/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmbIy4ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmbIy4ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621D0C4CEF7;
	Tue, 17 Feb 2026 20:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361663;
	bh=NSpH+uJJHJfhpdjY60d9a27uKRrTQQwpxAgcGzLf4bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmbIy4ZHfdLBxN1QCyFQ7x1iyn5LSSxselWGLCe++9VP2uUdkdKcUBR+swWpQHbpF
	 uUaCTkBo3LAhmqts0ETrHdKLwfRN/p1GqzUOmHWTAJfKOPQpb9dPAjXesAqQZ3U1E/
	 QRyecadYowQFVx0qTvyy3KSdgxAPvj7r4+FlBfEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Xiaolong Guo <guoxiaolong2008@gmail.com>
Subject: [PATCH 6.12 38/42] f2fs: fix to avoid mapping wrong physical block for swapfile
Date: Tue, 17 Feb 2026 21:32:29 +0100
Message-ID: <20260217200007.455799429@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 5c145c03188bc9ba1c29e0bc4d527a5978fc47f9 upstream.

Xiaolong Guo reported a f2fs bug in bugzilla [1]

[1] https://bugzilla.kernel.org/show_bug.cgi?id=220951

Quoted:

"When using stress-ng's swap stress test on F2FS filesystem with kernel 6.6+,
the system experiences data corruption leading to either:
1 dm-verity corruption errors and device reboot
2 F2FS node corruption errors and boot hangs

The issue occurs specifically when:
1 Using F2FS filesystem (ext4 is unaffected)
2 Swapfile size is less than F2FS section size (2MB)
3 Swapfile has fragmented physical layout (multiple non-contiguous extents)
4 Kernel version is 6.6+ (6.1 is unaffected)

The root cause is in check_swap_activate() function in fs/f2fs/data.c. When the
first extent of a small swapfile (< 2MB) is not aligned to section boundaries,
the function incorrectly treats it as the last extent, failing to map
subsequent extents. This results in incorrect swap_extent creation where only
the first extent is mapped, causing subsequent swap writes to overwrite wrong
physical locations (other files' data).

Steps to Reproduce
1 Setup a device with F2FS-formatted userdata partition
2 Compile stress-ng from https://github.com/ColinIanKing/stress-ng
3 Run swap stress test: (Android devices)
adb shell "cd /data/stressng; ./stress-ng-64 --metrics-brief --timeout 60
--swap 0"

Log:
1 Ftrace shows in kernel 6.6, only first extent is mapped during second
f2fs_map_blocks call in check_swap_activate():
stress-ng-swap-8990: f2fs_map_blocks: ino=11002, file offset=0, start
blkaddr=0x43143, len=0x1
(Only 4KB mapped, not the full swapfile)
2 in kernel 6.1, both extents are correctly mapped:
stress-ng-swap-5966: f2fs_map_blocks: ino=28011, file offset=0, start
blkaddr=0x13cd4, len=0x1
stress-ng-swap-5966: f2fs_map_blocks: ino=28011, file offset=1, start
blkaddr=0x60c84b, len=0xff

The problematic code is in check_swap_activate():
if ((pblock - SM_I(sbi)->main_blkaddr) % blks_per_sec ||
    nr_pblocks % blks_per_sec ||
    !f2fs_valid_pinned_area(sbi, pblock)) {
    bool last_extent = false;

    not_aligned++;

    nr_pblocks = roundup(nr_pblocks, blks_per_sec);
    if (cur_lblock + nr_pblocks > sis->max)
        nr_pblocks -= blks_per_sec;

    /* this extent is last one */
    if (!nr_pblocks) {
        nr_pblocks = last_lblock - cur_lblock;
        last_extent = true;
    }

    ret = f2fs_migrate_blocks(inode, cur_lblock, nr_pblocks);
    if (ret) {
        if (ret == -ENOENT)
            ret = -EINVAL;
        goto out;
    }

    if (!last_extent)
        goto retry;
}

When the first extent is unaligned and roundup(nr_pblocks, blks_per_sec)
exceeds sis->max, we subtract blks_per_sec resulting in nr_pblocks = 0. The
code then incorrectly assumes this is the last extent, sets nr_pblocks =
last_lblock - cur_lblock (entire swapfile), and performs migration. After
migration, it doesn't retry mapping, so subsequent extents are never processed.
"

In order to fix this issue, we need to lookup block mapping info after
we migrate all blocks in the tail of swapfile.

Cc: stable@kernel.org
Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Cc: Daeho Jeong <daehojeong@google.com>
Reported-and-tested-by: Xiaolong Guo <guoxiaolong2008@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220951
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3980,6 +3980,7 @@ static int check_swap_activate(struct sw
 
 	while (cur_lblock < last_lblock && cur_lblock < sis->max) {
 		struct f2fs_map_blocks map;
+		bool last_extent = false;
 retry:
 		cond_resched();
 
@@ -4005,11 +4006,10 @@ retry:
 		pblock = map.m_pblk;
 		nr_pblocks = map.m_len;
 
-		if ((pblock - SM_I(sbi)->main_blkaddr) % blks_per_sec ||
-				nr_pblocks % blks_per_sec ||
-				f2fs_is_sequential_zone_area(sbi, pblock)) {
-			bool last_extent = false;
-
+		if (!last_extent &&
+			((pblock - SM_I(sbi)->main_blkaddr) % blks_per_sec ||
+			nr_pblocks % blks_per_sec ||
+			f2fs_is_sequential_zone_area(sbi, pblock))) {
 			not_aligned++;
 
 			nr_pblocks = roundup(nr_pblocks, blks_per_sec);
@@ -4030,8 +4030,8 @@ retry:
 				goto out;
 			}
 
-			if (!last_extent)
-				goto retry;
+			/* lookup block mapping info after block migration */
+			goto retry;
 		}
 
 		if (cur_lblock + nr_pblocks >= sis->max)


