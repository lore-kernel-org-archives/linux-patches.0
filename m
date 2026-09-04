Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EE8346FC3;
	Fri,  4 Sep 2026 06:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501628; cv=none; b=dmAJFmlwQshbeNwaxTtRv0L4fr4CqNk/KxdJRPPGLGFT3DES9PrW1ZLBKmQI702F8R1pqbyn+6w3HjhrDQUyi/jVVJoFkSG9Ng1kY1es66FrBZm01tQFN+bufqqG9q0i6HHTIf5r263bpkvqSp5FHKwchFKXMPOd9U+6MXQRzv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501628; c=relaxed/simple;
	bh=VHgBWbOx3w90G/oScKXruBSEHSCqe4uADpTZm2vFEDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzNIEONiEnmKUG55NRv1ExqTuOU5l/vhI5FmoNiM86sj6mAmen/4/gejP48/XJIbk4zIlSRTH7tRP5PcttD3OzTNxVgutdociszlQS8R0A3aZkA5666lNVsBaETYmcyWaJVBQt6b+x/v4lFs+TuqiamGW4hUCtHYmkd9LEoy4TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9eqAHN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9eqAHN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAC01F00A3D;
	Fri,  4 Sep 2026 06:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501627;
	bh=LvftXJ3M0ksOeitiSxZ1bOqn2/o+h0M3I/wjo0eEBgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9eqAHN6ftScm6z/R4/dBtmcUHFye3SkU783nX6vz1O91e2+Yda9k5skLJ4KG6ALf
	 EHJQe/icI6EB0qpeAG0uAUFYruHksjDBU6QlZIL8TMuKoT4TxV2H3ynVAgzuPUlJ86
	 198qoG1/f0RqiLER7SrvW803rYA3rrHEeSgwAV8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 475/552] net/smc: fix use-after-free in smc_rx_pipe_buf_release()
Date: Fri,  4 Sep 2026 07:00:32 +0200
Message-ID: <20260904045801.454608447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


