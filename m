Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C59E214411;
	Tue, 12 Nov 2024 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408203; cv=none; b=BQhvtEbxy2chmq0Q9q+vGyjiYhqsozOF6Tl8ih2bsd00gwRnpbn2rq2gMJyqlSG5mRsmt0JHWU2IzJyWfDDvt+wAHD/roDIxOHZsSXz1mkxVLE4RRgyWRsXecBRMEZVwDo4jrMDytiLtkDu3hEDbAOa/Off53W3kxuXIt0HE6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408203; c=relaxed/simple;
	bh=lOTqWQ6OOhpgM/Qyo75wBg43dnVixhUaFJLTwm5bn68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V36tF3Y/VWxa0oyiTTTJDKmTQa5DJJzqyWfX0qBMd9h+KefiC1fWiR3PSKC6Hp/b9rePgZE00Z3EAJJm0hsBIKrc69kZ7iIpcRk+h1wx9rvEjk5kzEluzlzXMzsQ1tGE3eoUy/keP+u887xO+9ZMHKJ+a+Gcrdcc85oPiaPG01s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUCWeERM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUCWeERM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F744C4CECD;
	Tue, 12 Nov 2024 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408202;
	bh=lOTqWQ6OOhpgM/Qyo75wBg43dnVixhUaFJLTwm5bn68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUCWeERMuGeWdXq/4oS2NdS/uuHxgjwhksRQS+TFC0aLvZbl/NhqrNpAKgoGWhrCq
	 UR72pvRR2EXhwY861wzHJE6R/NOLdK7mSHR4pbfYVR5EUU9W5Y4hxqOXVFOy/FcBio
	 8LSvPqBAkHn0sBiVpcdhpmWIIfJzMW6fXU3TkRwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.11 090/184] ksmbd: check outstanding simultaneous SMB operations
Date: Tue, 12 Nov 2024 11:20:48 +0100
Message-ID: <20241112101904.312843968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 0a77d947f599b1f39065015bec99390d0c0022ee upstream.

If Client send simultaneous SMB operations to ksmbd, It exhausts too much
memory through the "ksmbd_work_cache”. It will cause OOM issue.
ksmbd has a credit mechanism but it can't handle this problem. This patch
add the check if it exceeds max credits to prevent this problem by assuming
that one smb request consumes at least one credit.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    1 +
 fs/smb/server/connection.h |    1 +
 fs/smb/server/server.c     |   16 ++++++++++------
 fs/smb/server/smb_common.c |   10 +++++++---
 fs/smb/server/smb_common.h |    2 +-
 5 files changed, 20 insertions(+), 10 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -70,6 +70,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	atomic_set(&conn->refcnt, 1);
+	atomic_set(&conn->mux_smb_requests, 0);
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -107,6 +107,7 @@ struct ksmbd_conn {
 	__le16				signing_algorithm;
 	bool				binding;
 	atomic_t			refcnt;
+	atomic_t			mux_smb_requests;
 };
 
 struct ksmbd_conn_ops {
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -270,6 +270,7 @@ static void handle_ksmbd_work(struct wor
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
+	atomic_dec(&conn->mux_smb_requests);
 	/*
 	 * Checking waitqueue to dropping pending requests on
 	 * disconnection. waitqueue_active is safe because it
@@ -291,6 +292,15 @@ static int queue_ksmbd_work(struct ksmbd
 	struct ksmbd_work *work;
 	int err;
 
+	err = ksmbd_init_smb_server(conn);
+	if (err)
+		return 0;
+
+	if (atomic_inc_return(&conn->mux_smb_requests) >= conn->vals->max_credits) {
+		atomic_dec_return(&conn->mux_smb_requests);
+		return -ENOSPC;
+	}
+
 	work = ksmbd_alloc_work_struct();
 	if (!work) {
 		pr_err("allocation for work failed\n");
@@ -301,12 +311,6 @@ static int queue_ksmbd_work(struct ksmbd
 	work->request_buf = conn->request_buf;
 	conn->request_buf = NULL;
 
-	err = ksmbd_init_smb_server(work);
-	if (err) {
-		ksmbd_free_work_struct(work);
-		return 0;
-	}
-
 	ksmbd_conn_enqueue_request(work);
 	atomic_inc(&conn->r_count);
 	/* update activity on connection */
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -388,6 +388,10 @@ static struct smb_version_ops smb1_serve
 	.set_rsp_status = set_smb1_rsp_status,
 };
 
+static struct smb_version_values smb1_server_values = {
+	.max_credits = SMB2_MAX_CREDITS,
+};
+
 static int smb1_negotiate(struct ksmbd_work *work)
 {
 	return ksmbd_smb_negotiate_common(work, SMB_COM_NEGOTIATE);
@@ -399,18 +403,18 @@ static struct smb_version_cmds smb1_serv
 
 static int init_smb1_server(struct ksmbd_conn *conn)
 {
+	conn->vals = &smb1_server_values;
 	conn->ops = &smb1_server_ops;
 	conn->cmds = smb1_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb1_server_cmds);
 	return 0;
 }
 
-int ksmbd_init_smb_server(struct ksmbd_work *work)
+int ksmbd_init_smb_server(struct ksmbd_conn *conn)
 {
-	struct ksmbd_conn *conn = work->conn;
 	__le32 proto;
 
-	proto = *(__le32 *)((struct smb_hdr *)work->request_buf)->Protocol;
+	proto = *(__le32 *)((struct smb_hdr *)conn->request_buf)->Protocol;
 	if (conn->need_neg == false) {
 		if (proto == SMB1_PROTO_NUMBER)
 			return -EINVAL;
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -427,7 +427,7 @@ bool ksmbd_smb_request(struct ksmbd_conn
 
 int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
 
-int ksmbd_init_smb_server(struct ksmbd_work *work);
+int ksmbd_init_smb_server(struct ksmbd_conn *conn);
 
 struct ksmbd_kstat;
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,


