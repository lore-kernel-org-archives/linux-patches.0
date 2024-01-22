Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1923C605DE;
	Tue, 23 Jan 2024 01:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974708; cv=none; b=eVG1P41Dl+IhoweDVTeozxlbu+DG+H416Z1Ggrue+W5TTmSC5k3rQ9a/3qyBCJtM0v7HvC1ASak1b4/v+G+Li8oeWZRE3u+BFW3Gds80acYWUvvAOXV3tOBN12zQ2eecsylt0R4qVQ18yTyNmKXA76m5bqfRbXob1TxO0kfjSng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974708; c=relaxed/simple;
	bh=WZjzgvRMJDRudnszvxR53e99/0hmB7KL67nGBmXUjA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9jl/U2plZzp3E1GrKeC9RBZI9XElhUR+GjIJGL15H2nfhNAm0vqxXAmg5O5QMonIcmet6tQt26B9pq15YTpxgwBwqMWH5GhMhUo29QZmrQ6PZHq0vc5ZWzl6iwWRPBZs51lIhVT+IU3uuxA6ye8mmQ7Q+sHrh3riLJQflgiqdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijuIOXFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijuIOXFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9B7C433F1;
	Tue, 23 Jan 2024 01:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974707;
	bh=WZjzgvRMJDRudnszvxR53e99/0hmB7KL67nGBmXUjA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijuIOXFVAzAvHnUWtyzVJvZRz4MlTH6v7qOYU5OBfUD2jM57vBCkDm458HRF/41HJ
	 0Zb1/SivW0xWP3sMSCxGefoviQzR4oy8inL0epedU/7yzMPlNTAtMDJmGWW/cz4/8E
	 oslf71CrftDVKp5S0zzvv6hqGmCSoMOcq4QQgm2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/583] wifi: mt76: mt7915: fallback to non-wed mode if platform_get_resource fails in mt7915_mmio_wed_init()
Date: Mon, 22 Jan 2024 15:53:07 -0800
Message-ID: <20240122235816.275082837@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5f9d5d4fc561e7bd3a18742f1fdb96cab98f1870 ]

mt76 assumes mt7915_mmio_wed_init can fail just after wed driver has
been attached running mtk_wed_device_attach().
Fall back to non-wed mode if platform_get_resource fails in
mt7915_mmio_wed_init routines.

Fixes: eebb70976be5 ("wifi: mt76: mt7915: enable wed for mt7986-wmac chipset")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index fc7ace638ce8..f4ad7219f94f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -742,7 +742,7 @@ int mt7915_mmio_wed_init(struct mt7915_dev *dev, void *pdev_ptr,
 
 		res = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
 		if (!res)
-			return -ENOMEM;
+			return 0;
 
 		wed->wlan.platform_dev = plat_dev;
 		wed->wlan.bus_type = MTK_WED_BUS_AXI;
-- 
2.43.0



