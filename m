Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE78D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C28C433EF;
	Mon, 15 May 2023 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169445;
	bh=RcMf99sVVFYOzFuBxPyij6kdwnRsBoKd96FJsfVFXdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdXMbEkO0k/dG0n4aoFFq9Ng3Xyuh9YX59s51rLXWEFFtcqp7w+mRExZhgbYHzElc
	 WaTusAVWl1lrKXwp4lDFkQ8hkMYqBtpku+2TogdFok9USRqr7LPkJKfpMr/NFrqrCx
	 iaVFqrmYM48OVXC/i4DAsa3SW2c9+J8WueUOeuwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 030/246] octeontx2-pf: mcs: Match macsec ethertype along with DMAC
Date: Mon, 15 May 2023 18:24:02 +0200
Message-Id: <20230515161723.509277307@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 57d00d4364f314485092667d2a48718985515deb ]

On CN10KB silicon a single hardware macsec block is
present and offloads macsec operations for all the
ethernet LMACs. TCAM match with macsec ethertype 0x88e5
alone at RX side is not sufficient to distinguish all the
macsec interfaces created on top of netdevs. Hence append
the DMAC of the macsec interface too. Otherwise the first
created macsec interface only receives all the macsec traffic.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c  | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 9ec5f38d38a84..f699209978fef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -9,6 +9,7 @@
 #include <net/macsec.h>
 #include "otx2_common.h"
 
+#define MCS_TCAM0_MAC_DA_MASK		GENMASK_ULL(47, 0)
 #define MCS_TCAM0_MAC_SA_MASK		GENMASK_ULL(63, 48)
 #define MCS_TCAM1_MAC_SA_MASK		GENMASK_ULL(31, 0)
 #define MCS_TCAM1_ETYPE_MASK		GENMASK_ULL(47, 32)
@@ -237,8 +238,10 @@ static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
 				     struct cn10k_mcs_rxsc *rxsc, u8 hw_secy_id)
 {
 	struct macsec_rx_sc *sw_rx_sc = rxsc->sw_rxsc;
+	struct macsec_secy *secy = rxsc->sw_secy;
 	struct mcs_flowid_entry_write_req *req;
 	struct mbox *mbox = &pfvf->mbox;
+	u64 mac_da;
 	int ret;
 
 	mutex_lock(&mbox->lock);
@@ -249,11 +252,16 @@ static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
 		goto fail;
 	}
 
+	mac_da = ether_addr_to_u64(secy->netdev->dev_addr);
+
+	req->data[0] = FIELD_PREP(MCS_TCAM0_MAC_DA_MASK, mac_da);
+	req->mask[0] = ~0ULL;
+	req->mask[0] = ~MCS_TCAM0_MAC_DA_MASK;
+
 	req->data[1] = FIELD_PREP(MCS_TCAM1_ETYPE_MASK, ETH_P_MACSEC);
 	req->mask[1] = ~0ULL;
 	req->mask[1] &= ~MCS_TCAM1_ETYPE_MASK;
 
-	req->mask[0] = ~0ULL;
 	req->mask[2] = ~0ULL;
 	req->mask[3] = ~0ULL;
 
-- 
2.39.2



