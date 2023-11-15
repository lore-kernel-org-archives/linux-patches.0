Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6784E250EA
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+Ie3GdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D30C433C9;
	Wed, 15 Nov 2023 20:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081190;
	bh=UBvyEugtN3SEjewfAdTr4txn1x9P4muuG4Y+wZDA2n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+Ie3GdAzKGqNkrk/T6vvVu3yvSPKTtLekBPqWYRfV7R2VBuMyGyBaMdqiQbEeZKa
	 NtEYV5Bc8VGRaDWd4FGurc2CDJ1O3uJA2Y0mQoMXipbmFMkdhs+6GvM7Sn2Jy1hgfP
	 Q5obezOIdi0E8Wwp5T0WOrByGhNOtFoi6gMM8P3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 80/88] net/smc: fix dangling sock under state SMC_APPFINCLOSEWAIT
Date: Wed, 15 Nov 2023 15:36:32 -0500
Message-ID: <20231115191430.876549096@linuxfoundation.org>
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

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit 5211c9729484c923f8d2e06bd29f9322cc42bb8f ]

Considering scenario:

				smc_cdc_rx_handler
__smc_release
				sock_set_flag
smc_close_active()
sock_set_flag

__set_bit(DEAD)			__set_bit(DONE)

Dues to __set_bit is not atomic, the DEAD or DONE might be lost.
if the DEAD flag lost, the state SMC_CLOSED  will be never be reached
in smc_close_passive_work:

if (sock_flag(sk, SOCK_DEAD) &&
	smc_close_sent_any_close(conn)) {
	sk->sk_state = SMC_CLOSED;
} else {
	/* just shutdown, but not yet closed locally */
	sk->sk_state = SMC_APPFINCLOSEWAIT;
}

Replace sock_set_flags or __set_bit to set_bit will fix this problem.
Since set_bit is atomic.

Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c    | 4 ++--
 net/smc/smc.h       | 5 +++++
 net/smc/smc_cdc.c   | 2 +-
 net/smc/smc_close.c | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 6b30bec54b624..ad0ac657fe12c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -141,7 +141,7 @@ static int smc_release(struct socket *sock)
 
 	if (!smc->use_fallback) {
 		rc = smc_close_active(smc);
-		sock_set_flag(sk, SOCK_DEAD);
+		smc_sock_set_flag(sk, SOCK_DEAD);
 		sk->sk_shutdown |= SHUTDOWN_MASK;
 	} else {
 		if (sk->sk_state != SMC_LISTEN && sk->sk_state != SMC_INIT)
@@ -852,7 +852,7 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 		if (new_clcsock)
 			sock_release(new_clcsock);
 		new_sk->sk_state = SMC_CLOSED;
-		sock_set_flag(new_sk, SOCK_DEAD);
+		smc_sock_set_flag(new_sk, SOCK_DEAD);
 		sock_put(new_sk); /* final */
 		*new_smc = NULL;
 		goto out;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index adbdf195eb085..c3b0e1e3f505d 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -268,4 +268,9 @@ static inline bool using_ipsec(struct smc_sock *smc)
 struct sock *smc_accept_dequeue(struct sock *parent, struct socket *new_sock);
 void smc_close_non_accepted(struct sock *sk);
 
+static inline void smc_sock_set_flag(struct sock *sk, enum sock_flags flag)
+{
+	set_bit(flag, &sk->sk_flags);
+}
+
 #endif	/* __SMC_H */
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 333e4353498f8..c657fd29ff5d0 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -304,7 +304,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 		smc->sk.sk_shutdown |= RCV_SHUTDOWN;
 		if (smc->clcsock && smc->clcsock->sk)
 			smc->clcsock->sk->sk_shutdown |= RCV_SHUTDOWN;
-		sock_set_flag(&smc->sk, SOCK_DONE);
+		smc_sock_set_flag(&smc->sk, SOCK_DONE);
 		sock_hold(&smc->sk); /* sock_put in close_work */
 		if (!schedule_work(&conn->close_work))
 			sock_put(&smc->sk);
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index cac0773f5ebd9..4ea28ec7ad135 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -164,7 +164,7 @@ static void smc_close_active_abort(struct smc_sock *smc)
 		break;
 	}
 
-	sock_set_flag(sk, SOCK_DEAD);
+	smc_sock_set_flag(sk, SOCK_DEAD);
 	sk->sk_state_change(sk);
 }
 
-- 
2.42.0



