Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4C28F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DFAC433C7;
	Sun, 16 Jul 2023 20:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539091;
	bh=H9FIY/Na+OMcJuPlbpyr2AflDyB9HGFfSbjH/P6nK2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jjVRYanX1QHDVRczrotegyS42kjSctMVTrfcClF/qWocg99Uq+HQXAtGLJxiGLwR
	 O7xP2MTKDtboMwjVMHoJ0XrIG+NElAJbwjm8n2npkzED4S+azQaSrO6Ymo7qNPmfWt
	 y1rcx9gEKnTJLiyeENSayOfED9yF7sVmSWnaKWGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 684/800] octeontx2-af: cn10kb: fix interrupt csr addresses
Date: Sun, 16 Jul 2023 21:48:57 +0200
Message-ID: <20230716195005.011954981@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 4c5a331cacda995e995a7857f0e44e8937d98d2c ]

The current design is that, for asynchronous events like link_up and
link_down firmware raises the interrupt to kernel. The previous patch
which added RPM_USX driver has a bug where it uses old csr addresses
for configuring interrupts. Which is resulting in losing interrupts
from source firmware.

This patch fixes the issue by correcting csr addresses.

Fixes: b9d0fedc6234 ("octeontx2-af: cn10kb: Add RPM_USX MAC support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index de0d88dd10d65..a433f92c51eae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -47,7 +47,7 @@ static struct mac_ops		rpm2_mac_ops   = {
 	.int_set_reg    =       RPM2_CMRX_SW_INT_ENA_W1S,
 	.irq_offset     =       1,
 	.int_ena_bit    =       BIT_ULL(0),
-	.lmac_fwi	=	RPM_LMAC_FWI,
+	.lmac_fwi	=	RPM2_LMAC_FWI,
 	.non_contiguous_serdes_lane = true,
 	.rx_stats_cnt   =       43,
 	.tx_stats_cnt   =       34,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 22147b4c21370..be294eebab265 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -94,7 +94,8 @@
 
 /* CN10KB CSR Declaration */
 #define  RPM2_CMRX_SW_INT				0x1b0
-#define  RPM2_CMRX_SW_INT_ENA_W1S			0x1b8
+#define  RPM2_CMRX_SW_INT_ENA_W1S			0x1c8
+#define  RPM2_LMAC_FWI					0x12
 #define  RPM2_CMR_CHAN_MSK_OR				0x3120
 #define  RPM2_CMR_RX_OVR_BP_EN				BIT_ULL(2)
 #define  RPM2_CMR_RX_OVR_BP_BP				BIT_ULL(1)
-- 
2.39.2



