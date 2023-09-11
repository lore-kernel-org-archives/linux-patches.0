Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F37211705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FC7C433C8;
	Mon, 11 Sep 2023 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443003;
	bh=vfPUf/Di5uQlueGaxK/+5nm1vxvwnr1STgdr2OupcSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzuYyvsnckoINGbWTc5/yPXE2v83HBBUErn7mD525JazjnjbXIv3BNwVf84/Ikxub
	 clX7179edWBWWtw90O+sabgsf2JIFxEJbvziQhxymkzbQNibphw3chl0fgRclrcZ2j
	 yBJZwGgRbSA1iv//1GnSJEv7r6jZWNqXDmcrgmaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 224/737] net: annotate data-races around sk->sk_lingertime
Date: Mon, 11 Sep 2023 15:41:23 +0200
Message-ID: <20230911134656.839252307@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bc1fb82ae11753c5dec53c667a055dc37796dbd2 ]

sk_getsockopt() runs locklessly. This means sk->sk_lingertime
can be read while other threads are changing its value.

Other reads also happen without socket lock being held,
and must be annotated.

Remove preprocessor logic using BITS_PER_LONG, compilers
are smart enough to figure this by themselves.

v2: fixed a clang W=1 (-Wtautological-constant-out-of-range-compare) warning
    (Jakub)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c |  2 +-
 net/bluetooth/sco.c |  2 +-
 net/core/sock.c     | 18 +++++++++---------
 net/sched/em_meta.c |  2 +-
 net/smc/af_smc.c    |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index cd07836850758..00e93ae6373da 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1486,7 +1486,7 @@ static int iso_sock_release(struct socket *sock)
 
 	iso_sock_close(sk);
 
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	if (sock_flag(sk, SOCK_LINGER) && READ_ONCE(sk->sk_lingertime) &&
 	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 7762604ddfc05..99b149261949a 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1267,7 +1267,7 @@ static int sco_sock_release(struct socket *sock)
 
 	sco_sock_close(sk);
 
-	if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
+	if (sock_flag(sk, SOCK_LINGER) && READ_ONCE(sk->sk_lingertime) &&
 	    !(current->flags & PF_EXITING)) {
 		lock_sock(sk);
 		err = bt_sock_wait_state(sk, BT_CLOSED, sk->sk_lingertime);
diff --git a/net/core/sock.c b/net/core/sock.c
index ddcf0630cc3ee..b2083a359ec10 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -793,7 +793,7 @@ EXPORT_SYMBOL(sock_set_reuseport);
 void sock_no_linger(struct sock *sk)
 {
 	lock_sock(sk);
-	sk->sk_lingertime = 0;
+	WRITE_ONCE(sk->sk_lingertime, 0);
 	sock_set_flag(sk, SOCK_LINGER);
 	release_sock(sk);
 }
@@ -1226,15 +1226,15 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			ret = -EFAULT;
 			break;
 		}
-		if (!ling.l_onoff)
+		if (!ling.l_onoff) {
 			sock_reset_flag(sk, SOCK_LINGER);
-		else {
-#if (BITS_PER_LONG == 32)
-			if ((unsigned int)ling.l_linger >= MAX_SCHEDULE_TIMEOUT/HZ)
-				sk->sk_lingertime = MAX_SCHEDULE_TIMEOUT;
+		} else {
+			unsigned long t_sec = ling.l_linger;
+
+			if (t_sec >= MAX_SCHEDULE_TIMEOUT / HZ)
+				WRITE_ONCE(sk->sk_lingertime, MAX_SCHEDULE_TIMEOUT);
 			else
-#endif
-				sk->sk_lingertime = (unsigned int)ling.l_linger * HZ;
+				WRITE_ONCE(sk->sk_lingertime, t_sec * HZ);
 			sock_set_flag(sk, SOCK_LINGER);
 		}
 		break;
@@ -1680,7 +1680,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 	case SO_LINGER:
 		lv		= sizeof(v.ling);
 		v.ling.l_onoff	= sock_flag(sk, SOCK_LINGER);
-		v.ling.l_linger	= sk->sk_lingertime / HZ;
+		v.ling.l_linger	= READ_ONCE(sk->sk_lingertime) / HZ;
 		break;
 
 	case SO_BSDCOMPAT:
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 6fdba069f6bfd..da34fd4c92695 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -502,7 +502,7 @@ META_COLLECTOR(int_sk_lingertime)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_lingertime / HZ;
+	dst->value = READ_ONCE(sk->sk_lingertime) / HZ;
 }
 
 META_COLLECTOR(int_sk_err_qlen)
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f94e7a04e33d0..462ece6bb1802 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1820,7 +1820,7 @@ void smc_close_non_accepted(struct sock *sk)
 	lock_sock(sk);
 	if (!sk->sk_lingertime)
 		/* wait for peer closing */
-		sk->sk_lingertime = SMC_MAX_STREAM_WAIT_TIMEOUT;
+		WRITE_ONCE(sk->sk_lingertime, SMC_MAX_STREAM_WAIT_TIMEOUT);
 	__smc_release(smc);
 	release_sock(sk);
 	sock_put(sk); /* sock_hold above */
-- 
2.40.1



