Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032570;
	b=DosiD5mATvZfdhJh43xujZ2qE6YJIbYf248fzOr9mjF/A9jgCJosHxmF3sUJEc85FvSL
	 tYr8YlRTJi06EzPwwhHDJs0cnSO0LjISlaYz9zI0+9/c1Qa1/gI7LNar4uLhPGesuLZWx
	 dOV1T6Mwil3rEp3sFxBkhultp9NKVGADmIWHW+HIjTpbfPn02ctnn1WEpa5AkX1Lbd5AA
	 J4sHhxzzvkKijRtlXe78B1LTlTHumlwHAidf7WKzRTGgiwfUyQG91pVaDMl0iLYAWJMoH
	 +LzSdE1E46kqblu7xVKJsrlRLwQ8W1YkJtTO49o46+JAIlgEqQDTS8DDSiRr2CNvpmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F4DuofMogERHWcB7S8Hk93DXSPzjmoZCMkGvn+bbPcQ=;
	b=qNa7tgW7ODrP5ble36fv8Yi6vt97HUC2IsQZcYbXJphNF5/jPsf0zxuEo+HXSdlI5mbb
	 ikV/3JPv7R0cUpT/GlSwDfFz2NERVKSwPAM9e2YA7wHEawlXBCtgFHMu6GvY0OUMVOHaq
	 A7FB31f4YfIkNv+19AELQKDpcZm/0HLR5KuGfCCThS9bmfMr0g9kjvY4M9FZsiB0Jcoar
	 v6Sg3u7+rNF9Ag8bGgm7MsVc8zt7Brt/jEJ79ZEHxGmBrx9oF9Ahpq8wl4I+LKPmu5LzH
	 wrNV//gQZMh9WNNdgvtepyielVe5VCpQfXLAnXDrONoB55/bTYant6xjlBVcEW1+ZlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIVKIeHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D134C606A32A;
	Wed, 18 Nov 2026 20:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kIVKIeHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DBA1F000C4;
	Wed, 18 Nov 2026 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032570;
	bh=F4DuofMogERHWcB7S8Hk93DXSPzjmoZCMkGvn+bbPcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIVKIeHqYL1w1D7yb7BNpHOdbbw6S2U22SK0aDx+KBwPngPTu5pXv0t5IFioSZUVt
	 R7/BiE7WHqFEH/SGmsvrVj+MReWbGp0kbbgu82SV7nQ5ZYV/Wb0Chsb+6f6fz1Iaoe
	 rOMG5J55VHvEv9kl9Pbi4vmaFIEs44p4yEgNAWXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1456/1756] net: bcmasp: fix network filter lookup and wake filter pair allocation
Date: Wed, 18 Nov 2026 15:59:43 +0100
Message-ID: <20261118150107.049445363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit fa1459375794f14fb65039cd19c9398d759b491e ]

In bcmasp_netfilt_get_init(), when looking up an existing filter (!init)
for a specified location, if the filter at loc was not claimed, the
previous loop continued searching higher indices and could return an
arbitrary unrelated filter belonging to the port. This caused flow get or
delete operations on an empty rule location to return or delete an
unintended filter.

Fix this by checking only the requested location on lookup and rejecting
RX_CLS_LOC_ANY when !init. In addition, harden wake filter allocation
and release by ensuring wake filter pair searches stay on even boundaries
where both entries are free, checking that loc + 1 is free for positioned
wake filters, and validating parity and bounds on release.

Fixes: c5d511c49587 ("net: bcmasp: Add support for wake on net filters")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-7-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 121 +++++++++++---------
 1 file changed, 70 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index d34d3e2c0be15..35a35aa0ad69b 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -511,6 +511,13 @@ static int bcmasp_netfilt_wr_to_hw(struct bcmasp_priv *priv,
 	return 0;
 }
 
