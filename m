Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208109;
	b=PsvtX4USKYkc88v4NqIuGA3plAPJLSW1IIz+J1ONv2NKi1Ky3NwBDzQyqm3CyWqWLSH2
	 FEuAc0O6q8Zav3aVl138vx37NYPliQ9potNzHVuFo9+TUA8P0mFpFe0ts8Cy4XK1k/UzO
	 AlNX6DNhk2Bo3skNIkFkZ4Uso8gAcpYAV8bQSPwfbhxsf9h32GYfMY6adgvLbrdKFHN1A
	 M19FZpYbuUoEfA8jzlwAlZxxB2dAO+MCTyWp+dGUnSVVoL+oI8MmRQkIcJlHBsWUkMJtp
	 L8HgaKV6Q74Vg42l4VJVIIyKQQsHzX6Dc2nAzfyLKlY/fM2rdAVLuWlTBcYXdOdA3Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2v7xeNzQ4URpmVMkdH5zrGtD1YVBag7gTHV1iWUfRRY=;
	b=vU5Ig27XUBhHREbz9VoWifbLYs6cT58JyIZny6G+LXhYI880bCC0SYiF/NwFmSuIErsZ
	 JnVurxSnd4IEW1z+/JOwVbkJDAnIjZNbRnobOUabmITnY6hjUHXOQgV5haLDQemDf33eH
	 vrZh5/pWeMcQLzusma6JYesmNaHPgNdUHYfbCp/kOaklCaYi6UNhf9DF+qPgE1b+w8QSQ
	 03zytVbfA2QuQgx4g7ENquhZ0CAwz8Tz1UpjaXuvYR6Jy+hWC+pdutA+IoBxkheIuB04d
	 p0nle71S18BJjN8O+sZYvb4WzV3QX+W8RZvcPMN7tH62vheyzv8dI7oRGgRl5U5Xh+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x52RHmEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750FA606A31F;
	Wed, 28 Oct 2026 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x52RHmEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909451F01828;
	Wed, 28 Oct 2026 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208109;
	bh=2v7xeNzQ4URpmVMkdH5zrGtD1YVBag7gTHV1iWUfRRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x52RHmEUQSe0hnxuX/xV0ROacvhD1qTfnAD94g9LRIxawRYMKRSSWBu03Yu3ZQZnJ
	 G+kH+GLKf1s3R9hsyTm5AdHRcpTNE1zeAsAdjdb2xT7C7W/0Gp7otD0Wh1IigyhP+D
	 EEpe6H8fiVW4mWa1LnI+fKPL2fd56FCL45ZKL0Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 226/247] io_uring/poll: dont loop on HUP with multiple references
Date: Wed, 28 Oct 2026 18:00:29 +0100
Message-ID: <20261028165952.771621503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -264,12 +264,14 @@ static inline void io_poll_execute(struc
  */
 static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 {
+	bool again;
 	int v;
 
 	if (unlikely(io_should_terminate_tw(req->ctx)))
 		return -ECANCELED;
 
 	do {
+		again = false;
 		v = atomic_read(&req->poll_refs);
 
 		if (unlikely(v != 1)) {
@@ -331,9 +333,15 @@ static int io_poll_check_events(struct i
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
 			ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
@@ -351,7 +359,7 @@ static int io_poll_check_events(struct i
 		 * task_work while we were executing it.
 		 */
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
+	} while (again || atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;


