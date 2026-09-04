Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B257408035;
	Fri,  4 Sep 2026 05:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500025; cv=none; b=lobDi0CJsfxARPuY9FsnKdVhRn/LUCtGpTq26e0yiNZkHmX5V3kCxU6zsQi/YyxA6+5YJ+6ba1tS4h0O2FJ2EK0NCKySrDfxOV5CJgAzXfqA3543oO70xvgrv8P2ptSUQucUC2NkHi6v+TLazIMGgINi8ABs94weEF3bhZV5kEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500025; c=relaxed/simple;
	bh=bn7fdgB1V1jQa0CsrbU75rvg4o7KuiiYaLTTJFL1yCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI46XoUlbqPmT526QRICBsch7i1nH5DIkden45y3O1r8Is2drRtnMUU2ZGU6egshnw4d4la9vZDiuEFJmte7ANELFKfFLJ3KhceWmUH0y2Bt3leWFo/76pBvdMECRPJRP4p2Ggzy11SGqYhDlJRAjbCZk0xSH0yDjjxAS0QRpV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCoDcc9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCoDcc9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D601F00A3F;
	Fri,  4 Sep 2026 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500024;
	bh=a7+ctGf2X4Y8H7L26TbnYTfVxKHYUXqIkuH+0bVLq/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCoDcc9wH+sPasvgCNsjiuMu/eHsSopzImX6HFMW+TVB5juGh7w8PIcFlWHYAHU5f
	 BOO1d83NqHenN+dyXS6e8yeXAtE7L71bVQwAUrCRNUdyB3Q61ctjQoAEkVSIaHPSEs
	 3dMztTwd2bzhNcGwgmQqWLWglOjdwLadLxhu9WXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 623/713] net/smc: fix use-after-free in smc_rx_pipe_buf_release()
Date: Fri,  4 Sep 2026 06:59:51 +0200
Message-ID: <20260904045817.791319246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hidayath Khan <hidayath@linux.ibm.com>

commit c924884743e948e25625b7fbf3ee2a9325a204a7 upstream.

smc_rx_splice() hands RMB pages to a pipe and takes a socket reference
per entry so the smc_sock stays alive until the reader finishes. The
connection does not: a concurrent close runs smc_conn_free(), which
releases the receive buffer back to the link group pool.

smc_rx_pipe_buf_release() tests sk_state before taking the socket lock.
The state can change between the test and the lock, and
smc_rx_update_cons() then dereferences conn->rmb_desc and walks
conn->lgr, which smc_conn_free() has already released. On the
is_reg_err path smcr_buf_unuse() frees the descriptor outright, so
this is a use-after-free.

Take the socket lock first and test conn->freed instead.
smc_conn_free() sets that flag before releasing anything, and every
caller holds the socket lock. The two paths exclude each other: either
the pipe release runs first with everything valid, or it sees the flag
and skips the update.

Fixes: 9014db202cb7 ("smc: add support for splice()")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260820074642.966856-3-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_rx.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -115,16 +115,15 @@ static void smc_rx_pipe_buf_release(stru
 				    struct pipe_buffer *buf)
 {
 	struct smc_spd_priv *priv = (struct smc_spd_priv *)buf->private;
+	struct smc_connection *conn = &priv->smc->conn;
 	struct smc_sock *smc = priv->smc;
-	struct smc_connection *conn;
 	struct sock *sk = &smc->sk;
 
-	if (sk->sk_state == SMC_CLOSED ||
-	    sk->sk_state == SMC_PEERFINCLOSEWAIT ||
-	    sk->sk_state == SMC_APPFINCLOSEWAIT)
-		goto out;
-	conn = &smc->conn;
 	lock_sock(sk);
+	if (conn->freed) {
+		release_sock(sk);
+		goto out;
+	}
 	smc_rx_update_cons(smc, priv->len);
 	release_sock(sk);
 	if (atomic_sub_and_test(priv->len, &conn->splice_pending))


