Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6393546C8;
	Wed, 20 May 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299141; cv=none; b=j5FmiEctdw3MQ64MEDpwHS18QZBO1q5L0Bk1ezOfYwKYvIaciDM9NEt5oRqWkwRSrXNPGHDSPJBzlA5C8U01vv4K4BqwG0ZUHYZOnSJwMt5ZAT2947IXiMHQR3bFRM2Vsxxf0zdpq6t7Hh29/EpcJkYPRVGkNb5ojx7RR1RSXag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299141; c=relaxed/simple;
	bh=IAE7P3GSB+R4p2gPeG5ejKngILtIo+lZQHfIO+3HLJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsUzSgIO6f2rVZKYNO/RBaqiIBzzawymveVjONfQZSt52gKxpx6CUSqIyXcjzbMv099Slm/xkF+DTxE8ednAgnq0DJ/84SInc7PYRDxDnlj7DnaoDvVEn1H001VikqrrvmYaKlNuINCgeCkLgRS5bFanl0DUv54Bh1VB/4vrfkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9qBLBiX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9qBLBiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0AF1F000E9;
	Wed, 20 May 2026 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299140;
	bh=yxQMP+VN7MOgN7aab6AOGtOLZ00MnLkL0IFaJvujAYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9qBLBiXj7LBFELpOyE6mLCih9SFMCw1pRltSNaKhmt7R1fqIa22O9dQol2ly9HHL
	 u21wPb+5kv3uaQWfw4kurhhfkV9MiWfFKEo/dtEvYn+9YI9Gkhe5vNdL/hO8DowtrB
	 hiyKhRwFPARagPCM6719Sc8aixJaVdaNbGJzAMrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Rahul Gupta <rahul-rg.gupta@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 679/957] bnge: fix initial HWRM sequence
Date: Wed, 20 May 2026 18:19:22 +0200
Message-ID: <20260520162149.262580333@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 70d7c905a07ae8415b955569620bf2bf77423553 ]

Firmware may not advertize correct resources if backing store is not
enabled before resource information is queried.
Fix the initial sequence of HWRMs so that driver gets capabilities
and resource information correctly.

Fixes: 3fa9e977a0cd ("bng_en: Initialize default configuration")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Rahul Gupta <rahul-rg.gupta@broadcom.com>
Link: https://patch.msgid.link/20260418023438.1597876-2-vikas.gupta@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnge/bnge_core.c    | 30 ++++++++++++++-----
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_core.c b/drivers/net/ethernet/broadcom/bnge/bnge_core.c
index 312a9db4d75d1..657cd7a880d29 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_core.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_core.c
@@ -68,6 +68,13 @@ static int bnge_func_qcaps(struct bnge_dev *bd)
 		return rc;
 	}
 
+	return 0;
+}
+
+static int bnge_func_qrcaps_qcfg(struct bnge_dev *bd)
+{
+	int rc;
+
 	rc = bnge_hwrm_func_resc_qcaps(bd);
 	if (rc) {
 		dev_err(bd->dev, "query resc caps failure rc: %d\n", rc);
@@ -127,23 +134,28 @@ static int bnge_fw_register_dev(struct bnge_dev *bd)
 
 	bnge_hwrm_fw_set_time(bd);
 
-	rc =  bnge_hwrm_func_drv_rgtr(bd);
+	/* Get the resources and configuration from firmware */
+	rc = bnge_func_qcaps(bd);
 	if (rc) {
-		dev_err(bd->dev, "Failed to rgtr with firmware rc: %d\n", rc);
+		dev_err(bd->dev, "Failed querying caps rc: %d\n", rc);
 		return rc;
 	}
 
 	rc = bnge_alloc_ctx_mem(bd);
 	if (rc) {
 		dev_err(bd->dev, "Failed to allocate ctx mem rc: %d\n", rc);
-		goto err_func_unrgtr;
+		goto err_free_ctx_mem;
 	}
 
-	/* Get the resources and configuration from firmware */
-	rc = bnge_func_qcaps(bd);
+	rc = bnge_hwrm_func_drv_rgtr(bd);
 	if (rc) {
-		dev_err(bd->dev, "Failed initial configuration rc: %d\n", rc);
-		rc = -ENODEV;
+		dev_err(bd->dev, "Failed to rgtr with firmware rc: %d\n", rc);
+		goto err_free_ctx_mem;
+	}
+
+	rc = bnge_func_qrcaps_qcfg(bd);
+	if (rc) {
+		dev_err(bd->dev, "Failed querying resources rc: %d\n", rc);
 		goto err_func_unrgtr;
 	}
 
@@ -152,7 +164,9 @@ static int bnge_fw_register_dev(struct bnge_dev *bd)
 	return 0;
 
 err_func_unrgtr:
-	bnge_fw_unregister_dev(bd);
+	bnge_hwrm_func_drv_unrgtr(bd);
+err_free_ctx_mem:
+	bnge_free_ctx_mem(bd);
 	return rc;
 }
 
-- 
2.53.0



