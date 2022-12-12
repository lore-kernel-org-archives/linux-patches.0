Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5434328ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9989FC433D2;
	Mon, 12 Dec 2022 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851380;
	bh=CN6UsLlELhbC/fmn3IbT3WakVUqhHfbcPBl4AV0avB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCMc4+P39mA7YzmAA6lROjfKx+4kKKqsBnz716IJQIX0ieO3Trd4d5wyM62fiXtDQ
	 jYwVmtFxriq4MESyZhyvTA/Sw3aDdY1ckUhILzQDbPFMXtFL3G1rOSoVU/Q7I+H2d7
	 TzQr1ny+naXCu7/nbNIPCOl3vqquuaFIZv+yJ034=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Jaron <michalx.jaron@intel.com>,
	Kamil Maziarz <kamil.maziarz@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.4 50/67] i40e: Fix not setting default xps_cpus after reset
Date: Mon, 12 Dec 2022 14:17:25 +0100
Message-Id: <20221212130920.015489501@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Jaron <michalx.jaron@intel.com>

[ Upstream commit 82e0572b23029b380464fa9fdc125db9c1506d0a ]

During tx rings configuration default XPS queue config is set and
__I40E_TX_XPS_INIT_DONE is locked. __I40E_TX_XPS_INIT_DONE state is
cleared and set again with default mapping only during queues build,
it means after first setup or reset with queues rebuild. (i.e.
ethtool -L <interface> combined <number>) After other resets (i.e.
ethtool -t <interface>) XPS_INIT_DONE is not cleared and those default
maps cannot be set again. It results in cleared xps_cpus mapping
until queues are not rebuild or mapping is not set by user.

Add clearing __I40E_TX_XPS_INIT_DONE state during reset to let
the driver set xps_cpus to defaults again after it was cleared.

Fixes: 6f853d4f8e93 ("i40e: allow XPS with QoS enabled")
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 15f177185d71..d612b23c2e3f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -9953,6 +9953,21 @@ static int i40e_rebuild_channels(struct i40e_vsi *vsi)
 	return 0;
 }
 
+/**
+ * i40e_clean_xps_state - clean xps state for every tx_ring
+ * @vsi: ptr to the VSI
+ **/
+static void i40e_clean_xps_state(struct i40e_vsi *vsi)
+{
+	int i;
+
+	if (vsi->tx_rings)
+		for (i = 0; i < vsi->num_queue_pairs; i++)
+			if (vsi->tx_rings[i])
+				clear_bit(__I40E_TX_XPS_INIT_DONE,
+					  vsi->tx_rings[i]->state);
+}
+
 /**
  * i40e_prep_for_reset - prep for the core to reset
  * @pf: board private structure
@@ -9984,8 +9999,10 @@ static void i40e_prep_for_reset(struct i40e_pf *pf, bool lock_acquired)
 		rtnl_unlock();
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
-		if (pf->vsi[v])
+		if (pf->vsi[v]) {
+			i40e_clean_xps_state(pf->vsi[v]);
 			pf->vsi[v]->seid = 0;
+		}
 	}
 
 	i40e_shutdown_adminq(&pf->hw);
-- 
2.35.1



