Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826836;
	b=ug/Ls4sn9vTyLJkgfYL4XaHUDEj7r/PY7/ks/g2DJNYksVpmpeBaazbi3t+Wk4fl+48Z
	 uYp82+kgd6piaE+AJxSSsadCkICOpeORv1SdVNURbLL1HjhrRVzzi4cbY1EGM05O/sOBE
	 yVvBtX8BwgXGmWPEqJ4aG01zazd2738MGbITDXYcBxg68HfNhM0O2V6ED/TTaR9eLwOqK
	 Vbecy+Cuxl13hnxvW5r5/N0aH5bG0meuqar5blODtKZ4s84NEMzzU3LJQFF3b7jMW1SRS
	 FylGNjwNGnX51DtAZvPHShrU2c/ttPKl7duet3N/ZilE2J1xeOWC+rdalLIf/Czm/QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E3VL8MAcJ19k2NSEP3BAtDbpjmT0r8jJ8xSEqH6H7IU=;
	b=CeilzpscR+bpfjB5On5gzS8Ee6g7spJlHgTBMSFYD/dA1Nt87OGYpqB4Z27QGjSEM/dY
	 SUWZawSziAByH28FUKOFMbOhabV1TE9xj1rPBJo9OgazIPtc3OrgXlhsFCkMG1KKqdYMm
	 RLDorNp9vRQtjVX7xEnnHjrxWBpq1ITzm1GOGBx59S6CspC70QPxH5FHz54b3c1jYY1g9
	 e9HdKpJ5CjqpyeEUOfJUevhcDgCdiSZssCCd9MvTIgvM8VhG2C4mMtjAIjTIIoCmsLv9R
	 tqc5otf1DYMGv3PyqLVIiqPvEPoghlSZuXZdgbi4RW5M9KZTV5J9w0SCH3sHnKMLfWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qyi/FOQ4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8976072652;
	Wed,  4 Nov 2026 21:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qyi/FOQ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17351F00A1B;
	Wed,  4 Nov 2026 21:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826836;
	bh=E3VL8MAcJ19k2NSEP3BAtDbpjmT0r8jJ8xSEqH6H7IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyi/FOQ4oo5jpTadya0xuBLTuPSHEDrFpj5cHJvHIZZuo5vwQd8gmfmyqYG8cejbY
	 pmykq7Qs6S79zs536S+4E9xt1YcokuKUTw74i/F/3/RfCHVbqEnrL8sHkh36sqZl31
	 YLXFIPQ4wsuR6yvrVFKivmixZwz3Io/eB59fRjhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 036/547] io_uring/wait: look at all CQ waiters on wake up
Date: Wed,  4 Nov 2026 16:03:40 -0500
Message-ID: <20261104211039.363802308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 356f92f2412686f822383b784fa102924407457a ]

io_wake_function() returns -1 if the waiter it is called for doesn't have
enough events yet, which makes __wake_up_common() stop walking the wait
queue. That assumes that the waiters behind it can't be satisfied either.
Each waiter has its own target though, computed from the min_complete it
passed in:

  thread A: io_uring_enter(GETEVENTS, min_complete = 10)  // queued first
  thread B: io_uring_enter(GETEVENTS, min_complete = 1)
  one CQE is posted: A isn't woken, and B isn't even considered

B keeps sleeping with the event it asked for sitting in the CQ ring, until
A's demand is met or a timeout or signal ends the wait.

Return 0 to carry on with the next waiter. Only waiters whose condition
is met are woken, like before.

Fixes: bda521624e75 ("io_uring: make CQ ring wakeups be more efficient")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-20-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/wait.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/wait.c b/io_uring/wait.c
index 62f0101321000..078fa8b076a99 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -27,7 +27,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 */
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
-	return -1;
+	/* keep going, a waiter further down may be content with less */
+	return 0;
 }
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)
-- 
2.53.0



