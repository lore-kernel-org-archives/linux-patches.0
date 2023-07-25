Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8580815AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073CBC433C8;
	Tue, 25 Jul 2023 10:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282670;
	bh=85g6DID9k2ibS8z1TTDX47AxZiK/O5St7gTuDb91eao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5trJj7bR2GdpEaf1s+oraVEEAXMHrQ90+2QTBWnXwMDKEnXT4FxyS9RxFPyBx9NA
	 3treGE7cehURI9FaOrlBLYsg321fuLac1FPEi1KQHcqijApDK+k6bjOXhiNMYhabUn
	 izTlx2m0QmYn7A6sGiHYHT9F3JZeL2BfqR6F7wa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 212/227] tcp: annotate data-races around icsk->icsk_syn_retries
Date: Tue, 25 Jul 2023 12:46:19 +0200
Message-ID: <20230725104523.533588016@linuxfoundation.org>
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

[ Upstream commit 3a037f0f3c4bfe44518f2fbb478aa2f99a9cd8bb ]

do_tcp_getsockopt() and reqsk_timer_handler() read
icsk->icsk_syn_retries while another cpu might change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 net/ipv4/tcp.c                  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1386787eaf1a5..3105a676eba76 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1016,7 +1016,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 	icsk = inet_csk(sk_listener);
 	net = sock_net(sk_listener);
-	max_syn_ack_retries = icsk->icsk_syn_retries ? :
+	max_syn_ack_retries = READ_ONCE(icsk->icsk_syn_retries) ? :
 		READ_ONCE(net->ipv4.sysctl_tcp_synack_retries);
 	/* Normally all the openreqs are young and become mature
 	 * (i.e. converted to established socket) for first timeout.
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cc7966cfad1a3..488cf4ae75fab 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3400,7 +3400,7 @@ int tcp_sock_set_syncnt(struct sock *sk, int val)
 		return -EINVAL;
 
 	lock_sock(sk);
-	inet_csk(sk)->icsk_syn_retries = val;
+	WRITE_ONCE(inet_csk(sk)->icsk_syn_retries, val);
 	release_sock(sk);
 	return 0;
 }
@@ -3681,7 +3681,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		if (val < 1 || val > MAX_TCP_SYNCNT)
 			err = -EINVAL;
 		else
-			icsk->icsk_syn_retries = val;
+			WRITE_ONCE(icsk->icsk_syn_retries, val);
 		break;
 
 	case TCP_SAVE_SYN:
@@ -4102,7 +4102,7 @@ int do_tcp_getsockopt(struct sock *sk, int level,
 		val = keepalive_probes(tp);
 		break;
 	case TCP_SYNCNT:
-		val = icsk->icsk_syn_retries ? :
+		val = READ_ONCE(icsk->icsk_syn_retries) ? :
 			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		break;
 	case TCP_LINGER2:
-- 
2.39.2



