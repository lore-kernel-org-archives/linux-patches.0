Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19421F12F7;
	Tue,  3 Dec 2024 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242092; cv=none; b=TASO8AQXQIsfeUoDP/bWb7t8G/DrnvTuDMEBtRb0tpkH7lFmUkF3HYWL3WUMvU0SX1s4CB53wFGQeQ9LomnUZHjwMCtohg28AF1IpmuHYJW0syvEYKWFT14kFjJxQLpudfnS4R+kTqGI1B1bIrxGkXs97Sw+TOZDzp0lWv5Ph8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242092; c=relaxed/simple;
	bh=iYgUN5Ia7Xy0H5rKrb1mXYMmxqEvYMTAYnjEmrGpODs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFqvdbgDz9Ju8ROMKAcsVYW1FTU70iSMMtxtrvGmLa4jKjDwqRkJEEIgJzMg/Se431EGtdPvuWcK/NXYDnGpjrhGw5DbC9Nxjx2Jwf79aEdjULpNZz8KAVVPIixk8MpwQQtoHeDTd1aKeK8zpoiQQZT1FEUgkWgo/ZPAuIIuNP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGek2T1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGek2T1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7C8C4CECF;
	Tue,  3 Dec 2024 16:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242091;
	bh=iYgUN5Ia7Xy0H5rKrb1mXYMmxqEvYMTAYnjEmrGpODs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGek2T1aksltRPXwR5v0XpyrIL5y2Oegkwgmlr4iAcV8ec3n/+OuH5BL5dw/wz4pi
	 Mvhe5yKeszBiayBUvb6rUjMAuBPl2f3ZGGoXJXivkJOPR7Z5d6xpCm18F+zMax+Atm
	 jaq3e4rALh+2FIFXRowYXfqqnmOPDECvdD0xjIxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 605/826] phy: realtek: usb: fix NULL deref in rtk_usb3phy_probe
Date: Tue,  3 Dec 2024 15:45:32 +0100
Message-ID: <20241203144807.355106862@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit bf373d2919d98f3d1fe1b19a0304f72fe74386d9 ]

In rtk_usb3phy_probe() devm_kzalloc() may return NULL
but this returned value is not checked.

Fixes: adda6e82a7de ("phy: realtek: usb: Add driver for the Realtek SoC USB 3.0 PHY")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241025070744.149070-1-hanchunchao@inspur.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/realtek/phy-rtk-usb3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/realtek/phy-rtk-usb3.c b/drivers/phy/realtek/phy-rtk-usb3.c
index dfcf4b921bba6..96af483e5444b 100644
--- a/drivers/phy/realtek/phy-rtk-usb3.c
+++ b/drivers/phy/realtek/phy-rtk-usb3.c
@@ -577,6 +577,8 @@ static int rtk_usb3phy_probe(struct platform_device *pdev)
 
 	rtk_phy->dev			= &pdev->dev;
 	rtk_phy->phy_cfg = devm_kzalloc(dev, sizeof(*phy_cfg), GFP_KERNEL);
+	if (!rtk_phy->phy_cfg)
+		return -ENOMEM;
 
 	memcpy(rtk_phy->phy_cfg, phy_cfg, sizeof(*phy_cfg));
 
-- 
2.43.0



