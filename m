Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484336124;
	Wed, 30 Jul 2025 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868506; cv=none; b=ltJr7eR5JwDQ27wMy/vNwJYnGkkeRGy9nzOoSdOEi05DmqWdYGU/pQVoGpg/FtD8PVhUclkPfPg8iLt+BHKyi/NCEsq7VvgjJZcphlWRoH26B4Lxg5pG+MulZIqg3P9cKQvwMtiDR1KsQ7qqZ0Unv4pde051UG02zo+XQv+nl7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868506; c=relaxed/simple;
	bh=NBbO+TIM8NLj72+UkXFmKQJ3L4JlUkWnrr4cBgcscEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dd+Po7xJBXYodQ7170yOg0Ofkt3bU+2+ghg4WWrRR4X2DsLLu8RtgmEKXMIKKWmPvUSjYNV/KwD1E6MH0L6ibfNV76K5PghVCTK4uCVpVKO5I4W5mMeGE9fuqFBDXo7y0B2j8EEZ+gCHWeFQNh8SnteViiBZlKnnSrf7pQA5vyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2qOuENB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2qOuENB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848D1C4CEE7;
	Wed, 30 Jul 2025 09:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868505;
	bh=NBbO+TIM8NLj72+UkXFmKQJ3L4JlUkWnrr4cBgcscEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2qOuENB4x8oVn+3EdyNXmX99cocqJNQGIIZDUXRMNy1CctbC6Bz7USwifeh+Yw6H
	 R4u20X8jLO8f+dJu8jfd+BeU4ITEvNBFNaYtJldPsLmbSnNVB+B83DoVyNgwmERuaC
	 OAqWSOUUJ1MkTYdtvkjySwHSsi7LxuO4wZKRBPwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 68/76] ksmbd: add free_transport ops in ksmbd connection
Date: Wed, 30 Jul 2025 11:36:01 +0200
Message-ID: <20250730093229.504744410@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit a89f5fae998bdc4d0505306f93844c9ae059d50c upstream.

free_transport function for tcp connection can be called from smbdirect.
It will cause kernel oops. This patch add free_transport ops in ksmbd
connection, and add each free_transports for tcp and smbdirect.

Fixes: 21a4e47578d4 ("ksmbd: fix use-after-free in __smb2_lease_break_noti()")
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c     |    2 +-
 fs/smb/server/connection.h     |    1 +
 fs/smb/server/transport_rdma.c |   10 ++++++++--
 fs/smb/server/transport_tcp.c  |    3 ++-
 4 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -40,7 +40,7 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	if (atomic_dec_and_test(&conn->refcnt)) {
-		ksmbd_free_transport(conn->transport);
+		conn->transport->ops->free_transport(conn->transport);
 		kfree(conn);
 	}
 }
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -132,6 +132,7 @@ struct ksmbd_transport_ops {
 			  void *buf, unsigned int len,
 			  struct smb2_buffer_desc_v1 *desc,
 			  unsigned int desc_len);
+	void (*free_transport)(struct ksmbd_transport *kt);
 };
 
 struct ksmbd_transport {
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -158,7 +158,8 @@ struct smb_direct_transport {
 };
 
 #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
-
+#define SMBD_TRANS(t)	((struct smb_direct_transport *)container_of(t, \
+				struct smb_direct_transport, transport))
 enum {
 	SMB_DIRECT_MSG_NEGOTIATE_REQ = 0,
 	SMB_DIRECT_MSG_DATA_TRANSFER
@@ -409,6 +410,11 @@ err:
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
@@ -455,7 +461,6 @@ static void free_transport(struct smb_di
 
 	smb_direct_destroy_pools(t);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
-	kfree(t);
 }
 
 static struct smb_direct_sendmsg
@@ -2301,4 +2306,5 @@ static struct ksmbd_transport_ops ksmbd_
 	.read		= smb_direct_read,
 	.rdma_read	= smb_direct_rdma_read,
 	.rdma_write	= smb_direct_rdma_write,
+	.free_transport = smb_direct_free_transport,
 };
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -93,7 +93,7 @@ static struct tcp_transport *alloc_trans
 	return t;
 }
 
-void ksmbd_free_transport(struct ksmbd_transport *kt)
+static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 {
 	struct tcp_transport *t = TCP_TRANS(kt);
 
@@ -659,4 +659,5 @@ static struct ksmbd_transport_ops ksmbd_
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
 	.disconnect	= ksmbd_tcp_disconnect,
+	.free_transport = ksmbd_tcp_free_transport,
 };


