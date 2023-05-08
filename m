Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45857168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2F5C433D2;
	Mon,  8 May 2023 10:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541362;
	bh=wsRoZLZQ+L9SkIuoYcGvqLlBQgJq35mpVdb5l1RjQGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DC1zW6dbjEUxh9HlrFY0fpUfYy6eHsaXYLr1lYuVDanUzFWkT3yTFULXQ/4KEjH6X
	 ZvnMQQjyog1lrOrqNqmMd9dRQUwlvZTx/ljuafYEkSdNbQUKqLJqUvd74pFexnR3LD
	 tocW/WYfcktZpKo8XZdGf3Ksmj18gBKQ1WkBOv3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.2 090/663] ksmbd: fix racy issue under cocurrent smb2 tree disconnect
Date: Mon,  8 May 2023 11:38:36 +0200
Message-Id: <20230508094431.382742833@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 30210947a343b6b3ca13adc9bfc88e1543e16dd5 upstream.

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
@@ -2055,11 +2055,12 @@ int smb2_tree_disconnect(struct ksmbd_wo
 
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


