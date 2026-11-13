Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590191;
	b=WKGtZBNX2+FbFP5SoMR9YO6iUAzJBnyWiCB6v5PYEH6CAevCEx2VKO8r/OMOL3l/6wnL
	 6+PXCLiXcyqDByypjG3fwoXhEq9xj6GeI6/kCFnRFoIjgAthkm6oLgTmo16vG4TtwD63I
	 sEsMpPD3K/3/IiqpD7TkxvlPUo/oiEJIwbqpLuSsdmmlkzvFaJT2hpkTSIclpz7vwwGlb
	 KwGdxyfhBcdLr6eQT27A0TyKmxI7n9nMHwFz75nJ8kMOZBDyp4tHTnJ/iBc02PebmFbw6
	 E9isJuAWT3Lx+vTlQq1Kc/bSb4M/7PItzODrqDntfS5/84bF7VeCQevUuVoqerld45A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V13w3GfqjahtxN1/IfxzVS4dQ0Hfk3F68o2jk2nnvVg=;
	b=ieRnTTZrobVbZOoiyKZZ7xZP2nMFxmEFO9RMLbbHyVIEZyCTfEfneRUpLygLDmPNm/oL
	 L/s0jQxj6yhuctDxQKv6l+9/w6UF8rUiX6+vTKKHMd+6CgXlvuZuQhrdgKLZzG+2v7qHP
	 G577RiYOZCEtinRxO0ggpsLO/7J5L3wIsOloIp0l58KVGV8vq9RqiqxwynIK0/MqbagaZ
	 gcfEL/xNxXw3t+KlXuVy90yp1PndxiuZUZNY3wz9VH75OpMNL8e74Xc8e7XykFJqWrv10
	 iFKAl4ihHA4eJzFztPNZL7ceLE9/1MB5nDspuNn5afA/VSKqC3vXleuv7sujxW3zEiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zguh/KsR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A956074B1F;
	Fri, 13 Nov 2026 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zguh/KsR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B321F000C5;
	Fri, 13 Nov 2026 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590191;
	bh=V13w3GfqjahtxN1/IfxzVS4dQ0Hfk3F68o2jk2nnvVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zguh/KsRDeW1HeSIOBj+Y93CdbfMQOaZO/7XN5AFfstKduDKaK89MAX2ttj8QI1W6
	 xp4u5caE+exKNgCoHHJViEfuCyqCnSAQm+JHWaTn7NvYwINHdq+kMVXkYN72HvLOaU
	 TyGmJE8oO3Kgjca16jdYXxXKFGqUoDSLw4GIda1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/686] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Fri, 13 Nov 2026 10:45:32 -0500
Message-ID: <20261113153827.795448886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 71f756a4c064b0312f46617c20893ecc17c332e4 ]

When transmitting a non-QoS unicast frame to a station in AP mode,
rsi_core_xmit() assigns IEEE80211_NONQOS_TID (16) to tid. The station
lookup succeeds, allowing tid to index start_tx_aggr[], which has only
IEEE80211_NUM_TIDS (16) elements. This causes an out-of-bounds read and,
if the value read is zero, an out-of-bounds write.

Only access the aggregation state for tids below IEEE80211_NUM_TIDS,
excluding the non-QoS sentinel from TX aggregation setup.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 19844c0a9a19 ("rsi: data and managemet path changes for AP mode")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261015072010.742369-1-a.kazinsky@ideco.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index ead4d4e043280..3281fc94e1078 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -458,7 +458,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			tx_params->sta_id = 0;
 		}
 
-		if (rsta) {
+		if (rsta && tid < IEEE80211_NUM_TIDS) {
 			/* Start aggregation if not done for this tid */
 			if (!rsta->start_tx_aggr[tid]) {
 				rsta->start_tx_aggr[tid] = true;
-- 
2.53.0



