Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207326;
	b=5m3SsCaA6fgKohTIN6J0TIH7Wg/kbEPxTzRjZWBrm0pqvhVfJNeFAlumlLvGpCVoLgy5
	 0xge5W86gLi8kjS5KrV8iKRNvQUofDib4FDiOAqjC9ZUvXsmX7zo8m4EIpYttvt67pYhO
	 dnT+u1fL4sfuWptVO3wXTUu+6NzMkhelO3NaVJkQoQzXLgK2Z9gYfVMfOOFiaBy5sH07H
	 6YSy2dNB9VEnpEVw7+IxjGSK2KW1csk/nXq56VG8lHYFyD0vHc1e42Qw9fyHIRg9EDDUC
	 rVh57Kc8eK6ADKOAftoWEainF8vasWNsd2PPoDi1+0mSAOtzGWMZ0GXAprmzHWsPiAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b9bKu96HXk9m1koOnJym8uAamtDFRCbZJVB0gQJuNXY=;
	b=WuoZSeIMSFxr0TXhCoCadXC/iW1OnKAQUi6kGg9DnuuLqjOoFpXBAhBBlN2ITADKBzmo
	 Wd/5hUBa/b41YvL3c+IGbNvSMLTj0zgY3yO5s7AWyyF6nRVrGKm9iBjVjjzIgUlxTKdn7
	 YZGdEF4Aa+bzoJZHQwpu5rIbbxeCWZ+hp0pcijD1lths0KwIpewS2wkOiwLka5sHa/Hfp
	 hdTHbt/w7WLO7/89BzZFxcllakilFtsrHS3wbshHzuIoFXCl8CAOIV7Zj3GbuGx7kCbzn
	 O4+raBiVTjtqiYJVPuW9Zp+tY3R/eK3ZK0pBIUqwMQCv7e4tpODZtSVw9TVZZscIZxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fa7yUad8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B0E606A31A;
	Wed, 28 Oct 2026 17:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fa7yUad8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A618E1F01825;
	Wed, 28 Oct 2026 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207326;
	bh=b9bKu96HXk9m1koOnJym8uAamtDFRCbZJVB0gQJuNXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fa7yUad8qe0FPJIKq67crEtkHFZaE4bAdyrT7sgJrIEcmCc/I1YOnV+xlffNVK+ok
	 VLx7bTNDyTanIB3boxA96HdpcopBfx8PVJ66m/63XTOMkx3KGoDI9XtSR37VZw3mUj
	 5DryhI4AhNZLF8uUOhG2WUbfGvFB3i+rbeYJh6MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 7.2 64/88] io_uring/poll: dont loop on HUP with multiple references
Date: Wed, 28 Oct 2026 18:00:12 +0100
Message-ID: <20261028165943.621985543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -241,12 +241,14 @@ static inline void io_poll_execute(struc
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
@@ -310,9 +312,15 @@ static int io_poll_check_events(struct i
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
@@ -331,7 +339,7 @@ static int io_poll_check_events(struct i
 		 * task_work while we were executing it.
 		 */
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
+	} while (again || atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;


