Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8303643F089;
	Mon, 17 Aug 2026 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978481; cv=none; b=tmPjmtFiLar3KVV543e8X1WEK8Aw/ZlYwhddAKovkFCsjDnzTTRW3DuGDoKlbw+AMDDRY4tTJOcDYgXm9ECb5A8QdFQXrfBzqduc6V9FKLjSrRwTHqOZOFRTeLhGk3NR7PKEdXT5cPwIdrUOmVe4rTmkxrR89h3YXgdbxSrz9fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978481; c=relaxed/simple;
	bh=NFPqUCWOm4qQyyd9SuC/KHhmiLxN+zynDEXqhkdY+fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwi82gPIYw5SAJs1IE7zd9YiYGGd8u5mPM8pmvc0TKUNc36uYDIauVcvTRNySm3O7M8ftv9aQB00GHItIq0TKIT+ihCnMk6guaz2Ig198NXQL2KPiHYZKgsN9b3relJgfdUwUb/rVArQn7UPWZO+GKSCH8Dimd+NMP1PnySTm5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsbMQpYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsbMQpYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AA41F00A3D;
	Mon, 17 Aug 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978476;
	bh=CdgdFbil1zpqeWLFU8NgAlMh5rS+MyxNwqRsrqbd7i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZsbMQpYKb5/Ns7t/PeQGfHLh86Jx4SG8spI7hmCG5DJ/VFzZWgA/lFiZK0PvAL9yp
	 qtfBOgNsvaXoWpWvYRZ+7ZUWsU+cvo17NhtGINd7/8BQggH7m3RmT3dhbZ4TxVQIXB
	 Hrolgf6NdtDeanoXmHEHVaWwxOrbdNEhHLBfF/hM=
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
Subject: [PATCH 6.6 051/156] net/smc: fix TOCTOU race between smc_listen_out() and listener close
Date: Mon, 17 Aug 2026 15:33:05 +0200
Message-ID: <20260817132536.589861327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5e07160e5719..087102ff3c640 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1921,11 +1921,12 @@ static void smc_listen_out(struct smc_sock *new_smc)
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



