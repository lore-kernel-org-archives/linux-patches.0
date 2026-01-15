Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4CE1A2389;
	Thu, 15 Jan 2026 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498746; cv=none; b=YZjEpe0YJUJoTIzOzpcfRz7fOLjDy+6nGSMqmDgW5YowUUZf/Z/Yb3TnIDLsHfGdlSQ4ULDxiZTYgv4QifLa3FC1yaZ7gaNye9ZcR57KP3v3QAADENgiv1TmxYIcPV2nkAU5UNxqkd99/uDWdXpA/m1sWjWmbOFXmJq/ZEglCg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498746; c=relaxed/simple;
	bh=buBYC2+7+HA6jTcwixgJau8zkk0OhnAYQhqg14JJL5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXlKiJbP0kNstcEZhY+ls4ij39LMTyEEvNP9AZbGeOzQCFZ7gFIibktQ0f9f+CIRyHCBHpSEQZ2tF+FR4QcSqSQVDo3yngBEwxB2cPYSKkjajyCY+Kd/6vGlMPtPidKbG66Xid2CmKyj80qIs2O+B1gyi/bEN43UodNEu64MLcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWpbljip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWpbljip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E998BC116D0;
	Thu, 15 Jan 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498746;
	bh=buBYC2+7+HA6jTcwixgJau8zkk0OhnAYQhqg14JJL5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWpbljipVsMNTXXYOGQj+NuLJscZrBCe4gAQlaIKfEpBlhZaA9+SpgcVc1ZdXZI3F
	 tPSWsTTYOqGiDKURy+kZFrX3aNmKzxHPzTwE4wQYA/MkQNyLNvEecCQvkF1oeClXlz
	 2m9gZgPP8gltj1gQwyac5KJd1Fm1yY2XTCqVDITs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 540/554] net: enetc: fix build warning when PAGE_SIZE is greater than 128K
Date: Thu, 15 Jan 2026 17:50:06 +0100
Message-ID: <20260115164305.871631396@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 4b5bdabb5449b652122e43f507f73789041d4abe ]

The max buffer size of ENETC RX BD is 0xFFFF bytes, so if the PAGE_SIZE
is greater than 128K, ENETC_RXB_DMA_SIZE and ENETC_RXB_DMA_SIZE_XDP will
be greater than 0xFFFF, thus causing a build warning.

This will not cause any practical issues because ENETC is currently only
used on the ARM64 platform, and the max PAGE_SIZE is 64K. So this patch
is only for fixing the build warning that occurs when compiling ENETC
drivers for other platforms.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601050637.kHEKKOG7-lkp@intel.com/
Fixes: e59bc32df2e9 ("net: enetc: correct the value of ENETC_RXB_TRUESIZE")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260107091204.1980222-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 40c8f0f026a5b..adcb53167d3f9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -40,9 +40,9 @@ struct enetc_tx_swbd {
 #define ENETC_RXB_TRUESIZE	(PAGE_SIZE >> 1)
 #define ENETC_RXB_PAD		NET_SKB_PAD /* add extra space if needed */
 #define ENETC_RXB_DMA_SIZE	\
-	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - ENETC_RXB_PAD)
+	min(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - ENETC_RXB_PAD, 0xffff)
 #define ENETC_RXB_DMA_SIZE_XDP	\
-	(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - XDP_PACKET_HEADROOM)
+	min(SKB_WITH_OVERHEAD(ENETC_RXB_TRUESIZE) - XDP_PACKET_HEADROOM, 0xffff)
 
 struct enetc_rx_swbd {
 	dma_addr_t dma;
-- 
2.51.0



