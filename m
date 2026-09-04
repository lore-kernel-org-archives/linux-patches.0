Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B0C41685A;
	Fri,  4 Sep 2026 05:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500299; cv=none; b=jhNMtxMsO0tFTCJg+BgbT5gKavEbZnWlPwO1/I8L66TUSrJSGxZt98AYOJe6i2W6Xa6JJO5c5+hVzpLG73zEGXwY6la52JddRm2h9yjsPVG5TciwE2W/v3advBkyx9sglUkt6HVc9F/+nyU6QZD7+CsAIzrKVf30WMOw9ZuBUpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500299; c=relaxed/simple;
	bh=GvVznlQR7nY3Iw1wESmjifbEbUk3DghE1b595Yd30Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6C8GyCeyO4jxzXyo5msiGp3S2WkeWmiL0706Yn3S93vy7wBTcKKnYc41mqRmD1GOc9xcGTOk3YXzDmvyFW3ld4Yk1EocXnOJo8wh3iFRmbX+3IBm6QjZD5gBqNeTIDhwZB0+jb5wF8J4ZLbg71a1DpxoPy5yUa4M+QzUEVuIqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmIjC/vP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmIjC/vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFFA1F00A3F;
	Fri,  4 Sep 2026 05:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500298;
	bh=ajKucTiVPCe99LVDEZ8JkkFgB9/uTbAhky35CYrl7zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmIjC/vPgErrgvkkNBgzhO/msM7dI21onTpV4hDKI/RhjDS9zlyxEbAXFrG8CV7JN
	 cI/twDEgPcdDQgUsJPsWOJWbcE81Whh/CmeDucoaknWkAYn+A71Edk3EYNwK3dR9+M
	 2CiS60isYz/D3P5EJlU1m1VA48HPJOiNf1VQKc5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 678/713] fuse: decouple fuse_ring creation from ent registration
Date: Fri,  4 Sep 2026 07:00:46 +0200
Message-ID: <20260904045819.033046654@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 6330b1f61ed1d17850fc61bdb8920ca1056e2cf9 ]

Currently, the connection's fuse_ring is created lazily on the first
FUSE_IO_URING_CMD_REGISTER command. A server registers entries from one
thread per queue (one per CPU) and those threads issue their first
REGISTER command concurrently. They then race to create the single
per-connection fuse_ring, which required open-coded handling in
fuse_uring_create() to detect and protect against concurrent creations.

