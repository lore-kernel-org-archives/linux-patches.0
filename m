Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995214CDDD4;
	Thu, 17 Sep 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658871; cv=none; b=Z8qSB+4h9zYoHZV4npN5nhCR5NYF8/lddT68dFxlH8ARJYNsB0/ZJr6t6liNz4n+IEGh0VWkdNH4fqjaqtok+22TiDNYk9rmEb+TQRmVS5sxq8tFdoN+3kZIWneuFBRAVDGO1zD/u+fNzuOxZFnC2XXsBrP0uXIDD5mLauuWjzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658871; c=relaxed/simple;
	bh=+j62bjKPoCI2nA0JFUiLBIqwj630NilJk2HXIzjsETc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tENbFmLZrmcT64U3aK70fOcaDS7qZue6pz5e0B4cKUteriL0W4hmO+gJsOAsJ+/8Au4USDTLnLrd1CjdPC593DSj+dPYX/kn9/ikRvVaP1q/chk8i58BxarxAAQHh4ZV40Pvs8hFLMXS2gLWh2bGFug9unZmJ4LywmUjnczYN6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/vH1rSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/vH1rSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C971F00893;
	Thu, 17 Sep 2026 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658859;
	bh=2nk8x42uy/Klh7Q0hxBDH2aa5nZABq1U3zcfGw0RFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/vH1rSytFOOGssG4GkfrIknVLNuZT0E8ieBt9Ve7GL1ujuh/mjvVoWcHPNKAIl2f
	 qs9Z55ZlhFysejW9aC4RR1QldRhMqBVjAqMsnNxVENS6W/0IrVuuqclNmM/32fSHzj
	 3JlvcMKxkxEeGEEzhA7iNcyLxHuCP0Q8gv4A3YDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sangram kumar yerra <sangram.k.y@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 063/733] scsi: ufs: ufs-pci: Add MCQ support for Intel UFS 4.0 controllers
Date: Thu, 17 Sep 2026 16:06:11 +0100
Message-ID: <20260917151352.402562433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sangram kumar yerra <sangram.k.y@intel.com>

[ Upstream commit c46cc9cee39bd6f395ab9ac98b1794705df13d7c ]

The Intel UFS 4.0 PCI variant (PCI ID 8086:D335) advertises MCQ support
in its capability register. However, ufshcd_alloc_mcq() also requires an
.op_runtime_config hook to locate the per-queue operation and runtime
(OPR) register blocks, which was not provided by this variant operations
table.

As a result, MCQ initialization fails and ufshcd_add_scsi_host() prints
"MCQ mode is disabled, err=%d\n" before falling back to legacy
single-doorbell (SDB) mode.

Add ufs_intel_mcq_config_resource() to initialize the MCQ configuration
base and add ufs_intel_op_runtime_config() to set up the OPR register
offsets and stride.

Wire both hooks into the variant operations table so MCQ is enabled when
supported by the hardware.

Fixes: 096cd6b7adf2 ("scsi: ufs: ufs-pci: Add support for Intel Nova Lake")
Signed-off-by: sangram kumar yerra <sangram.k.y@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260818112830.453402-3-sangram.k.y@intel.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufshcd-pci.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 93bfafc25018b..21bb11c724bea 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -460,6 +460,43 @@ static int ufs_intel_mtl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static int ufs_intel_mcq_config_resource(struct ufs_hba *hba)
+{
+	hba->mcq_base = hba->mmio_base + ufshcd_mcq_queue_cfg_addr(hba);
+
+	return 0;
+}
+
+/*
+ * This Intel UFS4.0 controller maps MCQ doorbell and interrupt-status
+ * registers into the same PCI BAR as the legacy HCI space, at this
+ * fixed offset/stride.
+ */
+#define UFS_INTEL_SQDAO0	0x2800
+#define UFS_INTEL_SQISAO0	0x2814
+#define UFS_INTEL_CQDAO0	0x281C
+#define UFS_INTEL_CQISAO0	0x2824
+#define UFS_INTEL_MCQ_STRIDE	0x30
+
+static int ufs_intel_op_runtime_config(struct ufs_hba *hba)
+{
+	struct ufshcd_mcq_opr_info_t *opr;
+	int i;
+
+	hba->mcq_opr[OPR_SQD].offset  = UFS_INTEL_SQDAO0;
+	hba->mcq_opr[OPR_SQIS].offset = UFS_INTEL_SQISAO0;
+	hba->mcq_opr[OPR_CQD].offset  = UFS_INTEL_CQDAO0;
+	hba->mcq_opr[OPR_CQIS].offset = UFS_INTEL_CQISAO0;
+
+	for (i = 0; i < OPR_MAX; i++) {
+		opr = &hba->mcq_opr[i];
+		opr->stride = UFS_INTEL_MCQ_STRIDE;
+		opr->base = hba->mmio_base + opr->offset;
+	}
+
+	return 0;
+}
+
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
 {
 	return MAX_SUPP_MAC;
@@ -547,6 +584,8 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 	.pwr_change_notify	= ufs_intel_nvl_pwr_change_notify,
+	.mcq_config_resource	= ufs_intel_mcq_config_resource,
+	.op_runtime_config	= ufs_intel_op_runtime_config,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
-- 
2.53.0



