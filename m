Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED91D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fy1go7ax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8CBC433C7;
	Wed,  4 Oct 2023 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443481;
	bh=KPPsJPe9XfG12UFVzfK5pUowDsp9iz/seWdWrGHPBAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fy1go7axxbd9NR35gi5QPoqYojDAinjBoNdGHnr/Fsa20an1NFuBRlmGEeK/l1m8g
	 HAqBaDNLscWQphxEYAK7bv/IGISNmHFDzIHqmvRFcMriN8WRMgyA8IyvOyApPJkXtX
	 V79DxVoAQnGENqwTGz0EsjEtF1t3DHQAed4RKUbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 172/259] smb3: correct places where ENOTSUPP is used instead of preferred EOPNOTSUPP
Date: Wed,  4 Oct 2023 19:55:45 +0200
Message-ID: <20231004175225.184071187@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit ebc3d4e44a7e05457825e03d0560153687265523 ]

checkpatch flagged a few places with:
     WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
Also fixed minor typo

Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c   | 2 +-
 fs/smb/client/smb2ops.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 92c1ed9304be7..9531ea2430899 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2605,7 +2605,7 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 	}
 
 	cifsFileInfo_put(cfile);
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 }
 
 int cifs_truncate_page(struct address_space *mapping, loff_t from)
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1387d5126f53b..efff7137412b4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -292,7 +292,7 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 		cifs_server_dbg(VFS, "request has less credits (%d) than required (%d)",
 				credits->value, new_val);
 
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	spin_lock(&server->req_lock);
@@ -1155,7 +1155,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 			/* Use a fudge factor of 256 bytes in case we collide
 			 * with a different set_EAs command.
 			 */
-			if(CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
+			if (CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
 			   MAX_SMB2_CLOSE_RESPONSE_SIZE - 256 <
 			   used_len + ea_name_len + ea_value_len + 1) {
 				rc = -ENOSPC;
@@ -4721,7 +4721,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 
 	if (shdr->Command != SMB2_READ) {
 		cifs_server_dbg(VFS, "only big read responses are supported\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	if (server->ops->is_session_expired &&
-- 
2.40.1



