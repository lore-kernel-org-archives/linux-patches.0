Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DFD1E1C0F;
	Wed, 19 Feb 2025 09:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957462; cv=none; b=F2KaOF4WJ4ec0iWsxaCJXAvZxjr10mzF/NjBm1TroFCUfN0ILmrEn2OcIcl/avizRGjQ6F4BYhbtrrCDBFoS4ByWLmuBmXrULtZBj8Yc0/lEWC/ljywrCh2FmT7YC3Mh3e5vtoTRK46t9ecXPpV4W8pzAaEguaXemwb/FYW6paY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957462; c=relaxed/simple;
	bh=PV1+7TzcW/IS25Rb0hkIXsBcrTFGMwA+nIz5a/CDsqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loXTi5kWIhDBzrfbBd6k5vOyfztaVzMLCH/8kCBVvAFIs6hC5TVdyrXYC5A89gbuVrJpk69q8lwSfGWJ1hbcVzoKrHDJRxYVSYeXsQ5+H/AyT1vdBA/MUsI1anTsRZ0U0u/w+tiImNojua0VlqV4C4biLz49O4tbhlCATfYra+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbPv2ehH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbPv2ehH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3C2C4CED1;
	Wed, 19 Feb 2025 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957462;
	bh=PV1+7TzcW/IS25Rb0hkIXsBcrTFGMwA+nIz5a/CDsqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbPv2ehH9lk0xzrXjoyPHzjdSTNuBohUU8zhJ/EBLingZJLsBLvZlOCPYdS/AN2JN
	 5k118ojdiViJpii4GUOAl4jBIiOJ5gAMnrepWvDc18lXpJWsPFT5DqaKbrgCj5CYB6
	 A+iz+9VK4p97WEUTO+GgWm2EIRwZI9VeeIvXSS2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 535/578] btrfs: fix hole expansion when writing at an offset beyond EOF
Date: Wed, 19 Feb 2025 09:28:59 +0100
Message-ID: <20250219082714.022429500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit da2dccd7451de62b175fb8f0808d644959e964c7 upstream.

At btrfs_write_check() if our file's i_size is not sector size aligned and
we have a write that starts at an offset larger than the i_size that falls
within the same page of the i_size, then we end up not zeroing the file
range [i_size, write_offset).

The code is this:

    start_pos = round_down(pos, fs_info->sectorsize);
    oldsize = i_size_read(inode);
    if (start_pos > oldsize) {
        /* Expand hole size to cover write data, preventing empty gap */
        loff_t end_pos = round_up(pos + count, fs_info->sectorsize);

        ret = btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
        if (ret)
            return ret;
    }

So if our file's i_size is 90269 bytes and a write at offset 90365 bytes
comes in, we get 'start_pos' set to 90112 bytes, which is less than the
i_size and therefore we don't zero out the range [90269, 90365) by
calling btrfs_cont_expand().

This is an old bug introduced in commit 9036c10208e1 ("Btrfs: update hole
handling v2"), from 2008, and the buggy code got moved around over the
years.

Fix this by discarding 'start_pos' and comparing against the write offset
('pos') without any alignment.

This bug was recently exposed by test case generic/363 which tests this
scenario by polluting ranges beyond EOF with an mmap write and than verify
that after a file increases we get zeroes for the range which is supposed
to be a hole and not what we wrote with the previous mmaped write.

We're only seeing this exposed now because generic/363 used to run only
on xfs until last Sunday's fstests update.

The test was failing like this:

   $ ./check generic/363
   FSTYP         -- btrfs
   PLATFORM      -- Linux/x86_64 debian0 6.13.0-rc7-btrfs-next-185+ #17 SMP PREEMPT_DYNAMIC Mon Feb  3 12:28:46 WET 2025
   MKFS_OPTIONS  -- /dev/sdc
   MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

   generic/363 0s ... [failed, exit status 1]- output mismatch (see /home/fdmanana/git/hub/xfstests/results//generic/363.out.bad)
#      --- tests/generic/363.out	2025-02-05 15:31:14.013646509 +0000
#      +++ /home/fdmanana/git/hub/xfstests/results//generic/363.out.bad	2025-02-05 17:25:33.112630781 +0000
       @@ -1 +1,46 @@
        QA output created by 363
       +READ BAD DATA: offset = 0xdcad, size = 0xd921, fname = /home/fdmanana/btrfs-tests/dev/junk
       +OFFSET      GOOD    BAD     RANGE
       +0x1609d     0x0000  0x3104  0x0
       +operation# (mod 256) for the bad data may be 4
       +0x1609e     0x0000  0x0472  0x1
       +operation# (mod 256) for the bad data may be 4
       ...
       (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/generic/363.out /home/fdmanana/git/hub/xfstests/results//generic/363.out.bad'  to see the entire diff)
   Ran: generic/363
   Failures: generic/363
   Failed 1 of 1 tests

Fixes: 9036c10208e1 ("Btrfs: update hole handling v2")
CC: stable@vger.kernel.org
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1122,7 +1122,6 @@ static int btrfs_write_check(struct kioc
 	loff_t pos = iocb->ki_pos;
 	int ret;
 	loff_t oldsize;
-	loff_t start_pos;
 
 	/*
 	 * Quickly bail out on NOWAIT writes if we don't have the nodatacow or
@@ -1147,9 +1146,8 @@ static int btrfs_write_check(struct kioc
 	 */
 	update_time_for_write(inode);
 
-	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
-	if (start_pos > oldsize) {
+	if (pos > oldsize) {
 		/* Expand hole size to cover write data, preventing empty gap */
 		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
 


