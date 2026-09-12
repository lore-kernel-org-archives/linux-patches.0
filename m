Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E4B38E8A8;
	Sat, 12 Sep 2026 08:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200924; cv=none; b=FsXx97Dv/HYz0Q0p8SYD9C1cZEP/hov04ecUjrYsVLOlgBzbjPWEgXeqghxo8+V4MMcSMEIAH9sfu3NWIm1a+bmMyxV5S2sQ+vh7TO7YbL7tFgA3bsUENFJBWxwXD8wFn47e0lz/m61VL2X12WEcBYngip3FoYu40vvmanY39V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200924; c=relaxed/simple;
	bh=asOj+TPZ49xpKQDX+rr3JGLXMAsMsGBz286+HzSZOeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tV60iwdZoG69RRqDVkRuEXiHCp8meTN8xD1zP+men0BSFM8Z7uJAcPI86WCGRBCQqWH8Kf6TlAfSwCXRSTHI8HalXddcddWP2jXo3C97QtxKtBBRLEB/qdUEnlQGogIFKm5z+T5SBj8zgJOl7fg0XkSgw9/E5+Pc91gRsW2r57M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUvb1vHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUvb1vHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C171C1F000FF;
	Sat, 12 Sep 2026 08:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200922;
	bh=aLva6pPmiYJYZbo6VAnbXVbAzTLNZwBH5ui7d9TBehQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUvb1vHKaZC7+2xCAmtVj0mgVt7c9f6vaJyzgPax8P+Xz7d3bQ5udZxCN3lGVsknA
	 L//zt27m/BHFBYcu3I1bMUfvYVjAhR3L0FCH7NS3rGtR+2qJ0BRSMNwPuEf5oyDdiU
	 F7CKyJXF0b15TgNYAtt/9QeabrCcGnqKRLeWwmr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0890/1815] wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
Date: Sat, 12 Sep 2026 08:44:00 +0200
Message-ID: <20260912065709.813876339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit dd59a6126a8f1bd52bf6bd057bf0c8307f76a74b ]

The clock enable path for the second adie sets MT_ADIE_SLP_CTRL_CK0(1)
but polled the busy bit of MT_ADIE_SLP_CTRL_CK0(0), so dual-adie
bring-up could proceed before the adie1 clock was stable.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Link: https://patch.msgid.link/20260722082610.2699628-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index 54ff6de96f3ea..13fba2a061c78 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -908,7 +908,7 @@ static void mt7986_wmac_clock_enable(struct mt7915_dev *dev, u32 adie_type)
 
 		read_poll_timeout(mt76_rr, cur, !(cur & MT_SLP_CTRL_BSY_MASK),
 				  USEC_PER_MSEC, 50 * USEC_PER_MSEC, false,
-				  dev, MT_ADIE_SLP_CTRL_CK0(0));
+				  dev, MT_ADIE_SLP_CTRL_CK0(1));
 	}
 	mt76_wmac_spi_unlock(dev);
 
-- 
2.53.0



