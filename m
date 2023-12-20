Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E343FB0B;
	Wed, 20 Dec 2023 16:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr/oXlZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4EEC433C8;
	Wed, 20 Dec 2023 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088901;
	bh=XYdAHVVMKjWAaNPfmofshOyx3w3CoK51g/QbhMn9FL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr/oXlZdzF86n0WQmOZl7WUpx9mOHTvPiTL6XJFiJXRXAFwnL+qfMVUnEkZb5ZEOY
	 MiUe+P0d23uoOp1/P+GNonos1cHsk/7cbD2KSXO8KlA5HAJd+zuE25UmGwJCR4+cuX
	 m85Gy2OcHB10gx7PzTol83GGwpzBdJm6XQWaEDu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 092/159] ksmbd: fix racy issue under cocurrent smb2 tree disconnect
Date: Wed, 20 Dec 2023 17:09:17 +0100
Message-ID: <20231220160935.666235852@linuxfoundation.org>
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

[ Upstream commit 30210947a343b6b3ca13adc9bfc88e1543e16dd5 ]

There is UAF issue under cocurrent smb2 tree disconnect.
This patch introduce TREE_CONN_EXPIRE flags for tcon to avoid cocurrent
access.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20592
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/mgmt/tree_connect.c |   10 +++++++++-
 fs/ksmbd/mgmt/tree_connect.h |    3 +++
 fs/ksmbd/smb2pdu.c           |    3 ++-
 3 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -109,7 +109,15 @@ int ksmbd_tree_conn_disconnect(struct ks
 struct ksmbd_tree_connect *ksmbd_tree_conn_lookup(struct ksmbd_session *sess,
 						  unsigned int id)
 {
-	return xa_load(&sess->tree_conns, id);
+	struct ksmbd_tree_connect *tcon;
+
+	tcon = xa_load(&sess->tree_conns, id);
+	if (tcon) {
+		if (test_bit(TREE_CONN_EXPIRE, &tcon->status))
+			tcon = NULL;
+	}
+
+	return tcon;
 }
 
 struct ksmbd_share_config *ksmbd_tree_conn_share(struct ksmbd_session *sess,
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -14,6 +14,8 @@ struct ksmbd_share_config;
 struct ksmbd_user;
 struct ksmbd_conn;
 
+#define TREE_CONN_EXPIRE		1
+
 struct ksmbd_tree_connect {
 	int				id;
 
@@ -25,6 +27,7 @@ struct ksmbd_tree_connect {
 
 	int				maximal_access;
 	bool				posix_extensions;
+	unsigned long			status;
 };
 
 struct ksmbd_tree_conn_status {
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2083,11 +2083,12 @@ int smb2_tree_disconnect(struct ksmbd_wo
 
 	ksmbd_debug(SMB, "request\n");
 
-	if (!tcon) {
+	if (!tcon || test_and_set_bit(TREE_CONN_EXPIRE, &tcon->status)) {
 		struct smb2_tree_disconnect_req *req =
 			smb2_get_msg(work->request_buf);
 
 		ksmbd_debug(SMB, "Invalid tid %d\n", req->hdr.Id.SyncId.TreeId);
+
 		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		smb2_set_err_rsp(work);
 		return 0;


