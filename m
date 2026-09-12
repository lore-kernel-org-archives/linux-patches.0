Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F4A47ACCA;
	Sat, 12 Sep 2026 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215406; cv=none; b=VaDd53yHu7yuIiAvcchXzAzFslJ6P41E+RHrs+NiOD68H/9phWxUlER0vfbrAspPZe4L06CjUd/FzYate0XdPzUQ5OwXXjZvKr7r36/EuXiGNC3VitBp5PkE9xb+PcdyW08Z2DMwyLnOXpOTbyh1a2eclYZjjZS8nOqsmt0JDiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215406; c=relaxed/simple;
	bh=fzzTJ0KDlQCylXFZLLVAV7O9ukQUM96lDbPrS6ND+w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IY5aXh85gQAZvXVsnwhTdBjx+DktEVze+7zWiyeSSCBDeY6lampJc2QeLQkkShvr95AxoDDe5rofdLORfqdXD9gjaYM9YDsx9d6yRf2hUVeC8fqKRNt1F1PiBFrXrrVV4Yz2XKcqZ+rGe7c+Jpls+kH6943UpZan/mGlskBPc74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiSgmk14; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiSgmk14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1471F000FF;
	Sat, 12 Sep 2026 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215400;
	bh=jvFJemsFmEcjihJExDBdB87tO9u4YhSGtPPfd54WIco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiSgmk14DNZsuP6EbwvLHB9QyP7Nu7sOequG1dizs28ltL7QJk+upYWthcG2qEb7t
	 fViFtVmMpOY1VI/axuaFTza4oGyEaXLFywxYLAXhqFjopX8NVrWBXY7iOd3+v1YIhD
	 Auiti/gyhv1QWy8A1Cr2J0RglZcITzT9ZQD78NPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0525/1376] cxl/pci: Honor -EPROBE_DEFER from component register setup
Date: Sat, 12 Sep 2026 08:49:11 +0200
Message-ID: <20260912065619.237186251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 430c502c80e542e77bcf97db13ec0e8cdf9addb0 ]

cxl_pci_setup_regs() for CXL_REGLOC_RBI_COMPONENT can return
-EPROBE_DEFER on a Restricted CXL Host (RCD) when the upstream port
has not yet been enumerated and the Component Registers must be
extracted from the RCRB. cxl_pci_probe() treats every non-zero return
from that call as the benign "component registers not found" case,
logs a warning, and continues. The rc is then immediately overwritten
by the subsequent cxl_pci_type3_init_mailbox() call, so the deferral
is silently swallowed.

Return -EPROBE_DEFER instead of continuing so the probe is retried
once the upstream port is available.

Fixes: 733b57f262b0 ("cxl/pci: Early setup RCH dport component registers from RCRB")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/ajzhsubot_PSYtHQ@MWDK4CY14F/T/#m063bbf76b1c9c293ade52ab311018ae6bba11a44
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/linux-cxl/ajzhsubot_PSYtHQ@MWDK4CY14F/T/#m063bbf76b1c9c293ade52ab311018ae6bba11a44
Link: https://patch.msgid.link/20260706224322.714934-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 02040b51f44ec..82cbacb3e2ca1 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -851,10 +851,13 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
 				&cxlds->reg_map);
-	if (rc)
+	if (rc) {
+		if (rc == -EPROBE_DEFER)
+			return rc;
 		dev_warn(&pdev->dev, "No component registers (%d)\n", rc);
-	else if (!cxlds->reg_map.component_map.ras.valid)
+	} else if (!cxlds->reg_map.component_map.ras.valid) {
 		dev_dbg(&pdev->dev, "RAS registers not found\n");
+	}
 
 	rc = cxl_map_component_regs(&cxlds->reg_map, &cxlds->regs.component,
 				    BIT(CXL_CM_CAP_CAP_ID_RAS));
-- 
2.53.0



