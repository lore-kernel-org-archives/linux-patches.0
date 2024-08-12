Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AF11494B8;
	Mon, 12 Aug 2024 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480656; cv=none; b=mWjUOekBTNi8mcrP7lTAf3UvN+igfZ29ln92V9b4wL8bElH1GVbvogMEtA64O4y6yaVDW6hwVhRJ3es4d2Sen41dcYKeE6NlbMfhzNQXD05elyQCLNeNg5MBpGmcyR6+P0ezo/FIKwtsxGQmSN1boyH7RHL7zUUAlnyI9GRALv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480656; c=relaxed/simple;
	bh=xoRDKSLB/3+hR0TBLhXqS+2K+KdfSfYVm37FiynHtk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duejlK3+38+ZGlTo7GTU3p9KHASfoz/OAxwMjrVaYoBSgtM74neTzD/Qp4yOjtpg5dklUThjAObOUuWakK0SRFUEfAdj59+DCNBp2+tXBiVD7TBQckd8dDGWNRYujhlHLqrBex+ceaI68WYxnsin5QPoTcyiSt+qARYhNg8Xr+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07egJZKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07egJZKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E13C32782;
	Mon, 12 Aug 2024 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480656;
	bh=xoRDKSLB/3+hR0TBLhXqS+2K+KdfSfYVm37FiynHtk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07egJZKC3/Hn0IWH1YB7JQ8s15ifxR5YfyEPqGUMOp4+beozx0agO1yujB1AyT3bT
	 Hmj/UX/gmM3MWAwMbsiIUg/ASHUCLqzam1rVwCoIDV+n2KB8+aSHtuysboKbZcxRWG
	 8GX0A79T5FqwSwtvEQygprhai1ZGDqf80ggazO2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7dbbb74af6291b5a5a8b@syzkaller.appspotmail.com,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 263/263] btrfs: fix double inode unlock for direct IO sync writes
Date: Mon, 12 Aug 2024 18:04:24 +0200
Message-ID: <20240812160156.723201804@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit e0391e92f9ab4fb3dbdeb139c967dcfa7ac4b115 upstream.

If we do a direct IO sync write, at btrfs_sync_file(), and we need to skip
inode logging or we get an error starting a transaction or an error when
flushing delalloc, we end up unlocking the inode when we shouldn't under
the 'out_release_extents' label, and then unlock it again at
btrfs_direct_write().

Fix that by checking if we have to skip inode unlocking under that label.

Reported-by: syzbot+7dbbb74af6291b5a5a8b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/linux-btrfs/000000000000dfd631061eaeb4bc@google.com/
Fixes: 939b656bc8ab ("btrfs: fix corruption after buffer fault in during direct IO append write")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2080,7 +2080,10 @@ out:
 
 out_release_extents:
 	btrfs_release_log_ctx_extents(&ctx);
-	btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
+	if (skip_ilock)
+		up_write(&BTRFS_I(inode)->i_mmap_lock);
+	else
+		btrfs_inode_unlock(BTRFS_I(inode), BTRFS_ILOCK_MMAP);
 	goto out;
 }
 


