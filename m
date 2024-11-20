Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2201CACDC;
	Wed, 20 Nov 2024 13:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107679; cv=none; b=LaLw28BfiVTw2juE+5eU13iMQaeSoOQ8fxioec/69Y+WGQ6rehBuFIScAlFnlm91HKHQSf4lusd04ZtWktzoUfAQ4We42CD7afzPK8A8iNy9BPAAL8rWVeDLYtnxi93mbBtKUovDbstNjre5m4qlmsuwis+QBXTm/Kav/KCqGds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107679; c=relaxed/simple;
	bh=bl0njdsLTwiAH5PxDikXOtaPbQqqBdoslq5hqWIc9Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFmIkfYVUA9rxbUZqxE2vzfNKeT7eYDh9UCcivyiOZCBa0hKX3D9GfrWhQJEkARMkJujXsLScPjSpeNSE/hrNZ3MtuxpJhCtM0WHBmbMT/o0bahUC9EBNDVa/NdgOJGYwS4WRBFmrHykxZtqv0xqG8NYMo3WOkb4evcm4iZwqB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkTOLmfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkTOLmfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAF0C4CECD;
	Wed, 20 Nov 2024 13:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107679;
	bh=bl0njdsLTwiAH5PxDikXOtaPbQqqBdoslq5hqWIc9Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkTOLmfACsNGEAjEWVGgvKpHXsysbTKpxm7qlFKTKtCrIePGTrPA24FTNRkCyhc7n
	 /arQvKoQG5HMmmRTNjXhiZO9amNZFUw8Er7iWmN76LgBSfT0KmSgWjR4Sq+2XJ2Q65
	 vLr4/iQkjPzcFzV1+1yGEuukAXR5eHjXw/cGs1HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/73] fs/ntfs3: Additional check in ntfs_file_release
Date: Wed, 20 Nov 2024 13:58:22 +0100
Message-ID: <20241120125810.476413367@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 031d6f608290c847ba6378322d0986d08d1a645a ]

Reported-by: syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index aedd4f5f459e6..70b38465aee36 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1214,8 +1214,16 @@ static int ntfs_file_release(struct inode *inode, struct file *file)
 	int err = 0;
 
 	/* If we are last writer on the inode, drop the block reservation. */
-	if (sbi->options->prealloc && ((file->f_mode & FMODE_WRITE) &&
-				      atomic_read(&inode->i_writecount) == 1)) {
+	if (sbi->options->prealloc &&
+	    ((file->f_mode & FMODE_WRITE) &&
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