+static bool bcmasp_netfilt_is_companion(struct bcmasp_priv *priv, int i)
+{
+	return i > 0 && (i % 2) &&
+	       priv->net_filters[i].wake_filter &&
+	       priv->net_filters[i - 1].wake_filter;
+}
+
 void bcmasp_netfilt_suspend(struct bcmasp_intf *intf)
 {
 	struct bcmasp_priv *priv = intf->parent;
@@ -524,9 +531,7 @@ void bcmasp_netfilt_suspend(struct bcmasp_intf *intf)
 		    priv->net_filters[i].port != intf->port)
 			continue;
 
-		if (i > 0 && (i % 2) &&
-		    priv->net_filters[i].wake_filter &&
-		    priv->net_filters[i - 1].wake_filter)
+		if (bcmasp_netfilt_is_companion(priv, i))
 			continue;
 
 		ret = bcmasp_netfilt_wr_to_hw(priv, &priv->net_filters[i]);
@@ -556,9 +561,7 @@ int bcmasp_netfilt_get_all_active(struct bcmasp_intf *intf, u32 *rule_locs,
 		    priv->net_filters[i].port != intf->port)
 			continue;
 
-		if (i > 0 && (i % 2) &&
-		    priv->net_filters[i].wake_filter &&
-		    priv->net_filters[i - 1].wake_filter)
+		if (bcmasp_netfilt_is_companion(priv, i))
 			continue;
 
 		if (j == *rule_cnt)
@@ -583,9 +586,7 @@ int bcmasp_netfilt_get_active(struct bcmasp_intf *intf)
 			continue;
 
 		/* Skip over a wake filter pair */
-		if (i > 0 && (i % 2) &&
-		    priv->net_filters[i].wake_filter &&
-		    priv->net_filters[i - 1].wake_filter)
+		if (bcmasp_netfilt_is_companion(priv, i))
 			continue;
 
 		cnt++;
@@ -607,6 +608,9 @@ bool bcmasp_netfilt_check_dup(struct bcmasp_intf *intf,
 		    priv->net_filters[i].port != intf->port)
 			continue;
 
