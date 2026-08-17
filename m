Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1CC3D5C07;
	Mon, 17 Aug 2026 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980306; cv=none; b=ncLWRa/LVvxu73DEvBQldN4djCyFZH2UOHaBoyrvXMBWvbJaryebEtNrJYzdNGx4HADvwlrxYjayi5esJL4q0Gm+jCYhEsQ93xZFa2o7ClY7j5UfD/JCImJ4rBKqTf7OMhh07lezg8NSuA4tFcCNGN86FXKUYT1T5HRVvbItV40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980306; c=relaxed/simple;
	bh=IkIarc5QScnIS4DpnNymsnemkiBogZiJCvRHPUuvYpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnwn3PW4KbD0tIh/CFipQY+GFJQi/Ay/mIZFpmB6Pny+aLd+XY2uQoeo3ByuEovm8meDkuu/EBEL2+0jQsmdg1cKOTNQobqC24ZsN1Nt2q/4OvYrj3LXth/vPxBVqesd3gJS1P+DWBS21bU0WMrr4MsOyieWpnEa7/qdV9bbnLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8NWZ/co; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8NWZ/co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FB31F000E9;
	Mon, 17 Aug 2026 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980305;
	bh=Ep56zePf852T23hpSmv6C/VpsHryEn/pXQQDi7pqIec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8NWZ/coVQQ8LIjsB4RjXIhwm+vLAUh2Gg3QQfZKNA2jU+zFCSE2NNqMdCVMHscnU
	 cROdGcEcww6biS5e+rNcs3DyAC6Sjgl7QRpPyD6QIc6XT561h9CSQ0rdFzujMdTIno
	 ggBUfqdQsV6neBKZBElyWvep7WMyPLBTgOoCCUlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Breno Leitao <leitao@debian.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 525/609] net/smc: fix TOCTOU race between smc_listen_out() and listener close
Date: Mon, 17 Aug 2026 15:33:41 +0200
Message-ID: <20260817132601.379333497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidraya Jayagond <sidraya@linux.ibm.com>

[ Upstream commit 185a4caeecabc150106deda1da170b09f2ad803f ]

smc_listen_out() reads lsmc->sk.sk_state without the listener lock,
then acquires lock_sock_nested() only after the check passes. This
opens a window where smc_close_active() can transition the listener
to SMC_CLOSED, call smc_close_cleanup_listen() to drain the accept
queue, and release the lock, all between the lockless read and the
delayed lock acquisition:

  smc_listen_work (smc_hs_wq)          smc_close_active()
  -------------------------------      -------------------------
  release_sock(child)
  if (sk_state == SMC_LISTEN) TRUE
                                        lock_sock(listener)
                                        sk_state = SMC_CLOSED
                                        smc_close_cleanup_listen()
                                        release_sock(listener)
                                        flush_work(tcp_listen_work)
  lock_sock_nested(listener)
  smc_accept_enqueue(listener, child) /* child enqueued on dead listener */

smc_close_active() flushes only tcp_listen_work. Work items already
dispatched onto smc_hs_wq for the CLC handshake continue running
unguarded. smc_accept_enqueue() takes a sock_hold() on the child that
is never released, so the child smc_sock, its clcsock, and the
reference all leak. A remote peer that opens TCP connections while the
server calls close() can exhaust kernel memory.

Move lock_sock_nested() to before the sk_state check so that the test
and the enqueue are atomic under the listener lock.

Fixes: fd57770dd198 ("net/smc: wait for pending work before clcsock release_sock")
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Sidraya Jayagond <sidraya@linux.ibm.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20260803070701.126339-1-sidraya@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index ae97f47f4fda0..d069e5b156e51 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1874,11 +1874,12 @@ static void smc_listen_out(struct smc_sock *new_smc)
 		atomic_dec(&lsmc->queued_smc_hs);
 
 	release_sock(newsmcsk); /* lock in smc_listen_work() */
+	lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
-		lock_sock_nested(&lsmc->sk, SINGLE_DEPTH_NESTING);
 		smc_accept_enqueue(&lsmc->sk, newsmcsk);
 		release_sock(&lsmc->sk);
 	} else { /* no longer listening */
+		release_sock(&lsmc->sk);
 		smc_close_non_accepted(newsmcsk);
 	}
 
-- 
2.53.0



