Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC631F1534;
	Sat, 12 Sep 2026 08:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201482; cv=none; b=XZzTUnzEqyBGjYRVYlZGy2LmhQ6R0hWSM1ajJ5LhbRTAdqOCGcHe+4gF15bCFVMHw7iH25UJAZHWqE7w9KU5GeDs2WWnXtvo6BK8IHzN//ERHIcH3JO9Lv4g3MMn9ALY+AnIR2PSs+Hd9ogScfJYwObUZn81+Mbof3EfH1PSyI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201482; c=relaxed/simple;
	bh=ibBSFiY8hu8eII8kuHHbhEjLAOL3KFKrBjVdyNIvmE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDnz7f8KVJG9EmSQrWmInS/tTCyLaY8WexY171YJc4D7jOzxsV8Eb1OT/NN8saPsGUjX8TRtUB/KVSlqgg1FC0XHlAoGBEWRimIlhFzQwBRAoLJhnO+tuxOYB9Eyvr7lDxDOnvB6PwwSwlj/dlYIBJy8lQKpvFAy8qHbHARpUTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7XYaubj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7XYaubj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924881F000FF;
	Sat, 12 Sep 2026 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201481;
	bh=Ub8gFPFv6+rfPLRk17y+JVYGEM0JsO7AFiDiuwxzMSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7XYaubjPgurMmXIjLW3zUElfv3SNzsToR2upJXVmnZP8rMyaVA1v65MQ+/kSmUTD
	 LY5C6i2GORj/YDDbgG2ZoAm8KAoVUibssVolwaJt8pmcOo8YkGjyTAHhnl3O13Ho8d
	 0f1BHUKEf6MKY14I8B8K0S9x8C/rk1efIkmxay4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0962/1815] iommu/arm-smmu-v3: Convert to use atomic poll timeout
Date: Sat, 12 Sep 2026 08:45:12 +0200
Message-ID: <20260912065711.556523749@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 966d329d27441..35b7b2fd4a122 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4553,8 +4553,9 @@ static int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
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



