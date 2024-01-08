Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4C6D6DC;
	Mon,  8 Jan 2024 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCeseoZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7CDC433C8;
	Mon,  8 Jan 2024 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726829;
	bh=QvTrv4k7k1cRfsKX0RWzEB+ALxCTS0AYjWjHDhQq3sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCeseoZaFHZSwF2hB0LdSPTEjG9I8d8w3tLceYJAn6LkhaDKpTfqAMKMedQhTWKMb
	 U9GLYHheITdHHx9+VHX+vb1F+wgHIEidqHdWWl30iwmqz4RLWpWn71N4fEbYcYM8L+
	 gV5j7+ZKHVp2N14kS3VqWnVdHzIJ8BButT+Pb2H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/124] phy: ti: gmii-sel: Fix register offset when parent is not a syscon node
Date: Mon,  8 Jan 2024 16:08:30 +0100
Message-ID: <20240108150606.852821196@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 0f40d5099cd6d828fd7de6227d3eabe86016724c ]

When the node for this phy selector is a child node of a syscon node then the
property 'reg' is used as an offset into the parent regmap. When the node
is standalone and gets its own regmap this offset is pre-applied. So we need
to track which method was used to get the regmap and not apply the offset
in the standalone case.

Fixes: 1fdfa7cccd35 ("phy: ti: gmii-sel: Allow parent to not be syscon node")
Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20231025143302.1265633-1-afd@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-gmii-sel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index 555b323f45da1..bc847d3879f79 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -64,6 +64,7 @@ struct phy_gmii_sel_priv {
 	u32 num_ports;
 	u32 reg_offset;
 	u32 qsgmii_main_ports;
+	bool no_offset;
 };
 
 static int phy_gmii_sel_mode(struct phy *phy, enum phy_mode mode, int submode)
@@ -402,7 +403,8 @@ static int phy_gmii_sel_init_ports(struct phy_gmii_sel_priv *priv)
 		priv->num_ports = size / sizeof(u32);
 		if (!priv->num_ports)
 			return -EINVAL;
-		priv->reg_offset = __be32_to_cpu(*offset);
+		if (!priv->no_offset)
+			priv->reg_offset = __be32_to_cpu(*offset);
 	}
 
 	if_phys = devm_kcalloc(dev, priv->num_ports,
@@ -471,6 +473,7 @@ static int phy_gmii_sel_probe(struct platform_device *pdev)
 			dev_err(dev, "Failed to get syscon %d\n", ret);
 			return ret;
 		}
+		priv->no_offset = true;
 	}
 
 	ret = phy_gmii_sel_init_ports(priv);
-- 
2.43.0



