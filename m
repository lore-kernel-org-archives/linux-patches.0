Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C74738FB0;
	Tue, 29 Apr 2025 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947630; cv=none; b=XxGbtJLH8OYbTLLwczNiE8fJbqZcr02k1ly0js+s+sVBiPvsUI3qFE+hQ80eiaU8JyIXAgCVBAzys26Uz3hBgApqYc0iI+PCEaicYiqRTYslroSaBIObpBTu2HMVoT1BUr+0pKmJzYfSplX3KnTEQQ1a0e+WAgF8X/s4H/tpEK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947630; c=relaxed/simple;
	bh=lrVM1Fjx5uoeWfRdh1p3ne1mvkhsyZ3vCm02CRbJUi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0tvdBq/QvdI54STPlFN9ryZgBakEpYV6FS67Zgbd+SsX0ulzy1D8uwVHeYS3uPQLXimBDG9QCjQmnXXTaQgJWEI2X0hsKw/qfCEoTD8ZFBdxHahQsN801UoE9I0a5qb3IlOt8+F0UPN34Hfu/Fw/qB+DEnScNSrK236roGLX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXMBKZPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXMBKZPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226CAC4CEE3;
	Tue, 29 Apr 2025 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947629;
	bh=lrVM1Fjx5uoeWfRdh1p3ne1mvkhsyZ3vCm02CRbJUi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXMBKZPw1lqA+k4vRZsDLl70BcIKgUaXIJbmJu0REbDftSYVu0NWIuyyUUuoyeOuj
	 iLI4QoT00lRYFoxVmCkySC0HRxrRUS1+GLIiXeItcRkxIndF7S4kw4mHlSDkaJNFqS
	 nM6qrHODFj8oYzxHiihwjlcANlxXwlckO7fygyiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/280] ksmbd: fix use-after-free in __smb2_lease_break_noti()
Date: Tue, 29 Apr 2025 18:39:40 +0200
Message-ID: <20250429161116.721149948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 21a4e47578d44c6b37c4fc4aba8ed7cc8dbb13de ]

Move tcp_transport free to ksmbd_conn_free. If ksmbd connection is
referenced when ksmbd server thread terminates, It will not be freed,
but conn->tcp_transport is freed. __smb2_lease_break_noti can be performed
asynchronously when the connection is disconnected. __smb2_lease_break_noti
calls ksmbd_conn_write, which can cause use-after-free
when conn->ksmbd_transport is already freed.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c    |  4 +++-
 fs/smb/server/transport_tcp.c | 14 +++++++++-----
 fs/smb/server/transport_tcp.h |  1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b0f69cee96a75..7aaea71a4f206 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -39,8 +39,10 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
-	if (atomic_dec_and_test(&conn->refcnt))
+	if (atomic_dec_and_test(&conn->refcnt)) {
+		ksmbd_free_transport(conn->transport);
 		kfree(conn);
+	}
 }
 
 /**
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7f38a3c3f5bd6..abedf510899a7 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -93,17 +93,21 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	return t;
 }
 
-static void free_transport(struct tcp_transport *t)
+void ksmbd_free_transport(struct ksmbd_transport *kt)
 {
-	kernel_sock_shutdown(t->sock, SHUT_RDWR);
-	sock_release(t->sock);
-	t->sock = NULL;
+	struct tcp_transport *t = TCP_TRANS(kt);
 
-	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
+	sock_release(t->sock);
 	kfree(t->iov);
 	kfree(t);
 }
 
+static void free_transport(struct tcp_transport *t)
+{
+	kernel_sock_shutdown(t->sock, SHUT_RDWR);
+	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
+}
+
 /**
  * kvec_array_init() - initialize a IO vector segment
  * @new:	IO vector to be initialized
diff --git a/fs/smb/server/transport_tcp.h b/fs/smb/server/transport_tcp.h
index 8c9aa624cfe3c..1e51675ee1b20 100644
--- a/fs/smb/server/transport_tcp.h
+++ b/fs/smb/server/transport_tcp.h
@@ -8,6 +8,7 @@
 
 int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz);
 struct interface *ksmbd_find_netdev_name_iface_list(char *netdev_name);
+void ksmbd_free_transport(struct ksmbd_transport *kt);
 int ksmbd_tcp_init(void);
 void ksmbd_tcp_destroy(void);
 
-- 
2.39.5



