Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69141E5724;
	Wed,  8 Apr 2026 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672015; cv=none; b=suGJvafgnRZVWyPX33angqbcW4Oz7ym/iubE+BsgRO2T8+ECj0BjqrBOHrN4h/qhufWPkBNhtubd7LqikpYz7TgxqbS1CVVosr1GGO0bmoA7qCWcF/wfqcWEUagxl07fW+3F9eQijWkKDph4lDAQ2nkXQdm3/KA769Id4YiRpFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672015; c=relaxed/simple;
	bh=EVkKKZK6KJqx6fSK+JCydLmas8fscAgbwEvbg1vkf1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHGI2YLrPwt/RS+hRBQCouLXypp+JwfrRAlaroqdmN2z5FyQogfVFxD1DkP0dSAVTZ8hPtpS9P/1KIaWvwfZ1irTZZo9UW98OOEVJHXUdSHcojA7wyUHNocvcej9snLBv+km/VZDMbJPTZBblgBUvCG+z8S1ll/3+2VWVxQw2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVCviuTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVCviuTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D394C19421;
	Wed,  8 Apr 2026 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672015;
	bh=EVkKKZK6KJqx6fSK+JCydLmas8fscAgbwEvbg1vkf1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVCviuThEfCblGmux30a/YnSKb8DiDtw+wY3j9fCWqHqtMKpxm93o1fU6bRaG6wk6
	 eHc6Y+4g4lnin3/0Wh5iLCVMpAAa07BB+6QYfKQV4tZ8YhMxTnYN9grTwv0FwVVRim
	 ZySiAWOW3CsmaWOwlONGvkuvWnCR3AemUWRa01Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <olteanv@gmail.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/312] phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()
Date: Wed,  8 Apr 2026 20:00:41 +0200
Message-ID: <20260408175938.398851688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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
index 6a63380f6a71f..c4ff31d0df192 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -1339,6 +1339,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			dev_err(dev,
 				"%s: Reading \"reg\" from \"%s\" failed: %d\n",
 				__func__, subnode->name, ret);
+			of_node_put(serdes);
 			return ret;
 		}
 		of_property_read_u32(subnode, "cdns,num-lanes", &num_lanes);
@@ -1351,6 +1352,7 @@ static int wiz_get_lane_phy_types(struct device *dev, struct wiz *wiz)
 			wiz->lane_phy_type[i] = phy_type;
 	}
 
+	of_node_put(serdes);
 	return 0;
 }
 
-- 
2.53.0



