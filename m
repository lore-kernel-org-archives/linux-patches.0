Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0829442364;
	Mon, 17 Aug 2026 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977207; cv=none; b=j2ZBb/KzYLdmoH3AddN4U00tsHgzCTxBSxIx3J+3iHk1OUxu0d1+EK+KdjwtmHeu4mb2Vq2WyPBRaTqigiufaBoXEfCsHX1ZysPByg9Zd1t1wSy9EloDDvYZmHOw2uCYdQuPK3G2NJ0UlrVvFIMPcWbhXCTCBwcBPX9XqeF4eII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977207; c=relaxed/simple;
	bh=qrzmbtD6kINn8C8fGNVTUyBsV4pZmspgWO8TGy/NYL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=putQMf/J4x8DdzMY515Fo+lmUgu24FwIvqKOZ2S5M+6UuLlkeMkOjaGb0dIPOg2o3ZOjcx8gkVSCdalw5zT4iG9ZBKhAMyBnlXiWlTTYuQKNreVPZ090O1iYcInFeDX+Orjr43ZVUvVj+9SVoLRVRCUbHJRoNRbiNNEBfTnyQdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=noBQnyBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="noBQnyBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5713D1F000E9;
	Mon, 17 Aug 2026 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977205;
	bh=dGfVf0YXxR3jpRkDUiD1XOXO2HYDBpWU4D9SvXNBLaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=noBQnyBZeM7B4i0CuFnSyJxekzAL8LuT4oKmDpCynvbjTzIk1XOaaxZQIl9/DBRsp
	 ABnDXfbBFy2CLi6fwl8T+cLQKTX4lCr8WTo1/Ar3j/dg/+GnEj9Ny+du+aJR7Ul0Qj
	 zHNz1dQDp/rCs3r1eFp2XrCfWD2AsGHQ9wAO4qa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/456] phy: zynqmp: Allow variation in refclk rate
Date: Mon, 17 Aug 2026 15:30:39 +0200
Message-ID: <20260817132549.816748503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 76009ee76e05e30e29aade02e788aebe9ce9ffd2 ]

Due to limited available frequency ratios, the reference clock rate may
not be exactly the same as the required rate. Allow a small (100 ppm)
deviation.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20230711194542.898230-1-sean.anderson@seco.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: e4779e2a16d6 ("phy: zynqmp: fix clock error handling in xpsgtr_phy_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index ac9a9124a36de..fb67db31e94a3 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -957,7 +957,10 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 		rate = clk_get_rate(clk);
 
 		for (i = 0 ; i < ARRAY_SIZE(ssc_lookup); i++) {
-			if (rate == ssc_lookup[i].refclk_rate) {
+			/* Allow an error of 100 ppm */
+			unsigned long error = ssc_lookup[i].refclk_rate / 10000;
+
+			if (abs(rate - ssc_lookup[i].refclk_rate) < error) {
 				gtr_dev->refclk_sscs[refclk] = &ssc_lookup[i];
 				break;
 			}
-- 
2.53.0



