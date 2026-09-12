Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0212E2D0C94;
	Sat, 12 Sep 2026 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218538; cv=none; b=rdunmvpx7nYEMOvgtcFRKeWvktuQkYvoTFwImA3J12FgmLXC3wgVBesEIjLH+/n9VR27n2XOqLFRyyoFYOjTn4oQMgtf6XJ8E+9SI262tywsgjaiJo6+wJ+zg12At7mmhc2uYPX8bKmuYeiQ6vJOrUSEqMxaNU9PPYgumD/0UuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218538; c=relaxed/simple;
	bh=ky5zEOtLW1Rh7ZwFjaBbGSlNluB6RTYxx12H8jILPqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7kikMOvBdqfPs2BYnbq4DOZV5nOxPUQYDAxm650xsHH5MovT8iE0bk7Bya+WvoGe1mSSqQSFc+bPEm/jsP2/twrhlbbPEuKNvZ+4OuSRzRUscd+sfFo7U8dIzG+ILzDbu3SS0/5By1lQ4kV17kWgQIdlNAK9ThTC9AL/OVm8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nS5nn1Hg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nS5nn1Hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5731F000FF;
	Sat, 12 Sep 2026 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218536;
	bh=4hfxf2mJDu30+y2QkY16yWsOrxLhiws485Ahrm1t2JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nS5nn1HgaB4gN9OTtHPkiEcJEeJIRSW3xFwUP3HSOqtiBP/jlo3Jx924kwzlGwQIT
	 ONHg9Kf/5cjkf9mSg+w2jdLNEKdPquL4yWPdr0frN3wiC9YBrk7Q6t2ss8Q5QOGdDX
	 mL5WhTc+Dmvzyrg6VkeDZUmgbo47widNF9cFtvAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runa Takemoto <takemotoruna223@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1166/1376] ksmbd: free preauth sessions on connection teardown
Date: Sat, 12 Sep 2026 08:59:52 +0200
Message-ID: <20260912065633.538706795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5a896b146f437..6808fee63f284 100644
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
index ecd511351f19b..65f8ba9347af0 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -374,6 +374,17 @@ struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
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
index cba7f688f6b57..525650d6876c3 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -101,6 +101,7 @@ void destroy_previous_session(struct ksmbd_conn *conn,
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



