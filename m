Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375602E659
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B183BC433C9;
	Wed, 20 Sep 2023 12:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211904;
	bh=k5CQEzYUEmw9OfHAkW6Uu+wxz1Mu/XCh2DPZrQiytog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGYhe0NfJaGHBwGi2TrLgJoIMVDifgTvT5TVdQT5Bo5kIypIANJR0zRozo2s0JZmv
	 N3JhpnVYizcJyrLQ4P+GR0PsI1gpTJWRCFpFTsaRiTG59ubvVAGRAfj/mc8HQg4N6/
	 y2B41E//BMi3stDyElNKanfhAIUCiRYu1oFuG63U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yan Zhai <yan@cloudflare.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/273] lwt: Check LWTUNNEL_XMIT_CONTINUE strictly
Date: Wed, 20 Sep 2023 13:28:21 +0200
Message-ID: <20230920112848.336681879@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

From: Yan Zhai <yan@cloudflare.com>

[ Upstream commit a171fbec88a2c730b108c7147ac5e7b2f5a02b47 ]

LWTUNNEL_XMIT_CONTINUE is implicitly assumed in ip(6)_finish_output2,
such that any positive return value from a xmit hook could cause
unexpected continue behavior, despite that related skb may have been
freed. This could be error-prone for future xmit hook ops. One of the
possible errors is to return statuses of dst_output directly.

To make the code safer, redefine LWTUNNEL_XMIT_CONTINUE value to
distinguish from dst_output statuses and check the continue
condition explicitly.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/96b939b85eda00e8df4f7c080f770970a4c5f698.1692326837.git.yan@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/lwtunnel.h | 5 ++++-
 net/ipv4/ip_output.c   | 2 +-
 net/ipv6/ip6_output.c  | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 33fd9ba7e0e5a..ec75c0a1c529f 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -16,9 +16,12 @@
 #define LWTUNNEL_STATE_INPUT_REDIRECT	BIT(1)
 #define LWTUNNEL_STATE_XMIT_REDIRECT	BIT(2)
 
+/* LWTUNNEL_XMIT_CONTINUE should be distinguishable from dst_output return
+ * values (NET_XMIT_xxx and NETDEV_TX_xxx in linux/netdevice.h) for safety.
+ */
 enum {
 	LWTUNNEL_XMIT_DONE,
-	LWTUNNEL_XMIT_CONTINUE,
+	LWTUNNEL_XMIT_CONTINUE = 0x100,
 };
 
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 92fa11e75a4d0..6936f703758bb 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -221,7 +221,7 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 	if (lwtunnel_xmit_redirect(dst->lwtstate)) {
 		int res = lwtunnel_xmit(skb);
 
-		if (res < 0 || res == LWTUNNEL_XMIT_DONE)
+		if (res != LWTUNNEL_XMIT_CONTINUE)
 			return res;
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4f31a781ab370..ff4d349e13f78 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -106,7 +106,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	if (lwtunnel_xmit_redirect(dst->lwtstate)) {
 		int res = lwtunnel_xmit(skb);
 
-		if (res < 0 || res == LWTUNNEL_XMIT_DONE)
+		if (res != LWTUNNEL_XMIT_CONTINUE)
 			return res;
 	}
 
-- 
2.40.1



