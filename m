Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E44A32A3EC;
	Mon, 18 Aug 2025 14:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525631; cv=none; b=GRIYTE+eukZ9K/oFQeL9XVurP3YEg6OWbNl36wZWKnrnDLThUbH3xLdzcujHDNQEL1yn5D4kLqOBHrOlbx2JDr70uExAD7RlK5c3fcpgEyk5Gk6679sNgxWadfheGZtYowG3kkipmAvdPlNjdDGKhR1M+iqZwu2hhJm2jCThhbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525631; c=relaxed/simple;
	bh=Ws5Y/Fg+3PDYs8IaN4s7eYWO9p9A0z6ewFjbolhyRhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hilrk5lnhOK9wHzz56MA81IvVoJQ+he5hTpi5HK7pWHOk6/PsxE/Mym+4u3lhbC3eWuEfyMpHSyLQXkCm41Z28wRCHv/w7OJm0nRND7/dZVG+PPmdBdg+u9Kxp3ryD7jNeN//uCCITi7JLd4HtZnu2Jgk4rG0VWIkoIsHS/rJKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbY5D802; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbY5D802"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8427C4CEEB;
	Mon, 18 Aug 2025 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525631;
	bh=Ws5Y/Fg+3PDYs8IaN4s7eYWO9p9A0z6ewFjbolhyRhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbY5D802arBkewyu25j9iZZHIhmZAp9oRM5y5qT6Ffl2CimrBMI8eNB83Dbvp+2qr
	 PgjWyQciVxZiMGS6rOo/ylYllULZPBEK1NuNXc26L1Mi5YBM8Ujq+Vfc23WDRJKOmS
	 KtSUOemQfW7f+qlx5MxU7AmTJ1/UCUCbGifdiauQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 321/570] dpaa_eth: dont use fixed_phy_change_carrier
Date: Mon, 18 Aug 2025 14:45:08 +0200
Message-ID: <20250818124518.222793398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 23c23cca2620..3edc8d142dd5 100644
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
@@ -3150,7 +3149,6 @@ static const struct net_device_ops dpaa_ops = {
 	.ndo_stop = dpaa_eth_stop,
 	.ndo_tx_timeout = dpaa_tx_timeout,
 	.ndo_get_stats64 = dpaa_get_stats64,
-	.ndo_change_carrier = fixed_phy_change_carrier,
 	.ndo_set_mac_address = dpaa_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
 	.ndo_set_rx_mode = dpaa_set_rx_mode,
-- 
2.39.5



