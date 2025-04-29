Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D82B244668;
	Tue, 29 Apr 2025 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945878; cv=none; b=pTnJK495g9/zEYe+j+Mrr/qK4qIwB14qjfVzAKGqYDCaV4d7c5WODLpMSvbfiT59DOZkBRsXUKuHPa0ChPNCG2kO0KdLjKJPbSUJS3qu/IVzmCAywkCraVbTKpIS5qlovu5/p+ZF1LgpT1SZybz01LaHXVIrLDkNW8vRwqN5pF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945878; c=relaxed/simple;
	bh=K9VGDbvHvKE4O47DwC0Yclzh9ZMN/IBAwN2YGU/jFmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBhquStpa44mlEPsJRFmQqC2abq/TY3M/caX9ap4raJ0LmPHyEn35RcvrZb09kqj5UotnyBg7TqDrj2w5sBdyxL792cWwmYZeHriqllr4P9KkLxVkqV8ONNvrOf4pnTTkT4dbyPvP0lTwnBYF0fh+SR4S0xrJQNuAA9V/jWNtbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsusWBQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsusWBQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A43DC4CEE9;
	Tue, 29 Apr 2025 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945877;
	bh=K9VGDbvHvKE4O47DwC0Yclzh9ZMN/IBAwN2YGU/jFmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsusWBQIid69xPmkb4PriG/Rlrigj1MzWa8iN9jVmNru8f1x8w3AGJsHX5eGMGA+h
	 Aqybl9/9wBTQ/V6/MhMatuFA7uPG0x4AAGTAoI2HIAEYTvlZ9dbOf7eBu+a/wYyOqn
	 Hwv5HcwKf4qj2YpghMZt2oJUfqihv7dPxyDhMg40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 079/311] net: stmmac: fix multiplication overflow when reading timestamp
Date: Tue, 29 Apr 2025 18:38:36 +0200
Message-ID: <20250429161124.283014066@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit 7b7491372f8ec2d8c08da18e5d629e55f41dda89 ]

The current way of reading a timestamp snapshot in stmmac can lead to
integer overflow, as the computation is done on 32 bits. The issue has
been observed on a dwmac-socfpga platform returning chaotic timestamp
values due to this overflow. The corresponding multiplication is done
with a MUL instruction, which returns 32 bit values. Explicitly casting
the value to 64 bits replaced the MUL with a UMLAL, which computes and
returns the result on 64 bits, and so returns correctly the timestamps.

Prevent this overflow by explicitly casting the intermediate value to
u64 to make sure that the whole computation is made on u64. While at it,
apply the same cast on the other dwmac variant (GMAC4) method for
snapshot retrieval.

Fixes: 477c3e1f6363 ("net: stmmac: Introduce dwmac1000 timestamping operations")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250423-stmmac_ts-v2-2-e2cf2bbd61b1@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c  | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 96bcda0856ec6..11c525b8d2698 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -560,7 +560,7 @@ void dwmac1000_get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
 	u64 ns;
 
 	ns = readl(ptpaddr + GMAC_PTP_ATNR);
-	ns += readl(ptpaddr + GMAC_PTP_ATSR) * NSEC_PER_SEC;
+	ns += (u64)readl(ptpaddr + GMAC_PTP_ATSR) * NSEC_PER_SEC;
 
 	*ptp_time = ns;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 0f59aa9826040..e2840fa241f29 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -222,7 +222,7 @@ static void get_ptptime(void __iomem *ptpaddr, u64 *ptp_time)
 	u64 ns;
 
 	ns = readl(ptpaddr + PTP_ATNR);
-	ns += readl(ptpaddr + PTP_ATSR) * NSEC_PER_SEC;
+	ns += (u64)readl(ptpaddr + PTP_ATSR) * NSEC_PER_SEC;
 
 	*ptp_time = ns;
 }
-- 
2.39.5