Decouple fuse_ring creation from ent registration and move it to
FUSE_INIT reply processing after a server has negotiated and set
FUSE_OVER_IO_URING. The ring is published before the connection is
marked initialized. fuse_uring_register() no longer creates the ring and
it instead uses the ring set up at init time.

Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: fd10f40af314 ("fuse: copy request headers via a stack buffer for io-uring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c         |    8 +++-----
 fs/fuse/dev.h         |    2 +-
 fs/fuse/dev_uring.c   |   26 ++++++++++----------------
 fs/fuse/dev_uring_i.h |    5 +++++
 fs/fuse/inode.c       |    4 +++-
 5 files changed, 22 insertions(+), 23 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -75,6 +75,9 @@ void fuse_chan_set_initialized(struct fu
 		fch->minor = param->minor;
 		fch->max_write = param->max_write;
 		fch->max_pages = param->max_pages;
+
+		if (param->io_uring_enabled)
+			fuse_uring_conn_init(fch);
 	}
 
 	/* Make sure stores before this are seen on another CPU */
@@ -415,11 +418,6 @@ void fuse_chan_set_fc(struct fuse_chan *
 	fch->conn = fc;
 }
 
-void fuse_chan_io_uring_enable(struct fuse_chan *fch)
-{
-	fch->io_uring = 1;
-}
-
 void fuse_pqueue_init(struct fuse_pqueue *fpq)
 {
 	spin_lock_init(&fpq->lock);
--- a/fs/fuse/dev.h
+++ b/fs/fuse/dev.h
@@ -22,6 +22,7 @@ struct fuse_chan_param {
 	unsigned int minor;
 	unsigned int max_write;
 	unsigned int max_pages;
+	bool io_uring_enabled;
 };
 
 struct fuse_chan *fuse_chan_new(void);
@@ -34,7 +35,6 @@ void fuse_chan_max_background_set(struct
 unsigned int fuse_chan_num_waiting(struct fuse_chan *fch);
 void fuse_chan_set_fc(struct fuse_chan *fch, struct fuse_conn *fc);
 void fuse_chan_set_initialized(struct fuse_chan *fch, struct fuse_chan_param *param);
-void fuse_chan_io_uring_enable(struct fuse_chan *fch);
 ssize_t fuse_chan_send(struct fuse_chan *fch, struct fuse_args *args);
 int fuse_chan_send_bg(struct fuse_chan *fch, struct fuse_args *args, gfp_t gfp_flags);
 int fuse_chan_send_notify_reply(struct fuse_chan *fch, struct fuse_args *args, u64 unique);
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -238,7 +238,6 @@ static struct fuse_ring *fuse_uring_crea
 {
 	struct fuse_ring *ring;
 	size_t nr_queues = num_possible_cpus();
-	struct fuse_ring *res = NULL;
 	size_t max_payload_size;
 
 	ring = kzalloc_obj(*ring, GFP_KERNEL_ACCOUNT);
@@ -258,12 +257,6 @@ static struct fuse_ring *fuse_uring_crea
 		spin_unlock(&fch->lock);
 		goto out_err;
 	}
-	if (fch->ring) {
-		/* race, another thread created the ring in the meantime */
-		spin_unlock(&fch->lock);
-		res = fch->ring;
-		goto out_err;
-	}
 
 	init_waitqueue_head(&ring->stop_waitq);
 
@@ -278,7 +271,13 @@ static struct fuse_ring *fuse_uring_crea
 out_err:
 	kfree(ring->queues);
 	kfree(ring);
-	return res;
+	return NULL;
+}
+
+void fuse_uring_conn_init(struct fuse_chan *fch)
+{
+	if (fuse_uring_create(fch))
+		fch->io_uring = 1;
 }
 
 static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
@@ -1178,15 +1177,10 @@ static int fuse_uring_register(struct io
 	struct fuse_ring *ring = smp_load_acquire(&fch->ring);
 	struct fuse_ring_queue *queue;
 	struct fuse_ring_ent *ent;
-	int err;
 	unsigned int qid = READ_ONCE(cmd_req->qid);
 
-	err = -ENOMEM;
-	if (!ring) {
-		ring = fuse_uring_create(fch);
-		if (!ring)
-			return err;
-	}
+	if (!ring)
+		return -EINVAL;
 
 	if (qid >= ring->nr_queues) {
 		pr_info_ratelimited("fuse: Invalid ring qid %u\n", qid);
@@ -1197,7 +1191,7 @@ static int fuse_uring_register(struct io
 	if (!queue) {
 		queue = fuse_uring_create_queue(ring, qid);
 		if (!queue)
-			return err;
+			return -ENOMEM;
 	}
 
 	/*
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -135,6 +135,7 @@ struct fuse_ring {
 	bool ready;
 };
 
+void fuse_uring_conn_init(struct fuse_chan *fch);
 void fuse_uring_stop_queues(struct fuse_ring *ring);
 void fuse_uring_abort_end_requests(struct fuse_ring *ring);
 int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
@@ -174,6 +175,10 @@ static inline bool fuse_uring_ready(stru
 
 #else /* CONFIG_FUSE_IO_URING */
 
+static inline void fuse_uring_conn_init(struct fuse_chan *fch)
+{
+}
+
 static inline void fuse_uring_abort(struct fuse_chan *fch)
 {
 }
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1272,6 +1272,7 @@ static void process_init_reply(struct fu
 	struct fuse_mount *fm = ia->fm;
 	struct fuse_conn *fc = fm->fc;
 	struct fuse_init_out *arg = &ia->out;
+	bool io_uring_enabled = false;
 	bool ok = true;
 
 	if (error || arg->major != FUSE_KERNEL_VERSION)
@@ -1402,7 +1403,7 @@ static void process_init_reply(struct fu
 					ok = false;
 			}
 			if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
-				fuse_chan_io_uring_enable(fc->chan);
+				io_uring_enabled = true;
 
 			if (flags & FUSE_REQUEST_TIMEOUT)
 				timeout = arg->request_timeout;
@@ -1432,6 +1433,7 @@ static void process_init_reply(struct fu
 			.minor = fc->minor,
 			.max_write = fc->max_write,
 			.max_pages = fc->max_pages,
+			.io_uring_enabled = io_uring_enabled,
 		};
 		fuse_chan_set_initialized(fc->chan, &cp);
 	}


