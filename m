Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F03E5EE8;
	Tue, 31 Mar 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975498; cv=none; b=RmKqAAnvfYh3y++1tjsRoCfeErRmF8U2strgGpZZJ7weYHN+o1nL/6QHjFXBFLHt302Odi6r2n9Bn11owFO/dZJbO68ffPqtS2S2UwIL9h0HZq3GfwmpmQMcHlInfssrUPKqu8D2EusojGMOgRsHqYDfxZofwCDmMCe35ng1tnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975498; c=relaxed/simple;
	bh=oNkjcQ5j1GZu4UGa0gEOkB5ux8v231VCjIHNVsfPUc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xl21vFtCBzFce+PayvQ/sHLi4wovxNYulkRHmm0NEVcz/e8SNyB/nEALnl0jPsDd4tFJ9HzzVopmbCFKxKfHcngnnEFfl0CGHj9+kM2yy9YiXfaH2jLgJyMqv+xZieKzOlLtaXy7kfDEb7bsU+B+lcniVw2iXqD0XoASDL0cPB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxKXwjJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxKXwjJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0050C19423;
	Tue, 31 Mar 2026 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975498;
	bh=oNkjcQ5j1GZu4UGa0gEOkB5ux8v231VCjIHNVsfPUc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxKXwjJI/wLW/WtJS5qt9NPgmpSx/TYocCW/3O4Ze/L2J6wKEF1uZ/UpwIhRyK/CL
	 bXWAwU2rNPvQx490vt14YddP1gB99IrC4a6Xa8YPwXT1BdA8dbu7Z4xQg3BtfAAm52
	 ou+BHgF52Farb3dlUltiSPgoiPNzhdcE12vKR7Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 319/342] phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()
Date: Tue, 31 Mar 2026 18:22:32 +0200
Message-ID: <20260331161810.655708928@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 584b457f4166293bdfa50f930228e9fb91a38392 ]

The serdes device_node is obtained using of_get_child_by_name(),
which increments the reference count. However, it is never put,
leading to a reference leak.

Add the missing of_node_put() calls to ensure the reference count is
properly balanced.

Fixes: 7ae14cf581f2 ("phy: ti: j721e-wiz: Implement DisplayPort mode to the wiz driver")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260212-wiz-v2-1-6e8bd4cc7a4a@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index ba31b0a1f7f79..77f18de6fdf62 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -1425,6 +1425,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			dev_err(dev,
 				"%s: Reading \"reg\" from \"%s\" failed: %d\n",
 				__func__, subnode->name, ret);
+			of_node_put(serdes);
 			return ret;
 		}
 		of_property_read_u32(subnode, "cdns,num-lanes", &num_lanes);
@@ -1439,6 +1440,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 		}
 	}
 
+	of_node_put(serdes);
 	return 0;
 }
 
-- 
2.53.0



