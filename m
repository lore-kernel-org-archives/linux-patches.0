Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB9A3FF1B5;
	Thu, 30 Jul 2026 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421647; cv=none; b=YlRoheA+QS2yPSkBqhidj9AaJwlODxfHYov30jeDV9M/4EWR2N2Cutkv5UOZtIw2thlgH5vOkq738Q0d1tw2IcbG7qQUdLczSCyQ0b5Rlxzfc2S5XDauN01QAvatwkxHP9vnN5o/bAdyIdyECkyqTjA3XvPDefvM5JV1Qe9Cbzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421647; c=relaxed/simple;
	bh=eFuiyWgBH0V1j5nMI8oS+bN43e2QzV17ltWZ3KIcbFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNYPOIFhNtp/aEtIINIs1+dW44UXlCYMP3KU+hTenEV/YZKfevUqK1MJAmdtsX6pQVaBMX04rm/HaCl2OS9NJKHQJmPBwA5OgMMA18jiMhjyU0Kq2UOqB79i4RbSprm+AI+B9Grm5TWKpG6VYXALH3YqhjYSxU7C0hJQ4lU4Y8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KufnqXwi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KufnqXwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E387C1F000E9;
	Thu, 30 Jul 2026 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421646;
	bh=07cAFS4y4oIb2/kAWa9M3HXRweTW8ICXh45JSBMDfVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KufnqXwis+UZBouDmerIJHKg0JNDoeg/KaAk+5ReRz2VsHXOUTeCOuRPHJzDBp4gZ
	 1lyjX1Z31XBKXKcjkVO7hS8zuhNFJjY6c8NTFh7Y11Vt0RpUq+JdBOrdeX0sh22y19
	 lkLER6U6zZx2gKoFft5a5lzvOLQyiLkgbxRgqBcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 130/744] tcp: fix TIME_WAIT socket reference leak on PSP policy failure
Date: Thu, 30 Jul 2026 16:06:43 +0200
Message-ID: <20260730141447.043656803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2c1931a81122c3cdc4c89448fe0442c69e21c0d5 ]

Release the TIME_WAIT socket reference and jump to discard_it
upon PSP policy failure in both IPv4 and IPv6 receive paths.
This prevents a memory leak of tcp_tw_bucket structures.

Fixes: 659a2899a57d ("tcp: add datapath logic for PSP with inline key exchange")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/20260710181317.4060230-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 6 ++++--
 net/ipv6/tcp_ipv6.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index bfdabad01fa765..d5cd238358ef04 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2319,8 +2319,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 
 		drop_reason = psp_twsk_rx_policy_check(inet_twsk(sk), skb);
-		if (drop_reason)
-			break;
+		if (drop_reason) {
+			inet_twsk_put(inet_twsk(sk));
+			goto discard_it;
+		}
 	}
 		/* to ACK */
 		fallthrough;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 36d75fb50a70b7..71cca3c74423f5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1962,8 +1962,10 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		}
 
 		drop_reason = psp_twsk_rx_policy_check(inet_twsk(sk), skb);
-		if (drop_reason)
-			break;
+		if (drop_reason) {
+			inet_twsk_put(inet_twsk(sk));
+			goto discard_it;
+		}
 	}
 		/* to ACK */
 		fallthrough;
-- 
2.53.0



