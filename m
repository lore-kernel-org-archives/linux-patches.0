Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C147469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB74C433C8;
	Mon, 28 Aug 2023 10:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218717;
	bh=nNRdEpPlfnw8r5Fj7xeIRM5d9YI9/Ha73iakJfEVzTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7eD7hm4mPeaDIvLCsxcrcW2HoXndHXQKhZuLCpysTT9OSFx2AQKipWJYePWp5rXZ
	 C8zZUrNUQ/cQ9HOeSkX4udJ3/G7/+N5UDtOtPGuqcEVfmtVARe0KF7p1wCDI1grV49
	 g/tVVI9zx6EoFosLUGmSBOPkqN6+QRwPBAU/pT84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 059/122] io_uring/msg_ring: move double lock/unlock helpers higher up
Date: Mon, 28 Aug 2023 12:12:54 +0200
Message-ID: <20230828101158.398763949@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 423d5081d0451faa59a707e57373801da5b40141 upstream.

In preparation for needing them somewhere else, move them and get rid of
the unused 'issue_flags' for the unlock side.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |   47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -24,6 +24,28 @@ struct io_msg {
 	u32 flags;
 };
 
+static void io_double_unlock_ctx(struct io_ring_ctx *octx)
+{
+	mutex_unlock(&octx->uring_lock);
+}
+
+static int io_double_lock_ctx(struct io_ring_ctx *octx,
+			      unsigned int issue_flags)
+{
+	/*
+	 * To ensure proper ordering between the two ctxs, we can only
+	 * attempt a trylock on the target. If that fails and we already have
+	 * the source ctx lock, punt to io-wq.
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		if (!mutex_trylock(&octx->uring_lock))
+			return -EAGAIN;
+		return 0;
+	}
+	mutex_lock(&octx->uring_lock);
+	return 0;
+}
+
 void io_msg_ring_cleanup(struct io_kiocb *req)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
@@ -51,29 +73,6 @@ static int io_msg_ring_data(struct io_ki
 	return -EOVERFLOW;
 }
 
-static void io_double_unlock_ctx(struct io_ring_ctx *octx,
-				 unsigned int issue_flags)
-{
-	mutex_unlock(&octx->uring_lock);
-}
-
-static int io_double_lock_ctx(struct io_ring_ctx *octx,
-			      unsigned int issue_flags)
-{
-	/*
-	 * To ensure proper ordering between the two ctxs, we can only
-	 * attempt a trylock on the target. If that fails and we already have
-	 * the source ctx lock, punt to io-wq.
-	 */
-	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		if (!mutex_trylock(&octx->uring_lock))
-			return -EAGAIN;
-		return 0;
-	}
-	mutex_lock(&octx->uring_lock);
-	return 0;
-}
-
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
@@ -122,7 +121,7 @@ static int io_msg_install_complete(struc
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0, true))
 		ret = -EOVERFLOW;
 out_unlock:
-	io_double_unlock_ctx(target_ctx, issue_flags);
+	io_double_unlock_ctx(target_ctx);
 	return ret;
 }
 


