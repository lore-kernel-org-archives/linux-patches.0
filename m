Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D33FB1B;
	Mon, 23 Jun 2025 22:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716208; cv=none; b=acT8r7LJNwKD1OFCQultBTj+8un4w7vaI2ClByRf8zx9RqpfnrFbAFvK6Pz8fbdW2Z0y/CgIGvUA9n8uli+sGCBdYy36r6Hq6mcaTsDKEzie8AQwQYm+dwJbBVco5sVBDrcti+EJ0142N+/sA0dcGo40Mrwq649Xe/je5YF2LqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716208; c=relaxed/simple;
	bh=mqr4XFbkZ1tBbr0vy+9WPDwaxLRoXbGDltspGDtLpAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/0zmT7PycZkhqXhZhQ1F4dKwVG3bpDy+oZ6X8ppQJPsrCtUuyEYsZrxnYOAl3K4IAq//LY5zePpvXZSFc4PqpTTYHPHhuQN4+PvyT0K009sroOOVNRJfeVKvbxx3qljKVj02eRtuZcOUoeRVMl/NREm5PpAEXFPpL+tPfO2rZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkJ4Bbub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkJ4Bbub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1313FC4CEEA;
	Mon, 23 Jun 2025 22:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716208;
	bh=mqr4XFbkZ1tBbr0vy+9WPDwaxLRoXbGDltspGDtLpAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkJ4BbubmnW3mZN65+QnAuto773h3kte1Z6Bql4w0VhgzzAx1kMO4gmF8Ljgqh5Kb
	 kzLBS/zcs9d2SCexjdy/7L8PAaqmFX5Lbg2QdvOWO6yemi/RnCFu9IAAwTuT63QTAp
	 imb6XAGd0mfE4EjekE2LuqsbuphK2aQBPaOoEaz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 529/592] ksmbd: add free_transport ops in ksmbd connection
Date: Mon, 23 Jun 2025 15:08:07 +0200
Message-ID: <20250623130713.017800817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a89f5fae998bdc4d0505306f93844c9ae059d50c ]

free_transport function for tcp connection can be called from smbdirect.
It will cause kernel oops. This patch add free_transport ops in ksmbd
connection, and add each free_transports for tcp and smbdirect.

Fixes: 21a4e47578d4 ("ksmbd: fix use-after-free in __smb2_lease_break_noti()")
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c     |  2 +-
 fs/smb/server/connection.h     |  1 +
 fs/smb/server/transport_rdma.c | 10 ++++++++--
 fs/smb/server/transport_tcp.c  |  3 ++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 83764c230e9d4..3f04a2977ba86 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -40,7 +40,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	if (atomic_dec_and_test(&conn->refcnt)) {
-		ksmbd_free_transport(conn->transport);
+		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
 	}
 }
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 14620e147dda5..572102098c108 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -132,6 +132,7 @@ struct ksmbd_transport_ops {
 			  void *buf, unsigned int len,
 			  struct smb2_buffer_desc_v1 *desc,
 			  unsigned int desc_len);
+	void (*free_transport)(struct ksmbd_transport *kt);
 };
 
 struct ksmbd_transport {
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4998df04ab95a..64a428a06ace0 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -159,7 +159,8 @@ struct smb_direct_transport {
 };
 
 #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
-
+#define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
+				struct smb_direct_transport, transport))
 enum {
 	SMB_DIRECT_MSG_NEGOTIATE_REQ = 0,
 	SMB_DIRECT_MSG_DATA_TRANSFER
@@ -410,6 +411,11 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	return NULL;
 }
 
+static void smb_direct_free_transport(struct ksmbd_transport *kt)
+{
+	kfree(SMBD_TRANS(kt));
+}
+
 static void free_transport(struct smb_direct_transport *t)
 {
 	struct smb_direct_recvmsg *recvmsg;
@@ -455,7 +461,6 @@ static void free_transport(struct smb_direct_transport *t)
 
 	smb_direct_destroy_pools(t);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
-	kfree(t);
 }
 
 static struct smb_direct_sendmsg
@@ -2281,4 +2286,5 @@ static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.read		= smb_direct_read,
 	.rdma_read	= smb_direct_rdma_read,
 	.rdma_write	= smb_direct_rdma_write,
+	.free_transport = smb_direct_free_transport,
 };
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index abedf510899a7..4e9f98db9ff40 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -93,7 +93,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	return t;
 }
 
-void ksmbd_free_transport(struct ksmbd_transport *kt)
+static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 {
 	struct tcp_transport *t = TCP_TRANS(kt);
 
@@ -656,4 +656,5 @@ static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.free_transport = ksmbd_tcp_free_transport,
 };
-- 
2.39.5



