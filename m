Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE9117A2E8;
	Mon, 10 Mar 2025 18:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629736; cv=none; b=JjcqmqU/2meDjgf9J+al1rYEszxpXN3h7xq/YGymXZo1TtcSsJQ+MWn97k/YxF4j8ec+oTdTcO75dDe39f8QhHsIj8Mc5xeZ6e5gr8kgblWyZ7aVg5LdXl7xc1gzV43khPYTF8M3uHhs0MvU/SDT06reDWKlsstKpoIi/Sm1AGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629736; c=relaxed/simple;
	bh=QVKeZ2q/2+JxQrEn0NcpRe1IW7RdkBRZme+GyJO61iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aniQ+rwwaYJbeGchDanU3YZusKg67OLTr+Xy46mtzAzg1KRxjmGceuinLJognRJDk3fX7TUfI3dScCxOw8zPjOU8tWkdUnumPmQrKaxav10zm00kWG78vUC+z6HOBpYZOw6rvbb7faxIdqfs0Z/Ri4jEjtvfzPPfb/FANfyAtmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLiO7q5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLiO7q5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4B7C4CEE5;
	Mon, 10 Mar 2025 18:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629736;
	bh=QVKeZ2q/2+JxQrEn0NcpRe1IW7RdkBRZme+GyJO61iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLiO7q5vRoL7Bt7XVzlqsmS8KqpwEs9Gndm+kVA1fjwET8YUwdYC/+5L2VDtw0CrJ
	 z9zMwLqHcNiF4Qsc99+ANdsdvfuzc8oTNELVPUOUyDIW9Oczgdp4TNOMw44lTdiwOv
	 svRH3cv6Ce/S5selkt9JjsokeT25Um3AcUH8f2B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 388/620] btrfs: fix hole expansion when writing at an offset beyond EOF
Date: Mon, 10 Mar 2025 18:03:54 +0100
Message-ID: <20250310170600.912025287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1607,7 +1607,6 @@ static int btrfs_write_check(struct kioc
 	loff_t pos = iocb->ki_pos;
 	int ret;
 	loff_t oldsize;
-	loff_t start_pos;
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		size_t nocow_bytes = count;
@@ -1637,9 +1636,8 @@ static int btrfs_write_check(struct kioc
 	 */
 	update_time_for_write(inode);
 
-	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
-	if (start_pos > oldsize) {
+	if (pos > oldsize) {
 		/* Expand hole size to cover write data, preventing empty gap */
 		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
 


