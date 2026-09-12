Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC41641169F;
	Sat, 12 Sep 2026 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216790; cv=none; b=XComdJG1EpbWI4yx4MAo3T7WSu8JGfsiBE31kX8D5JDo8mKKZBfSxDBUohhNwm6ehTtAiKjCSq9ATcSIKLxrLI4tvB5ZSS8wDK9YXMQOYLUHzhECMm7WW9GuDGr3M+sRRxb3gCWlQMhCn9xqrvdHmCbsG4cCZESk5kLCCFgWlmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216790; c=relaxed/simple;
	bh=aJziMbzZS5UDM4Kiu/YUO2w0BQnpElX4zsFw7iyR3g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CB19rnF6Q7ezroWra2FLwQucdtvUCBc4KOFwf0S1k8/gSqMdAWS0FLCxMTnFUCHQsZdXWznKr+6pxBOatLDasEoRfSECDVrQ2loe2Tptvd0QyDWbs9j18uZjy7+wDHQ+LTn2198XjgbyBFyTBYOkBXuSg5mnJgZJnYQUkvFjjCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrK6in4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrK6in4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F057E1F000FF;
	Sat, 12 Sep 2026 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216789;
	bh=7E+63+OMMMOvuEhyl2gvoF2QEriarsalFlJTl+TOebU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrK6in4E1yY37N6FO6bJX/gaa0Hi2JrxTW7RyWhCY4iYbLtXjsxeYoISYWpoyrdXB
	 FCyLdV4+GjENS75SHduVl6rr6KSMfnlgRCpW1LtZNywBhXWfYUwlsp0u6zAYd+W23D
	 pP7Vpf4eWmw9z/hul3VUlLvK1bqqXpOP4ENRffb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0808/1376] wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
Date: Sat, 12 Sep 2026 08:53:54 +0200
Message-ID: <20260912065625.548656105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2243778a5fae8329ab5f18e7adcd7e03b911a1b7 ]

band_idx comes from a 2-bit descriptor field (0-3) and was used directly
to index dev->mt76.phys[] (size __MT_MAX_BAND == 3) and dereference the
result. A corrupt or reserved descriptor value could index out of bounds
or hit a NULL phy on parts with fewer bands. Reject invalid band indices,
mirroring mt7996_rx_get_wcid().

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Link: https://patch.msgid.link/20260722082610.2699628-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 54bbc871c0bdc..116050a987a61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -454,7 +454,13 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	memset(status, 0, sizeof(*status));
 
 	band_idx = FIELD_GET(MT_RXD1_NORMAL_BAND_IDX, rxd1);
+	if (!mt7996_band_valid(dev, band_idx))
+		return -EINVAL;
+
 	mphy = dev->mt76.phys[band_idx];
+	if (!mphy)
+		return -EINVAL;
+
 	phy = mphy->priv;
 	status->phy_idx = mphy->band_idx;
 
-- 
2.53.0



