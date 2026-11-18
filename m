Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019077;
	b=WSjS1M5SIpXviaqSBZZOCqxDPIv/AT/apsOecPTuIuAy6evlNJjzvVVi8Ee02cwRG6tr
	 IBVzf+oGUkhmgRUwi7qHHay3JfzLGSysK15SyIL7J7Ogoe73GAfr/ChETd9r6WboSZyGh
	 ORDNc7U7bmsprS6LxJnowaAHfR2PbfyktFS4oVzW06Wr1K1FGh6FxDI9A1bA7vTvI2cdC
	 f0baBKXE+Qcv2tHcYcjKvr1xiLQCfdzO2WMKXTeb67XJVaHc/AsDCHA44D6ii8ZEl7/Xb
	 /eCoZMSw0w9BVVzyfQF+Q0KCOLKVfSa/sQSctBTsarZjacR7MhliuI4+GYOcQHu6P9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdBrxbKqlbwYsBlesea63+4ELe5YP+Sr2hrfzd8s4uw=;
	b=PYXclnz7kTFrxSlE8sawztWcrEqhuCk5Lf/GRAPReTj16Y9byXVNLkdMKj0aSO6Y87pf
	 kv/hlqHIqgqT3115u4QZMxOWTVqPsxxJpLNvJyuvVByujStvEZuJJZyRPR6DUQOrtmxjJ
	 mh/GjkxjbbfIU3kWM7PX+nuuHQSI+u4eHlfU9neCPx44Hcz93gtLoylxwE2lo5iAjaRdv
	 cXrKA3JpnUCWzx3vKM5PXJV6OAnOcqnsahmyvTAmbnT+2RU0q02OcxnvVZ+WRZXpK7d02
	 LHr4llnsP4xk92R9jz7hwQTVdYzVFcq5pd0VU1AI1NDTTcx20inA1AeU63Nk283gnRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xL+5azzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F301760A2605;
	Wed, 18 Nov 2026 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xL+5azzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CCBB1F000C4;
	Wed, 18 Nov 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019076;
	bh=DdBrxbKqlbwYsBlesea63+4ELe5YP+Sr2hrfzd8s4uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xL+5azzRsidcHe0zk3mc8+l0X3RzE2HS/4N+0BByNd2arMsM37vdZ+fFDcYTiOb2s
	 sCDKYrpy6HDU3I1XqM6hbGq8FhL1AdrGCZGollqLr8GyBu4EOPsaPsr2W/DOvHnYuJ
	 4SWZ48TVWk3xRoRCctB16TwHx3G//iQQsn0Z8sRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1466/2651] wifi: mt76: abort a scan only for a link change on the scanning radio
Date: Wed, 18 Nov 2026 15:45:06 +0100
Message-ID: <20261118150340.813433435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c7a6b6a1dcc8fc0ac49ec0d7418b4603684e7d73 ]

mt76_assign_vif_chanctx() and mt76_unassign_vif_chanctx() abort the
scan whenever the scanning vif gains or loses a link, on any radio. An
AP MLD that scans on one radio for ACS while its link on another radio
comes up therefore loses the whole scan, and hostapd gets an aborted
scan. mac80211 does not continue an aborted scan with the next band.

The scan uses the link of the vif that mt76_get_vif_phy_link() returns
for the scanning radio, so it needs to stop only for a channel context
on that radio: the new link would duplicate the offchannel link, or the
removed link is the one the scan uses. Abort only in that case, as
mt76_add_chanctx() does.

Fixes: e411b8190fe7 ("wifi: mt76: add multi-radio support to scanning code")
Link: https://patch.msgid.link/20261006205936.669125-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 903f3a420e4ca..8d4daa76be541 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -114,7 +114,7 @@ int mt76_assign_vif_chanctx(struct ieee80211_hw *hw,
 	bool mlink_alloc = false;
 	int ret = 0;
 
-	if (dev->scan.vif == vif)
+	if (dev->scan.vif == vif && dev->scan.phy == phy)
 		mt76_abort_scan(dev);
 
 	mutex_lock(&dev->mutex);
@@ -161,7 +161,7 @@ void mt76_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt76_phy *phy = ctx->phy;
 	struct mt76_dev *dev = phy->dev;
 
-	if (dev->scan.vif == vif)
+	if (dev->scan.vif == vif && dev->scan.phy == phy)
 		mt76_abort_scan(dev);
 
 	mutex_lock(&dev->mutex);
-- 
2.53.0



