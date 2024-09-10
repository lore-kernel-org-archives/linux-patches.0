Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B7B186E4B;
	Tue, 10 Sep 2024 09:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962049; cv=none; b=WnI13drdOQu8Wpg5CoID/0Cmfi1QZiCNa9hWGzRyeReaz3JsE7SeVbNHRiWq8Mqn6RRal3XQ7yJ5qidmizk0phdLLG7REW2vVzqwmzY5tqO0TbnzBRAhS8bJlD3mAM/gd2rzsFtlNaXnTe8sW6QwNPqHhpH4RNAE/+1ewor0QrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962049; c=relaxed/simple;
	bh=wuFwNbC1CGuNsjQx1ytw5JHtKGyvFTbUsPQcSD1iPk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzPvGfuyqj2lZXAncCIpJkS8bRGsjrEcT9UTNiu4qElOUZkSUttQCzrjiXCoOa4Yh+eo9Sa8G2weeMb1+8uh/cNF2Sp1EgqaNwE1VCsRkqdFZvVSvqnuLMXj54FSREIXY5jBvEWxrzQeu26dOVk0/gw3FTQNNKtmKbFvapeV7BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0Wr+I/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0Wr+I/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E9C4CEC6;
	Tue, 10 Sep 2024 09:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962049;
	bh=wuFwNbC1CGuNsjQx1ytw5JHtKGyvFTbUsPQcSD1iPk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0Wr+I/2Edg6vOs5sjJKkEMfGT2PYVT9Q2UbAwrx81ZbkevtLGMMCRXkgOx4lN23J
	 kCCoM2yz6riXVtuuthUGAIszuwNNUUhlxhT9OS96RtUFf/7QaED6+lnpxsXy6XMSDg
	 y8l0da5iDppeiGqXwiG6gnvP4Pw2BmlI4IdQJv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 277/375] smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
Date: Tue, 10 Sep 2024 11:31:14 +0200
Message-ID: <20240910092631.865789194@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 4e8771a3666c8f216eefd6bd2fd50121c6c437db ]

null-ptr-deref will occur when (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
and parse_lease_state() return NULL.

Fix this by check if 'lease_ctx_info' is NULL.

Additionally, remove the redundant parentheses in
parse_durable_handle_context().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c  |  2 +-
 fs/smb/server/smb2pdu.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a8f52c4ebbda..e546ffa57b55 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1510,7 +1510,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
  * parse_lease_state() - parse lease context containted in file open request
  * @open_req:	buffer containing smb2 file open(create) request
  *
- * Return:  oplock state, -ENOENT if create lease context not found
+ * Return: allocated lease context object on success, otherwise NULL
  */
 struct lease_ctx_info *parse_lease_state(void *open_req)
 {
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bc69b94df40f..39dfecf082ba 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2771,8 +2771,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				}
 			}
 
-			if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-			     req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
+			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
+			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				dh_info->CreateGuid =
 					durable_v2_blob->CreateGuid;
 				dh_info->persistent =
@@ -2792,8 +2792,8 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
-			     req_op_level == SMB2_OPLOCK_LEVEL_BATCH)) {
+			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
+			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				ksmbd_debug(SMB, "Request for durable open\n");
 				dh_info->type = dh_idx;
 			}
@@ -3415,7 +3415,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
-		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE) {
+		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			if (S_ISDIR(file_inode(filp)->i_mode)) {
 				lc->req_state &= ~SMB2_LEASE_WRITE_CACHING_LE;
 				lc->is_dir = true;
-- 
2.43.0



