Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA4F1EA7E
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3306AC433C7;
	Tue, 25 Jul 2023 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283411;
	bh=Zvjawh1/4N4zFoePaMmjh5NVk337pUc+UwAWI71gFWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJITOKEuFRQ36KFn0N5ihRCLwMbdK4aiaAwBo46DoGmjCJLQDlrrZd6SzG5RJQXl7
	 HnIrIFxqZYnw7ytE0pTP9zvRzawtC9KUzS8XwkqhANqag39kRFXCtlLvwIal9OCaOV
	 iwd5JfqzDz57XxiebIDktKlwpdiXYLoME5fLeqy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 67/78] tcp: annotate data-races around tp->keepalive_intvl
Date: Tue, 25 Jul 2023 12:46:58 +0200
Message-ID: <20230725104453.874666168@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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
index f9a24f48fa986..b737ce77f7062 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1473,9 +1473,14 @@ void tcp_leave_memory_pressure(struct sock *sk);
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
index 54219e2080019..8fe1098b183d0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3350,7 +3350,7 @@ int tcp_sock_set_keepintvl(struct sock *sk, int val)
 		return -EINVAL;
 
 	lock_sock(sk);
-	tcp_sk(sk)->keepalive_intvl = val * HZ;
+	WRITE_ONCE(tcp_sk(sk)->keepalive_intvl, val * HZ);
 	release_sock(sk);
 	return 0;
 }
@@ -3564,7 +3564,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
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



