Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8722D739C;
	Sat, 12 Sep 2026 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224698; cv=none; b=AkdM8JEj6H2Adx9GMHjMbHbmJGWJEFy/tbi19JloiP9eauyEsElnAsHykbl2RXkJoiwalArbutSZ1rvQK0WNOitX+hUP6mZTwkNM7h43vAog4oLqV6TGqf+MY3ly5EtvuhQpi+2NRj0qi26Zu2X9SyVghUVmsqVhTWM8NGyEvz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224698; c=relaxed/simple;
	bh=OEmvhQ0KlX51Ptp6MuDboCSbHJqF31wZJl/PUK5HrWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfdukZ+FiqHN2sCHdsO+be09x4JppCW49Yjkds0/qSQXfIr23TPups1wC6AM9LXVxLBYsOXoWDeYqBPjLzBa3qEoDqmZ0hndrbgfaceWUpBzLfvtKlANep7LW/8N4YgiJoFgEqKB3SRiRsggxsNvTO04abfhvLVoNq7B2LfPyX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJHDZm51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJHDZm51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0EA1F000FF;
	Sat, 12 Sep 2026 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224696;
	bh=tWotEFHynzDV10ow/zytyQ6E6vc3OXrWBqeMlXRccEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJHDZm51XMLlSRYwI2+veLmxyVBcJLQkOv24uSqEhI6/R0yFhdslKwjBLipWwvRYA
	 5LNo5n9S0jPhB6iGusQ/zZTqD5fWVlFRWeuLFWQAzNnquJb/MlX+xUR+XR29EfEqQu
	 eJXFPokPjQFD0Vr2hm48TWMBcY08lRZ0ycQL+bOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1003/1424] iommu/arm-smmu-v3: Convert to use atomic poll timeout
Date: Sat, 12 Sep 2026 08:57:15 +0200
Message-ID: <20260912065629.774701686@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bb7365b432198..70e5d7cda0c98 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3128,8 +3128,9 @@ static int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
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



