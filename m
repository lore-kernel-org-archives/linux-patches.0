Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C9E4B0481;
	Mon, 17 Aug 2026 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977626; cv=none; b=fLbxJ8SjrNNt2icZvz34DB4lW6QikiLkoMLUTsicm69bHs5wh50LTkjymOvBV01Y0UVUoKNS/TBda3CO6muoFXxohmCxn+9nKC/eW0FL5hEqg4GZ8O1WGyfHQzxRRT8KgXCiXJtgHi/jMmcFsltjhKz/mzLTn1T6n6lj4y5UW4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977626; c=relaxed/simple;
	bh=6bQTG5oRE7182VXjJzEPJLCDe2CxwnQ0vnQQwI323bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH78d74Rr/birU9znxHs09dq2YnrwJYPrOUHT8Bm9wjD/D+5nVr5oBFAjxLsnzy5oxBJN9oO6y4/OEaMKjM0c/RmVnePuspCp1PpUcOISUgd4zYrgKIYEeTjWuCyTfLQBEIqDj4WO8bJt0SC/E+xGX8tfKsTzPsOlT0LajIFtT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN2Sgqlm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN2Sgqlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BC41F000E9;
	Mon, 17 Aug 2026 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977625;
	bh=2VxvVyq9rI2Zn5INypWjqaaTg804g3wGlU6J88JdIZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hN2SgqlmVJoY2kKYxGlebfkp5EwFDsXM+/BfwEyR7fAM2G5gpt9EGIi6UA4sAHTLX
	 r5wn4zZSl7qJMe6Bus3fNIPeNclz3XLllJNdYV8oo0HpWvWTMx+NUOo/EKuI8sxdKg
	 rIDrk93yVCAEhe871+d3F/KVX6yKSDj73nLZSY28=
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
Subject: [PATCH 5.15 392/456] net/smc: fix TOCTOU race between smc_listen_out() and listener close
Date: Mon, 17 Aug 2026 15:33:02 +0200
Message-ID: <20260817132554.737141192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b60a5dd240dd..7bbb59e170a6b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1574,11 +1574,12 @@ static void smc_listen_out(struct smc_sock *new_smc)
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



