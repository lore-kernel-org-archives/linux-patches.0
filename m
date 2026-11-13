Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590018;
	b=sJpfpZdmgsFhDCblkWaAwpdGAgc4EJjf/CvsXXb4z4uRCDILJVAoXSo+bAahJnGEmYJa
	 C8oxxZFa9ZduHNgxDirltCfL6/BnP0Ca3IsNQivApxpE/2TCds2E1n3M01sPD/6b2aQjs
	 3vfDZLOzFQrdn/7IEtsZXXZuUtz1S3lWTlxCh+/WuNh/rRUZU+fnF/qdaIwSWzJh3ew6U
	 l3FU8M+uLtDgg/HuU4N7Ywe/RXwhmFBYo+Q0/eGLwy6xMSLfJRHKAlcjvhBaHxLwPAzCt
	 mls59wPFi8r5cl2cJ+VsW7H7fagU1MhQ5Zj69XxO6zAxP4eXPqnmYM+OEm7y3L3l4ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4WHzKapawo7pclhtRqA6zFvNUNPrve0JYSXdbijq5NE=;
	b=OeMtNhoWAV0sg6A1l+oisnsIEeD6g2x0pvlw3UdjO1/ZXYbCBP733T0WAjTVEAVpvVb9
	 EN0CB1sn5xmKpVlz5XLo0GF/w75TLEW8QQ33cThjke6DB7tHG+nfFZN6Ztajxdgn3tkJO
	 rt1XNzmBfogC5wYtGf6PxxA7Lx42AJZ12HN8eDpptIneQH1VEBQTCBWpYma7nlg+fMh6b
	 6Y0CcslRwLkUCCqcpJTYuotjevJdbLts55RAGPsoq0cYy+lpBIIX4xphG+tyEMI6b31K2
	 i4wYRPhxHtBy8tunJAHPYbDIhxheVyRNu5cGxlBwAK3uS6XenoeAoiqtlm1RkLp2plQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+y1iC2n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9C606A33F;
	Fri, 13 Nov 2026 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+y1iC2n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757C71F000C4;
	Fri, 13 Nov 2026 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590018;
	bh=4WHzKapawo7pclhtRqA6zFvNUNPrve0JYSXdbijq5NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+y1iC2nZvsotHgOkk2M+b+mW7mkDTPuW5UbhYwGczOabPlAqq3BiWykstZ95/XKy
	 1+JxPDfdGobMiP0Z541zFzMTRtn293i81S0n+QxSLgnWsquDM5+69YK8XVjYmr8SBQ
	 cHl75g22iWxlzrQM7vVOKSxSGmGbx7F8eyFxFjCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/686] io_uring/cancel: drop sqd->lock while SQPOLL waits
Date: Fri, 13 Nov 2026 10:43:13 -0500
Message-ID: <20261113153822.975053394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit cb0306c52ffae083a86fb283de67875ae7a9500e upstream.

An exiting SQPOLL thread calls io_uring_cancel_generic() with sqd->lock
held, and keeps it across cond_resched() and the sleep until nothing is
in flight anymore. A zero-copy send notification can't be canceled and
stays pending as long as the peer doesn't read, so the lock is held for
as long as a user cares to. io_ring_exit_work() needs it to park the
thread, and so do IORING_REGISTER_IOWQ_AFF and IOWQ_MAX_WORKERS. With
64 such rings sharing the thread, every iou_exit slot sleeps on the lock
and no ring gets freed for anyone.

Drop the lock around cond_resched() and the sleep, like the main loop of
the thread does. Each walk of ctx_list is still under one hold, and
nothing is kept across the unlock. The thread drops its io-wq, frees its
tctx and clears sqd->thread under one hold after the loop, so whoever
holds the lock and finds sqd->thread set can still use them.

Fixes: 63809137ebb5 ("io_uring: flush notifiers after sendzc")
Signed-off-by: Chris Mason <mason@kernel.org>
[axboe: adapted to the schedule_timeout() based loop]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: adapted to the schedule() based wait loop]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 50ec818aa19f6..44d8b7b25267e 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -641,7 +641,16 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		}
 
 		if (loop) {
+			/*
+			 * A request that runs in io-wq and doesn't end makes
+			 * each round come here. Don't hold sqd->lock for that
+			 * long either.
+			 */
+			if (sqd)
+				mutex_unlock(&sqd->lock);
 			cond_resched();
+			if (sqd)
+				mutex_lock(&sqd->lock);
 			continue;
 		}
 
@@ -659,8 +668,20 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx, !cancel_all))
+		if (inflight == tctx_inflight(tctx, !cancel_all)) {
+			/*
+			 * A zero-copy notification can't be canceled, and a
+			 * peer that doesn't read keeps it pending. Don't hold
+			 * sqd->lock while waiting for it, or whoever wants the
+			 * lock sleeps as long. No ring is used across this,
+			 * the next round walks ->ctx_list anew.
+			 */
+			if (sqd)
+				mutex_unlock(&sqd->lock);
 			schedule();
+			if (sqd)
+				mutex_lock(&sqd->lock);
+		}
 end_wait:
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-- 
2.53.0



