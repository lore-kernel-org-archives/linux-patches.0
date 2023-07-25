Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEA61ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF30C433C8;
	Tue, 25 Jul 2023 11:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284833;
	bh=ZknIXTGme+516XjQD57xXVVQU9/BYcybhU/cvZzy/Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xakvajEWx+LW3+83kRNI7g4sSplD9hJCvESb4nmgcZjtYZew1dezJ3EdE3+5gXBQ1
	 F6TBLiQVdX8SO/xJ8bEMUd4y0L6PTaN8mbkMtG3jnR7R8Sbg6XjoHH9fIcL+DFDOAC
	 CuoyJvLA0zmURx8IgYpxPZ8M/E1Q3fLPTVfAQjQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/509] tcp: annotate data-races around tp->keepalive_probes
Date: Tue, 25 Jul 2023 12:47:15 +0200
Message-ID: <20230725104616.469681776@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit 6e5e1de616bf5f3df1769abc9292191dfad9110a ]

do_tcp_getsockopt() reads tp->keepalive_probes while another cpu
might change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 9 +++++++--
 net/ipv4/tcp.c    | 5 +++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 428f84f6e0d0c..be81a930b91fa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1475,9 +1475,14 @@ static inline int keepalive_time_when(const struct tcp_sock *tp)
 static inline int keepalive_probes(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
+	int val;
+
+	/* Paired with WRITE_ONCE() in tcp_sock_set_keepcnt()
+	 * and do_tcp_setsockopt().
+	 */
+	val = READ_ONCE(tp->keepalive_probes);
 
-	return tp->keepalive_probes ? :
-		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_probes);
+	return val ? : READ_ONCE(net->ipv4.sysctl_tcp_keepalive_probes);
 }
 
 static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b5a05b0984146..80212bb0400c2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3138,7 +3138,8 @@ int tcp_sock_set_keepcnt(struct sock *sk, int val)
 		return -EINVAL;
 
 	lock_sock(sk);
-	tcp_sk(sk)->keepalive_probes = val;
+	/* Paired with READ_ONCE() in keepalive_probes() */
+	WRITE_ONCE(tcp_sk(sk)->keepalive_probes, val);
 	release_sock(sk);
 	return 0;
 }
@@ -3330,7 +3331,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		if (val < 1 || val > MAX_TCP_KEEPCNT)
 			err = -EINVAL;
 		else
-			tp->keepalive_probes = val;
+			WRITE_ONCE(tp->keepalive_probes, val);
 		break;
 	case TCP_SYNCNT:
 		if (val < 1 || val > MAX_TCP_SYNCNT)
-- 
2.39.2



