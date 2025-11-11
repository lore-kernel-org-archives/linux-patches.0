Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA025EF81;
	Tue, 11 Nov 2025 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824931; cv=none; b=M8eIMA9su9RPxMD14/iQAetrmd5BNUBTX/FOB2UKUq1SMTCBvbx5yBHXmxg0RbL2zn1c7i6wxOg++T6gMaJAkprFM40CoQnNK48+owf7Jj0HZpw8U39FmtWYLbCSyrMN/WpTcrcNR8b8nsGmPMsasJ2ChKQ9sUuhKOOhFS1j1rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824931; c=relaxed/simple;
	bh=wp4KjkC+enCRoTPUmnMYl1JwndAcLAMewf0QVw8t5LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TI+xRf7CLc8ffiCcJ6bmkcgb8lP/IQzLUDQXuNtWbc/I10sAZy2GsDfNYGef9qDi4ufBR2UvSrywRPGN+o65LkkSDSq8+4pnubqkdd7CKYVxI2wQWap8JO9daEj0OskDq0vSPkFOODcxx/AC/G7CnorZ0QaADtPvIrP3dhpKQJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tc+Zywyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tc+Zywyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394BEC4CEFB;
	Tue, 11 Nov 2025 01:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824930;
	bh=wp4KjkC+enCRoTPUmnMYl1JwndAcLAMewf0QVw8t5LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tc+ZywybdxNS0zgfWzLKcGzr8LmqM3RClXXPMMLuW0j+Mi3i7IjxNiyfSrFlM4gFO
	 HRz4MF7KZitwRnKmPN5sReTO0ppDTmpUIpxejM+HM57uDBJWyev0ap6ColerCVBPBy
	 RzatXwaCpdGxb/9rc+PMahJxKiw6gTc7wqt9pK7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 600/849] iommu/vt-d: Remove LPIG from page group response descriptor
Date: Tue, 11 Nov 2025 09:42:50 +0900
Message-ID: <20251111004550.929461708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 4402e8f39d0bfff5c0a5edb5e1afe27a56545e11 ]

Bit 66 in the page group response descriptor used to be the LPIG (Last
Page in Group), but it was marked as Reserved since Specification 4.0.
Remove programming on this bit to make it consistent with the latest
specification.

Existing hardware all treats bit 66 of the page group response descriptor
as "ignored", therefore this change doesn't break any existing hardware.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20250901053943.1708490-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.h | 1 -
 drivers/iommu/intel/prq.c   | 7 ++-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 2c261c069001c..21b2c3f85ddc5 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -462,7 +462,6 @@ enum {
 #define QI_PGRP_PASID(pasid)	(((u64)(pasid)) << 32)
 
 /* Page group response descriptor QW1 */
-#define QI_PGRP_LPIG(x)		(((u64)(x)) << 2)
 #define QI_PGRP_IDX(idx)	(((u64)(idx)) << 3)
 
 
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index 52570e42a14c0..ff63c228e6e19 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -151,8 +151,7 @@ static void handle_bad_prq_event(struct intel_iommu *iommu,
 			QI_PGRP_PASID_P(req->pasid_present) |
 			QI_PGRP_RESP_CODE(result) |
 			QI_PGRP_RESP_TYPE;
-	desc.qw1 = QI_PGRP_IDX(req->prg_index) |
-			QI_PGRP_LPIG(req->lpig);
+	desc.qw1 = QI_PGRP_IDX(req->prg_index);
 
 	qi_submit_sync(iommu, &desc, 1, 0);
 }
@@ -379,19 +378,17 @@ void intel_iommu_page_response(struct device *dev, struct iopf_fault *evt,
 	struct iommu_fault_page_request *prm;
 	struct qi_desc desc;
 	bool pasid_present;
-	bool last_page;
 	u16 sid;
 
 	prm = &evt->fault.prm;
 	sid = PCI_DEVID(bus, devfn);
 	pasid_present = prm->flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
-	last_page = prm->flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
 
 	desc.qw0 = QI_PGRP_PASID(prm->pasid) | QI_PGRP_DID(sid) |
 			QI_PGRP_PASID_P(pasid_present) |
 			QI_PGRP_RESP_CODE(msg->code) |
 			QI_PGRP_RESP_TYPE;
-	desc.qw1 = QI_PGRP_IDX(prm->grpid) | QI_PGRP_LPIG(last_page);
+	desc.qw1 = QI_PGRP_IDX(prm->grpid);
 	desc.qw2 = 0;
 	desc.qw3 = 0;
 
-- 
2.51.0



