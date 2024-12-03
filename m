Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642FC1EE001;
	Tue,  3 Dec 2024 15:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239428; cv=none; b=iRNJJJewUKNRI/atVqkktrA35LZSbwv8Z69XTJYTLWi7lycuqMWyz4IisG9J9hDNSLBDNMFZyR4ig/GVzzbKEuPN/eUolAy5XhoL4j6XdprXSLxsmTnUDaUJBScAD6x2IoYfU66OM+0mUjq5CAZljDTPL4UnQZjXwk6xt/qtAkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239428; c=relaxed/simple;
	bh=zDO2GTZF3K2xyTavnCyTjEbAJ9OtNPor3thcdHznIr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkCbuTS7nZblAkKpX2DfSk0yQKBjnFEWCYjQLBfUqb1OcP/en27bmzqmWA9Qo0MTxFj3LncMNATrZ30etdsvJSh98VS4ezujU+GIOah5syA9VFoK8vAFcdObt5lPEqgepW1agr3dIzAf28B7d3HPxqeWkdopn+MW5AbqPkCLytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CztdAxxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CztdAxxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9548C4CECF;
	Tue,  3 Dec 2024 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239428;
	bh=zDO2GTZF3K2xyTavnCyTjEbAJ9OtNPor3thcdHznIr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CztdAxxiPTxrjbpnAFHtIv3BjkwZSC1N1nrvzqs8MNJ0cHhd5XyRgb9sBXwF3FJ7H
	 Jfset+Sw8aXGoDZeH92fW/4iILQELucjR5EaYD+eQQmInS1JFCY0SjZTCCXqPJ//Yu
	 UMX79r/HlDz5iAc6NY9OoJnITHKvNRGWBA8Ljyy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 579/817] octeontx2-af: RPM: Fix low network performance
Date: Tue,  3 Dec 2024 15:42:31 +0100
Message-ID: <20241203144018.516870781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit d1e8884e050c1255a9ceb477f5ff926ee9214a23 ]

Low network performance is observed even on RPMs with larger
FIFO lengths.

The cn10kb silicon has three RPM blocks with the following
FIFO sizes:

         --------------------
         | RPM0  |   256KB  |
         | RPM1  |   256KB  |
         | RPM2  |   128KB  |
         --------------------

The current design stores the FIFO length in a common structure for all
RPMs (mac_ops). As a result, the FIFO length of the last RPM is applied
to all RPMs, leading to reduced network performance.

This patch resolved the problem by storing the fifo length in per MAC
structure (cgx).

Fixes: b9d0fedc6234 ("octeontx2-af: cn10kb: Add RPM_USX MAC support")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c         | 9 +++++++--
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h         | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h | 5 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c         | 6 +++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c     | 9 ++++-----
 5 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 27935c54b91bc..2f621714c54e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -112,6 +112,11 @@ struct mac_ops *get_mac_ops(void *cgxd)
 	return ((struct cgx *)cgxd)->mac_ops;
 }
 
+u32 cgx_get_fifo_len(void *cgxd)
+{
+	return ((struct cgx *)cgxd)->fifo_len;
+}
+
 void cgx_write(struct cgx *cgx, u64 lmac, u64 offset, u64 val)
 {
 	writeq(val, cgx->reg_base + (lmac << cgx->mac_ops->lmac_offset) +
@@ -501,7 +506,7 @@ static u32 cgx_get_lmac_fifo_len(void *cgxd, int lmac_id)
 	u8 num_lmacs;
 	u32 fifo_len;
 
-	fifo_len = cgx->mac_ops->fifo_len;
+	fifo_len = cgx->fifo_len;
 	num_lmacs = cgx->mac_ops->get_nr_lmacs(cgx);
 
 	switch (num_lmacs) {
@@ -1764,7 +1769,7 @@ static void cgx_populate_features(struct cgx *cgx)
 	u64 cfg;
 
 	cfg = cgx_read(cgx, 0, CGX_CONST);
-	cgx->mac_ops->fifo_len = FIELD_GET(CGX_CONST_RXFIFO_SIZE, cfg);
+	cgx->fifo_len = FIELD_GET(CGX_CONST_RXFIFO_SIZE, cfg);
 	cgx->max_lmac_per_mac = FIELD_GET(CGX_CONST_MAX_LMACS, cfg);
 
 	if (is_dev_rpm(cgx))
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index dc9ace30554af..f9cd4b58f0c02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -185,4 +185,5 @@ int cgx_lmac_get_pfc_frm_cfg(void *cgxd, int lmac_id, u8 *tx_pause,
 int verify_lmac_fc_cfg(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
 		       int pfvf_idx);
 int cgx_lmac_reset(void *cgxd, int lmac_id, u8 pf_req_flr);
+u32 cgx_get_fifo_len(void *cgxd);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 9ffc6790c5130..c43ff68ef1408 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -72,7 +72,6 @@ struct mac_ops {
 	u8			irq_offset;
 	u8			int_ena_bit;
 	u8			lmac_fwi;
-	u32			fifo_len;
 	bool			non_contiguous_serdes_lane;
 	/* RPM & CGX differs in number of Receive/transmit stats */
 	u8			rx_stats_cnt;
@@ -142,6 +141,10 @@ struct cgx {
 	u8			lmac_count;
 	/* number of LMACs per MAC could be 4 or 8 */
 	u8			max_lmac_per_mac;
+	/* length of fifo varies depending on the number
+	 * of LMACS
+	 */
+	u32			fifo_len;
 #define MAX_LMAC_COUNT		8
 	struct lmac             *lmac_idmap[MAX_LMAC_COUNT];
 	struct			work_struct cgx_cmd_work;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 9e8c5e4389f8b..22dd50a3fcd3a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -480,7 +480,7 @@ u32 rpm_get_lmac_fifo_len(void *rpmd, int lmac_id)
 	u8 num_lmacs;
 	u32 fifo_len;
 
-	fifo_len = rpm->mac_ops->fifo_len;
+	fifo_len = rpm->fifo_len;
 	num_lmacs = rpm->mac_ops->get_nr_lmacs(rpm);
 
 	switch (num_lmacs) {
@@ -533,9 +533,9 @@ u32 rpm2_get_lmac_fifo_len(void *rpmd, int lmac_id)
 	 */
 	max_lmac = (rpm_read(rpm, 0, CGX_CONST) >> 24) & 0xFF;
 	if (max_lmac > 4)
-		fifo_len = rpm->mac_ops->fifo_len / 2;
+		fifo_len = rpm->fifo_len / 2;
 	else
-		fifo_len = rpm->mac_ops->fifo_len;
+		fifo_len = rpm->fifo_len;
 
 	if (lmac_id < 4) {
 		num_lmacs = hweight8(lmac_info & 0xF);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 266ecbc1b97a6..4dcd7bfcad4e4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -923,13 +923,12 @@ int rvu_mbox_handler_cgx_features_get(struct rvu *rvu,
 
 u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 {
-	struct mac_ops *mac_ops;
-	u32 fifo_len;
+	void *cgxd = rvu_first_cgx_pdata(rvu);
 
-	mac_ops = get_mac_ops(rvu_first_cgx_pdata(rvu));
-	fifo_len = mac_ops ? mac_ops->fifo_len : 0;
+	if (!cgxd)
+		return 0;
 
-	return fifo_len;
+	return cgx_get_fifo_len(cgxd);
 }
 
 u32 rvu_cgx_get_lmac_fifolen(struct rvu *rvu, int cgx, int lmac)
-- 
2.43.0



