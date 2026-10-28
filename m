Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209817;
	b=nXW5iKmOSw1PYfhbQ0MyEMQOuhW/QpTOkIBQb+9eFv8jWH74Yfdl3Pt9yHSu61av8Vfn
	 AGYlrCa1Tl4WCEIvrOqPIKVHGsekFlrjfv+iiEom1YcKvcNFu6sdZPhRPIK0nnQA5l9dQ
	 wGACJrWYGi7Ks/Qp6MxS5RS3pvnm0PtwElFTvIIJhF9BBsyKpxFNkiTRgZDQoT+F0shi3
	 qf40iLeYsLAcMEq51n3LfntRb9rWf+zzLTXjKG73dO1XcOv0TwMIo2uqU+/Svx81wLdfL
	 qVzQ0AwWBRSN1fGyfU+f2Ga2WmJssq+h2mJbqqfM66HpAaHdK9jACT/cyPcU7jEihbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0EQnKxm5FtEmzCVwwMbYiTWTL0aogUYh2EAGkfbcb2E=;
	b=XfH970KFkG8hwTGyz9lR3MqHtP0NUmZHlgTRa+flVhWMUB3oSn0FZ1iYDj3hXAh/hINw
	 ILOmWUPBKpLuGQ/pgv402GmcMZ25esW3jIJKL42+0Mc8oU9kkVCrlFyyNHmi8pZ3zuPm5
	 qIantPhpul9zG12KV18A16yxZnQwj8G9MBcIR9cnd40s0+pQU4miA2H6JWGYIrsEM6Ny+
	 DSaBfXfPKiD1eyIiwSuaO1Pc28Ru0V5UB6ooP1zlaOqpwLaWPjRhkdKkhGRaIAcOq4w9h
	 ZvHiwtrINPLAs+7eRa0kjfvL3BFQBOUa8IiBv/s60D/cbs1Ohe6qBAcPfl7KJ18pJMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnCJo6C6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1304606A31C;
	Wed, 28 Oct 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TnCJo6C6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBD41F01829;
	Wed, 28 Oct 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209816;
	bh=0EQnKxm5FtEmzCVwwMbYiTWTL0aogUYh2EAGkfbcb2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnCJo6C67eJc7lOSdZWMHO9iwjJunQjwJrV6Z3T53+rwddVXjbLvnztzj+kvvDEAu
	 BzUN0JcQiOW5hxxKRHLRBvj/0wk5Z+Ps8e7jZCdIf91KwJMAtOTAraYRN6wjv3s8+m
	 XHMmozvJXOCK3eCyxbcrLsdRjvYgiKmypNDhTX4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.18 085/109] io_uring/poll: dont loop on HUP with multiple references
Date: Wed, 28 Oct 2026 18:01:09 +0100
Message-ID: <20261028165944.358142059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit cf1d5c9d335e2c673811da641531da82cb01393a upstream.

io_poll_check_events() drops down to one reference when a multishot
request sees HUP with more than one, so that the loop goes around once
more. It did so by subtracting one less than it had. With the cmpxchg
that only takes the local count down: the exchange fails, the next pass
reads the unchanged count, and goes through the same motions again. The
loop then only ends once io_poll_issue() stops the request.

Drop the extra references from the counter instead, and loop once more
without trying the exchange. The next pass sees one reference, like it
did before, and ends unless a wake up came in.

Fixes: 937d38dcacd6 ("io_uring/poll: avoid retry wakeup loss when dropping ownership")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -223,12 +223,14 @@ static inline void io_poll_execute(struc
  */
 static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 {
+	bool again;
 	int v;
 
 	if (unlikely(tw.cancel))
 		return -ECANCELED;
 
 	do {
+		again = false;
 		v = atomic_read(&req->poll_refs);
 
 		if (unlikely(v != 1)) {
@@ -290,9 +292,15 @@ static int io_poll_check_events(struct i
 		} else {
 			int ret;
 
-			/* multiple refs and HUP, ensure we loop once more */
-			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && v != 1)
-				v--;
+			/*
+			 * Multiple refs and HUP, ensure we loop once more. Drop
+			 * down to one ref now, so the next pass ends unless a
+			 * wake up came in.
+			 */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) && v != 1) {
+				atomic_sub(v - 1, &req->poll_refs);
+				again = true;
+			}
 
 			ret = io_poll_issue(req, tw);
 			if (ret == IOU_COMPLETE)
@@ -311,7 +319,7 @@ static int io_poll_check_events(struct i
 		 * task_work while we were executing it.
 		 */
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
+	} while (again || atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;


