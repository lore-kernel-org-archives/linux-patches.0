Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DF97D411;
	Wed, 21 Feb 2024 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524377; cv=none; b=Lr34g1hzw57DQWDFp70uFGyzF2v0gpjFaXiPJyw0jIR7M5lQsv1YNxWcw9kZsBQZ1RlCO9NEMM5Qizj71OzT30IwFoMnsk9QhcskzpXLgLH/QAxKotvscMG3yakvJ6HHyNKeCGJZN0xqVifO0LicxZ6kPwlte1gMdR145hYkogU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524377; c=relaxed/simple;
	bh=jz8t9wxalv0aksXs0qUjKptVytbxedTOL5FCjE9AwZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPnzd81WJrd1HfQ9TuLcXLv6DnsPYOkmqvh7dpodAiIxAs4LmCaZ88xN8AtOKiY5bjhLixRP4gEi4sBg/EvXwAbk8ywC/ergDuJ5M1e3KcQlc0l/YyNaMjN1M1QxXS2F7GoTksOZ2qorJpAu6FHGQxCPmx0hR728qfmHamsqrik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WD4jbWck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WD4jbWck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBFBC43394;
	Wed, 21 Feb 2024 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524376;
	bh=jz8t9wxalv0aksXs0qUjKptVytbxedTOL5FCjE9AwZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD4jbWck94GhhtacPiwmuWDxT12W/97TEDNL9CVOoqBtZEp37Cg0ZS6DgZU/ZnrH8
	 4S39GAZGhPNWIVaV5HG7r8/BUWLwo57AB26ueodQSj3TEwfI4q6HlxvZ36NF6PdLwW
	 etMJvkKHeA9EJV+JqsQqGRbJ+UciqCmlw7Q2e4ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/379] ip6_tunnel: use dev_sw_netstats_rx_add()
Date: Wed, 21 Feb 2024 14:06:45 +0100
Message-ID: <20240221130001.584365907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit afd2051b18404640a116fd3bb2460da214ccbda4 ]

We have a convenient helper, let's use it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8d975c15c0cd ("ip6_tunnel: make sure to pull inner header in __ip6_tnl_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index edf4a842506f..9b8b209b780a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -829,7 +829,6 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 						struct sk_buff *skb),
 			 bool log_ecn_err)
 {
-	struct pcpu_sw_netstats *tstats;
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int err;
 
@@ -888,11 +887,7 @@ static int __ip6_tnl_rcv(struct ip6_tnl *tunnel, struct sk_buff *skb,
 		}
 	}
 
-	tstats = this_cpu_ptr(tunnel->dev->tstats);
-	u64_stats_update_begin(&tstats->syncp);
-	tstats->rx_packets++;
-	tstats->rx_bytes += skb->len;
-	u64_stats_update_end(&tstats->syncp);
+	dev_sw_netstats_rx_add(tunnel->dev, skb->len);
 
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(tunnel->dev)));
 
-- 
2.43.0



