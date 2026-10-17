Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A43ACF02;
	Sat, 17 Oct 2026 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255128; cv=none; b=RzJcC/P/0PxR8bud+G8PaPYlRt7qwQksql90MIreVKmkjWqZoKvrqtzvrB7gopMbiaGLg67M7hpR6xwe+65WNUByjKX+w0s1WSljiYV/dMeAmuqbUhbLHAu5mAVhg4wfs+nM+uQIlPphRTNX9mn5STT/WJkdrYapjFHrLLt+1jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255128; c=relaxed/simple;
	bh=SNZy1En3sSV+wk1Vmase2L1zvmMMD0HOqWi1Rao8thk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7aQnMogIgw6hlVEi0HUAtX8lpVhcW6jbewPmc7FkwuXrC5ViWYcUboovxoHVoF8d//ZvMXLCnwlVBGc40xz9gWFXJzCl/p36HbawOIGYCscjrK3hT7FrvpVtDWOdDfmc0cMizGRzqi+dq/9+IheN8V8AHQJqaldA3V3cy9E2Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIQD77wJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIQD77wJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520531F000C4;
	Sat, 17 Oct 2026 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255126;
	bh=oxowIULB8DkHKfqarPiG+HOfPKJJewlaBW6dyOldGIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIQD77wJyb93l9BZ4Fm28BkmiGaRd+eDdM4AnfTMdfqNI7tAy/8vjZ3MxfE/GdJDh
	 WSgx3atcDx/fZQtO6mkkiE9k/5XAJc0Ns5+yk+n85ThCZ19SvLrwBmfR7D+lJDuOSA
	 KcfncJ3RW1+dQfGzrTg0K14BOuLlvX+M2GcoXzGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 674/869] wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed
Date: Sat, 17 Oct 2026 17:58:35 +0200
Message-ID: <20261017160054.267926212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 7c1924332e986019c6bcddf55c843361cccac73f ]

If the WED attach for the primary PCIe function fails, the probe path
still attached wed_hif2 for the secondary function, leaving the device
in an inconsistent half-WED configuration that crashes later. The hif2
call also re-enabled hwrro_mode, which the failed primary attach had
just turned off.

Skip the hif2 WED setup when the primary WED device is not active.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Link: https://patch.msgid.link/20260727150434.1778520-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 11e9c71e9b17a..ba1667ac1d367 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -312,6 +312,9 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	if (!wed_enable)
 		return 0;
 
+	if (hif2 && !mtk_wed_device_active(&dev->mt76.mmio.wed))
+		return 0;
+
 	dev->has_rro = true;
 
 	hif1_ofs = MT_WFDMA0_PCIE1(0) - MT_WFDMA0(0);
-- 
2.53.0



