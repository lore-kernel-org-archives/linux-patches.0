Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB6C401A25;
	Fri,  4 Sep 2026 05:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501414; cv=none; b=IosNc65/wL4pKQsW6VSy2h+Rr8avCAsir0mc9kyebPxSkC8wyxW/cBEaLihT7xD4oRohVCSMGWI+DqB45uxeC1LFoBEKdRcWMBWvyMij0J5bC0scnYqZMvhRIXviQlUmksEP+rrzFekkhqwKQ1JvezVEag5lB8dQ+nd0zJ+IS40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501414; c=relaxed/simple;
	bh=IbPJbZQu2+KHuQwPX2S0Ty+Qd2/2VfLZQjgF3fcAG5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+QV6pFvV08lPTDvU952l6SLdlkfgsFeRuN/EX2OWlcRTSvJ7PTMBIc4V1wurnadF98WfwfvhPGPRhQc3RLrP1d9wYhesb8PeZjfy3w0rLnvRNASd8c+RPwN0YnUqqAMlbRwEduNNiBbaLnYsqAj2ua4FR0/wYrjsMEX4Z0x/BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6lPvDQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6lPvDQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1C21F00A3D;
	Fri,  4 Sep 2026 05:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501413;
	bh=qk8ozDuYWuo3jsf8k5nwlUWTsblQCRBcn9BBUxVAJWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6lPvDQ+GcfoN4gojRBbEDzCkg18hOlR4WljfLUmqHEU57w8ftlFyIg52oG48BVSJ
	 HjI3m9EZR+VS4/yW1tIuEI3R9sWFT2IBvLA/fizmz59tNHNpDOzUnmgLqFBPfvVVS6
	 AXMFhaMH3N93CSxFgKog/zZEZ58TFVTQuXAqnKw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 402/552] iommu/amd: Put PCI device after handling PPR faults
Date: Fri,  4 Sep 2026 06:59:19 +0200
Message-ID: <20260904045759.585077702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 drivers/iommu/amd/ppr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -151,7 +151,7 @@ static void iommu_call_iopf_notifier(str
 
 	/* Submit event */
 	iommu_report_device_fault(&pdev->dev, &event);
-
+	pci_dev_put(pdev);
 	return;
 
 out:
@@ -159,6 +159,7 @@ out:
 	amd_iommu_complete_ppr(&pdev->dev, PPR_PASID(raw[0]),
 			       IOMMU_PAGE_RESP_FAILURE,
 			       PPR_TAG(raw[0]) & 0x1FF);
+	pci_dev_put(pdev);
 }
 
 void amd_iommu_poll_ppr_log(struct amd_iommu *iommu)


