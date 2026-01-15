Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D03A7F43;
	Thu, 15 Jan 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497143; cv=none; b=L8wj0TLyk6/DIw+L1L/4YoBIVwQovow7PBWDPFWWwRdgcRZKlVXgQSHUoUVYE4kFFtdJ6BtncgOPUaOr1sgYOoopnQFcoeqJhUSXRHvkNrWF2Qu1WgnuIgBVaHs7C8AygtAApNogxv8B5rMYE6Xx37cz0XXrNDUqGGObxrhzbmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497143; c=relaxed/simple;
	bh=eRWM0v8QaMgjpHttR1MWSzaJJ0/akhHJaaBUDcwqw2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm2lvbI8BfIH9xLzoRZBsHYH4j3eAcOj5SD7CX2CNx6mvZ8VYKBDiw2zJprfe0W5rTYVbScZ4D40xDpHmJBMSLxoFyce3GgRYYQ05HYalexf1Zg3pPcgS1sUsdwMRHHzpVHA5ZL0gXfde6okWQVPQAkK15Sq1nTrVpCgsJaKFyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrhmFmgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrhmFmgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D779C116D0;
	Thu, 15 Jan 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497143;
	bh=eRWM0v8QaMgjpHttR1MWSzaJJ0/akhHJaaBUDcwqw2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrhmFmgtsh9rzQS1yqi+BDPOBZKQCaTmFxigrqxgtwI1RTIWZtaoEskjPP4y4iLtD
	 KiGiX/xtTlNG0UFfuQvy6qWPXARcWzx0Sen0EHoXSBWKinMUwgvqiZrr56hXBBANIs
	 wZrzRmOHJAaalZNkGzsQEPqyBXtqdacdjBADM19o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 50/72] net: enetc: fix build warning when PAGE_SIZE is greater than 128K
Date: Thu, 15 Jan 2026 17:49:00 +0100
Message-ID: <20260115164145.307968634@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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
index aacdfe98b65ab..d2ad5be02a0d8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -43,9 +43,9 @@ struct enetc_tx_swbd {
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



