Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351DC2D8763;
	Wed,  4 Feb 2026 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218197; cv=none; b=n+ODwVwhMrSyi8NUCuWsx3C5j+cQ45zvPU82SG4k/8rJdteJUhZU5wD7vq1HFtR8YADEDQdQlMait91n1nbrunV6a12eg9TvERHt2Je90dx4RH7gR31XbJ8teodcxnDGYuR+2kWguLUUfZnopyvF9jKWNVJMu+BSaYEzat6V3Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218197; c=relaxed/simple;
	bh=oN+2V/PZOZYWi/uqvDCXcGW9uFENmkrrkKcFhlNNM6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3gzoWmUgfwtPjn2efO4PFYgWkncRE3HaoxmI/pbV91zgcFYaKXzxbbTTzYqEHiPP8wepiDd8cWseOIQyonhYGbmTgfjSJHWb4AQYmjNTGdZMC1JeGpLNq260DPyHw9hJp0DsTS4L+LhIAfaT5+3Eym6aD4KizMyfJEpkV0x0fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsipeoJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsipeoJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35EEC4CEF7;
	Wed,  4 Feb 2026 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218197;
	bh=oN+2V/PZOZYWi/uqvDCXcGW9uFENmkrrkKcFhlNNM6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsipeoJT6WiNZCj5VCkV0bXePmewW34Sc2XOapRJV/UJyL5uwnVHzMCXlkxXnmcot
	 7tjFdcGpiMeTwbWLtkan3+tMYdaaQbXV3i4Z+XeveBdCNlKuT6tOXWqSYc7a2MqVFq
	 GTUPDd8ReEZN6Id4s/Urp/qXjLal6z0HdKhQiwQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/280] phy: phy-rockchip-inno-usb2: simplify phy clock handling
Date: Wed,  4 Feb 2026 15:40:15 +0100
Message-ID: <20260204143918.301429980@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit b43511233c6e34b9c0d9a55e41b078d10e7d9ea6 ]

Simplify phyclk handling by using devm_clk_get_optional_enabled to
acquire and enable the optional clock. This also fixes a resource
leak in driver remove path and adds proper error handling.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20230522170324.61349-6-sebastian.reichel@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: e07dea3de508 ("phy: rockchip: inno-usb2: Fix a double free bug in rockchip_usb2phy_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -1273,18 +1273,16 @@ static int rockchip_usb2phy_probe(struct
 		return -EINVAL;
 	}
 
-	rphy->clk = of_clk_get_by_name(np, "phyclk");
-	if (!IS_ERR(rphy->clk)) {
-		clk_prepare_enable(rphy->clk);
-	} else {
-		dev_info(&pdev->dev, "no phyclk specified\n");
-		rphy->clk = NULL;
+	rphy->clk = devm_clk_get_optional_enabled(dev, "phyclk");
+	if (IS_ERR(rphy->clk)) {
+		return dev_err_probe(&pdev->dev, PTR_ERR(rphy->clk),
+				     "failed to get phyclk\n");
 	}
 
 	ret = rockchip_usb2phy_clk480m_register(rphy);
 	if (ret) {
 		dev_err(dev, "failed to register 480m output clock\n");
-		goto disable_clks;
+		return ret;
 	}
 
 	index = 0;
@@ -1347,11 +1345,6 @@ next_child:
 
 put_child:
 	of_node_put(child_np);
-disable_clks:
-	if (rphy->clk) {
-		clk_disable_unprepare(rphy->clk);
-		clk_put(rphy->clk);
-	}
 	return ret;
 }
 


