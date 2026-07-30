Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D094C3FADF1;
	Thu, 30 Jul 2026 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423538; cv=none; b=XvOjraHsqKt1yLoS0k2qa21/GGjCMrgg/m9WW+I9kAC4NSf1zkl09OWJbPsRWOZLGX0i0CU9Qm9chMCI36tKKrgfCOz5z4ElaIlmM6z7xEMV0VcNyjZM5rGg7qKbatwcHAXxWFOU878vOcAgDYwlMud2As+HSb8tsVNl/fVPxoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423538; c=relaxed/simple;
	bh=iw2XKpyqI8vU6v6eToiZjSKK8rm5T2kst1/iQxoOsl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjWSbjO8QfQ6Tubvhmv0qcdo8wmZtFn85dlUmZapx6Gko5LKbiaiTpxj3BWcPzDwCT53Ia6MqzyrLFAyRKY5GgtyMVQ5YSq78JZqujrV4UoE34g5503/gLt7AZA9gYu1feVU6p+H7XhXGGaxSzV9s56ELNe/meAB/MXVITQw+Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQ9e5ZD7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQ9e5ZD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2548E1F000E9;
	Thu, 30 Jul 2026 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423537;
	bh=OP3G/lrP+V50yO1wiXo7AF6SnLkIiyTE8dUnnch4AXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ9e5ZD7KsqaARSii2Cia9NIURWTwGbHpl4K5joZLfvokSOwamPR0lglJTtjv0eKK
	 aX3zlf2mR0AJ/2hXsnm1C7o/K6tF7/lL/scvE0sAKjqDi3xoMqmH5S8e6jVeLxsekD
	 rTbYMkSw16lq+aj4Lq5S6kDQAEXNGECTfEIKwAvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Petr Wozniak <petr.wozniak@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/675] xfrm: propagate -EINPROGRESS from validate_xmit_xfrm()
Date: Thu, 30 Jul 2026 16:06:05 +0200
Message-ID: <20260730141445.866361440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Wozniak <petr.wozniak@gmail.com>

[ Upstream commit 6860b467f569f732b11cbc588ae7e195e90e7e23 ]

validate_xmit_xfrm() returns NULL both when a packet is dropped and
when it is stolen by async crypto (-EINPROGRESS from ->xmit()).
Callers cannot distinguish the two cases.

f53c723902d1 ("net: Add asynchronous callbacks for xfrm on layer 2.")
changed the semantics of a NULL return from "dropped" to "stolen or
dropped", but __dev_queue_xmit() was not updated.  On virtual/bridge
interfaces (noqueue qdisc) __dev_queue_xmit() initialises rc=-ENOMEM
and jumps to out: when skb is NULL, returning -ENOMEM to the caller
even though the packet will be delivered correctly via xfrm_dev_resume().

Return ERR_PTR(-EINPROGRESS) from validate_xmit_xfrm() for the async
case so callers can tell it apart from a real drop.  Update
__dev_queue_xmit() to handle ERR_PTR(-EINPROGRESS) from
validate_xmit_skb() correctly.  Update validate_xmit_skb_list() to
use IS_ERR_OR_NULL() so that ERR_PTR(-EINPROGRESS) is not mistakenly
added to the transmitted list.

Fixes: f53c723902d1 ("net: Add asynchronous callbacks for xfrm on layer 2.")
Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c         | 10 ++++++++--
 net/xfrm/xfrm_device.c |  4 ++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 246d654551ae56..a83083e8761b1b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4005,6 +4005,9 @@ static struct sk_buff *validate_xmit_unreadable_skb(struct sk_buff *skb,
 	return NULL;
 }
 
+/* Returns the skb on success, NULL if dropped, or ERR_PTR(-EINPROGRESS)
+ * if stolen by async xfrm crypto (delivered via xfrm_dev_resume()).
+ */
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
 	netdev_features_t features;
@@ -4076,7 +4079,7 @@ struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *d
 		skb->prev = skb;
 
 		skb = validate_xmit_skb(skb, dev, again);
-		if (!skb)
+		if (IS_ERR_OR_NULL(skb))
 			continue;
 
 		if (!head)
@@ -4788,8 +4791,11 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 			goto recursion_alert;
 
 		skb = validate_xmit_skb(skb, dev, &again);
-		if (!skb)
+		if (IS_ERR_OR_NULL(skb)) {
+			if (PTR_ERR(skb) == -EINPROGRESS)
+				rc = NET_XMIT_SUCCESS;
 			goto out;
+		}
 
 		HARD_TX_LOCK(dev, txq, cpu);
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 550457e4c4f01d..8b526e3676389a 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -182,7 +182,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		err = x->type_offload->xmit(x, skb, esp_features);
 		if (err) {
 			if (err == -EINPROGRESS)
-				return NULL;
+				return ERR_PTR(-EINPROGRESS);
 
 			XFRM_INC_STATS(xs_net(x), LINUX_MIB_XFRMOUTSTATEPROTOERROR);
 			kfree_skb(skb);
@@ -224,7 +224,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		pskb = skb2;
 	}
 
-	return skb;
+	return skb ? skb : ERR_PTR(-EINPROGRESS);
 }
 EXPORT_SYMBOL_GPL(validate_xmit_xfrm);
 
-- 
2.53.0



