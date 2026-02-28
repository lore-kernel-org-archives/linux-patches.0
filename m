Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A63834252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301826; cv=none; b=mHTACAwvXEAD33DwfqH/dGVyPd7l8SCh9eUazb6m6AFpq0dIoPeQ+7Kn5+5USom9fDsB0Bk2kWOuUKf0yoTYgro36/oEk1Hk7Tf6ZeFhhV5eKIToZkh3VP+H5SjHII7ZJ20D0pHrVaLlwLjqQplKssSFVd1qAJdu7CVUcWhpUlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301826; c=relaxed/simple;
	bh=7fxwG1UM65CkilTKWjlv7IhWh7+K7CKnTAXxc1GtrPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsfCEnjnhABn15A/m8NJtiAbWu2R78pE9csdK+pLM6oKnCYhiPVNMX89RtRrKIL8Yi2TPDiAL7t+i4NZ10IsBkGvuO7YQGlH+o3BIiix5qFBa9T7WSTkYdg/5HX6xAZvEZIa4aThRh1kd0FA3bZSWG+czla1Xk7rbuD/Sl/YKik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7eFEimR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7eFEimR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBA4C19424;
	Sat, 28 Feb 2026 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301826;
	bh=7fxwG1UM65CkilTKWjlv7IhWh7+K7CKnTAXxc1GtrPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7eFEimRANUW2eCwm0JNlQsWMJBZNO+vB/lqkTuYAMX6U+NPjj7I/esVcFfQUQaUy
	 q7+0JOauxHto8WPPs/sg5yIUmIpooWZ/gCsWGv7F8GZnSw7ZuuQ5dHmG/yx2P9va8f
	 70ao5C0MTtOiN+1jCFmlwP3AtY8Tiebyz04kXXvfDkQXpWDsT61tKrUQNMnaRAC1IB
	 I4N1QXlAzrQpk4D4JKPPLZxyn003yUdaB7EeMEg0MPg04bW4/qROSC/ldqDp/+9M16
	 YMDhSsJZOpLKvb1PC79qnlP+u3KFnRD0iHhurrk7LAGpRkV5ggEi3ooa590FbSg3mq
	 HdddQ7TE8yYgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/385] octeon_ep: ensure dbell BADDR updation
Date: Sat, 28 Feb 2026 12:57:43 -0500
Message-ID: <20260228180011.1568201-241-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vimlesh Kumar <vimleshk@marvell.com>

[ Upstream commit ce8fe3fc4f99efd872120301c0f72f2e90ab9769 ]

Make sure the OUT DBELL base address reflects the
latest values written to it.

Fix:
Add a wait until the OUT DBELL base address register
is updated with the DMA ring descriptor address,
and modify the setup_oq function to properly
handle failures.

Fixes: 0807dc76f3bf5 ("octeon_ep: support Octeon CN10K devices")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260206111510.1045092-3-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeon_ep/octep_cn9k_pf.c         |  3 +-
 .../marvell/octeon_ep/octep_cnxk_pf.c         | 46 +++++++++++++++----
 .../ethernet/marvell/octeon_ep/octep_main.h   |  2 +-
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |  8 +++-
 4 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index f0bcb5f3c1474..01e82d0b6b2cd 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -307,7 +307,7 @@ static void octep_setup_iq_regs_cn93_pf(struct octep_device *oct, int iq_no)
 }
 
 /* Setup registers for a hardware Rx Queue  */
-static void octep_setup_oq_regs_cn93_pf(struct octep_device *oct, int oq_no)
+static int octep_setup_oq_regs_cn93_pf(struct octep_device *oct, int oq_no)
 {
 	u64 reg_val;
 	u64 oq_ctl = 0ULL;
@@ -355,6 +355,7 @@ static void octep_setup_oq_regs_cn93_pf(struct octep_device *oct, int oq_no)
 	reg_val = ((u64)time_threshold << 32) |
 		  CFG_GET_OQ_INTR_PKT(oct->conf);
 	octep_write_csr64(oct, CN93_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
+	return 0;
 }
 
 /* Setup registers for a PF mailbox */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
index 07e00887c6940..09a3f1d0645b8 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/jiffies.h>
 
 #include "octep_config.h"
 #include "octep_main.h"
@@ -327,12 +328,14 @@ static void octep_setup_iq_regs_cnxk_pf(struct octep_device *oct, int iq_no)
 }
 
 /* Setup registers for a hardware Rx Queue  */
-static void octep_setup_oq_regs_cnxk_pf(struct octep_device *oct, int oq_no)
+static int octep_setup_oq_regs_cnxk_pf(struct octep_device *oct, int oq_no)
 {
-	u64 reg_val;
-	u64 oq_ctl = 0ULL;
-	u32 time_threshold = 0;
 	struct octep_oq *oq = oct->oq[oq_no];
+	unsigned long t_out_jiffies;
+	u32 time_threshold = 0;
+	u64 oq_ctl = 0ULL;
+	u64 reg_ba_val;
+	u64 reg_val;
 
 	oq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
 	reg_val = octep_read_csr64(oct, CNXK_SDP_R_OUT_CONTROL(oq_no));
@@ -343,6 +346,36 @@ static void octep_setup_oq_regs_cnxk_pf(struct octep_device *oct, int oq_no)
 			reg_val = octep_read_csr64(oct, CNXK_SDP_R_OUT_CONTROL(oq_no));
 		} while (!(reg_val & CNXK_R_OUT_CTL_IDLE));
 	}
