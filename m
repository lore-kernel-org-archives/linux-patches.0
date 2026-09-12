Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE26346A08;
	Sat, 12 Sep 2026 07:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198932; cv=none; b=SWqJ/stmSX40MeyqWT0Hkfm90zInAPZY8gBelvyDD2K7cZ2dLr0sDa6Y2PfNPxpmun2ppgh+vcMPRqr+lqr5ShINYbExNcE6yf5gF3d6BKzeNQIYpn02l1ZBFxKwgCtmZDgYp6GGSXF5NTLOvfSVIFylyy7DRhZKUdXfKS2b/To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198932; c=relaxed/simple;
	bh=/m1P2IX2xcHaakhgJc36kLWrGkJW4La0ONPKD6jxKNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwMl++4SYYZGAP1Au6x7rNX/B130iDOLXaPQ195xRwO6DBXNPlNQmWGI7uHiLW4fThqYdcsCuQOUoc5ZP4FUo8tm029qOJ6OOfh9NYvgKgTHupl5M+0QqF0cbP8rixT4oGWq8KIYaFZvAjRynQFxCYJs1a9wCwvi4yk4/hScTSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKPS33Xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKPS33Xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CBD1F000FF;
	Sat, 12 Sep 2026 07:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198928;
	bh=XtmmHxOHUZaa+nI4BfK0tKR7YNcOGS8edSjRcPrt/zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKPS33Xy/gzq8tUjkl1eHaQrrliSZUi6LnSXgs6f4rfjPuyMiEbZ69D94CkZkCzFZ
	 ZWRRJgE3PEGGCZ/6sXtvSzXZMgOnkSbpJ2gknHGNsl+lOpjJ7IzahcSsP2CTIyDpJj
	 zfOcmTr33lqcG/meKJMFiqrSKavX3hF5dqK8A/zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <can.guo@oss.qualcomm.com>,
	Ziqi Chen <ziqi.chen@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0481/1815] scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR context
Date: Sat, 12 Sep 2026 08:37:11 +0200
Message-ID: <20260912065700.182399454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Can Guo <can.guo@oss.qualcomm.com>

[ Upstream commit 760fc6f0e25a72832c2fcf37ecf5f1b770ec8374 ]

TX EQTR may run while devfreq gear scaling has quiesced the UFS
tagset. In that context, functions ufshcd_tx_eqtr(), __ufshcd_tx_eqtr()
and ufs_qcom_get_rx_fom() allocate memory with GFP_KERNEL. If direct
reclaim is triggered, reclaim/writeback can depend on I/O to UFS
device. Because the queue is quiesced, this can cause deadlock.

Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
allocations in the TX EQTR call tree, including:

 - params->eqtr_record in ufshcd_tx_eqtr()

 - eqtr_data in __ufshcd_tx_eqtr()

 - params in ufs_qcom_get_rx_fom()

This is preferred over tagging individual call sites with GFP_NOIO, as it
automatically covers any future allocations added anywhere in the call tree
without requiring each caller to be aware of this constraint.

[mkp: fix label as suggested by Bart]

Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
Closes: https://sashiko.dev/#/patchset/20260615132834.2985346-1-can.guo@oss.qualcomm.com?part=2
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
Reviewed-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260618140941.902000-1-can.guo@oss.qualcomm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-txeq.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index aa64f2bf4f1ef..7df3d3b18cbec 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/sched/mm.h>
 #include <ufs/ufshcd.h>
 #include <ufs/unipro.h>
 #include "ufshcd-priv.h"
@@ -1216,14 +1217,25 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
 			  struct ufs_pa_layer_attr *pwr_mode)
 {
 	struct ufs_pa_layer_attr old_pwr_info;
+	unsigned int noio_flag;
 	int ret;
 
+	/*
+	 * ufshcd_tx_eqtr() is called from a power-mode-change context where
+	 * I/O is suspended. Use memalloc_noio_save() to propagate GFP_NOIO
+	 * to all allocations in the call tree instead of tagging each call
+	 * site individually.
+	 */
+	noio_flag = memalloc_noio_save();
+
 	if (!params->eqtr_record) {
 		params->eqtr_record = devm_kzalloc(hba->dev,
 						   sizeof(*params->eqtr_record),
 						   GFP_KERNEL);
-		if (!params->eqtr_record)
-			return -ENOMEM;
+		if (!params->eqtr_record) {
+			ret = -ENOMEM;
+			goto out_noio_restore;
+		}
 	}
 
 	memcpy(&old_pwr_info, &hba->pwr_info, sizeof(struct ufs_pa_layer_attr));
@@ -1231,23 +1243,26 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
 	ret = ufshcd_tx_eqtr_prepare(hba, pwr_mode);
 	if (ret) {
 		dev_err(hba->dev, "Failed to prepare TX EQTR: %d\n", ret);
-		goto out;
+		goto out_unprepare;
 	}
 
 	ret = ufshcd_vops_tx_eqtr_notify(hba, PRE_CHANGE, pwr_mode);
 	if (ret)
-		goto out;
+		goto out_unprepare;
 
 	ret = __ufshcd_tx_eqtr(hba, params, pwr_mode);
 	if (ret)
-		goto out;
+		goto out_unprepare;
 
 	ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, pwr_mode);
 
-out:
+out_unprepare:
 	if (ret)
 		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
 
+out_noio_restore:
+	memalloc_noio_restore(noio_flag);
+
 	return ret;
 }
 
-- 
2.53.0



