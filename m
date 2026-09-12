Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134FF343889;
	Sat, 12 Sep 2026 10:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209327; cv=none; b=adnILDFR8QHkaAA3DAE9zCSmsW3VypcrN69p69mor9LvL4rbX10SiLtZKUEei7Zwb/V3L7CqTnrLOrV3kDvXxneJE06iW/MFolH0CrIXt44oTWEbZUBhXWimcR1AS/aR3XJCV0ijHUiVIF+75pIjQzGuP/sFJotwL5QSjbS6gK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209327; c=relaxed/simple;
	bh=NANWjG/D1vMbJ9It7cf4ANFXzW34qnnmpERw5ts2LLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anNANyGDIEx1WinBhLfH+qf+fR0OntULrQUCoDjd03l+1PcwKy9Cmlis5xarz9f/97Gq4lwt0j5UN4HA/5jSfaU3JNeva6cbjtYGYhkuOmWjRao/QfFCLojDJxyHPbpgUAhfgY63Xuu1b72Xzw2f355xe57QO7qFJiGshowz5E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tDlguFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tDlguFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74771F000FF;
	Sat, 12 Sep 2026 10:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209326;
	bh=Xo99jDBvi6OCkn5xnAXJO+dzsmNjtTcr4IQ3EwwJN2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tDlguFf2Xhc2ADBU+EPg1haoJqgvSqntdzIbrFY/5JLydP2jaALEJxYA4OQhy6BO
	 Sa9yRC9S0KAQR02m5WbIyV5XaGEa3ZbMs9Xrt5uokf4o5pyhYtZ/D4YSeQ2vHRmfHJ
	 F5eLZNB/G+JhrYkS+5iO91rNJyrKF+92KfiCIxAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0799/1518] wifi: mt76: mt7915: report RX chain signal for all RX paths
Date: Sat, 12 Sep 2026 08:49:28 +0200
Message-ID: <20260912065641.507563994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b53c44fe65792608f58028c7b0953e610ad652ee ]

status->chains was set from the antenna mask, which is derived from the
number of spatial streams, while the chain_signal array is filled from
all RCPI fields. On boards where the number of RX paths exceeds the
stream count, e.g. the 3T3R mt7916/mt7981 variant with 2 streams on the
5 GHz band, the RSSI of the extra chains was never reported.

Use the band local RX path chainmask instead.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Link: https://patch.msgid.link/20260727150434.1778520-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index d79af9321ec79..dda4e7d179536 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -437,7 +437,7 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb,
 		if (v0 & MT_PRXV_HT_AD_CODE)
 			status->enc_flags |= RX_ENC_FLAG_LDPC;
 
-		status->chains = mphy->antenna_mask;
+		status->chains = mt7915_band_chainmask(phy);
 		status->chain_signal[0] = to_rssi(MT_PRXV_RCPI0, v1);
 		status->chain_signal[1] = to_rssi(MT_PRXV_RCPI1, v1);
 		status->chain_signal[2] = to_rssi(MT_PRXV_RCPI2, v1);
-- 
2.53.0



