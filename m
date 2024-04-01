Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FED3F8F4;
	Mon,  1 Apr 2024 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988329; cv=none; b=P0HfLd8cQLWIHiy1n6R0/Ynlv1KuJKPKPFfQNVtg0x+xAXzIwhnHUkms+o8C0lc6pQVCPbox5PdUWgQHifpRJPtCV1jLZAOXoY5GSWu9luXLwtn+dAVgfuYZ5vhJ0Zinkz+uTGoeI/eH/Q3BszJOUDQ0apNcADfksSRQ8Au/Q4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988329; c=relaxed/simple;
	bh=pysIJr9buRZrZNHBllczyu8YSq8TNX+Mrn4y5sbTj3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4Tua/u/L+R42KKcvk8/qe3ayr5i/BmGgPFIt1qNGy0EllwG+Vq0CxTZj9weJuffts1pLVgqD3qrbU0M1fOgFTPTz9wuxsznk9PHYtrGxnaGIl/Yp81J0Y9RacpynwNFAc2uste/8G7fwHTa6jvXNcw6h7YYRWKLzlni/zby2b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysnaIIVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysnaIIVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234D4C43390;
	Mon,  1 Apr 2024 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988329;
	bh=pysIJr9buRZrZNHBllczyu8YSq8TNX+Mrn4y5sbTj3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysnaIIVFf83nTvzrtDywCFBNA/ZRRvKgVTeJc5BvgfgBTdwXb2K/Z21z/UfUwXWk4
	 Z+xLyOwm9fGrCsf6yZn6PIJ8GiW7eQ/GbSa3BlK/J175o6lKGQFtscAPK29U6q8n/J
	 37hwAgJr1qa2aoFTRYk509lwFJcPeWR/mRnWx87A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 152/432] ksmbd: retrieve number of blocks using vfs_getattr in set_file_allocation_info
Date: Mon,  1 Apr 2024 17:42:19 +0200
Message-ID: <20240401152557.669631617@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f6cc5d2730ffb..199c31c275e5b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5809,15 +5809,21 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 
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
@@ -5825,7 +5831,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < inode->i_blocks) {
+	} else if (alloc_blks < stat.blocks) {
 		loff_t size;
 
 		/*
-- 
2.43.0



