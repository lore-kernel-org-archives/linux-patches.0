Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DE7420463;
	Fri,  4 Sep 2026 06:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502712; cv=none; b=gVvgXZxZFsw279PCzUIMtInku66guGg/sXqhY14cdN/zXdkSeL+Vgh+pKYFtZt8hiN1yJyfwGXiO6mbi4vyXPTIIGM7QAsx80dV90wEzyN1pzBg968uVavtpYTSjciyANHz2uHC5WO8O2iRSG361olt4vseJsyQPDgNDlgIxSK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502712; c=relaxed/simple;
	bh=wjP12+RjhXwotiaL3pLbX6OGwZcu5OtTgaLeRwtRJiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYpBB+LCNpC/u3BFSow6B0lFAz7FUUGTvM1dhsM3ocGwy+wJmXzCKs++vxKp4pl4TPeWN+WTyu7+AgQ9C9QYXlMR8ylisyeiPnGwickgvxSa5TCYEUQFt12VvuyoNUK4778TQT7aXQXGizVitefkkgE2IZHPCCcfunnygiTaCaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXbyi5aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXbyi5aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DE41F00A3D;
	Fri,  4 Sep 2026 06:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502710;
	bh=NGSvLUUNp2PDnTbydu2i4NgYjW3sCAyD9wlqA7bdVwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXbyi5awaZD9t2NV6ZkB2oiQE2AQ8X+effz8JzMtiqDwvdy/NejTnLL5kL+li1B01
	 DnIhfi8HMxBao45mCrhYKNNaPhK61bQBox/p04VTb+e44o8owPIy2wJE6StkMOjoZ3
	 QWwWI5IDb1XLJrHTy2WULdZf+tmxP8uT7oKYl2hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 302/403] iommu/amd: Put PCI device after handling PPR faults
Date: Fri,  4 Sep 2026 07:01:45 +0200
Message-ID: <20260904045741.711256910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit af3b69b16383fbc8fe5f61b5b0150d2e41ede71f upstream.

iommu_call_iopf_notifier() looks up the requester with
pci_get_domain_bus_and_slot(), which returns a PCI device with its
reference count incremented.

Neither the successful iommu_report_device_fault() path nor the abort
path drops that reference, so every handled PPR request leaks a PCI
device reference.

This is the same ownership rule that was fixed for the old iommu_v2
ppr_notifier() path by commit 6cf0981c2233 ("iommu/amd: Fix pci device
refcount leak in ppr_notifier()"), but iommu_call_iopf_notifier() was
added later as a separate PPR/IOPF notifier path.

Drop the PCI device reference after handling the PPR entry.

Fixes: 978d626b8f1a ("iommu/amd: Add IO page fault notifier handler")
Cc: stable@vger.kernel.org
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/ppr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 1f8d2823bea4..80369ca1e316 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -151,7 +151,7 @@ static void iommu_call_iopf_notifier(struct amd_iommu *iommu, u64 *raw)
 
 	/* Submit event */
 	iommu_report_device_fault(&pdev->dev, &event);
-
+	pci_dev_put(pdev);
 	return;
 
 out:
@@ -159,6 +159,7 @@ static void iommu_call_iopf_notifier(struct amd_iommu *iommu, u64 *raw)
 	amd_iommu_complete_ppr(&pdev->dev, PPR_PASID(raw[0]),
 			       IOMMU_PAGE_RESP_FAILURE,
 			       PPR_TAG(raw[0]) & 0x1FF);
+	pci_dev_put(pdev);
 }
 
 void amd_iommu_poll_ppr_log(struct amd_iommu *iommu)
-- 
2.55.0



