Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216403;
	b=CQ+XG12fG7nJ+IGLlCA2vfWxtxkos9gjj2Vx+pCMlQ6Q6zQ5JiCheYDMBBAhJivYzjxi
	 YJYvcvgePAIKJvivEW3zNuERy/t2Zo7NkO21cL1r/2d6tL7xyBnY86FDS7JIMYJmyHKGx
	 qiLMrJnZObEh+1s/5db8eM+4dQ3gi8/QKWgioiOHaMHh1a2mJg7BQAvng1yuMk1ExQ5/z
	 U/4YS0FEHcQL63FNYF4r8DhKbF1u0IeqsGM7osGWSlfNF8wRu2Q2nm2AkpVPF+xtkvXUL
	 tezfK3Hvn0+6mEn/KMfPW2G2X6Boea4FozSn0q2p952HqH2+8Fx5hK6Exxp6KvhnFgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6S8TrfXkupG1VwLJ4WQ0yk4ZTjIgf+8mKg/3wSKUw2M=;
	b=1GHuQXIgXZsynhFHOh9V/0XVkLWacmmfcrsmnoPllCZz/chKFyqKcVr+ilxr41iNz3+X
	 VbBsO8UKjH5UHuDbR7mT4k4aSI7B1ZvuKBuelt1NSjhZth6yidnR19B2BwKFixW0v+2Ou
	 KSBX3R2JLiutNFIwTPfrNzfUzYTChsNnmzmpo5UrdhX+CieNhJdL+UABaAr8Sjp6GIGQF
	 2+l/O3ezJbgoBWL6j07Px3FbAmF3U97XflwXFIzu4vJK4Pd2CdbcVzMZQAo5BRbZ9j73M
	 PDjKD3w4EkANRFtCy/aP2PmtsyHkNtsbZghofXS86jZMdJm7YsXY59JKkpQenNwLEDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KLxTa63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73516606A323;
	Wed, 28 Oct 2026 19:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2KLxTa63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22E61F031E0;
	Wed, 28 Oct 2026 19:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216403;
	bh=6S8TrfXkupG1VwLJ4WQ0yk4ZTjIgf+8mKg/3wSKUw2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KLxTa63syY8Z1rIzskAzgfgTEHQE9AQCI8htjdEXKQ1cbdGwTuX26iQgo7DJd83G
	 sjO3N1uQ0jJ/2nMTteESdGBch3hrEDek977ZtgF8PeJesiWDbN+qP8qTkLdevCEITW
	 aIJtjt+7W6EE6wfyIYhxyEcg3xvaJ857ujfVauoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runa Takemoto <takemotoruna223@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1543/1887] ksmbd: free preauth sessions on connection teardown
Date: Wed, 28 Oct 2026 18:00:39 +0100
Message-ID: <20261028170534.581601120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 06c7b1d731bc105a8644f1b70165ba8b9416cbab ]

SMB3.1.1 multichannel binding preserves the preauthentication hash in a
preauth_session between the NTLM negotiate and authenticate requests.
The binding NTLM negotiate allocates this object and returns
STATUS_MORE_PROCESSING_REQUIRED. If the client disconnects before it sends
the authenticate request, neither the authenticate nor error cleanup paths
free the object.

Release any remaining preauthentication sessions when tearing down the
connection. Initialize the list when allocating the connection so that this
cleanup is safe regardless of the negotiated dialect.

Reported-by: Runa Takemoto <takemotoruna223@gmail.com>
Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c        |  3 +++
 fs/smb/server/mgmt/user_session.c | 11 +++++++++++
 fs/smb/server/mgmt/user_session.h |  1 +
 fs/smb/server/smb2ops.c           |  1 -
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index a0c548447c2af..f1184ee9b2242 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -11,6 +11,7 @@
 #include "server.h"
 #include "smb_common.h"
 #include "mgmt/ksmbd_ida.h"
+#include "mgmt/user_session.h"
 #include "connection.h"
 #include "transport_tcp.h"
 #include "transport_rdma.h"
@@ -85,6 +86,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
+	ksmbd_preauth_session_destroy(conn);
 	ksmbd_conn_put(conn);
 }
 
@@ -124,6 +126,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	INIT_LIST_HEAD(&conn->conns_list);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
+	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	spin_lock_init(&conn->request_lock);
 	spin_lock_init(&conn->credits_lock);
 	ida_init(&conn->async_ida);
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index abb5b4619f36c..09c19d1f71e38 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -382,6 +382,17 @@ struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 	return sess;
 }
 
+void ksmbd_preauth_session_destroy(struct ksmbd_conn *conn)
+{
+	struct preauth_session *sess, *tmp;
+
+	list_for_each_entry_safe(sess, tmp, &conn->preauth_sess_table,
+				 preauth_entry) {
+		list_del(&sess->preauth_entry);
+		kfree(sess);
+	}
+}
+
 static bool ksmbd_preauth_session_id_match(struct preauth_session *sess,
 					   unsigned long long id)
 {
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 90ae30ba402f4..03b92c3667f62 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -98,6 +98,7 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 					       unsigned long long id);
 struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 						    u64 sess_id);
+void ksmbd_preauth_session_destroy(struct ksmbd_conn *conn);
 struct preauth_session *ksmbd_preauth_session_lookup(struct ksmbd_conn *conn,
 						     unsigned long long id);
 
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index c1ed62cc82960..e5accc7153485 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -283,7 +283,6 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
-	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	return 0;
 }
 
-- 
2.53.0



