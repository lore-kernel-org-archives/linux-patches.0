Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5B114A4D9;
	Thu, 23 May 2024 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470709; cv=none; b=oJ0EZq6Jk3dMng5hHkUqyPmVmFBMSpXfmciUXNU7IdyjllVHZKq5YbgFQvPp/sexKBKfko3EIFsjfLwAWmYCh4/Nvw1G/uw3a12V5k1Fid1rZynCiqkfI/KG6Fsf2pLH/ImZniojL9ZG/mfkA/bb0KGT5YPB2Cyp8Gylv5Nr3P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470709; c=relaxed/simple;
	bh=fFXLQlzxdlgCBaswqY4f+/HQbUzVEwIMMzCFO10OQgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdkHDTe5f1wTyYCDVNKUhz/VZC0WRVfncjs+QIu5+u+taZofgjl60Q89hAC9fkDKx4PBT6HROCyWnHpbz+Z/vX7cW5miiRZ0JzMLlcKNuAMiY5YdakuzOljAyRLm4LQBMj/WNkQTYnCaDtaMDQYsxSkWAwc+immZOqdDTMHvphU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXVRwu58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXVRwu58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A4EC4AF08;
	Thu, 23 May 2024 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470708;
	bh=fFXLQlzxdlgCBaswqY4f+/HQbUzVEwIMMzCFO10OQgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXVRwu58E3LO+ypD9jhkRyg1AvT3ZNkSxq8bF4Q2lfsZ28cs/Q0o5tXxMUApks2Qm
	 cGhiLwxDvTs/X/IMD7xbPTn+J8fEXZwx+2myw+ET8FT6ub88UpTp+qGn4VD18qID2f
	 RrH/nlC+iExcj3bMFc7dYe5T1jDUOgAv25b73ULA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/102] cifs: defer close file handles having RH lease
Date: Thu, 23 May 2024 15:13:26 +0200
Message-ID: <20240523130344.771840678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit dc528770edb138e26a533f8a77de5c4db18ea7f3 ]

Previously we only deferred closing file handles with RHW
lease. To enhance performance benefits from deferred closes,
we now include handles with RH leases as well.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 8eaf195ef5604..6dc2e8db9c8ed 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1152,6 +1152,19 @@ void smb2_deferred_work_close(struct work_struct *work)
 	_cifsFileInfo_put(cfile, true, false);
 }
 
+static bool
+smb2_can_defer_close(struct inode *inode, struct cifs_deferred_close *dclose)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+
+	return (cifs_sb->ctx->closetimeo && cinode->lease_granted && dclose &&
+			(cinode->oplock == CIFS_CACHE_RHW_FLG ||
+			 cinode->oplock == CIFS_CACHE_RH_FLG) &&
+			!test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags));
+
+}
+
 int cifs_close(struct inode *inode, struct file *file)
 {
 	struct cifsFileInfo *cfile;
@@ -1165,10 +1178,8 @@ int cifs_close(struct inode *inode, struct file *file)
 		cfile = file->private_data;
 		file->private_data = NULL;
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
-		if ((cifs_sb->ctx->closetimeo && cinode->oplock == CIFS_CACHE_RHW_FLG)
-		    && cinode->lease_granted &&
-		    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
-		    dclose && !(cfile->status_file_deleted)) {
+		if ((cfile->status_file_deleted == false) &&
+		    (smb2_can_defer_close(inode, dclose))) {
 			if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
 				inode_set_mtime_to_ts(inode,
 						      inode_set_ctime_current(inode));
-- 
2.43.0



