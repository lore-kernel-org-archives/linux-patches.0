Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30F135201E;
	Wed, 20 May 2026 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295217; cv=none; b=jVwE5edlRt9M1XT3lkVjGYZwlLFow1lFCD7f7xrfSa29TDs6xIg7bnl8998gT4xq5JmdNNAlThcgSEHcVQnwiudmGVx1tq+EHOrcn1HMWCksLEqRIu+ZLRx8dU/UvuENXspGVOpMxNC3MwPOajyymVkKueKtK8NOmFFMiVx592o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295217; c=relaxed/simple;
	bh=5PTPNe0bxGWYB3w3+6dXr+BXtbTuCS3WvRyKP94w0U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJg7FiCcMNjSjG5igdin1WeSlqTKzcB8ytG3NfZLhmHqnpUjwRtqwjTysT82B9LSc4I1YPoHECbCJeGTV2XDBYutgHD591gAxCmJwnPAC/f/I1bLrmdTimMWAUxyFi2/HzVIwpd48sMZRkG5Fy7UIy8sL6ah5OJa5cYfykzFw7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRp3en9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRp3en9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D6E1F000E9;
	Wed, 20 May 2026 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295216;
	bh=wRWMYekSp29z/0uHotLxgbPBtYv4wsF4OdvJSdsnrNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRp3en9n61lW79fO9SggvQPHWlqoTHPZBW6fvqOgU4NEVvaRQK01l0jAdqMN8ENoI
	 E1/ASZGkOHvMtwwIxNfMt61svXf6emr3kYdUE9EqEfIgnImoDa29DjWz9m5SgnlgsP
	 ghooMMLtjYYjNfKDlv0g6j5txTzkdUQsvJiMiSTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0334/1146] iommu/riscv: Fix signedness bug
Date: Wed, 20 May 2026 18:09:44 +0200
Message-ID: <20260520162155.759506873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 553a127cb66523089bc10eb54640205495f4bb5b ]

The function platform_irq_count() returns negative error codes and
iommu->irqs_count is an unsigned integer, so the check
(iommu->irqs_count <= 0) is always impossible.

Make the return value of platform_irq_count() be assigned to ret, check
for error, and then assign iommu->irqs_count to ret.

Detected by Smatch:
drivers/iommu/riscv/iommu-platform.c:119 riscv_iommu_platform_probe() warn:
'iommu->irqs_count' unsigned <= 0

Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Fixes: 5c0ebbd3c6c6 ("iommu/riscv: Add RISC-V IOMMU platform device driver")
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu-platform.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-platform.c b/drivers/iommu/riscv/iommu-platform.c
index 8f15b06e84997..399ba8fe1b3e5 100644
--- a/drivers/iommu/riscv/iommu-platform.c
+++ b/drivers/iommu/riscv/iommu-platform.c
@@ -115,10 +115,13 @@ static int riscv_iommu_platform_probe(struct platform_device *pdev)
 		fallthrough;
 
 	case RISCV_IOMMU_CAPABILITIES_IGS_WSI:
-		iommu->irqs_count = platform_irq_count(pdev);
-		if (iommu->irqs_count <= 0)
+		ret = platform_irq_count(pdev);
+		if (ret <= 0)
 			return dev_err_probe(dev, -ENODEV,
 					     "no IRQ resources provided\n");
+
+		iommu->irqs_count = ret;
+
 		if (iommu->irqs_count > RISCV_IOMMU_INTR_COUNT)
 			iommu->irqs_count = RISCV_IOMMU_INTR_COUNT;
 
-- 
2.53.0



