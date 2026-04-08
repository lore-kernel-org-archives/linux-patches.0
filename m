Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B680D3D6694;
	Wed,  8 Apr 2026 19:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674905; cv=none; b=Osm34mFMMnd/SdkHdUYOSZjy3LtjkSaHOkMFv9KkhwV8Yo6tfz9+aSH8T9EdaGZQXFtRQxQm769CFgvTu9TPJ+KbPm7q7x8HdypPU3vMdrPSqb4kB1hmn4FNQ4xp7AtyTUu8nnPDYsJDTfP7yyimZQq7tGu/C6mvzGp52HfhtgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674905; c=relaxed/simple;
	bh=IWYB195z31ONlyuMYdK/WZpe/shblcm6Uv4Ynda4R3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fhs+e7nfacnYihczLB0PHz0B6lEYiQ7877fDFqwFOXymtLbje6hvDGNz+0+aQIj7X0pIG3h9vb1/9ebLoq0xtdg+YJAOBeZDkvHCRl/89/93TS8kufawnAgyqJ7pU8408j8ccsFT3bY7z/zVB206cybNmstfTlyOx3lGHQQENyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoSan/L5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoSan/L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79496C19421;
	Wed,  8 Apr 2026 19:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674904;
	bh=IWYB195z31ONlyuMYdK/WZpe/shblcm6Uv4Ynda4R3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoSan/L5JPrj8BU9Oi7E7ReBx5Mmqk4TEwKEwppIO85KhYTiFMZu9nNHq0P26xjSy
	 h0k0zA83zR/Nf7IXSLxikeRNYafVCki50RytH6mG5ZMfTu3DPffc9mraZcryIv7hmg
	 9kF3LY81b2CEnacPqIwtYpcCYREma0FaZEiTO0Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sven Eckelmann (Plasma Cloud)" <se@simonwunderlich.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 277/311] net: ethernet: mtk_ppe: avoid NULL deref when gmac0 is disabled
Date: Wed,  8 Apr 2026 20:04:37 +0200
Message-ID: <20260408175949.722933213@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


