Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046209;
	b=FJQJOU5V2H7kJeUM90IiMY72JdZKJcAl7OdnE/iDj4yttJb4m0VsjOkuwnoys6AmJUFl
	 mA71u8Cnc2HR//nvVj5LezZ0fwjIdE/7lay1O+mGhZB96zlqLXDgdXOsYGVBde6cjdCJl
	 oBUs7D12itGB5Q0Bh0B3gYA026NjV81a3IMolrXXx1OGCjyKCHLwjbRntBkKSnbdxbHz2
	 xu34E//wsL8uELrgZctT4GVIZGvxzNY2hkPU6RT7uk+Rv2Q7PrQOsvtkzzYTNoGmmS+Bi
	 W3gCeSdMJoV0fn2VdZla3jz9Ct+GWGGrEZkQrnXxNEaS3JkfnmzP/EjgD+9co8Xl81Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ccRqTVVdWGZY02zgv/iaO24TkzpX4jKfVloZNIb3PoU=;
	b=zwcxJywVlD86mwvy66sh8EX9Fco5lvv00lxFwrRqdi/JeVUMCIlyn1voB4AlvvkRbnlr
	 T4Hv5MNkVCIOkLZrGXvG2CUavz8xrStoIlP8ZwNp5ig7QKjFZ9uGuHxuiWOWlcQ/L0rYk
	 C5iEg+CI+mQNXpQVVR/xHkpZd9JDxh6QBepxse2rE7v35crOLX29wtOns50SG3ozvk5Ic
	 MayLucHr/pqZnMXAZPvUymqxzI0cib9qPPLo/gPapvyYuViAHCRs+Q2vqm4TelXOxH0l4
	 GnHRl1HARz0PQ3EIiBilw0WxxGSNiD7zjQItx/fOiY5Ly8mcVVJCJwrG3qvrondIiNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbzLa6UO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362AF606A325;
	Wed, 18 Nov 2026 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbzLa6UO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898CC1F000C8;
	Wed, 18 Nov 2026 23:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046209;
	bh=ccRqTVVdWGZY02zgv/iaO24TkzpX4jKfVloZNIb3PoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbzLa6UOyJ+PwdcCA6e74pjEvU0DBc1SImbF9lgZ72CxTRa6wzxV2NxMBPG8V0Yni
	 +lerPlzhLGFNE9bQMpyfx7mWKLxtJvhMnwCGutgfmLFO+1Lzr8iEOC01jovVdfbblQ
	 Fv4wTisFt8bpClBLZvhSygwRlr8IfSbEEoVAGL2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1198/2857] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Wed, 18 Nov 2026 15:37:12 +0100
Message-ID: <20261118150244.750765899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



