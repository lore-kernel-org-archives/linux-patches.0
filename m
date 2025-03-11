Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47ED925C715;
	Tue, 11 Mar 2025 15:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705990; cv=none; b=cGFxFoNHCgCwlbNJUGg120YhOxFsSA7oJPcKud3hPEk3HwKjR7Xs9wIM71VQp3V2qxF+/xHv9z6CbluMdCDHc+vj7E1KiMkMw+r2krALrtQmua7m3M1nxsi5lmhvjt/QgCceDE/Ejn0e4+r9fsVNFvqPdTDRJoPzWMP1+XNdE3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705990; c=relaxed/simple;
	bh=s00B+dSNut3PWhsPhrcELyxzriTrJAxu/B49gn2R1oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGYGaLww2Pkavq/5lxaR3En41fP1p1DNxcdI1z+LzX7DYt9a7ujKLCU+wqJTDYs0uKXM2dT9QbDk/lf8aYSxzTofcaXKEdwrTyBBcLAFBpgM2zAzqxYwodEeGxMskOGkjcnmHk6y6MQrvA8m+bl5HO0PqbURYc1VqvgD8EUwYC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8EYWZ1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8EYWZ1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DD7C4CEE9;
	Tue, 11 Mar 2025 15:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705990;
	bh=s00B+dSNut3PWhsPhrcELyxzriTrJAxu/B49gn2R1oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8EYWZ1nAur1zKMARSzl0VGoMk/w9fmQC7hqHTjPsw+iAVbkN7HxC8ezo7w4VbS8+
	 eB/T2jZfbO9Y0Y7Mr7FIgC+MTWsM2cwdauTsaQP7kkgkPsAOTvvBjjvhPjcF0XBVr2
	 A8uiIK0C7ZeQda+5eAOdxdCZzbr+8qVx509pF6eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 206/328] ndisc: use RCU protection in ndisc_alloc_skb()
Date: Tue, 11 Mar 2025 15:59:36 +0100
Message-ID: <20250311145723.094432887@linuxfoundation.org>
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

[ Upstream commit 628e6d18930bbd21f2d4562228afe27694f66da9 ]

ndisc_alloc_skb() can be called without RTNL or RCU being held.

Add RCU protection to avoid possible UAF.

Fixes: de09334b9326 ("ndisc: Introduce ndisc_alloc_skb() helper.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 3096807caecab..92e35b3096dba 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -416,15 +416,11 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
 {
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	struct sock *sk = dev_net(dev)->ipv6.ndisc_sk;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(hlen + sizeof(struct ipv6hdr) + len + tlen, GFP_ATOMIC);
-	if (!skb) {
-		ND_PRINTK(0, err, "ndisc: %s failed to allocate an skb\n",
-			  __func__);
+	if (!skb)
 		return NULL;
-	}
 
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
@@ -435,7 +431,9 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
 	/* Manually assign socket ownership as we avoid calling
 	 * sock_alloc_send_pskb() to bypass wmem buffer limits
 	 */
-	skb_set_owner_w(skb, sk);
+	rcu_read_lock();
+	skb_set_owner_w(skb, dev_net_rcu(dev)->ipv6.ndisc_sk);
+	rcu_read_unlock();
 
 	return skb;
 }
-- 
2.39.5



