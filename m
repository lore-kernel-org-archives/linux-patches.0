Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AA22110E;
	Tue, 27 May 2025 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365559; cv=none; b=aShNQ2l/USUR5yLV/5h/sTWtv0/d4AFNBjq68xIge0EmBtEIeHxpfdIVPXlwEoENFh6/G5MNJcEAL5fMFsgxZwtxdU3dHyIxnKIjbQyOr098Un+bqcJe/fYalffMWCKeTeRu61LEouQQqEp2U7wraqz8I2FzafQG4AElBybC7q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365559; c=relaxed/simple;
	bh=lTb6mVzZAVehh5/zwNjvhKIKBUio6GCyTxzrDqR2VaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIMnY43gx7vy9xOE4hHBMIfUHzAGBCDhWi3EM1qo0QEzjXMIOTV7IlS+A3UpVhHtA7k8vYUBwQVITPUogFdkVGR53QRgeRr+l6yr6pa3xZ1bb5UKOuKvvV9D3EMivCnUJHp75vEPybdjtgM9rNqFVRTlkt49mgn32ohYwDEnSsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2e8jl4LB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2e8jl4LB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843FDC4CEF5;
	Tue, 27 May 2025 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365558;
	bh=lTb6mVzZAVehh5/zwNjvhKIKBUio6GCyTxzrDqR2VaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e8jl4LBCY6RNy5YWexGUI6uQcIAIQ/0u2JiYmREM6os1NNv23eSUYUlJCdLBMffo
	 ZhErdVudBlHkYmgOWgoda388koJINyEXbqc4kKLc5Sps13FrFe6/RpI+sglvSscWAz
	 /Kwzz+7dH76rFSf40ZHjN1ARxArTpbq6YgCBaqZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/626] soundwire: cadence_master: set frame shape and divider based on actual clk freq
Date: Tue, 27 May 2025 18:24:38 +0200
Message-ID: <20250527162500.655355438@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit e738d77f78b3ac085dfb51be414e93464abba7ec ]

Frame shape and curr_dr_freq could be updated by sdw_compute_bus_params().
Peripherals will set curr_dr_freq as their frequency. Managers
should do the same. Then update frame shape according to the actual
bus frequency.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://lore.kernel.org/r/20250205074232.87537-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 05652e983539b..6f2b5ec5c87c6 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -1341,7 +1341,7 @@ static u32 cdns_set_initial_frame_shape(int n_rows, int n_cols)
 	return val;
 }
 
-static void cdns_init_clock_ctrl(struct sdw_cdns *cdns)
+static int cdns_init_clock_ctrl(struct sdw_cdns *cdns)
 {
 	struct sdw_bus *bus = &cdns->bus;
 	struct sdw_master_prop *prop = &bus->prop;
@@ -1355,14 +1355,25 @@ static void cdns_init_clock_ctrl(struct sdw_cdns *cdns)
 		prop->default_row,
 		prop->default_col);
 
+	if (!prop->default_frame_rate || !prop->default_row) {
+		dev_err(cdns->dev, "Default frame_rate %d or row %d is invalid\n",
+			prop->default_frame_rate, prop->default_row);
+		return -EINVAL;
+	}
+
 	/* Set clock divider */
-	divider	= (prop->mclk_freq / prop->max_clk_freq) - 1;
+	divider	= (prop->mclk_freq * SDW_DOUBLE_RATE_FACTOR /
+		bus->params.curr_dr_freq) - 1;
 
 	cdns_updatel(cdns, CDNS_MCP_CLK_CTRL0,
 		     CDNS_MCP_CLK_MCLKD_MASK, divider);
 	cdns_updatel(cdns, CDNS_MCP_CLK_CTRL1,
 		     CDNS_MCP_CLK_MCLKD_MASK, divider);
 
+	/* Set frame shape base on the actual bus frequency. */
+	prop->default_col = bus->params.curr_dr_freq /
+			    prop->default_frame_rate / prop->default_row;
+
 	/*
 	 * Frame shape changes after initialization have to be done
 	 * with the bank switch mechanism
@@ -1375,6 +1386,8 @@ static void cdns_init_clock_ctrl(struct sdw_cdns *cdns)
 	ssp_interval = prop->default_frame_rate / SDW_CADENCE_GSYNC_HZ;
 	cdns_writel(cdns, CDNS_MCP_SSP_CTRL0, ssp_interval);
 	cdns_writel(cdns, CDNS_MCP_SSP_CTRL1, ssp_interval);
+
+	return 0;
 }
 
 /**
@@ -1383,9 +1396,12 @@ static void cdns_init_clock_ctrl(struct sdw_cdns *cdns)
  */
 int sdw_cdns_init(struct sdw_cdns *cdns)
 {
+	int ret;
 	u32 val;
 
-	cdns_init_clock_ctrl(cdns);
+	ret = cdns_init_clock_ctrl(cdns);
+	if (ret)
+		return ret;
 
 	sdw_cdns_check_self_clearing_bits(cdns, __func__, false, 0);
 
-- 
2.39.5



