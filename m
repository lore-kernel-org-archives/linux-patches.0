Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0FF43AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZC/Nq+5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38563C433C9;
	Wed, 15 Nov 2023 20:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081187;
	bh=f/SWgx8vmRVj+GIEEnzDoGnZXptUnen3eHgk9TFs25o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZC/Nq+5MQ85XMvQMGGsn0t2iRpVMn0aW6Ym7Yj+wnnZGnpp0ZqMk50aLauePxhELJ
	 xDJpxPL8okSXvyp14tyF7C/tiAPIM6OSUdX0CGG5qGV7WkvNNSAYcErow7wkREkXvz
	 ZuSJKZXmRwowmzkAg3c9nTDBmPTwht9EziGpLbbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ursula Braun <ubraun@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 78/88] net/smc: postpone release of clcsock
Date: Wed, 15 Nov 2023 15:36:30 -0500
Message-ID: <20231115191430.769764496@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit b03faa1fafc8018295401dc558bdc76362d860a4 ]

According to RFC7609 (http://www.rfc-editor.org/info/rfc7609)
first the SMC-R connection is shut down and then the normal TCP
connection FIN processing drives cleanup of the internal TCP connection.
The unconditional release of the clcsock during active socket closing
has to be postponed if the peer has not yet signalled socket closing.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5211c9729484 ("net/smc: fix dangling sock under state SMC_APPFINCLOSEWAIT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c    | 33 +++++++++++++++++----------------
 net/smc/smc_close.c |  7 ++++++-
 2 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index dcd00b514c3f9..6f342f6cc4876 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -143,32 +143,33 @@ static int smc_release(struct socket *sock)
 		rc = smc_close_active(smc);
 		sock_set_flag(sk, SOCK_DEAD);
 		sk->sk_shutdown |= SHUTDOWN_MASK;
-	}
-
-	sk->sk_prot->unhash(sk);
-
-	if (smc->clcsock) {
-		if (smc->use_fallback && sk->sk_state == SMC_LISTEN) {
+	} else {
+		if (sk->sk_state != SMC_LISTEN && sk->sk_state != SMC_INIT)
+			sock_put(sk); /* passive closing */
+		if (sk->sk_state == SMC_LISTEN) {
 			/* wake up clcsock accept */
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
-		mutex_lock(&smc->clcsock_release_lock);
-		sock_release(smc->clcsock);
-		smc->clcsock = NULL;
-		mutex_unlock(&smc->clcsock_release_lock);
-	}
-	if (smc->use_fallback) {
-		if (sk->sk_state != SMC_LISTEN && sk->sk_state != SMC_INIT)
-			sock_put(sk); /* passive closing */
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk);
 	}
 
+	sk->sk_prot->unhash(sk);
+
+	if (sk->sk_state == SMC_CLOSED) {
+		if (smc->clcsock) {
+			mutex_lock(&smc->clcsock_release_lock);
+			sock_release(smc->clcsock);
+			smc->clcsock = NULL;
+			mutex_unlock(&smc->clcsock_release_lock);
+		}
+		if (!smc->use_fallback)
+			smc_conn_free(&smc->conn);
+	}
+
 	/* detach socket */
 	sock_orphan(sk);
 	sock->sk = NULL;
-	if (!smc->use_fallback && sk->sk_state == SMC_CLOSED)
-		smc_conn_free(&smc->conn);
 	release_sock(sk);
 
 	sock_put(sk); /* final sock_put */
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 092696d738c00..3e7858793d485 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -415,8 +415,13 @@ static void smc_close_passive_work(struct work_struct *work)
 	if (old_state != sk->sk_state) {
 		sk->sk_state_change(sk);
 		if ((sk->sk_state == SMC_CLOSED) &&
-		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket))
+		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
 			smc_conn_free(conn);
+			if (smc->clcsock) {
+				sock_release(smc->clcsock);
+				smc->clcsock = NULL;
+			}
+		}
 	}
 	release_sock(sk);
 	sock_put(sk); /* sock_hold done by schedulers of close_work */
-- 
2.42.0



