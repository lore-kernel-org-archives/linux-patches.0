Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9581E8855;
	Wed, 19 Feb 2025 08:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955335; cv=none; b=aDhtzfEbqyn0GQNNI4AdRG9SVPt/wK/CcUL9L3YrRyXWDWwogQUuK16rVL/YW2Falpm+Sm+G2yD/2a7ZexLWbtSihP50v48n0G/TJzdaFEL0FyGkzT+w0iHh/mjtpTZqSJHcDiMMTYxrm0al6+y5f5wwZAUl9cfdeAKTJILRHV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955335; c=relaxed/simple;
	bh=E9SmRarCItTobkmH/rVe15gX1XCq55z8ceOX59Bw37E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vat43BWliv87bqMoTEr9jMfKOs0QJ9vtrVR+HX8dp6F0nkXfYgcNYqCFOHacvOSsxVcCYrZchljE3yT1G/UpsFtiCvJ9av37ITkkV/awh6gz3SFUtiSB1Yye1yfWvoBGInGl9U6Z++zFZRgNuxKZ/Wewi05SlJxjDRzjTvBFN5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TepUrBpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TepUrBpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AE9C4CED1;
	Wed, 19 Feb 2025 08:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955335;
	bh=E9SmRarCItTobkmH/rVe15gX1XCq55z8ceOX59Bw37E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TepUrBpDFoLxAEFsZMLXjZQ0YGaQlubOU/49YKbXglBeoNff2yg838K5L1YWUhK9i
	 BenFAWGNvYdg+B4zzpqJ4bWj0jL5ry5r8n2JdWm0l2GC4mEewp370ofyq67sqPZv+V
	 AI5vgq9gZni1Fv+SWpe7GNzW7uIGx0tLqc6kR00w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 162/230] btrfs: fix hole expansion when writing at an offset beyond EOF
Date: Wed, 19 Feb 2025 09:27:59 +0100
Message-ID: <20250219082608.033803132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1148,7 +1148,6 @@ int btrfs_write_check(struct kiocb *iocb
 	loff_t pos = iocb->ki_pos;
 	int ret;
 	loff_t oldsize;
-	loff_t start_pos;
 
 	/*
 	 * Quickly bail out on NOWAIT writes if we don't have the nodatacow or
@@ -1172,9 +1171,8 @@ int btrfs_write_check(struct kiocb *iocb
 	 */
 	update_time_for_write(inode);
 
-	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
-	if (start_pos > oldsize) {
+	if (pos > oldsize) {
 		/* Expand hole size to cover write data, preventing empty gap */
 		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
 


