Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037499;
	b=3z43r3IgpBcEY88Wb/gozyoeRuWdPNEXeoxMC/iPtS6b6fYohg4Zy9GyvD771us8Qnzl
	 XKwtKzvysRRYrzO0sxrFP6czdKaEuqbz57jdOiu+VVzjkssfqLPoHYSRVCuJ6nib6TSKr
	 tvVgurEhvRjz0iGWFYr/3QPNNAFgwZjdFXv11F3ZXuyhXH4fiX5G0cpKeqgHZUZEMnIkz
	 GtCcBenpTzqwSwWbjxfGnrP6GKCe4mESoF8jt2Qmynm/JQbwpLt3YJm7oee+mZrtguDvg
	 DVWHqFWZL8hzdceTp8ujDUBaBdR0Ftth8yMDOi7ZZ1EcgNFeHZTyVjyD8riK9c4YJ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dub2SCRXf0ERyu9kdEUwmXGZvH/2leV3waa3oaX2jxs=;
	b=U2rEcDUzG4SfN9e5LagZ2SLwEfmQk3CG6NHRbjiG6OwOS0s6PfLW1xgU+WQtZaCnP2aC
	 TwyT28Vx8Z7CIGxiJcR9cQMqSDPaOZPcGlof6gZaQSUD/IOHfXmHU5Nkpnrdc7X7KoAXE
	 pnbx0pSpQ6tcb3ixqVdAZLxiCe1qV9fPowY24VWbPYl/w9GHl7r8yhrUpciSpvsK/EoxN
	 /2xDW1D8sVHBapSJXBFbZY8Kq+qnhyKnveFtm6s4L2wOfDqrEJg3tp9DdxBQSt+MAFtQy
	 jomP/ougzCYsF7WVWZypxmdk6Gj392Mbc06xSVYXgNHUy8uu/rL1eJ2A0NKgBvUK7EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uETKkOtB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6514B606A32F;
	Wed, 18 Nov 2026 21:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uETKkOtB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FF31F000C4;
	Wed, 18 Nov 2026 21:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037499;
	bh=dub2SCRXf0ERyu9kdEUwmXGZvH/2leV3waa3oaX2jxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uETKkOtBlvv/2T4Hvlj490nqvgEsLa9htlzXvBaYiA/UMizmfQcPB69T0kE5YVM5f
	 absJ7evd9OmE7HV4yDreB+xNRl/qJVorBiww6NT8speMS5DCCKr5FRtLPazXmn+mqP
	 /QqpuzSaPUeOOFuRC95/yWOEuGSO3HMg0W9/qYrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1417/3318] batman-adv: fix skb leak when hard_iface is being released
Date: Wed, 18 Nov 2026 15:33:59 +0100
Message-ID: <20261118150403.199794913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 522e4aece2e96cacbb8a6ae1eec0d4c0dd6f4fed ]

batadv_batman_skb_recv() owns the skb it is given. When the hard_iface
refcount already dropped to zero, the function jumped to err_out, which
only returned NET_RX_DROP and skipped the kfree_skb() under err_free.

To avoid a leak, free the skb before returning in this case.

Cc: stable@vger.kernel.org
Fixes: 4fe56e60ac1b ("batman-adv: Check hard_iface refcnt when receiving skb")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 650e9bacbb79d..48065fd09e1a8 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -448,8 +448,10 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	 * shut down otherwise the packet may trigger de-reference errors
 	 * further down in the receive path.
 	 */
-	if (!kref_get_unless_zero(&hard_iface->refcount))
-		goto err_out;
+	if (!kref_get_unless_zero(&hard_iface->refcount)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 
@@ -508,7 +510,6 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 err_put:
 	batadv_hardif_put(hard_iface);
-err_out:
 	return NET_RX_DROP;
 }
 
-- 
2.53.0



