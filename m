Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F4B33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301232; cv=none; b=Psjhqc9dw8bvlusWJP5lDyuiyoneYSXe+j1vioUVVE+WS9ViZQ2BcypcHf0VK45szRdIQGybqLvRM67sJ6XXPENwtyFmYdxbgfx5cTmQLVYmU9RreUwELIbHLIx4+Y1yWXG2BOg6osbo4V39swj5IEjGEY/YNjEmAYjsebLT3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301232; c=relaxed/simple;
	bh=O+K1q1+wR6440kqlwgDo0GiaKAZ4CBiRYFoHICkaVBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pO3TiOCOdS77SD2e+Ho5jMNV4leWrSGlg44W3FEkIp0KTbRyDQeKwBuuXtJIQboYJgaXHB+4+j+Bp5IosV/62kMSFsUOXIna8rWi7F1r9ocEc9TFB9AD+AfN6oZGvGEITKmZSKrzQJ27mGArHBXd+ZnlVHxfHkpCCZHPmZKmC1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcBHJXUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcBHJXUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3712C19424;
	Sat, 28 Feb 2026 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301232;
	bh=O+K1q1+wR6440kqlwgDo0GiaKAZ4CBiRYFoHICkaVBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcBHJXUfs7u7zC1+Ng85iJW2wfCPI9/XFu79EinV5SJlr+7VNUemne43Uhuv8mzN1
	 1LgPS+mf1RlGA1uqxoUAjY+TwsRBO53VczPfhUiJVL1mNtp3aA+JYelhPRJeY6JHVQ
	 Rjdr0Ty4B/X2Moz5Hncc+kCWQtT1LEq/lyFGKKyKbPxvU3OEVtOhi07SLqBvEsQF+f
	 vz9mjVzl5qwlVUQk4rcCfIzkJ8s55En+vlu0qc5tktJx5DNN7OH8Jdu0j+DIaIOwOC
	 puMhmIDRPSHKJ5mRs0tCbN8Ftg+amk3cfVgvCH615lstZrp1YPcg6NyC0TQaUicR89
	 OGnsCbb6plEBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kicinski@meta.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 411/752] bnxt_en: Fix RSS context delete logic
Date: Sat, 28 Feb 2026 12:42:02 -0500
Message-ID: <20260228174750.1542406-411-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit e123d9302d223767bd910bfbcfe607bae909f8ac ]

We need to free the corresponding RSS context VNIC
in FW everytime an RSS context is deleted in driver.
Commit 667ac333dbb7 added a check to delete the VNIC
in FW only when netif_running() is true to help delete
RSS contexts with interface down.

Having that condition will make the driver leak VNICs
in FW whenever close() happens with active RSS contexts.
On the subsequent open(), as part of RSS context restoration,
we will end up trying to create extra VNICs for which we
did not make any reservation. FW can fail this request,
thereby making us lose active RSS contexts.

Suppose an RSS context is deleted already and we try to
process a delete request again, then the HWRM functions
will check for validity of the request and they simply
return if the resource is already freed. So, even for
delete-when-down cases, netif_running() check is not
necessary.

Remove the netif_running() condition check when deleting
an RSS context.

Reported-by: Jakub Kicinski <kicinski@meta.com>
Fixes: 667ac333dbb7 ("eth: bnxt: allow deleting RSS contexts when the device is down")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260219185313.2682148-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 95c774d98da66..427eb02ae5056 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10809,12 +10809,10 @@ void bnxt_del_one_rss_ctx(struct bnxt *bp, struct bnxt_rss_ctx *rss_ctx,
 	struct bnxt_ntuple_filter *ntp_fltr;
 	int i;
 
-	if (netif_running(bp->dev)) {
-		bnxt_hwrm_vnic_free_one(bp, &rss_ctx->vnic);
-		for (i = 0; i < BNXT_MAX_CTX_PER_VNIC; i++) {
-			if (vnic->fw_rss_cos_lb_ctx[i] != INVALID_HW_RING_ID)
-				bnxt_hwrm_vnic_ctx_free_one(bp, vnic, i);
-		}
+	bnxt_hwrm_vnic_free_one(bp, &rss_ctx->vnic);
+	for (i = 0; i < BNXT_MAX_CTX_PER_VNIC; i++) {
+		if (vnic->fw_rss_cos_lb_ctx[i] != INVALID_HW_RING_ID)
+			bnxt_hwrm_vnic_ctx_free_one(bp, vnic, i);
 	}
 	if (!all)
 		return;
-- 
2.51.0

