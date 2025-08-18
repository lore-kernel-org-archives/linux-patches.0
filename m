Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F271A322767;
	Mon, 18 Aug 2025 13:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523967; cv=none; b=WIVUYvQrsOhYmHQtUTR0gTN7uFRViS5HIegcy/UOvoNmZkHTquweIUp4wC+FGDbgukYY/2fxYLtGyrQNyVA40ptI04lH480PYklLdamuRm8Jh1XYiTyhLZnS9Oy5n/sDPRK5ZFFLeTV13DUsYXJrlWtUscOhahx5oyYAUClGT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523967; c=relaxed/simple;
	bh=ManrpZV5X4k13QFLIkRrgpcX/pm468KGCaZSLyL0RfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ck+8D1AKb+/vLeNp75oeWcYtCqmNVxpGy8xB9AhMTi6QRrsCS+gHmdlQkrHB+6gyQZLOv8rhYoc2Vi8Qw8N0K8em9XKjj45NC+28rw6ZUcg77qgAnrxr0kH+WN5A0s/Xlo/A28ITPg7JY73tVYfDDEJxWh9l+uVVTkyCE/C68Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcKOwZA6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcKOwZA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5F4C4CEEB;
	Mon, 18 Aug 2025 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523966;
	bh=ManrpZV5X4k13QFLIkRrgpcX/pm468KGCaZSLyL0RfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcKOwZA65GtwH+UneE7Y/luqpsIk40DFycNZbx6dG1yPbtrA1pbKtT+uuUHvra7M3
	 +0diOgMITc+B/O6qol3t75ZisjHNDnf509MPp2WWkEtvUtePqQKEU+dsTOAAkH7WOG
	 kD2xFocbx2oiXVlZ1vNHXHzC5QIqAZKSISEorYTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 295/515] dpaa_eth: dont use fixed_phy_change_carrier
Date: Mon, 18 Aug 2025 14:44:41 +0200
Message-ID: <20250818124509.776178199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4948b4906584..ebdaa3e7e106 100644
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
@@ -3151,7 +3150,6 @@ static const struct net_device_ops dpaa_ops = {
 	.ndo_stop = dpaa_eth_stop,
 	.ndo_tx_timeout = dpaa_tx_timeout,
 	.ndo_get_stats64 = dpaa_get_stats64,
-	.ndo_change_carrier = fixed_phy_change_carrier,
 	.ndo_set_mac_address = dpaa_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
-- 
2.39.5



