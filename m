Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8115886A;
	Tue,  9 Jul 2024 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524032; cv=none; b=KtGgzxI6tdhFJU0ED+LyDJYufV7vCLxmjPQFNcAXyc3kgGL1YgpdgryPXU+UToiOPY3x61TjeHkciEnt66g8YUQjVrnkvt3zsGEcGqAJZKxEP34TUV1s4CLg8GwMrvy/trjBJwL9QyKklLtfjLecgBz4aseHhxUuVn3BdSgIKa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524032; c=relaxed/simple;
	bh=GdPL9nETBl3+SroSuHS7JxlFS9kJT8cT26IKZWjHOkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoYhW5MyQmzBnoWkSMwVkMW7pu2KHH1amI2oBUtM0BHHZonovRGdteUplXUMPh+5hAb7FJhOu6Zmtq+YMKnF3CG+mWaOJgLCp0VvIRr46YQh/wTG+km3bYRYgPhMyNT19BylEfmjsIRLB/Ox5kQ3RhQ5JsRkd9h0WND976WZExw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtzYTiV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtzYTiV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA373C32786;
	Tue,  9 Jul 2024 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524032;
	bh=GdPL9nETBl3+SroSuHS7JxlFS9kJT8cT26IKZWjHOkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtzYTiV56hhuo+TwtvpL9Fs2kAT66Y8f/JNm2Fdx7bSCLzc3/y8nQTKx0ijJdauEO
	 82RDABzjY5KLk8H7DCkihv1deDhJxdbWCCPxLzzGcdvf4c/SlYPT4kXDioX+bx4HFq
	 7v5h/kIe6LSzXN4jcuxkqICKIMCHcnGfyABlqcJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 048/197] wifi: mt76: mt7996: add sanity checks for background radar trigger
Date: Tue,  9 Jul 2024 13:08:22 +0200
Message-ID: <20240709110710.822853697@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit ec55d8e7dfea92daff87f5c01689633f8c4e6a62 ]

Check if background radar is enabled or not before manually triggering it,
and also add more checks in radar detected event.

Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c     | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 9bd953586b041..62c03d088925c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -225,6 +225,11 @@ mt7996_radar_trigger(void *data, u64 val)
 	if (val > MT_RX_SEL2)
 		return -EINVAL;
 
+	if (val == MT_RX_SEL2 && !dev->rdd2_phy) {
+		dev_err(dev->mt76.dev, "Background radar is not enabled\n");
+		return -EINVAL;
+	}
+
 	return mt7996_mcu_rdd_cmd(dev, RDD_RADAR_EMULATE,
 				  val, 0, 0);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index e86c05d0eecc9..bc3b2babb094d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -355,7 +355,10 @@ mt7996_mcu_rx_radar_detected(struct mt7996_dev *dev, struct sk_buff *skb)
 	if (r->band_idx >= ARRAY_SIZE(dev->mt76.phys))
 		return;
 
-	if (dev->rdd2_phy && r->band_idx == MT_RX_SEL2)
+	if (r->band_idx == MT_RX_SEL2 && !dev->rdd2_phy)
+		return;
+
+	if (r->band_idx == MT_RX_SEL2)
 		mphy = dev->rdd2_phy->mt76;
 	else
 		mphy = dev->mt76.phys[r->band_idx];
-- 
2.43.0



