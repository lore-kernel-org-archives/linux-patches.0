Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E5D3F8D6;
	Wed, 20 Dec 2023 16:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reNtdw3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3CDC433C8;
	Wed, 20 Dec 2023 16:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088947;
	bh=dJwBPuznOLvXPZ073MZD+LO6gIUcykeMAhodlBQTmzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reNtdw3FkZJPzOyLR8JADaKK9IfWzoZ5ZsdBbR/lAmsIsSH8LPIamj2m7jG8bbKwJ
	 2xGfnS8nFQnBRgws0yhw8rz1Q6nJ0zoQc4URBe696vSWdXFi/GQkjipjyM9xOt4W2q
	 LD8X444gEl7jKlOipfzhhmLKt178L61nqiqrqHEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 116/159] ksmbd: validate session id and tree id in compound request
Date: Wed, 20 Dec 2023 17:09:41 +0100
Message-ID: <20231220160936.758503104@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3df0411e132ee74a87aa13142dfd2b190275332e ]

`smb2_get_msg()` in smb2_get_ksmbd_tcon() and smb2_check_user_session()
will always return the first request smb2 header in a compound request.
if `SMB2_TREE_CONNECT_HE` is the first command in compound request, will
return 0, i.e. The tree id check is skipped.
This patch use ksmbd_req_buf_next() to get current command in compound.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21506
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -87,9 +87,9 @@ struct channel *lookup_chann_list(struct
  */
 int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 {
-	struct smb2_hdr *req_hdr = smb2_get_msg(work->request_buf);
+	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	unsigned int cmd = le16_to_cpu(req_hdr->Command);
-	int tree_id;
+	unsigned int tree_id;
 
 	if (cmd == SMB2_TREE_CONNECT_HE ||
 	    cmd ==  SMB2_CANCEL_HE ||
@@ -114,7 +114,7 @@ int smb2_get_ksmbd_tcon(struct ksmbd_wor
 			pr_err("The first operation in the compound does not have tcon\n");
 			return -EINVAL;
 		}
-		if (work->tcon->id != tree_id) {
+		if (tree_id != UINT_MAX && work->tcon->id != tree_id) {
 			pr_err("tree id(%u) is different with id(%u) in first operation\n",
 					tree_id, work->tcon->id);
 			return -EINVAL;
@@ -560,9 +560,9 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
  */
 int smb2_check_user_session(struct ksmbd_work *work)
 {
-	struct smb2_hdr *req_hdr = smb2_get_msg(work->request_buf);
+	struct smb2_hdr *req_hdr = ksmbd_req_buf_next(work);
 	struct ksmbd_conn *conn = work->conn;
-	unsigned int cmd = conn->ops->get_cmd_val(work);
+	unsigned int cmd = le16_to_cpu(req_hdr->Command);
 	unsigned long long sess_id;
 
 	/*
@@ -588,7 +588,7 @@ int smb2_check_user_session(struct ksmbd
 			pr_err("The first operation in the compound does not have sess\n");
 			return -EINVAL;
 		}
-		if (work->sess->id != sess_id) {
+		if (sess_id != ULLONG_MAX && work->sess->id != sess_id) {
 			pr_err("session id(%llu) is different with the first operation(%lld)\n",
 					sess_id, work->sess->id);
 			return -EINVAL;


