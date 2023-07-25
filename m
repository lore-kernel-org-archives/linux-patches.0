Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472415AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ECEC433C7;
	Tue, 25 Jul 2023 10:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282664;
	bh=nixOx57yWWFbrAJPtpK5YVgblRlGyTCnfNbwt2T3BzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C01a1wFXjUn0wTRkfbVavmUL1mqNauajxW9R0osOcEkoN9JF3Wv+3eMa7BoZG+0KF
	 UmHLtc/6mREAsIuhpqAkZQjJM3goD1+Q7uSdGSXkkdwxIz/hZTR8kFbQE9IUuAgcat
	 PDgGt0EVm5sI90GNTICb7BWjGH0QIblVKwLkJAGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 210/227] tcp: annotate data-races around tp->keepalive_intvl
Date: Tue, 25 Jul 2023 12:46:17 +0200
Message-ID: <20230725104523.465880078@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5ecf9d4f52ff2f1d4d44c9b68bc75688e82f13b4 ]

do_tcp_getsockopt() reads tp->keepalive_intvl while another cpu
might change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 9 +++++++--
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9a12e8c09ea04..45d50a40795da 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1514,9 +1514,14 @@ void tcp_leave_memory_pressure(struct sock *sk);
 static inline int keepalive_intvl_when(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
+	int val;
+
+	/* Paired with WRITE_ONCE() in tcp_sock_set_keepintvl()
+	 * and do_tcp_setsockopt().
+	 */
+	val = READ_ONCE(tp->keepalive_intvl);
 
-	return tp->keepalive_intvl ? :
-		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_intvl);
+	return val ? : READ_ONCE(net->ipv4.sysctl_tcp_keepalive_intvl);
 }
 
 static inline int keepalive_time_when(const struct tcp_sock *tp)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c3b743093d482..514817119bd4d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3454,7 +3454,7 @@ int tcp_sock_set_keepintvl(struct sock *sk, int val)
 		return -EINVAL;
 
 	lock_sock(sk);
-	tcp_sk(sk)->keepalive_intvl = val * HZ;
+	WRITE_ONCE(tcp_sk(sk)->keepalive_intvl, val * HZ);
 	release_sock(sk);
 	return 0;
 }
@@ -3668,7 +3668,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
 			err = -EINVAL;
 		else
-			tp->keepalive_intvl = val * HZ;
+			WRITE_ONCE(tp->keepalive_intvl, val * HZ);
 		break;
 	case TCP_KEEPCNT:
 		if (val < 1 || val > MAX_TCP_KEEPCNT)
-- 
2.39.2



