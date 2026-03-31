Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EAF2D7DEF;
	Tue, 31 Mar 2026 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976944; cv=none; b=UBzH7a1h7tWKsjHY18ttH9VFjPN3J+J6fPltU5Nnh+cdPwR0tC0th2BwQ2fRR82Whfx0KXA+Rp5rQpbZZYtKMtRtL7y9vTv8Os9eGV8gweKa7FFlYihIK1CyZHqN83/3JaoeVVr7bj9t7od77UhDDZVB2otwUDoxU33kGBafVsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976944; c=relaxed/simple;
	bh=1QTKMBQLE3YPwJgydjBIwr6ix1qcP9WG1wyV8WPMcbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTYVFp9d5o78m1S/75q2ALemck3/hbbhwPtjzOE+nKqLXuGXss9r8lU2HmcmLtWs21hDTDQ+d9CDyqI4czGArK+H5yHzgCo6PMJRo6BvrUyCncN2ZkoKPmfaduCfYVFz44rzsZn/c7hkHUKFcqnYeHAMZXRw07l50R9/sc8c8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNw2pppK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNw2pppK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B02C19423;
	Tue, 31 Mar 2026 17:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976944;
	bh=1QTKMBQLE3YPwJgydjBIwr6ix1qcP9WG1wyV8WPMcbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNw2pppKTEdPAb3fr5RKvyz9/sV52ESAs7eWPdchfEGKXhrzCKTb9mJJNRO4II9rP
	 mtR0nrjUbMu8zwD1owDbEhw8mYG42WYVz+GPvxYzvEJC8XBtEsxdZB6bHv/9GHrRgu
	 RygRN2D1t3ajLd5iwS4wA8g3jt/TU0mcxYCT87Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/309] phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()
Date: Tue, 31 Mar 2026 18:23:12 +0200
Message-ID: <20260331161804.204955618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



