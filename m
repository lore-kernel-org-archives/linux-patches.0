Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE17396B7D;
	Thu, 15 Jan 2026 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496307; cv=none; b=n9Z5O0RsgF/ov7sQPtCrTmTEmcXVRdHMOpLn7jmgR7mEk+6j7EALvXuYlONZAuc5IliYd7+RSMLugo6i1BhoX15CuIs9UHx/p9vykm2jfp3pG/8UJ/aTsDJMdx7V5vDh3MPiW5zwjOnFAHBHJKtK7l/8VHCTtcpcNgyrGJErkI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496307; c=relaxed/simple;
	bh=aAXlDYEfEXrbCnyfe3g6GpF1ZKGQHI7EXEEzcQAiK/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsYN4LtEinygmwfI39kSPnZvCvH9ALKrM0PEwtGVSx4AjZjsFJFBBF/6YlfTkgUi1J/15g3fE5K6aZJt/QRCnI9mTGq6a41INIdciGX1CEEHACK5H8R+Uz0WDM3TGWKQChA+o2oiia8mhd0CTbz/W27N/WVe3ANxpftBE745Jfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gXY1Oyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gXY1Oyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1371EC116D0;
	Thu, 15 Jan 2026 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496307;
	bh=aAXlDYEfEXrbCnyfe3g6GpF1ZKGQHI7EXEEzcQAiK/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gXY1Oyny8ioESCTlL3vmtbRJ4sUQGonl4qH1ZWsanc/GaPIFsN7n9oMxIYSs0Wsh
	 HdwHwBq2jwY3aUhN3RJSz7DB9wrtG7nvWkHbcVcSJ1Jj9Ls8exz3OK5kdVwiJTP/g+
	 3M0WJAs7h3w7xR61IAFA7L8v/3A8Cx1zelVAiR9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/181] net: enetc: fix build warning when PAGE_SIZE is greater than 128K
Date: Thu, 15 Jan 2026 17:48:08 +0100
Message-ID: <20260115164207.764476726@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f279fa597991e..60c7205ea9ff5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -79,9 +79,9 @@ struct enetc_lso_t {
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



