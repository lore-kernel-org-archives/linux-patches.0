Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B326AA91;
	Wed,  9 Sep 2026 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964621; cv=none; b=bvKuALZrqaRaDduDFmZ9dwsIZ7MjXPVz4BT7OqNkNKFE8X0a8rWueKjTIiu3aX6rZ9eS4rsdLL71+Bpr1PQhV158PFXrIaiJ3x9pn1pzTrjidfu+KAqwgmnahdNPkOws0W/QARYssxlEqg+ixiQmThy2xaneIAlANNjK3W9a6rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964621; c=relaxed/simple;
	bh=AprkHkWXG5LfuKGQYVTRWJueCHHKg4E+Bg6CISdBmkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHowtG4CdwlukXYBZzBGOKj7p++0FalsEerVZPAElo7fq2OgJcjKIlXqky/uto8lon6lQRCk6hU3gq8+JtJ8YknRXTWH/VtD9zvfChIm08ybSY8GhLdSbsCqCEq78KiYDwv9Dre5S3sR7+Lm/2ekHHhHKVcmsn3lHmZk0mLM/fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7T5HHlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7T5HHlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47D21F00A3A;
	Wed,  9 Sep 2026 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964620;
	bh=x7KdO/ktk2vEv/tx50BLkWvsJFVmmxoKDmEpZvGVj/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7T5HHlrUtJN5HqQwt4LPKR+M1qfnE02B5/fZLBDAS80HD0PaFHeSlsuXHELIRSHJ
	 zEqRv9MvC+QzEkuaZxm2m+gBcglmTez1s1iDlNwHwBfapwjrqGD1Hf23kXXEMwk6r/
	 dJqK9tVV21xTjhoUlJMc+SWiKZ/pW2zr1Oh+Pjds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 487/583] cxl/ras: Fix cxl_rch_get_aer_severity() wrong severity register
Date: Wed,  9 Sep 2026 15:42:52 +0200
Message-ID: <20260909134254.686137433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Terry Bowman <terry.bowman@amd.com>

[ Upstream commit 9d399526128bae184b153deab42b49f5f3eea2ed ]

cxl_rch_get_aer_severity() classifies RCH Downstream Port uncorrectable
errors as fatal or non-fatal by ANDing uncorrectable status with
PCI_ERR_ROOT_FATAL_RCV. This is wrong because PCI_ERR_ROOT_FATAL_RCV is a
Root Error Status register bit (bit 6), not a severity bit. ANDing it
against uncorrectable status tests a reserved bit and produces incorrect
severity classification.

Fix by ANDing the unmasked uncor_status against uncor_severity. Per
PCIe Base Spec r6.0 Section 7.8.4.4, each bit in the Uncorrectable
Error Severity register indicates whether the corresponding error is
fatal (1) or non-fatal (0).

Fixes: 6ac07883dbb5 ("cxl/pci: Add RCH downstream port error logging")
Cc: stable@vger.kernel.org
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260803221810.3685703-3-terry.bowman@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/ras_rch.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/cxl/core/ras_rch.c
+++ b/drivers/cxl/core/ras_rch.c
@@ -94,11 +94,11 @@ static bool cxl_rch_get_aer_info(void __
 static bool cxl_rch_get_aer_severity(struct aer_capability_regs *aer_regs,
 				     int *severity)
 {
-	if (aer_regs->uncor_status & ~aer_regs->uncor_mask) {
-		if (aer_regs->uncor_status & PCI_ERR_ROOT_FATAL_RCV)
-			*severity = AER_FATAL;
-		else
-			*severity = AER_NONFATAL;
+	u32 uncor_status = aer_regs->uncor_status & ~aer_regs->uncor_mask;
+
+	if (uncor_status) {
+		*severity = (uncor_status & aer_regs->uncor_severity) ?
+			     AER_FATAL : AER_NONFATAL;
 		return true;
 	}
 


