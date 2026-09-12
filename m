Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0726178C9C;
	Sat, 12 Sep 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223743; cv=none; b=ViWWF3G6Ys4NbDY0tzKtwWhScrFbJ0UyMJ0AWBUZHGknmjFOyytlAAzA04RG0VCom+TNCCuS2JRcoyANfonJ0fw9xU4uA7lnlBBW1tEQvfaRCYaxyBBZGwXFzv9tqgfNQUWF9hu3yixL60p4t6HxqAQfRhStLoEgtIRMj5HVMYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223743; c=relaxed/simple;
	bh=RpZpyKmMo4O/vEhf/6HpsnQtUzCu3kJfIprTT8o5pms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfGvq9gxqM916yxiHk5ihdOUijX2zTnRxJfGU07isr8ule7F1x/13YtLPKC6XNY5LJGfuirS9bnyIWWCxcNPDerEKcQjQOBMRHiBi2dhkPyHZXAiv8sRxfXjH4S4q206pyCCbzR5KQHc+MjAQf4iwNuc0dgQYPGTopCKd/RRJLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnvhiwL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnvhiwL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57821F000FF;
	Sat, 12 Sep 2026 14:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223741;
	bh=xfGJ8hUrJog77FR1tVD0KXB+cdEIRPl4QqzxSXnjszY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnvhiwL9dgn3domSjozFE8OucrBh4R7pwZTsa+6GHQz4xLDozlHGiDcy4fEKgSdTW
	 90z57p2Kd5vIPyb10F/ULTYxmD95/Qz91Ku6Tso8x8ZBSjD4zW4n15MV5q6H/XKBH1
	 gPLixfWwIi085q3ZmzGgLmvKbtMigUS0a8VC4f/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0850/1424] iommu/qcom: Fix inverted fault report check in qcom_iommu_fault()
Date: Sat, 12 Sep 2026 08:54:42 +0200
Message-ID: <20260912065626.346400556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0dceb06034bc..e134c877c16e2 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -210,7 +210,7 @@ static irqreturn_t qcom_iommu_fault(int irq, void *dev)
 	fsynr = iommu_readl(ctx, ARM_SMMU_CB_FSYNR0);
 	iova = iommu_readq(ctx, ARM_SMMU_CB_FAR);
 
-	if (!report_iommu_fault(ctx->domain, ctx->dev, iova, 0)) {
+	if (report_iommu_fault(ctx->domain, ctx->dev, iova, 0)) {
 		dev_err_ratelimited(ctx->dev,
 				    "Unhandled context fault: fsr=0x%x, "
 				    "iova=0x%016llx, fsynr=0x%x, cb=%d\n",
-- 
2.53.0



