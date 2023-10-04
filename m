Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305BB1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40ACC433C9;
	Wed,  4 Oct 2023 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442925;
	bh=N6+GVCsLStHrFn95fGIQQMzcS5vRQetzK40XtumKSg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8oN0xSnrNZNp6rkSOomjMg5wCUm8Adr+dLMErjAxsRtomRlAbnwYLTTLgaVO5Uj6
	 Km6aXW7HSgz5mQiHtA5QSN6dh6OpeQxVaSi/mIhC6XckIYrTQltFvub7NGSam90q1k
	 ZM2S3qOqi5i7kFr7UR6xqr9EN2jeOjSaiR12tqE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/183] smb3: correct places where ENOTSUPP is used instead of preferred EOPNOTSUPP
Date: Wed,  4 Oct 2023 19:56:00 +0200
Message-ID: <20231004175209.350152528@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit ebc3d4e44a7e05457825e03d0560153687265523 ]

checkpatch flagged a few places with:
     WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
Also fixed minor typo

Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c   | 2 +-
 fs/cifs/smb2ops.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 82848412ad852..30a9a89c141bb 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2531,7 +2531,7 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 	}
 
 	cifsFileInfo_put(cfile);
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int cifs_truncate_page(struct address_space *mapping, loff_t from)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 560c4ababfe1a..d8ce079ba9091 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -266,7 +266,7 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 		cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
 				credits->value, new_val);
 
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	spin_lock(&server->req_lock);
@@ -1308,7 +1308,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 			/* Use a fudge factor of 256 bytes in case we collide
 			 * with a different set_EAs command.
 			 */
-			if(CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
+			if (CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
 			   MAX_SMB2_CLOSE_RESPONSE_SIZE - 256 <
 			   used_len + ea_name_len + ea_value_len + 1) {
 				rc = -ENOSPC;
@@ -4822,7 +4822,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 
 	if (shdr->Command != SMB2_READ) {
 		cifs_server_dbg(VFS, "only big read responses are supported\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	if (server->ops->is_session_expired &&
-- 
2.40.1



