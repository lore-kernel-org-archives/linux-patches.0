Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210375;
	b=10ABFyhKVTj3NGNwVXqTHfbnAzbKcFCIK52uzWI+jdtRSvqX79QiT/6+rlxmvsWbphtq
	 AohQgm4VcaRvftXtb4f17JEzCJNjMlScpmo0zmi2EEaRzzZRb5aB8Q8J9wgoR4vt1fk51
	 BgFZiq7NIyo9k0tFQdik6z+Tzk2SdO2i5gdadGNzZDCaLVSnmWohGkGcK58YIA8Kvk9IV
	 FwgtctonfjYiZWpqZOwQoi5sxfNXRSwBOoLIywkJ+7qkrMjxpi8fQ1eKH2MNdAaMJZgrh
	 X/O7B8GVIWrYZPVO0XJaGrb/nrf65W2lvYkRgKP+kGXqU8zwOjQ3Rcyu5cX/ykedXmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWhuMd6DGylPRZNwlYAYmYi2A3h6ElOmtvw/Fd5aFk4=;
	b=UqNSyjGNGzqFyv+Gnscvc3pvxVHGZNOeyQ4Z7/7THKnt0m3LdwgRWPnrZRehHLewlxPn
	 0SOLINiNGl2eSS94NW4oGSoBjmiyMOS+7j20alNCdOcF33kMiKoZXCLW/2rvN01PaeLMt
	 uJ4etnKf7pnBuk8XQawZ+Fj1FFQHxCmuGJDYX7vmoMIPqNshOj3fUDOR4t9UMDQdMY0GF
	 MHOtY+ere2JGtvns8C2mT59yktob+UGmbyonSilINcz9wTYCqiOFPQmOmPkHBOHW9hB+l
	 EV9+HHKG5qv3lq/10Jqmt7jdBmDsy9rY2OwI9UuHg8iGx1IwX796a6h6E97+dyP1c9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lL5g+0Ab;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055CA606A31D;
	Wed, 28 Oct 2026 17:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lL5g+0Ab
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A131F01825;
	Wed, 28 Oct 2026 17:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210374;
	bh=DWhuMd6DGylPRZNwlYAYmYi2A3h6ElOmtvw/Fd5aFk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lL5g+0AbhRhbq+v0snBhuajmlkWMw8ZHytbTI1MdpRcxEulv+7Z6ZI4cYYqHYkj/K
	 weRxJ2+/GKJsjNQMX5hLakOjlbIskZPc1GFv4JZQTq+H4WuwS1uQh/8Kvtxkh7kNfW
	 31ulPqeMcIuLTiA83HHpraBmWv9bqYrPPOVzMpXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 152/168] io_uring/poll: dont loop on HUP with multiple references
Date: Wed, 28 Oct 2026 18:01:28 +0100
Message-ID: <20261028165946.684582916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.6: v still carries the flag bits here, mask it for the subtraction ]
Fixes: 937d38dcacd6 ("io_uring/poll: avoid retry wakeup loss when dropping ownership")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -258,12 +258,14 @@ static inline void io_poll_execute(struc
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
@@ -325,10 +327,17 @@ static int io_poll_check_events(struct i
 		} else {
 			int ret;
 
-			/* multiple refs and HUP, ensure we loop once more */
+			/*
+			 * Multiple refs and HUP, ensure we loop once more. Drop
+			 * down to one ref now, so the next pass ends unless a
+			 * wake up came in.
+			 */
 			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) &&
-			    (v & IO_POLL_REF_MASK) != 1)
-				v--;
+			    (v & IO_POLL_REF_MASK) != 1) {
+				atomic_sub((v & IO_POLL_REF_MASK) - 1,
+					   &req->poll_refs);
+				again = true;
+			}
 			ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
@@ -346,7 +355,7 @@ static int io_poll_check_events(struct i
 		 * task_work while we were executing it.
 		 */
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
+	} while (again || atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	return IOU_POLL_NO_ACTION;
 }


