Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87B22D12ED;
	Fri,  7 Aug 2026 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116627; cv=none; b=DTf/Wzuo6iPWKwHgXKqI3rb4PUFiZjLIOMGrksjE4IiZr7+nobXSzjcMCPC6sZquJTTOcJd8HNko0Ed35bzWzbGVkDS+vrSpy1buiE0A95+vaD9+5vXub599+MhbfA98tSPxq8poir28SdXDGU3Rou0HnGUqMFRVvuj5J96+Z8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116627; c=relaxed/simple;
	bh=SvXD7GHySRozmN/tvJ1KpZuEJAZCWJp9x4IewXXzfl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYhSCE1gve5EOUe9GJ1/iV+jJaqcXH02ODh18nYrMHGY6ZPIReD+kXTqW0LEuzBX0WpHQB9IqLFy/ycYvvj9erAbAVtL+cQLo5MsAneWirEyug4NZS51RIaAllFDDc7vzhkXDZ1jaVRw6gNZs8c4H2fQz8OMjU6NFSKipr5G6y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPW1gLr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPW1gLr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469CB1F000E9;
	Fri,  7 Aug 2026 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116625;
	bh=R9WDFYSUmTwape+vFtoougdnzmUTth71RLTAOYg37cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPW1gLr5T0voLylYoaVUg2vLmYlz7qcFJw7KejgRapEapExA16SvQfHTrrBwhGp4j
	 dTPmDSPdhujGJfS+fCbNfhPVjw3i/qZEJLdm+XM8Xudgz3YGGLZgB4JhrpWilNyPLy
	 nBNLav+y5KXgKGc5bBlkS1qhcF4X4czA7u7zfySc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 035/438] phy: zynqmp: fix clock error handling in xpsgtr_phy_init()
Date: Fri,  7 Aug 2026 16:33:51 +0200
Message-ID: <20260807143428.755783078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit e4779e2a16d600892aaf743438f6ce8cc4eb3c4c ]

Propagate clk_prepare_enable() failures to the caller instead of
returning success, and disable the reference clock on initialization
error paths to avoid leaking clock references when phy_exit() is not
called.

Fixes: 25d700833513 ("phy: xilinx: phy-zynqmp: dynamic clock support for power-save")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260720153832.1130006-2-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index fe6b4925d1662..c8230f2bda629 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -658,12 +658,13 @@ static int xpsgtr_phy_init(struct phy *phy)
 {
 	struct xpsgtr_phy *gtr_phy = phy_get_drvdata(phy);
 	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&gtr_dev->gtr_mutex);
 
 	/* Configure and enable the clock when peripheral phy_init call */
-	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->refclk]))
+	ret = clk_prepare_enable(gtr_dev->clk[gtr_phy->refclk]);
+	if (ret)
 		goto out;
 
 	/* Skip initialization if not required. */
@@ -673,7 +674,7 @@ static int xpsgtr_phy_init(struct phy *phy)
 	if (gtr_dev->tx_term_fix) {
 		ret = xpsgtr_phy_tx_term_fix(gtr_phy);
 		if (ret < 0)
-			goto out;
+			goto out_disable_clk;
 
 		gtr_dev->tx_term_fix = false;
 	}
@@ -687,7 +688,7 @@ static int xpsgtr_phy_init(struct phy *phy)
 	 */
 	ret = xpsgtr_configure_pll(gtr_phy);
 	if (ret)
-		goto out;
+		goto out_disable_clk;
 
 	xpsgtr_lane_set_protocol(gtr_phy);
 
@@ -705,6 +706,10 @@ static int xpsgtr_phy_init(struct phy *phy)
 		break;
 	}
 
+	goto out;
+
+out_disable_clk:
+	clk_disable_unprepare(gtr_dev->clk[gtr_phy->refclk]);
 out:
 	mutex_unlock(&gtr_dev->gtr_mutex);
 	return ret;
-- 
2.53.0



