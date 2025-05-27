Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F10878F32;
	Tue, 27 May 2025 17:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365224; cv=none; b=oLbVK2A9KTChk+L3/rjzX9dlA3sye4xyYZYwp7sHiyNMItsjELnoy5URuYhPYHifNWXYdcim42Yqq2iIJTvnzB5tO6MCZoWUekV6KOs8mxrRt9dS/X2LI1yOmScOikUQKEayF5H+pp6swfT63PLrg/FTLnodmxPnkFrJ6rnuGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365224; c=relaxed/simple;
	bh=t+wPqRJ9zdOkHlaVs+1soJq31DUUAIJvlUlNf+Xjqww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8darqqXg/uVmhO3m/cX87vNwL5+SFpJLMCMWvnjxOG7mQY9IpA4AhwuU6JWW65pjKcvYq8YoVQ7u1tEniRjFCsnXpxLBqFMPRsyr3KnTf69EotdkjFfK+VrNHDnBtaVupFQRDy8KBUccs+zcr+FPmEbiGH7OTfO6d7QpKA1gg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWHdyxvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWHdyxvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCABC4CEE9;
	Tue, 27 May 2025 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365223;
	bh=t+wPqRJ9zdOkHlaVs+1soJq31DUUAIJvlUlNf+Xjqww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWHdyxvpVO3v6qRT9y+qB+ByAtk7Tff0glmFQHhEuAQKYN6WTfIo0a0JsVPu75T73
	 6qI1laYIYoxf6p8SeDteEX3RJZ+M1ZSnXHEh2cSeYIlOWdBLx+f62TwI754f5mXm6f
	 BhcmVmemSG3NrpmtRYPfJvoENjumaRgAxTiuNg/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/626] net: ethernet: mtk_ppe_offload: Allow QinQ, double ETH_P_8021Q only
Date: Tue, 27 May 2025 18:22:52 +0200
Message-ID: <20250527162456.363145190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Eric Woudstra <ericwouds@gmail.com>

[ Upstream commit 7fe0353606d77a32c4c7f2814833dd1c043ebdd2 ]

mtk_foe_entry_set_vlan() in mtk_ppe.c already supports double vlan
tagging, but mtk_flow_offload_replace() in mtk_ppe_offload.c only allows
for 1 vlan tag, optionally in combination with pppoe and dsa tags.

However, mtk_foe_entry_set_vlan() only allows for setting the vlan id.
The protocol cannot be set, it is always ETH_P_8021Q, for inner and outer
tag. This patch adds QinQ support to mtk_flow_offload_replace(), only in
the case that both inner and outer tags are ETH_P_8021Q.

Only PPPoE-in-Q (as before) and Q-in-Q are allowed. A combination
of PPPoE and Q-in-Q is not allowed.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Link: https://patch.msgid.link/20250225201509.20843-1-ericwouds@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index f20bb390df3ad..c855fb799ce14 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -34,8 +34,10 @@ struct mtk_flow_data {
 	u16 vlan_in;
 
 	struct {
-		u16 id;
-		__be16 proto;
+		struct {
+			u16 id;
+			__be16 proto;
+		} vlans[2];
 		u8 num;
 	} vlan;
 	struct {
@@ -349,18 +351,19 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 		case FLOW_ACTION_CSUM:
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
-			if (data.vlan.num == 1 ||
+			if (data.vlan.num + data.pppoe.num == 2 ||
 			    act->vlan.proto != htons(ETH_P_8021Q))
 				return -EOPNOTSUPP;
 
-			data.vlan.id = act->vlan.vid;
-			data.vlan.proto = act->vlan.proto;
+			data.vlan.vlans[data.vlan.num].id = act->vlan.vid;
+			data.vlan.vlans[data.vlan.num].proto = act->vlan.proto;
 			data.vlan.num++;
 			break;
 		case FLOW_ACTION_VLAN_POP:
 			break;
 		case FLOW_ACTION_PPPOE_PUSH:
-			if (data.pppoe.num == 1)
+			if (data.pppoe.num == 1 ||
+			    data.vlan.num == 2)
 				return -EOPNOTSUPP;
 
 			data.pppoe.sid = act->pppoe.sid;
@@ -450,12 +453,9 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f,
 	if (offload_type == MTK_PPE_PKT_TYPE_BRIDGE)
 		foe.bridge.vlan = data.vlan_in;
 
-	if (data.vlan.num == 1) {
-		if (data.vlan.proto != htons(ETH_P_8021Q))
-			return -EOPNOTSUPP;
+	for (i = 0; i < data.vlan.num; i++)
+		mtk_foe_entry_set_vlan(eth, &foe, data.vlan.vlans[i].id);
 
-		mtk_foe_entry_set_vlan(eth, &foe, data.vlan.id);
-	}
 	if (data.pppoe.num == 1)
 		mtk_foe_entry_set_pppoe(eth, &foe, data.pppoe.sid);
 
-- 
2.39.5



