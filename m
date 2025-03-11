Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B0925DAFD;
	Tue, 11 Mar 2025 15:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705999; cv=none; b=UUFMWgaCI5UccYIBEB6hQyRAJQsFnPcL1Q7K5pTW5m8FRh9400p7FkfanA0SUoGAPGNeoklNsOS5T8k/tZvemkkvgx+AGAJ/SNgx7o/IcvgZG6ktHSB1vaPwxKKWmjnud5iLmez4qU73Ry+rGiw9PZNxodRMTzWtTMO8pGwq7hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705999; c=relaxed/simple;
	bh=RB5J4l+O0y24ZibzdnkVsUmjF1ktD5NUAELtT6EPvyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQHB8bcR2hsRFpaTuMK4vZIDP/55qvrl/1ld+wYzHXibS4X371WObvcZvg9s47Ca029LbGTJ4N2p4ALDySvZ8VezsZe0HZ/xXM3hmFUGRcE2cqTc9gjIWjXpMO8Rj5HMftr4ObRXBl4Rq7wCtmxam6E8JEEubXBhjAz4vp2cSIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B35lcx63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B35lcx63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A067EC4CEE9;
	Tue, 11 Mar 2025 15:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705999;
	bh=RB5J4l+O0y24ZibzdnkVsUmjF1ktD5NUAELtT6EPvyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B35lcx63Djwwm9+EwESk2pNs3fdDtOHo08SM4TrCQ2kBXRCTKzpbpOYtlJFHi67Hf
	 GKNlyZ2raeZHmDa/PXSIRIDXj8n/ZtH/0t6tkNhceoKBsoVeutdOgxzGEE2Wzceukm
	 kOsAYWO4KDd29bd7lsVFpBp3CJIzfrjCVZ9Tq8ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/328] arp: use RCU protection in arp_xmit()
Date: Tue, 11 Mar 2025 15:59:39 +0100
Message-ID: <20250311145723.210793579@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a42b69f692165ec39db42d595f4f65a4c8f42e44 ]

arp_xmit() can be called without RTNL or RCU protection.

Use RCU protection to avoid potential UAF.

Fixes: 29a26a568038 ("netfilter: Pass struct net into the netfilter hooks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index b8fe943ae89d0..9455b96449e5a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -637,10 +637,12 @@ static int arp_xmit_finish(struct net *net, struct sock *sk, struct sk_buff *skb
  */
 void arp_xmit(struct sk_buff *skb)
 {
+	rcu_read_lock();
 	/* Send it off, maybe filter it using firewalling first.  */
 	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT,
-		dev_net(skb->dev), NULL, skb, NULL, skb->dev,
+		dev_net_rcu(skb->dev), NULL, skb, NULL, skb->dev,
 		arp_xmit_finish);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(arp_xmit);
 
-- 
2.39.5



