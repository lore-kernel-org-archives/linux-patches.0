Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056731A00F0;
	Tue, 26 Aug 2025 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213106; cv=none; b=WNENHy1ln+z88vAC8K55JziGhWEQ8Ol5bMrd6LE7j6TmYOVGrN5woRpBrp4qG/nuttbvnfOMU1lDqCED5fbGABkAyw3RMX2j5SC0zR0KuFM8ZSgqtGLwqdoNuDBbPohQbl0FTp9ZXAobgRYhGSpv1YdooKtl5b5g0McpBDUmtD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213106; c=relaxed/simple;
	bh=OX3GQCjFhPPQH0wTEmC2vSb3EzCGOLlXA9x3T9F2e3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/LlBng6MPTjwWGLMA+/8LTon9KBgwXz8oDfKNGRaa7fd28OTKFz5yW4h0yanN0tsExeOCW46iwKj25yqF6u/lcpOCyLJKW82dfjEnWUBnI9aKhxzPuSvmdfu0Q0MxzR5/LTVvsrFzCrrHGL7af+D5xZOS4hrLgve2YJkIAS+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGRgRljo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGRgRljo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B27C113CF;
	Tue, 26 Aug 2025 12:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213105;
	bh=OX3GQCjFhPPQH0wTEmC2vSb3EzCGOLlXA9x3T9F2e3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGRgRljohqYxYdzAPMReBuFktpDeYm+slh6nQaIkelv6c/Q8SnExzkCULiqETgh/o
	 oSWBef6YQCm0aeaom2gIrkr8a2W4h6s49mFAlJlxSIsKKKCEG8b0B/8PXip48BW7yF
	 E95lQ3Zufi6D28clE0ClwPYMxsGc0VJqSbC/sCcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/587] dpaa_eth: dont use fixed_phy_change_carrier
Date: Tue, 26 Aug 2025 13:05:41 +0200
Message-ID: <20250826110957.826726114@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit d8155c1df5c8b717052567b188455d41fa7a8908 ]

This effectively reverts 6e8b0ff1ba4c ("dpaa_eth: Add change_carrier()
for Fixed PHYs"). Usage of fixed_phy_change_carrier() requires that
fixed_phy_register() has been called before, directly or indirectly.
And that's not the case in this driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/7eb189b3-d5fd-4be6-8517-a66671a4e4e3@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e7bf70ac9a4c..6b7e1bb5c62d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -28,7 +28,6 @@
 #include <linux/percpu.h>
 #include <linux/dma-mapping.h>
 #include <linux/sort.h>
-#include <linux/phy_fixed.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <soc/fsl/bman.h>
@@ -3141,7 +3140,6 @@ static const struct net_device_ops dpaa_ops = {
 	.ndo_stop = dpaa_eth_stop,
 	.ndo_tx_timeout = dpaa_tx_timeout,
 	.ndo_get_stats64 = dpaa_get_stats64,
-	.ndo_change_carrier = fixed_phy_change_carrier,
 	.ndo_set_mac_address = dpaa_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
-- 
2.39.5



