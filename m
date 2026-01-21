Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E553904DB;
	Wed, 21 Jan 2026 18:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019671; cv=none; b=FIUPOipBu72qF3kHOI212Hy+k5FKv9eDoI+OHgotan+oNRk4I2/RnOSogHpmTYbqcxXW47vbUTxO8Zc+Wjo1N3VzEHk2KeDyH0YOAH7FTJmRfgZBlq+JTn3yDDm2w2iDuxRgoOTWd4rLJ1un5w24UTEaMCT2a5XIk8hjeJuWi7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019671; c=relaxed/simple;
	bh=2do7hs97H7PX/7F8CNVQLeMGdl3pcUo5XMvQR7hrAzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDpLtQj8+9bqscTHG67SlztGzlYxYHft6w2rcv48j8buNbm7d00Rw+QUWRUETpUUIkNWpx10WQgKHWkkKWFtNw9WswynaIYIpU/s7pedLrsDmUgZrPRfcU1FGdXPcm16MUr91ymooVoRcFa+pFECSETRo4CePeVLH1HkTqOsRQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VG7azSB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VG7azSB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5877AC4CEF1;
	Wed, 21 Jan 2026 18:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019669;
	bh=2do7hs97H7PX/7F8CNVQLeMGdl3pcUo5XMvQR7hrAzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VG7azSB20/Bsfa30MNFpISlOcsMQoqvSTzeJLDqLKh9YFxl87SRR+BFv7XoV1SA5C
	 gjqN8jwXnjepp3uKZgZlDE8TowynC2uqFyzetrGeyLl4n5hXHAhfy+wozmBhekp/Yc
	 jnS3gZCDe1VtO06apySgePGmmNqsooW4D8yjOQNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 074/139] phy: ti: gmii-sel: fix regmap leak on probe failure
Date: Wed, 21 Jan 2026 19:15:22 +0100
Message-ID: <20260121181414.118303826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 4914d67da947031d6f645c81c74f7879e0844d5d upstream.

The mmio regmap that may be allocated during probe is never freed.

Switch to using the device managed allocator so that the regmap is
released on probe failures (e.g. probe deferral) and on driver unbind.

Fixes: 5ab90f40121a ("phy: ti: gmii-sel: Do not use syscon helper to build regmap")
Cc: stable@vger.kernel.org	# 6.14
Cc: Andrew Davis <afd@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://patch.msgid.link/20251127134834.2030-1-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/ti/phy-gmii-sel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -480,7 +480,7 @@ static int phy_gmii_sel_probe(struct pla
 			return dev_err_probe(dev, PTR_ERR(base),
 					     "failed to get base memory resource\n");
 
-		priv->regmap = regmap_init_mmio(dev, base, &phy_gmii_sel_regmap_cfg);
+		priv->regmap = devm_regmap_init_mmio(dev, base, &phy_gmii_sel_regmap_cfg);
 		if (IS_ERR(priv->regmap))
 			return dev_err_probe(dev, PTR_ERR(priv->regmap),
 					     "Failed to get syscon\n");


