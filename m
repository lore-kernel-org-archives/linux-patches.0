Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CEC1C4609;
	Wed, 19 Feb 2025 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955443; cv=none; b=TrMaXzEig7DQ+6b/fpJaFotYtoc9YlsRVBMj/tBqDL3dlwfGAdOrBTwRgqua600AeSvYhnvxRQnMClAn4yZV/+SiPq8+bSkBCyoJZ+am+Ocyz2wqo6XF/baw/yGc4D7WTiY2o46idwuGzcAFHjKrjHEBrKxV9gq7fnuYwqKJplE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955443; c=relaxed/simple;
	bh=aQ4GRJzQ7SZSiH/d4BG/FB3yOV5Vdy3lBBwzFfW6v6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9Ry1kNj3n6EKmsLdI07JAniodKsDakC7a4gyr/dZx5J7yw5xuVkHHtd2+S7ZM7RbH+3VWQMikUKi60uZfgcTZFxSZIVijDHgc0rXUnB1eQ+HEx2uilKLJNVY01MtZXMvpY7RwKtn8YaU/zarTKm/qut897EgOc5J7EdMQ1q1Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dN4P20Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dN4P20Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAECEC4CED1;
	Wed, 19 Feb 2025 08:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955443;
	bh=aQ4GRJzQ7SZSiH/d4BG/FB3yOV5Vdy3lBBwzFfW6v6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dN4P20WqddQWNFQZyLXyP4g0fUGN8EKYtYyyu+6JQe0j3m+7gWujhZ1ianCrq8WeY
	 Dl4HUvsxsUTF0ip4J7W3/GNnLd8u5z8V0ZqDED7jp+RdJAoY/wFFg8oyxiFRGhLDCQ
	 Iq21/wZSUW3y+sv9+ziTrWKGddmM7nHD2w+l9Wq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/230] ndisc: use RCU protection in ndisc_alloc_skb()
Date: Wed, 19 Feb 2025 09:28:33 +0100
Message-ID: <20250219082609.364657813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 264b10a947577..90f8aa2d7af2e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -418,15 +418,11 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
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
@@ -437,7 +433,9 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
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



