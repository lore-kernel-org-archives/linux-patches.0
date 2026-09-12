Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD73890FC;
	Sat, 12 Sep 2026 07:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199475; cv=none; b=CNU+rELste+6apy/4ioN2zshP7YdPV9wPpsb8JaprAnTiD92AQHBd7grinOColoLGg9v2t1PqGwzS02XfVv1U8IcCrZUSABbdYgwtT7oa5GARhcPUYL4h6A2J6vp7gqurdi/qyKJnXh6CTcJ+zIkzHtG+xJ0IlRIH8JAHLrGBLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199475; c=relaxed/simple;
	bh=ByMYasF6f+tAgnT1XpYxLpCI/H6uxrNaEU1aJyx/KXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwqN+6/3TPw/sVx7MHScYPnCoAAhGZ0vRHl9+RWT3r4m8Q78EwBHkYUPxm4osBBtCBT2B/V5Ob8z0OoMCPFdcXUB/E8dptFZWA61enSK+R3/TXQwRP+MLLaqq9qzsS+vAhdbEy1E90B14U5WblivTOmGfcmc57F3vOgdTQqsFEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5UYvtOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5UYvtOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01CC1F000FF;
	Sat, 12 Sep 2026 07:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199473;
	bh=JOTTtGWgBHCSpuCVd8Le/giziMwwT8rg4hXDompAZZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5UYvtOv0lnYq8XkkXMIqvv4rH0gvEvuDO33QUKsss+GaCGlNaBc8MxyubL53wyjX
	 HQmNdZQ/70xLy+iI3qLqGXPm/pVuv6aPbsb31uxRyacsJ5yMlyoNJb7R3A2iT1VDIq
	 3k+cKET2OTFRuJfNhoAsksXzPjdNvYGcKqYVp9d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0590/1815] iommu/qcom: Fix inverted fault report check in qcom_iommu_fault()
Date: Sat, 12 Sep 2026 08:39:00 +0200
Message-ID: <20260912065702.730297770@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 1f33b8208a1978b0c0d6ad60a47fe4bb7a235e58 ]

report_iommu_fault() returns 0 when a fault handler successfully handles
the fault, and -ENOSYS when no handler is installed. The condition
'!report_iommu_fault()' evaluates to true (printing "Unhandled context
fault") precisely when the fault *was* handled, and stays silent when no
handler is present — the opposite of what is intended.

Remove the '!' so the driver logs unhandled faults correctly.

Fixes: 049541e178d5 ("iommu: qcom: wire up fault handler")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 32efef69e72db..09f2ee6be988b 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -200,7 +200,7 @@ static irqreturn_t qcom_iommu_fault(int irq, void *dev)
 	fsynr = iommu_readl(ctx, ARM_SMMU_CB_FSYNR0);
 	iova = iommu_readq(ctx, ARM_SMMU_CB_FAR);
 
-	if (!report_iommu_fault(ctx->domain, ctx->dev, iova, 0)) {
+	if (report_iommu_fault(ctx->domain, ctx->dev, iova, 0)) {
 		dev_err_ratelimited(ctx->dev,
 				    "Unhandled context fault: fsr=0x%x, "
 				    "iova=0x%016llx, fsynr=0x%x, cb=%d\n",
-- 
2.53.0