+		if (bcmasp_netfilt_is_companion(priv, i))
+			continue;
+
 		cur = &priv->net_filters[i].fs;
 
 		if (cur->flow_type != fs->flow_type ||
@@ -659,7 +663,7 @@ bool bcmasp_netfilt_check_dup(struct bcmasp_intf *intf,
 }
 
 /* If no network filter found, return open filter.
- * If no more open filters return NULL
+ * If no more open filters return error.
  */
 struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *intf,
 						  u32 loc, bool wake_filter,
@@ -669,45 +673,55 @@ struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *intf,
 	struct bcmasp_priv *priv = intf->parent;
 	int i, open_index = -1;
 
-	/* Check whether we exceed the filter table capacity */
+	if (!init) {
+		if (loc == RX_CLS_LOC_ANY || loc >= priv->num_net_filters)
+			return ERR_PTR(-EINVAL);
+
+		if (priv->net_filters[loc].claimed &&
+		    priv->net_filters[loc].port == intf->port &&
+		    !bcmasp_netfilt_is_companion(priv, loc))
+			return &priv->net_filters[loc];
+
+		return ERR_PTR(-ENOENT);
+	}
+
 	if (loc != RX_CLS_LOC_ANY && loc >= priv->num_net_filters)
 		return ERR_PTR(-EINVAL);
 
 	/* If the filter location is busy (already claimed) and we are initializing
 	 * the filter (insertion), return a busy error code.
 	 */
-	if (loc != RX_CLS_LOC_ANY && init && priv->net_filters[loc].claimed)
-		return ERR_PTR(-EBUSY);
-
-	/* We need two filters for wake-up, so we cannot use an odd filter */
-	if (wake_filter && loc != RX_CLS_LOC_ANY && (loc % 2))
-		return ERR_PTR(-EINVAL);
-
-	/* Initialize the loop index based on the desired location or from 0 */
-	i = loc == RX_CLS_LOC_ANY ? 0 : loc;
-
-	for ( ; i < priv->num_net_filters; i++) {
-		/* Found matching network filter */
-		if (!init &&
-		    priv->net_filters[i].claimed &&
-		    priv->net_filters[i].hw_index == i &&
-		    priv->net_filters[i].port == intf->port)
-			return &priv->net_filters[i];
-
-		/* If we don't need a new filter or new filter already found */
-		if (!init || open_index >= 0)
-			continue;
-
-		/* Wake filter conslidates two filters to cover more bytes
-		 * Wake filter is open if...
-		 * 1. It is an even filter
-		 * 2. The current and next filter is not claimed
-		 */
-		if (wake_filter && !(i % 2) && !priv->net_filters[i].claimed &&
-		    !priv->net_filters[i + 1].claimed)
-			open_index = i;
-		else if (!priv->net_filters[i].claimed)
-			open_index = i;
+	if (loc != RX_CLS_LOC_ANY) {
+		if (priv->net_filters[loc].claimed)
+			return ERR_PTR(-EBUSY);
+
+		/* We need two filters for wake-up, so we cannot use an odd filter */
+		if (wake_filter) {
+			if ((loc % 2) || loc + 1 >= priv->num_net_filters)
+				return ERR_PTR(-EINVAL);
+			if (priv->net_filters[loc + 1].claimed)
+				return ERR_PTR(-EBUSY);
+		}
+		open_index = loc;
+	} else {
+		for (i = 0; i < priv->num_net_filters; i++) {
+			/* Wake filter consolidates two filters to cover more bytes.
+			 * Wake filter is open if:
+			 * 1. It is an even filter
+			 * 2. The current and next filter is not claimed
+			 */
+			if (wake_filter) {
+				if (!(i % 2) && (i + 1 < priv->num_net_filters) &&
+				    !priv->net_filters[i].claimed &&
+				    !priv->net_filters[i + 1].claimed) {
+					open_index = i;
+					break;
+				}
+			} else if (!priv->net_filters[i].claimed) {
+				open_index = i;
+				break;
+			}
+		}
 	}
 
 	if (open_index >= 0) {
@@ -716,16 +730,20 @@ struct bcmasp_net_filter *bcmasp_netfilt_get_init(struct bcmasp_intf *intf,
 		nfilter->port = intf->port;
 		nfilter->ch = intf->channel + priv->tx_chan_offset;
 		nfilter->hw_index = open_index;
-	}
 
-	if (wake_filter && open_index >= 0) {
-		/* Claim next filter */
-		priv->net_filters[open_index + 1].claimed = true;
-		priv->net_filters[open_index + 1].wake_filter = true;
-		nfilter->wake_filter = true;
+		if (wake_filter) {
+			/* Claim next filter */
+			priv->net_filters[open_index + 1].claimed = true;
+			priv->net_filters[open_index + 1].wake_filter = true;
+			priv->net_filters[open_index + 1].hw_index = open_index + 1;
+			priv->net_filters[open_index + 1].port = intf->port;
+			priv->net_filters[open_index + 1].ch = intf->channel +
+							       priv->tx_chan_offset;
+			nfilter->wake_filter = true;
+		}
 	}
 
-	return nfilter ? nfilter : ERR_PTR(-EINVAL);
+	return nfilter ? nfilter : ERR_PTR(-ENOSPC);
 }
 
 void bcmasp_netfilt_release(struct bcmasp_intf *intf,
@@ -733,7 +751,8 @@ void bcmasp_netfilt_release(struct bcmasp_intf *intf,
 {
 	struct bcmasp_priv *priv = intf->parent;
 
-	if (nfilt->wake_filter) {
+	if (nfilt->wake_filter && !(nfilt->hw_index % 2) &&
+	    nfilt->hw_index + 1 < priv->num_net_filters) {
 		memset(&priv->net_filters[nfilt->hw_index + 1], 0,
 		       sizeof(struct bcmasp_net_filter));
 	}
-- 
2.53.0



