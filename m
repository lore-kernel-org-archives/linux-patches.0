Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E4079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B046C433B5;
	Wed, 30 Nov 2022 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833054;
	bh=QTm725KX/oZgFC7F0zi7TNXIWzt9C/tj8vlAzB2FRiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz6QcSv9YStrj4kROMFQeCtk3MYY6F66D4fIB0okD9H2pN09JWSqUTatl4TMQcdII
	 e30KSroi0UUc5ACZsQiznPdxfUjNj7SfcHs7qs5ooW6mCbcylPmG5ap/Z5NC69bt3J
	 4hDCYoJTX51vgO3lklbKBD9gn0rUjbnhlfwMQt8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/162] ceph: make ceph_create_session_msg a global symbol
Date: Wed, 30 Nov 2022 19:23:08 +0100
Message-Id: <20221130180531.390983626@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit fba97e8025015b63b1bdb73cd868c8ea832a1620 ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 16 +++++++++-------
 fs/ceph/mds_client.h |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6859967df2b1..36cf3638f501 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1157,7 +1157,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 /*
  * session messages
  */
-static struct ceph_msg *create_session_msg(u32 op, u64 seq)
+struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
 {
 	struct ceph_msg *msg;
 	struct ceph_mds_session_head *h;
@@ -1165,7 +1165,8 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
 			   false);
 	if (!msg) {
-		pr_err("create_session_msg ENOMEM creating msg\n");
+		pr_err("ENOMEM creating session %s msg\n",
+		       ceph_session_op_name(op));
 		return NULL;
 	}
 	h = msg->front.iov_base;
@@ -1299,7 +1300,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
 			   GFP_NOFS, false);
 	if (!msg) {
-		pr_err("create_session_msg ENOMEM creating msg\n");
+		pr_err("ENOMEM creating session open msg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	p = msg->front.iov_base;
@@ -1833,8 +1834,8 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
 
 	dout("send_renew_caps to mds%d (%s)\n", session->s_mds,
 		ceph_mds_state_name(state));
-	msg = create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
-				 ++session->s_renew_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
+				      ++session->s_renew_seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -1848,7 +1849,7 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
 
 	dout("send_flushmsg_ack to mds%d (%s)s seq %lld\n",
 	     session->s_mds, ceph_session_state_name(session->s_state), seq);
-	msg = create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
@@ -1900,7 +1901,8 @@ static int request_close_session(struct ceph_mds_session *session)
 	dout("request_close_session mds%d state %s seq %lld\n",
 	     session->s_mds, ceph_session_state_name(session->s_state),
 	     session->s_seq);
-	msg = create_session_msg(CEPH_SESSION_REQUEST_CLOSE, session->s_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_CLOSE,
+				      session->s_seq);
 	if (!msg)
 		return -ENOMEM;
 	ceph_con_send(&session->s_con, msg);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index acf33d7192bb..c0cff765cbf5 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -518,6 +518,7 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
 extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
 				    struct ceph_cap *cap);
 extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
-- 
2.35.1



