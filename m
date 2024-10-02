Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AFB16F84F;
	Wed,  2 Oct 2024 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875501; cv=none; b=MgRyPFaNXGM5sHQcG4W+FBCJhKiWQTGhqPwLosTkTobiAmOJYK9wVR1oHB9JL1aMjuo9RXBWUadYns3cGsmCIhl2WZedTCGxala3KWQOWZxZHPMryzsfTZaQ3Pw5hyFQlt61FDaozwMydLnX7IRc/SqjMytmozDH0mVyO1IowNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875501; c=relaxed/simple;
	bh=o1AaebVdPKhwCXFWwj6gPsvIEN8eyYs4BFPPo0yaxJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQqegua287chY7gaLR2DgIZ8zUuEfyvZMKwvu/dOw5/Vngawp6IKK49AiBtsuPkHAHxDWJTSRvkPgUaNlZgbK1fzWhuVlSyVirNY/0mvtwhAkgYtOQGts+qM7+W626Q0+WJMjNHQA+rIo0CHGNq6a1QyfGqiMSOruNIPyiQtEXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrX9wA1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrX9wA1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC1C4CEC5;
	Wed,  2 Oct 2024 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875500;
	bh=o1AaebVdPKhwCXFWwj6gPsvIEN8eyYs4BFPPo0yaxJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrX9wA1pOzJyL/ky2BX2WkGaKUOghpKDYNricRRjk6VBiuuxd4BU08FfWx+A+MDqQ
	 YxhF6TH6LGRl2TQJyo0oTs7wSz9BY55UgF9lJCfkRKM4OuXzzFTt/6WrlDggV8nyN9
	 9Stlp4PdPOT0Ek4mnc2ZCaf/NFvUGJ530rKzUwcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 090/695] wifi: mt76: mt7915: fix rx filter setting for bfee functionality
Date: Wed,  2 Oct 2024 14:51:28 +0200
Message-ID: <20241002125826.071855051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 6ac80fce713e875a316a58975b830720a3e27721 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://patch.msgid.link/20240827093011.18621-21-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 049223df9beb1..efbb8b23e4719 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -564,8 +564,7 @@ static void mt7915_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	rxfilter = phy->rxfilter;
-- 
2.43.0



