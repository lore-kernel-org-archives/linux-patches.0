Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09405299920;
	Sat, 12 Sep 2026 09:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204184; cv=none; b=TYtlDmHFyRR8gWCuvweu3uNjYWfhJwu5sPnBL1NiTzAOf/9wMc2aUlnWYkVn2ogWnd8suNTclBLzZX/f6t8FzlFq5LgCL9Bg1mD+Ggpc5qc03TJgGvvEyL2x7mbhjPsjUflUFK8T8HljBWkddJK8boRzJAKndlagCueAnM+Di6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204184; c=relaxed/simple;
	bh=R3evcC/lRhHnKrvsJJNdAwHihvyaYJzsvSldSdQBEok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT3ykBRrzxctRJyZOp9XmSfbZhb2Jk8CP6fSr+nE8GpoJtdb7CsVtyZt8mo1kMSL80Jq1A2gYxsNBheV9rvr5E0xAPSZBW73kz3oD5YGYRVKmXer6gdIt3uUPNPMPDG5GT2RmhAqis94fiVLYf1t+1NsMikMADMn3zzwRhNTClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnPqT/jE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnPqT/jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBD11F000FF;
	Sat, 12 Sep 2026 09:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204182;
	bh=JK5B5ShnGblKVvlw0JXbdi1jrmAbRdYAycF3ZrXyOIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnPqT/jE8R75v8iANr5zOOIPsV8sWnt/g9PT1G4fvfGgNsphPQE5k8eaEt4Zc3dNT
	 ZwbLP6+tZvZ5jE0xs7l5SQ5XVLFF9UdZjlezymn+Wt81xryjjNIsYu6D0k1ZH8Z+ga
	 hv6gjv6Q3skzW4L2Qo7vSyyXMrPyXF8iUHmDHjyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runa Takemoto <takemotoruna223@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1507/1815] ksmbd: free preauth sessions on connection teardown
Date: Sat, 12 Sep 2026 08:54:17 +0200
Message-ID: <20260912065724.375931597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ef6f202f4024c..636d6ce3386b2 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -11,6 +11,7 @@
 #include "server.h"
 #include "smb_common.h"
 #include "mgmt/ksmbd_ida.h"
+#include "mgmt/user_session.h"
 #include "connection.h"
 #include "compress.h"
 #include "transport_tcp.h"
@@ -185,6 +186,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
+	ksmbd_preauth_session_destroy(conn);
 	ksmbd_conn_put(conn);
 }
 
@@ -223,6 +225,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	init_waitqueue_head(&conn->r_count_q);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
+	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	spin_lock_init(&conn->request_lock);
 	spin_lock_init(&conn->credits_lock);
 	ida_init(&conn->async_ida);
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index f99c86284ba3d..bf4a4222c1f57 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -592,6 +592,17 @@ struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
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
index 4637a8c8436d0..2a0168e083286 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -104,6 +104,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
 			      struct ksmbd_user *user, u64 id);
 struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 						    u64 sess_id);
+void ksmbd_preauth_session_destroy(struct ksmbd_conn *conn);
 struct preauth_session *ksmbd_preauth_session_lookup(struct ksmbd_conn *conn,
 						     unsigned long long id);
 
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index 9eb7e17379763..d1ddfd9028ef8 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -293,8 +293,6 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 		conn->vals->req_capabilities |= SMB2_GLOBAL_CAP_MULTI_CHANNEL;
 
 	/* See init_smb3_02_server(): persistent handles require CA recovery. */
-
-	INIT_LIST_HEAD(&conn->preauth_sess_table);
 	return 0;
 }
 
-- 
2.53.0



