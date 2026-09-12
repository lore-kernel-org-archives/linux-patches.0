Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19A723BD03;
	Sat, 12 Sep 2026 15:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225695; cv=none; b=s92ziyItVD2NBxOHxHMVIje10lkUsClIT031MiAwlyv3Z9LlwDZekuZZ1cnFOKm5kT4tMLCxEWx17JbvlS4o06Xk0xjQ0V5DbZ3h3XZYfolrZf1B9npyk6ajL77n9wR/L1RJCbVacT022B3WanJXeZWYyPs+b/s0X4XYeEGzKdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225695; c=relaxed/simple;
	bh=clwmkI5tYIKet2GAZTLONE/O10ohYcTGsV/GdyF2jhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8h6J04GQ8rafNxbcAxaBoRfqAHEMMzyub5wQzlx4x2ZAlId5ToYEnQ0VQYJRaxQOM/w0BDIMtLJ3zVDpaWVA428qfeG8EQvtHls3JNw5E+3ZWW3zk6i+jtBo7bQHuJSzPxwUZQNFhiFLeJgAQa00OzUBqCjSnqKNn665/WXKjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjtVCxKS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjtVCxKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0091F000FF;
	Sat, 12 Sep 2026 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225693;
	bh=f1oSWSCnOX8HcDtpUtOkCZlVPO0QgqSHKGI6vKcfMPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjtVCxKS6fprksqI5BJXhHPoUu9MFqMVK9WkXUT6iMh4ayQf1Otv72B6VjspHaW6a
	 7UmpRPigNV1QylcevseEU7d57OuzOquX5IiNfmXnnF2mTVQoOQ5sx3T5kJBRxQ6RYy
	 iVPh0xIE7x5HUYnyAMSR5tdYH54OCoffDseKEIJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runa Takemoto <takemotoruna223@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1250/1424] ksmbd: free preauth sessions on connection teardown
Date: Sat, 12 Sep 2026 09:01:22 +0200
Message-ID: <20260912065635.277371420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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
 fs/smb/server/smb2ops.c           |  2 --
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 8a19058efc3f7..672c7f56546c3 100644
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
@@ -123,6 +124,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
+	ksmbd_preauth_session_destroy(conn);
 	ksmbd_conn_put(conn);
 }
 
@@ -161,6 +163,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	init_waitqueue_head(&conn->r_count_q);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
+	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	spin_lock_init(&conn->request_lock);
 	spin_lock_init(&conn->credits_lock);
 	ida_init(&conn->async_ida);
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index d9768f88aabc0..8423568710e76 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -370,6 +370,17 @@ struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
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
 void destroy_previous_session(struct ksmbd_conn *conn,
 			      struct ksmbd_user *user, u64 id)
 {
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index c5749d6ec7151..523b68c4ca40e 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -100,6 +100,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 			      struct ksmbd_user *user, u64 id);
 struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 						    u64 sess_id);
+void ksmbd_preauth_session_destroy(struct ksmbd_conn *conn);
 struct preauth_session *ksmbd_preauth_session_lookup(struct ksmbd_conn *conn,
 						     unsigned long long id);
 
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 9455abbfe1c0a..4c50b7f57f763 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -289,8 +289,6 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
 	/* See init_smb3_02_server(): persistent handles require CA recovery. */
-
-	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	return 0;
 }
 
-- 
2.53.0



