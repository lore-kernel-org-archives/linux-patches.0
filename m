Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B15D33121F;
	Wed,  8 Apr 2026 18:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674043; cv=none; b=GoRhSIkUuaVeA7NeT8mJZFe59btFdb8CoI5iTFhFKoQg4nHhbIsBGBytgylDLR1BPOLYbgzJj6D26H+gd30UM6P/4huA6SF2nkAyJe7okCzx+JTeV8L8Fokc3CbMjXWMPBu+ORx4DpiReK4zMn5theKf/yzqtd0hv1Yw86vvzUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674043; c=relaxed/simple;
	bh=aEeDHQ+csSsrtIo/Uiild1BgL/ehQQWhHBe4iCxi7Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4vWywPPmRvD41AbsyhAuh7yXXeWWobBRQd3kd+T6PN2KlNNUbV8D/tVZL82PJq4Xqm2SAkdt2GgQSn3Hu3pavdLudwL/r54gQuTxmCb0ROw3tNebSSCEDWJFOQp7xmZ4VPXUdpLUcUSemeMd0D2FN1r1Q0AFoK19xioj+PT9uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynuzkPTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynuzkPTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCADDC19421;
	Wed,  8 Apr 2026 18:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674043;
	bh=aEeDHQ+csSsrtIo/Uiild1BgL/ehQQWhHBe4iCxi7Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynuzkPTxXXiIM6Lyv+/6eEZDQ9zBwMd4q5r6kzkJMRIJSl5qHBx+w5AUAh3I1AAi6
	 L3deBRxKQVdgGjt8FB1p5cJgq4oliQhb2XvLKGR9OaLk/5HVKLlMI9BgLQlg3cGf8D
	 moTieSiChFrw5uZAldkIUbreSy2yvtqwfo3z9sR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sven Eckelmann (Plasma Cloud)" <se@simonwunderlich.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 188/242] net: ethernet: mtk_ppe: avoid NULL deref when gmac0 is disabled
Date: Wed,  8 Apr 2026 20:03:48 +0200
Message-ID: <20260408175934.119818643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>

commit 976ff48c2ac6e6b25b01428c9d7997bcd0fb2949 upstream.

If the gmac0 is disabled, the precheck for a valid ingress device will
cause a NULL pointer deref and crash the system. This happens because
eth->netdev[0] will be NULL but the code will directly try to access
netdev_ops.

Instead of just checking for the first net_device, it must be checked if
any of the mtk_eth net_devices is matching the netdev_ops of the ingress
device.

Cc: stable@vger.kernel.org
Fixes: 73cfd947dbdb ("net: ethernet: mtk_eth_soc: ppe: prevent ppe update for non-mtk devices")
Signed-off-by: Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260324-wed-crash-gmac0-disabled-v1-1-3bc388aee565@simonwunderlich.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -244,6 +244,25 @@ out:
 	return 0;
 }
 
+static bool
+mtk_flow_is_valid_idev(const struct mtk_eth *eth, const struct net_device *idev)
+{
+	size_t i;
+
+	if (!idev)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(eth->netdev); i++) {
+		if (!eth->netdev[i])
+			continue;
+
+		if (idev->netdev_ops == eth->netdev[i]->netdev_ops)
+			return true;
+	}
+
+	return false;
+}
+
 static int
 mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 			 int ppe_index)
@@ -270,7 +289,7 @@ mtk_flow_offload_replace(struct mtk_eth
 		flow_rule_match_meta(rule, &match);
 		if (mtk_is_netsys_v2_or_greater(eth)) {
 			idev = __dev_get_by_index(&init_net, match.key->ingress_ifindex);
-			if (idev && idev->netdev_ops == eth->netdev[0]->netdev_ops) {
+			if (mtk_flow_is_valid_idev(eth, idev)) {
 				struct mtk_mac *mac = netdev_priv(idev);
 
 				if (WARN_ON(mac->ppe_idx >= eth->soc->ppe_num))


