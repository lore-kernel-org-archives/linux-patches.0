Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7604D6FAF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8239C433C7;
	Mon, 28 Aug 2023 10:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217897;
	bh=l2FAUOiI9eGEP88/PBtKaLNCte0FY5anCthhXs1lccI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2l3fEUQTo3XcvWn7eas/bTXRCeBWSgoyYBCENWoBtaWwP+nU5CphTQhsCf+bvGd7g
	 fOeB9cxSy3cGorWUYH1Q0Wfo0opa1oOwOICcGx0meXUUL8DgUwLHj6hcVUTkRsjcaw
	 nsSg14GrsmPiSH4RoCe/r1Qcx2BUQ/cAOYCZ1NrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 022/129] mlxsw: pci: Set time stamp fields also when its type is MIRROR_UTC
Date: Mon, 28 Aug 2023 12:11:41 +0200
Message-ID: <20230828101158.115869142@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit bc2de151ab6ad0762a04563527ec42e54dde572a ]

Currently, in Spectrum-2 and above, time stamps are extracted from the CQE
into the time stamp fields in 'struct mlxsw_skb_cb', only when the CQE
time stamp type is UTC. The time stamps are read directly from the CQE and
software can get the time stamp in UTC format using CQEv2.

>From Spectrum-4, the time stamps that are read from the CQE are allowed
to be also from MIRROR_UTC type.

Therefore, we get a warning [1] from the driver that the time stamp fields
were not set, when LLDP control packet is sent.

Allow the time stamp type to be MIRROR_UTC and set the time stamp in this
case as well.

[1]
 WARNING: CPU: 11 PID: 0 at drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c:1409 mlxsw_sp2_ptp_hwtstamp_fill+0x1f/0x70 [mlxsw_spectrum]
[...]
 Call Trace:
  <IRQ>
  mlxsw_sp2_ptp_receive+0x3c/0x80 [mlxsw_spectrum]
  mlxsw_core_skb_receive+0x119/0x190 [mlxsw_core]
  mlxsw_pci_cq_tasklet+0x3c9/0x780 [mlxsw_pci]
  tasklet_action_common.constprop.0+0x9f/0x110
  __do_softirq+0xbb/0x296
  irq_exit_rcu+0x79/0xa0
  common_interrupt+0x86/0xa0
  </IRQ>
  <TASK>

Fixes: 4735402173e6 ("mlxsw: spectrum: Extend to support Spectrum-4 ASIC")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/bcef4d044ef608a4e258d33a7ec0ecd91f480db5.1692268427.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index c968309657dd1..51eea1f0529c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -517,11 +517,15 @@ static void mlxsw_pci_skb_cb_ts_set(struct mlxsw_pci *mlxsw_pci,
 				    struct sk_buff *skb,
 				    enum mlxsw_pci_cqe_v cqe_v, char *cqe)
 {
+	u8 ts_type;
+
 	if (cqe_v != MLXSW_PCI_CQE_V2)
 		return;
 
-	if (mlxsw_pci_cqe2_time_stamp_type_get(cqe) !=
-	    MLXSW_PCI_CQE_TIME_STAMP_TYPE_UTC)
+	ts_type = mlxsw_pci_cqe2_time_stamp_type_get(cqe);
+
+	if (ts_type != MLXSW_PCI_CQE_TIME_STAMP_TYPE_UTC &&
+	    ts_type != MLXSW_PCI_CQE_TIME_STAMP_TYPE_MIRROR_UTC)
 		return;
 
 	mlxsw_skb_cb(skb)->cqe_ts.sec = mlxsw_pci_cqe2_time_stamp_sec_get(cqe);
-- 
2.40.1



