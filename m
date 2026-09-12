Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C723815F8;
	Sat, 12 Sep 2026 19:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242909; cv=none; b=JtHolxzJK1Fvh0AME8nuVzYcQyyL8jYda0CehReuib8pvs2uM09ldniWpTQTJ07caxm1d6Mt+IW0QyuZaBU2HaZeMjjqV6ZRmiqp+z7JqOAw+XDHb+0rpFSDSNJF1ZKsdseOuMYRSKref0mXY9G3B9uLdLeLg6t6U+DxM745pho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242909; c=relaxed/simple;
	bh=yJ6/iu4IfaefzwqxsYpJfNana4b0rDIbX+X8Hamz/lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikW3zkkg6eCjhZ4xM09RoNepruOwMT3ywHIdoR/n/HfpJYcp0p/MWXH46NlTCJzHK+Uigp5hZqCMC/Yq5uZD2jMelC/2frn43//vXYN2ujTiaL7UqlQQscGZXLu9VGfu19d1SqMPNXxTNY/ywPug7oTI6JrU7kbblha1aXdUnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkp1FOjJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkp1FOjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097141F000FF;
	Sat, 12 Sep 2026 19:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242907;
	bh=2vmsfyUW5hl9g3yto3+ExN3V0bWPwj8dpVLg/w66uek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkp1FOjJaLP7M4KlDKxZG2rrJfyXKJQ0vaSF2r2g447tMd85NgU9+RCIrt9ZGFJ67
	 T8IZ4+GR1q3M8NZ2v/Q02HpMhL4qSIHBBBqSqRRajyvQ6oK75V84gBm5/39tlY1yiD
	 9namBv+kCaIRn5lOdlaMr4iEx/e45T4qUeutf+j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 570/798] iommu/arm-smmu-v3: Convert to use atomic poll timeout
Date: Sat, 12 Sep 2026 09:03:18 +0200
Message-ID: <20260912065530.192469948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit eced8058c82a3a81ae480a6546e2da32100dddfa ]

The arm_smmu_write_reg_sync() helper is currently implemented using
readl_relaxed_poll_timeout() (that relies on usleep_range() internally)
which becomes a critical issue when used in the gerror irq handler.

If the SMMU hits a gerror and enters Service Failure Mode
(GERROR_SFM_ERR), the gerror handler calls arm_smmu_device_disable() in
hard-irq context. This becomes a problem as arm_smmu_device_disable()
inevitably calls arm_smmu_write_reg_sync() which might attempt to sleep
inside a hard-irq context.

Fix this by converting the arm_smmu_write_reg_sync to use the
readl_relaxed_poll_timeout_atomic() polling helper.

(Discovered while running Sashiko locally on another patch series).

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 48ec83bcbcf5 ("iommu/arm-smmu: Add initial driver support for ARM SMMUv3 devices")
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8ee0446c358d6..41a4e5a235531 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2842,8 +2842,9 @@ static int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
 	u32 reg;
 
 	writel_relaxed(val, smmu->base + reg_off);
-	return readl_relaxed_poll_timeout(smmu->base + ack_off, reg, reg == val,
-					  1, ARM_SMMU_POLL_TIMEOUT_US);
+	return readl_relaxed_poll_timeout_atomic(smmu->base + ack_off, reg,
+						reg == val, 1,
+						ARM_SMMU_POLL_TIMEOUT_US);
 }
 
 /* GBPA is "special" */
-- 
2.53.0



