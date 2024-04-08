Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEB26F08E;
	Mon,  8 Apr 2024 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581823; cv=none; b=IHYAljfYydu8SviKZZ16WqxWBNvEJ9Q6DukfbfFWtkOmU488tqPyj2uG55qAp29sJUmVVLsbznEA2s3HSoYQ/1g40ZHeOIZVUIvsVgSTw6KVCtNs8MFk/TspehwBsdRi41M9X7IXzyVQoc0RfJRCSFb0NLbElHZEe75/fVSm0tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581823; c=relaxed/simple;
	bh=RfpyX1zdLYZwarg1juQD3Z4jGXNF4YokuTgopjsAklI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMrCe1PVdFOsDqV5tsYpVKOMXMDXfargxObWYNpg2USs9l/i4XAQtUZn5IQmqvfqhXaa5teMANVXg1QvPf95RWtJjqNQVskOLpyNRUaKv3gyA1K/kXKY4ZNHZBj+8M2jbDEZhcwBnWaUkp06eTWAlUuoF9+RgMMAzCuvxtBwrEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsCAW09r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsCAW09r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A4C433F1;
	Mon,  8 Apr 2024 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581823;
	bh=RfpyX1zdLYZwarg1juQD3Z4jGXNF4YokuTgopjsAklI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsCAW09rvZ+GCUPS5dQy6t1F4T0Jzd2irLiyWfvwFUl9x9ET0Lh7cnOfU6W7Txd8M
	 Sc0vZot3oe+vqY0AMkgc02YEVZ0WwaLzbdrL/uymN09HNJTk1daPqVMcsB6FBvCyBF
	 txb7ipIfMB6PH5e8KkmuJRixtMpioXU2LTuDz0a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/690] ksmbd: retrieve number of blocks using vfs_getattr in set_file_allocation_info
Date: Mon,  8 Apr 2024 14:49:11 +0200
Message-ID: <20240408125402.574684008@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 34cd86b6632718b7df3999d96f51e63de41c5e4f ]

Use vfs_getattr() to retrieve stat information, rather than make
assumptions about how a filesystem fills inode structs.

Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0613b8d14409c..14cd86a14012f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5759,15 +5759,21 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 
 	loff_t alloc_blks;
 	struct inode *inode;
+	struct kstat stat;
 	int rc;
 
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
+	rc = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			 AT_STATX_SYNC_AS_STAT);
+	if (rc)
+		return rc;
+
 	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;
 	inode = file_inode(fp->filp);
 
-	if (alloc_blks > inode->i_blocks) {
+	if (alloc_blks > stat.blocks) {
 		smb_break_all_levII_oplock(work, fp, 1);
 		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
 				   alloc_blks * 512);
@@ -5775,7 +5781,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < inode->i_blocks) {
+	} else if (alloc_blks < stat.blocks) {
 		loff_t size;
 
 		/*
-- 
2.43.0