+	octep_write_csr64(oct, CNXK_SDP_R_OUT_WMARK(oq_no),  oq->max_count);
+	/* Wait for WMARK to get applied */
+	usleep_range(10, 15);
+
+	octep_write_csr64(oct, CNXK_SDP_R_OUT_SLIST_BADDR(oq_no),
+			  oq->desc_ring_dma);
+	octep_write_csr64(oct, CNXK_SDP_R_OUT_SLIST_RSIZE(oq_no),
+			  oq->max_count);
+	reg_ba_val = octep_read_csr64(oct, CNXK_SDP_R_OUT_SLIST_BADDR(oq_no));
+
+	if (reg_ba_val != oq->desc_ring_dma) {
+		t_out_jiffies = jiffies + 10 * HZ;
+		do {
+			if (reg_ba_val == ULLONG_MAX)
+				return -EFAULT;
+			octep_write_csr64(oct,
+					  CNXK_SDP_R_OUT_SLIST_BADDR(oq_no),
+					  oq->desc_ring_dma);
+			octep_write_csr64(oct,
+					  CNXK_SDP_R_OUT_SLIST_RSIZE(oq_no),
+					  oq->max_count);
+			reg_ba_val =
+			octep_read_csr64(oct,
+					 CNXK_SDP_R_OUT_SLIST_BADDR(oq_no));
+		} while ((reg_ba_val != oq->desc_ring_dma) &&
+			  time_before(jiffies, t_out_jiffies));
+
+		if (reg_ba_val != oq->desc_ring_dma)
+			return -EAGAIN;
+	}
 
 	reg_val &= ~(CNXK_R_OUT_CTL_IMODE);
 	reg_val &= ~(CNXK_R_OUT_CTL_ROR_P);
@@ -356,10 +389,6 @@ static void octep_setup_oq_regs_cnxk_pf(struct octep_device *oct, int oq_no)
 	reg_val |= (CNXK_R_OUT_CTL_ES_P);
 
 	octep_write_csr64(oct, CNXK_SDP_R_OUT_CONTROL(oq_no), reg_val);
-	octep_write_csr64(oct, CNXK_SDP_R_OUT_SLIST_BADDR(oq_no),
-			  oq->desc_ring_dma);
-	octep_write_csr64(oct, CNXK_SDP_R_OUT_SLIST_RSIZE(oq_no),
-			  oq->max_count);
 
 	oq_ctl = octep_read_csr64(oct, CNXK_SDP_R_OUT_CONTROL(oq_no));
 
@@ -385,6 +414,7 @@ static void octep_setup_oq_regs_cnxk_pf(struct octep_device *oct, int oq_no)
 	reg_val &= ~0xFFFFFFFFULL;
 	reg_val |= CFG_GET_OQ_WMARK(oct->conf);
 	octep_write_csr64(oct, CNXK_SDP_R_OUT_WMARK(oq_no), reg_val);
+	return 0;
 }
 
 /* Setup registers for a PF mailbox */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 936b786f42816..c063c8451d47a 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -77,7 +77,7 @@ struct octep_pci_win_regs {
 
 struct octep_hw_ops {
 	void (*setup_iq_regs)(struct octep_device *oct, int q);
-	void (*setup_oq_regs)(struct octep_device *oct, int q);
+	int (*setup_oq_regs)(struct octep_device *oct, int q);
 	void (*setup_mbox_regs)(struct octep_device *oct, int mbox);
 
 	irqreturn_t (*mbox_intr_handler)(void *ioq_vector);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index 82b6b19e76b47..f2a7c6a76c742 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -12,6 +12,8 @@
 #include "octep_config.h"
 #include "octep_main.h"
 
+static void octep_oq_free_ring_buffers(struct octep_oq *oq);
+
 static void octep_oq_reset_indices(struct octep_oq *oq)
 {
 	oq->host_read_idx = 0;
@@ -170,11 +172,15 @@ static int octep_setup_oq(struct octep_device *oct, int q_no)
 		goto oq_fill_buff_err;
 
 	octep_oq_reset_indices(oq);
-	oct->hw_ops.setup_oq_regs(oct, q_no);
+	if (oct->hw_ops.setup_oq_regs(oct, q_no))
+		goto oq_setup_err;
+
 	oct->num_oqs++;
 
 	return 0;
 
+oq_setup_err:
+	octep_oq_free_ring_buffers(oq);
 oq_fill_buff_err:
 	vfree(oq->buff_info);
 	oq->buff_info = NULL;
-- 
2.51.0

