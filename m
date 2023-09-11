Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1847C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BBCC433C8;
	Mon, 11 Sep 2023 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442404;
	bh=MFYCr/fVXla8TEokWeL4XCmtR86ycjRXuOZmjN8WA8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nog0F+DurZoBHW0Vf6kHvLhp1S0giaPK6JWfgQra4NWdNw7GQ3pC19hB5v+4khJyU
	 rm6WxQI+s+3IbKLKlblUqcKPnHouKJAZjQV5OduVqOP3F8tUZw2N6a4mvwZ272TbTg
	 fRHju9Nfsbe0D9AfLeOFrSHOhSFS4cBS+cBgDP7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.4 014/737] ksmbd: fix out of bounds in init_smb2_rsp_hdr()
Date: Mon, 11 Sep 2023 15:37:53 +0200
Message-ID: <20230911134650.728565077@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 536bb492d39bb6c080c92f31e8a55fe9934f452b ]

If client send smb2 negotiate request and then send smb1 negotiate
request, init_smb2_rsp_hdr is called for smb1 negotiate request since
need_neg is set to false. This patch ignore smb1 packets after ->need_neg
is set to false.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21541
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c     |  7 ++++++-
 fs/smb/server/smb_common.c | 19 +++++++++++--------
 fs/smb/server/smb_common.h |  2 +-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index ced7a9e916f01..9df121bdf3492 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -286,6 +286,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 static int queue_ksmbd_work(struct ksmbd_conn *conn)
 {
 	struct ksmbd_work *work;
+	int err;
 
 	work = ksmbd_alloc_work_struct();
 	if (!work) {
@@ -297,7 +298,11 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	work->request_buf = conn->request_buf;
 	conn->request_buf = NULL;
 
-	ksmbd_init_smb_server(work);
+	err = ksmbd_init_smb_server(work);
+	if (err) {
+		ksmbd_free_work_struct(work);
+		return 0;
+	}
 
 	ksmbd_conn_enqueue_request(work);
 	atomic_inc(&conn->r_count);
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 3e391a7d5a3ab..27b8bd039791e 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -388,26 +388,29 @@ static struct smb_version_cmds smb1_server_cmds[1] = {
 	[SMB_COM_NEGOTIATE_EX]	= { .proc = smb1_negotiate, },
 };
 
-static void init_smb1_server(struct ksmbd_conn *conn)
+static int init_smb1_server(struct ksmbd_conn *conn)
 {
 	conn->ops = &smb1_server_ops;
 	conn->cmds = smb1_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb1_server_cmds);
+	return 0;
 }
 
-void ksmbd_init_smb_server(struct ksmbd_work *work)
+int ksmbd_init_smb_server(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	__le32 proto;
 
-	if (conn->need_neg == false)
-		return;
-
 	proto = *(__le32 *)((struct smb_hdr *)work->request_buf)->Protocol;
+	if (conn->need_neg == false) {
+		if (proto == SMB1_PROTO_NUMBER)
+			return -EINVAL;
+		return 0;
+	}
+
 	if (proto == SMB1_PROTO_NUMBER)
-		init_smb1_server(conn);
-	else
-		init_smb3_11_server(conn);
+		return init_smb1_server(conn);
+	return init_smb3_11_server(conn);
 }
 
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index 6b0d5f1fe85ca..f0134d16067fb 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -427,7 +427,7 @@ bool ksmbd_smb_request(struct ksmbd_conn *conn);
 
 int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
 
-void ksmbd_init_smb_server(struct ksmbd_work *work);
+int ksmbd_init_smb_server(struct ksmbd_work *work);
 
 struct ksmbd_kstat;
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
-- 
2.40.1



