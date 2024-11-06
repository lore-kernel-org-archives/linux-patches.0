Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF5B1E00B0;
	Wed,  6 Nov 2024 12:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897471; cv=none; b=hvHG/FHylzcjpcn3EnFMnqM33R9uAZU8bLy89j9eBAsz1ymzdt1RpT2NKzumDpyXhZjUgYFoi1nzRkqqQO4wC46JCqsNjeaH8AZE23JnyWy8aa/QvHknNelVua8E/4O+QeULuuBLR3EREXKGRfuqpks8ZxSuBIn2dQZNz3AFIA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897471; c=relaxed/simple;
	bh=4wKBuyW7Kl1dTHdFdZ4czhD72bm9BAualB55eiMXFE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgOrwrfbXDS1IYjvRc2ZdtI7kiC1mtXrfPC7mMFOtb+znKGqQgNFMVoBRYRDRiusNGTF/e+f7nGSpjwRevZd03Axj9yxanmCBBvMojrDuMEPogukTNJuAlqSs8mHIDGI0LmfigMMXaKup+RfV5jMsATItjWoiIZSsJiAIxFlElM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GclrnAkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GclrnAkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DD6C4CECD;
	Wed,  6 Nov 2024 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897471;
	bh=4wKBuyW7Kl1dTHdFdZ4czhD72bm9BAualB55eiMXFE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GclrnAkUSBBiK6IuVlNe6nZZTpkIiVjkRdY71UFpB32vF92zQiQ09mQxt4QthRMCs
	 3xKu4ZwrqQltR66oYEkrHRUuDATz+mRSwQVwnQQdwFaF2G+R6TriF9L6FwpFRMZA8W
	 EJUG0zdozoqDMaW9yGdlcrjVcVnOim9bu/k5fc5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/151] fs/ntfs3: Additional check in ntfs_file_release
Date: Wed,  6 Nov 2024 13:04:11 +0100
Message-ID: <20241106120310.573925779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 031d6f608290c847ba6378322d0986d08d1a645a ]

Reported-by: syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index f14d21b6c6d39..2ecd0303f9421 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1173,7 +1173,14 @@ static int ntfs_file_release(struct inode *inode, struct file *file)
 	/* If we are last writer on the inode, drop the block reservation. */
 	if (sbi->options->prealloc &&
 	    ((file->f_mode & FMODE_WRITE) &&
-	     atomic_read(&inode->i_writecount) == 1)) {
+	     atomic_read(&inode->i_writecount) == 1)
+	   /*
+	    * The only file when inode->i_fop = &ntfs_file_operations and
+	    * init_rwsem(&ni->file.run_lock) is not called explicitly is MFT.
+	    *
+	    * Add additional check here.
+	    */
+	    && inode->i_ino != MFT_REC_MFT) {
 		ni_lock(ni);
 		down_write(&ni->file.run_lock);
 
-- 
2.43.0



