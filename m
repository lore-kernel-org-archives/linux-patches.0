Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E446D556;
	Tue, 21 Jul 2026 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649187; cv=none; b=sJ5HPabcN6izNH68N1WpUKsqquX029OdBwUClLQgFppFNjsrvM4aqOPmPwwJtjGPwn0VqHvQj1RMO3jhTCny0rCK+TbS/kH1+HjYpNXdK9KnGORD4pjOAQoCd8huuX35mLWBfI8fyRHDAfccPmZF+P6JMh5r4Q5VMf+bhIbyhjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649187; c=relaxed/simple;
	bh=9uZaxSGnpNgYZ2nZ9vCrBvvJ1u+3zyB/kKSUL1iFEog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rq/UEiuios/gWBR1YfSd15MZ7taNsr0sRf6TE8c7l5BvVhUI1clrxXaqVi6qGw72096724AIigXaNw00TO0yp6MThymb8IZawq4RDh1ub1RCrTnc4nQkm1n/04tkwsEY4X+9Vr3d13AsYzwNr/7YlFR2Voqb7IRcvCeEqSLlzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZ+qPsA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZ+qPsA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD971F00A3A;
	Tue, 21 Jul 2026 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649186;
	bh=8CDLRPmo9fku41HOwSi62Ju3EquQTn85XGcJzhXQ9A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZ+qPsA9m1U8GJxiaAUcyTO+RuDsYcDVG0qfMh70P4WTK4OdP+udsrnmskg7/ZzdN
	 BFcqxSZurB3Mbe+tbW9dPBqhKYBFkiNr9j5kB8vfp9fvKc6NaRyHjIvxkRmdn9/aRT
	 eEyfj6aE9EW7VG4VJWIxvaWq3tRpGpEp0JhRoKbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0483/2077] cxl/pci: Convert PCIBIOS errors to errno on DVSEC config accesses
Date: Tue, 21 Jul 2026 17:02:36 +0200
Message-ID: <20260721152604.199891589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 26aa60e0276272ae61b843a05a91748dcb1130f9 ]

PCI config space accessors return positive PCIBIOS_* status codes on
failure that are positive integers. Several DVSEC accesses in the CXL
core propagated these raw values to callers that test for failure against
less than 0. Thus silently misinterpret the return value as success.

Convert the positive error values to negative errno values so the checks
are correct on error paths.

While the chances of a config access failure are low, fix for correctness
and to avoid confusion in the future when more DVSEC accesses are added.

Fixes: 14d788740774 ("cxl/mem: Consolidate CXL DVSEC Range enumeration in the core")
Fixes: ce17ad0d5498 ("cxl: Wait Memory_Info_Valid before access memory related info")
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260604180154.1925149-3-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 43885c59a7f246..e4338fd7e01b47 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -89,7 +89,7 @@ static int cxl_dvsec_mem_range_valid(struct cxl_dev_state *cxlds, int id)
 					   d + PCI_DVSEC_CXL_RANGE_SIZE_LOW(id),
 					   &temp);
 		if (rc)
-			return rc;
+			return pcibios_err_to_errno(rc);
 
 		valid = FIELD_GET(PCI_DVSEC_CXL_MEM_INFO_VALID, temp);
 		if (valid)
@@ -123,7 +123,7 @@ static int cxl_dvsec_mem_range_active(struct cxl_dev_state *cxlds, int id)
 		rc = pci_read_config_dword(
 			pdev, d + PCI_DVSEC_CXL_RANGE_SIZE_LOW(id), &temp);
 		if (rc)
-			return rc;
+			return pcibios_err_to_errno(rc);
 
 		active = FIELD_GET(PCI_DVSEC_CXL_MEM_ACTIVE, temp);
 		if (active)
@@ -156,7 +156,7 @@ int cxl_await_media_ready(struct cxl_dev_state *cxlds)
 	rc = pci_read_config_word(pdev,
 				  d + PCI_DVSEC_CXL_CAP, &cap);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	hdm_count = FIELD_GET(PCI_DVSEC_CXL_HDM_COUNT, cap);
 	for (i = 0; i < hdm_count; i++) {
@@ -275,7 +275,7 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 
 	rc = pci_read_config_word(pdev, d + PCI_DVSEC_CXL_CAP, &cap);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	if (!(cap & PCI_DVSEC_CXL_MEM_CAPABLE)) {
 		dev_dbg(dev, "Not MEM Capable\n");
@@ -299,7 +299,7 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 	 */
 	rc = pci_read_config_word(pdev, d + PCI_DVSEC_CXL_CTRL, &ctrl);
 	if (rc)
-		return rc;
+		return pcibios_err_to_errno(rc);
 
 	info->mem_enabled = FIELD_GET(PCI_DVSEC_CXL_MEM_ENABLE, ctrl);
 	if (!info->mem_enabled)
@@ -316,14 +316,14 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 		rc = pci_read_config_dword(
 			pdev, d + PCI_DVSEC_CXL_RANGE_SIZE_HIGH(i), &temp);
 		if (rc)
-			return rc;
+			return pcibios_err_to_errno(rc);
 
 		size = (u64)temp << 32;
 
 		rc = pci_read_config_dword(
 			pdev, d + PCI_DVSEC_CXL_RANGE_SIZE_LOW(i), &temp);
 		if (rc)
-			return rc;
+			return pcibios_err_to_errno(rc);
 
 		size |= temp & PCI_DVSEC_CXL_MEM_SIZE_LOW;
 		if (!size) {
@@ -333,14 +333,14 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 		rc = pci_read_config_dword(
 			pdev, d + PCI_DVSEC_CXL_RANGE_BASE_HIGH(i), &temp);
 		if (rc)
-			return rc;
+			return pcibios_err_to_errno(rc);
 
 		base = (u64)temp << 32;
 
 		rc = pci_read_config_dword(
 			pdev, d + PCI_DVSEC_CXL_RANGE_BASE_LOW(i), &temp);
 		if (rc)
-			return rc;
+			return pcibios_err_to_errno(rc);
 
 		base |= temp & PCI_DVSEC_CXL_MEM_BASE_LOW;
 
-- 
2.53.0



