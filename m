Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D11D20ADFD;
	Tue, 12 Nov 2024 10:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407748; cv=none; b=pY102Vw0lnWXOUZ2UAgayzPf4Uf7d39+lLptLzjpeziLZpDWDtbBnpH4bQKwFt869k9OslKjNgeUCr7YjYoGH8Xfmvq/3ok8ecS86sEB2b5tV2hZXSU4kB7soSlR9fRqP1nmfxro73vnwrQaeqnvDzfgKFV2r5yD0tau+ppplVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407748; c=relaxed/simple;
	bh=PeWys+eUa4ilpYLLkbsJI+9ATF8B1hwTIKIL29kfkak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/9OL6h7pGKLSMgv/REWDa4UH1yjfYALFLA6+pQvVq2vctIU4nN11scPfFXNKowZSveqmGgpOQSlvX63yZcTSADOIBAffU9dfvPM1oQM1Sk4nVQkU4iz9GvIFuVmj9SHIdRmEwq3PcuS1cZG1vSR2kfGbYpgLc+InW9WTyv9buk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D681I0Pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D681I0Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899D3C4CECD;
	Tue, 12 Nov 2024 10:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407747;
	bh=PeWys+eUa4ilpYLLkbsJI+9ATF8B1hwTIKIL29kfkak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D681I0PpAnahekiQf97AmB2U2XPU2nYDGRpXA1OyqrtYNt8VqClyukE01EwF0bqRD
	 5Osl7ZR0olHtpEsIM9zMnMyy1vVFAzsKgUYxfIcTrgNhNXgGhHbCoze+UvF5YAM47+
	 Adj9XKOIrk/E/HnM/C/sZLFGxZ6ZxSUfmxvl7ql0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 071/119] ksmbd: check outstanding simultaneous SMB operations
Date: Tue, 12 Nov 2024 11:21:19 +0100
Message-ID: <20241112101851.428332150@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


