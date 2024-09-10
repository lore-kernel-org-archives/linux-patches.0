Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0696F13AD09;
	Tue, 10 Sep 2024 09:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961823; cv=none; b=W9Djoj2avCPp4Y+ZYm+9/APFjVhr/OfWT4wQRFDOT1TTDHtjpUuaOxfXbbr8ERcCZ8f0uqBiZAp/Y4p1etHC+nM++5kYxdH7NrG0npI+jBLcGwj2y4L3cLb6QqFTKXdXLxn1RX1Jyq7oDrkX4KUqzP1j+u5b/IHDjNzV1oH692o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961823; c=relaxed/simple;
	bh=01jIDEXr3VHsgmNaM2hsNPy8jFP4vHUVHCeTsoL4R2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmygqWfTHpTebuiAY5AiCVYWG/C7bXkp0IEe1WpxsGd3SoCbGmlrvMsDhhfmiSGuA0m1haGCGPJU0tj/UEAO39BurcmPU8W9DH+2iN/8FfNEwqBOalYfLT5bkHQ375tgdrUjHnj3IBk9GQWq+XW2s5qXOmksfR7OPUP9bo9KpL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/wrmihs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/wrmihs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83087C4CEC3;
	Tue, 10 Sep 2024 09:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961822;
	bh=01jIDEXr3VHsgmNaM2hsNPy8jFP4vHUVHCeTsoL4R2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/wrmihsVxeNHvZDP2mTBCTRG1FXhL8nj35IzGNdfsDFnN6hg7EJfB3U0K/lLrKgU
	 bbHOeMo5f2jZAC7k8XulgrKURoSfdIeP+GaR7JlT5aw/WdBy/7bHefrF8sx4crjAcQ
	 0tAGmtPiDD2+tgbWvdhB5AOaDHbt2DxRyeihV6LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 201/375] phy: zynqmp: Take the phy mutex in xlate
Date: Tue, 10 Sep 2024 11:29:58 +0200
Message-ID: <20240910092629.254941223@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit d79c6840917097285e03a49f709321f5fb972750 ]

Take the phy mutex in xlate to protect against concurrent
modification/access to gtr_phy. This does not typically cause any
issues, since in most systems the phys are only xlated once and
thereafter accessed with the phy API (which takes the locks). However,
we are about to allow userspace to access phys for debugging, so it's
important to avoid any data races.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://lore.kernel.org/r/20240628205540.3098010-5-sean.anderson@linux.dev
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index d7d12cf3011a..9cf0007cfd64 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -846,6 +846,7 @@ static struct phy *xpsgtr_xlate(struct device *dev,
 	phy_type = args->args[1];
 	phy_instance = args->args[2];
 
+	guard(mutex)(&gtr_phy->phy->mutex);
 	ret = xpsgtr_set_lane_type(gtr_phy, phy_type, phy_instance);
 	if (ret < 0) {
 		dev_err(gtr_dev->dev, "Invalid PHY type and/or instance\n");
-- 
2.43.0



