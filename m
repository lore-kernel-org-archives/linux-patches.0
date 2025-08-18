Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CC631CA62;
	Mon, 18 Aug 2025 13:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524844; cv=none; b=AV45xiJg/m/3epnLwI5MOgYaVTaGPkx25QtafsfIm9m9FvnCD9k8q1fLsLrhLbltEAFC/0sYTA+A4RpFnx5b0ZBDyM4X7au8qil/vBcACXI6CP+iMx7jxFPFd97c2s0ZHar38VHZnsEh+SICqcvBnr30wsKpkiE/F7qO1wKxe/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524844; c=relaxed/simple;
	bh=8P5uRurJO2UYmjXDhsV/iPl2sgR9HfhT+7dFPx6107E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcgECIBLCh2POlOE7BoS2VDIRhMr7AcKcPdwRJBubh0kRoeifPFbABcReRaWddpNBTKy2r8oHbGrPGOX8kampyStMdP84hgNkzVRaHyU7Q92P/Ca7UQM9jGER+TrXYFpVilQg4AiHxLK6YFyhJ9MKaw3dRz+IsgoK6iPhtL+VMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFf5Lb18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFf5Lb18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B514FC4CEEB;
	Mon, 18 Aug 2025 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524844;
	bh=8P5uRurJO2UYmjXDhsV/iPl2sgR9HfhT+7dFPx6107E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFf5Lb18Rp6i1HIWssNPMQbZlVSZU/VUnFx0ZGDuIFzatmL88GDsU7ms03sJRWBbD
	 jfOcBcwX1gzJwFdhENskGbYgRLdv5+Bjp3JXeqoZTBF47dHAiYDR9r8WfeXWVbuksE
	 dfA66ahljllqhy8JKYzxCT0kOsDjuoyEAB05FbIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 063/570] xfrm: bring back device check in validate_xmit_xfrm
Date: Mon, 18 Aug 2025 14:40:50 +0200
Message-ID: <20250818124508.244629654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 65f079a6c446a939eefe71e6d5957d5d6365fcf9 ]

This is partial revert of commit d53dda291bbd993a29b84d358d282076e3d01506.

This change causes traffic using GSO with SW crypto running through a
NIC capable of HW offload to no longer get segmented during
validate_xmit_xfrm, and is unrelated to the bonding use case mentioned
in the commit.

Fixes: d53dda291bbd ("xfrm: Remove unneeded device check from validate_xmit_xfrm")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 1f88472aaac0..c7a1f080d2de 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -155,7 +155,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	if (skb_is_gso(skb) && unlikely(xmit_xfrm_check_overflow(skb))) {
+	if (skb_is_gso(skb) && (unlikely(x->xso.dev != dev) ||
+				unlikely(xmit_xfrm_check_overflow(skb)))) {
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
-- 
2.50.1



