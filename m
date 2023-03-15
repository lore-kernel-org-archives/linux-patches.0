Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DBA4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DBEC433EF;
	Wed, 15 Mar 2023 12:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883232;
	bh=yX16k0Nh2KcYRzjmDNVj+RByDoVhwVbko8q98jgCSMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBGq6BxLGz/DiAF8dG6gWLw6uNIsawVT+OU8dtN5TlAnqx4eNd3UV8K8QL+nntHQk
	 Ok9RUTUOFwLEJlz/2xrUiPKrN990cx5XrMtchnsLhMyp+D+rePa8KG6tF5vqUuTq4l
	 +P3PfqWfiCUsbdAwtae3i1Y+LMkNZcshF8zQgdKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Major=20D=C3=A1vid?= <major.david@balasys.hu>
Subject: [PATCH 5.15 065/145] netfilter: tproxy: fix deadlock due to missing BH disable
Date: Wed, 15 Mar 2023 13:12:11 +0100
Message-Id: <20230315115741.182320068@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 4a02426787bf024dafdb79b362285ee325de3f5e ]

The xtables packet traverser performs an unconditional local_bh_disable(),
but the nf_tables evaluation loop does not.

Functions that are called from either xtables or nftables must assume
that they can be called in process context.

inet_twsk_deschedule_put() assumes that no softirq interrupt can occur.
If tproxy is used from nf_tables its possible that we'll deadlock
trying to aquire a lock already held in process context.

Add a small helper that takes care of this and use it.

Link: https://lore.kernel.org/netfilter-devel/401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu/
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-and-tested-by: Major Dávid <major.david@balasys.hu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tproxy.h   | 7 +++++++
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index 82d0e41b76f22..faa108b1ba675 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -17,6 +17,13 @@ static inline bool nf_tproxy_sk_is_transparent(struct sock *sk)
 	return false;
 }
 
+static inline void nf_tproxy_twsk_deschedule_put(struct inet_timewait_sock *tw)
+{
+	local_bh_disable();
+	inet_twsk_deschedule_put(tw);
+	local_bh_enable();
+}
+
 /* assign a socket to the skb -- consumes sk */
 static inline void nf_tproxy_assign_sock(struct sk_buff *skb, struct sock *sk)
 {
diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index b2bae0b0e42a1..61cb2341f50fe 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -38,7 +38,7 @@ nf_tproxy_handle_time_wait4(struct net *net, struct sk_buff *skb,
 					    hp->source, lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 6bac68fb27a39..3fe4f15e01dc8 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -63,7 +63,7 @@ nf_tproxy_handle_time_wait6(struct sk_buff *skb, int tproto, int thoff,
 					    lport ? lport : hp->dest,
 					    skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 		if (sk2) {
-			inet_twsk_deschedule_put(inet_twsk(sk));
+			nf_tproxy_twsk_deschedule_put(inet_twsk(sk));
 			sk = sk2;
 		}
 	}
-- 
2.39.2



