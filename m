Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD7B250C0E;
	Wed,  5 Mar 2025 17:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197158; cv=none; b=NnH9dpKKNVc/tunQuT2QgfuUHwSBtLdtR1Y2XaxAbPDzuG4V1GG5IipsYHGZmVxfPot3gFYDgCT6QazI9tf0lRmAGQ1S+4pXIMH1rsmYumB6DlaqtAIqc5M/eX3wM+auQyElh/9O1IN4MZ+QX4STNHGVZL0OWjkO9dg0YE8jPo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197158; c=relaxed/simple;
	bh=U8Y7uj95MccMJ1DZV8E1IdQI08zNHfS3b0ZSdYDx8Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjlZSgqfSpj6NabAZQBZeSQyC+oxfOu/E6JnXPaxYQGp0ZDS7mYsaFgwqxL7MNNZuen0xo6oyfWvpQtu6/FmyKF747Ges99bQMRRLG3d+CUYLy4vs57XmoLI6rj7G66sC42PZldaJXN3rLmM+dHihhefpAebXTpbzhdQ2SinquY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnYcIDUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnYcIDUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F75C4CED1;
	Wed,  5 Mar 2025 17:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197157;
	bh=U8Y7uj95MccMJ1DZV8E1IdQI08zNHfS3b0ZSdYDx8Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnYcIDUqiaihnSw7nI/7ebrPF7KlxkcbZQJ3GnYCFi5yPRu8+Lwrb+1oD13dpTvXU
	 VbdOHPruC7R+kYLrvYcBriaKDj6ICp0vdvVsVIHaJg+PeUu1bfVTajnFuG33GIx83E
	 R9/2PcKJBmQGY9cDUuyuq+JUHJjAVkhm9ktvXJy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/176] net: axienet: Set mac_managed_pm
Date: Wed,  5 Mar 2025 18:47:08 +0100
Message-ID: <20250305174507.828722596@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit a370295367b55662a32a4be92565fe72a5aa79bb ]

The external PHY will undergo a soft reset twice during the resume process
when it wake up from suspend. The first reset occurs when the axienet
driver calls phylink_of_phy_connect(), and the second occurs when
mdio_bus_phy_resume() invokes phy_init_hw(). The second soft reset of the
external PHY does not reinitialize the internal PHY, which causes issues
with the internal PHY, resulting in the PHY link being down. To prevent
this, setting the mac_managed_pm flag skips the mdio_bus_phy_resume()
function.

Fixes: a129b41fe0a8 ("Revert "net: phy: dp83867: perform soft reset and retain established link"")
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250217055843.19799-1-nick.hu@sifive.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a957721581761..f227ed8e99345 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2159,6 +2159,7 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
+	lp->phylink_config.mac_managed_pm = true;
 	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD;
 
-- 
2.39.5



