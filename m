Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134CDF9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89888C433C7;
	Mon, 11 Sep 2023 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444693;
	bh=O5zAikEQcQ1NkjwgrZazX1j16W067dHGT1Gty9APZbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJgueh/k2ITwhA+5C8ifMvSVAVuKXve5nnfUXo4jCU4Y3eACCE5xW4gLXweNqzq7E
	 HxgU9edy4EmS6iXWKvECAivzu7B5j4YfLVZJYrFxumnNc5fQVHwPS6oq78kbLPUDKd
	 e4+8KEP7yhQdv7rThxlDWcpVKcVWrfD4hNMIu/9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/600] net: annotate data-races around sk->sk_{rcv|snd}timeo
Date: Mon, 11 Sep 2023 15:41:25 +0200
Message-ID: <20230911134635.150238965@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 285975dd674258ccb33e77a1803e8f2015e67105 ]

sk_getsockopt() runs without locks, we must add annotations
to sk->sk_rcvtimeo and sk->sk_sndtimeo.

In the future we might allow fetching these fields before
we lock the socket in TCP fast path.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c     | 24 ++++++++++++++----------
 net/sched/em_meta.c |  4 ++--
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 509773919d302..8b91d9f911336 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -425,6 +425,7 @@ static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
 {
 	struct __kernel_sock_timeval tv;
 	int err = sock_copy_user_timeval(&tv, optval, optlen, old_timeval);
+	long val;
 
 	if (err)
 		return err;
@@ -435,7 +436,7 @@ static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
 	if (tv.tv_sec < 0) {
 		static int warned __read_mostly;
 
-		*timeo_p = 0;
+		WRITE_ONCE(*timeo_p, 0);
 		if (warned < 10 && net_ratelimit()) {
 			warned++;
 			pr_info("%s: `%s' (pid %d) tries to set negative timeout\n",
@@ -443,11 +444,12 @@ static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
 		}
 		return 0;
 	}
-	*timeo_p = MAX_SCHEDULE_TIMEOUT;
-	if (tv.tv_sec == 0 && tv.tv_usec == 0)
-		return 0;
-	if (tv.tv_sec < (MAX_SCHEDULE_TIMEOUT / HZ - 1))
-		*timeo_p = tv.tv_sec * HZ + DIV_ROUND_UP((unsigned long)tv.tv_usec, USEC_PER_SEC / HZ);
+	val = MAX_SCHEDULE_TIMEOUT;
+	if ((tv.tv_sec || tv.tv_usec) &&
+	    (tv.tv_sec < (MAX_SCHEDULE_TIMEOUT / HZ - 1)))
+		val = tv.tv_sec * HZ + DIV_ROUND_UP((unsigned long)tv.tv_usec,
+						    USEC_PER_SEC / HZ);
+	WRITE_ONCE(*timeo_p, val);
 	return 0;
 }
 
@@ -809,9 +811,9 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs)
 {
 	lock_sock(sk);
 	if (secs && secs < MAX_SCHEDULE_TIMEOUT / HZ - 1)
-		sk->sk_sndtimeo = secs * HZ;
+		WRITE_ONCE(sk->sk_sndtimeo, secs * HZ);
 	else
-		sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
+		WRITE_ONCE(sk->sk_sndtimeo, MAX_SCHEDULE_TIMEOUT);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(sock_set_sndtimeo);
@@ -1708,12 +1710,14 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 
 	case SO_RCVTIMEO_OLD:
 	case SO_RCVTIMEO_NEW:
-		lv = sock_get_timeout(sk->sk_rcvtimeo, &v, SO_RCVTIMEO_OLD == optname);
+		lv = sock_get_timeout(READ_ONCE(sk->sk_rcvtimeo), &v,
+				      SO_RCVTIMEO_OLD == optname);
 		break;
 
 	case SO_SNDTIMEO_OLD:
 	case SO_SNDTIMEO_NEW:
-		lv = sock_get_timeout(sk->sk_sndtimeo, &v, SO_SNDTIMEO_OLD == optname);
+		lv = sock_get_timeout(READ_ONCE(sk->sk_sndtimeo), &v,
+				      SO_SNDTIMEO_OLD == optname);
 		break;
 
 	case SO_RCVLOWAT:
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 49bae3d5006b0..b1f1b49d35edf 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -568,7 +568,7 @@ META_COLLECTOR(int_sk_rcvtimeo)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_rcvtimeo / HZ;
+	dst->value = READ_ONCE(sk->sk_rcvtimeo) / HZ;
 }
 
 META_COLLECTOR(int_sk_sndtimeo)
@@ -579,7 +579,7 @@ META_COLLECTOR(int_sk_sndtimeo)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_sndtimeo / HZ;
+	dst->value = READ_ONCE(sk->sk_sndtimeo) / HZ;
 }
 
 META_COLLECTOR(int_sk_sendmsg_off)
-- 
2.40.1



