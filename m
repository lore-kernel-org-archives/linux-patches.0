Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF0C340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301083; cv=none; b=PAxKM1YhJYm2kvKmvfPtt/jUtJCK67yns+hWeYbzESGXNHziW9oK+m9hs8STpMYfeWMS4EqLvGXO6OLFmWamInj+BcGUTqMFDlVMnxS+oxFdPZYKfxrEze8T+dl2mjWQHSDN62ULKuyphRyn9pChgfsglAL/uuccdeokz252CIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301083; c=relaxed/simple;
	bh=km1en+wOnA7APhxYghhhsiMKa2l+LIQ27jLaH88HG0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7r4EGvgg3s3zPnrcRQAJF6b8DIKhNl6MFbxBjV7e4P5Hdvrw0jpl3uSd5fJoR511Zy0BzZRbXYL5vjaaQjNOkASVWs7ogYonGdjYFE3srz+clZVXlCU1sy3TtcBMQF1WyYhijkbut+BU33YLzzBSSzfpp2G567KgKlC8jsTL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntVMttTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntVMttTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A947DC19424;
	Sat, 28 Feb 2026 17:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301083;
	bh=km1en+wOnA7APhxYghhhsiMKa2l+LIQ27jLaH88HG0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntVMttTwE37EAXHDItkigdJ0IYQt8645YBvqQx4apBnnn1eXCocEeV0exXNeNKP1P
	 RIi9GNJfqGxQMJtdQXiCKO6cgqv570nCadwU6vJx8FU7+QfRZmWqitq50Pkeb2uXqk
	 JmAwdjldp9975mZlB7rkyB/vAAuPO6aoMtRZ+e6kGO/kF/yHeeBZkL8+HSsBEVrK0U
	 tlVcc6tg/+GCwyb/bzbWupq5SQlQeMIlFfgFOVS3I+N3q4ndW/VA3bq4VzsnLVB7Yh
	 gAS+1lszNv5kvRrXx/YCoP82rZMBIqXyfs1cGMX3yqKyz3/36+9xMAvKNNMQMJk4wa
	 Rn9gv2iQDwNzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/752] iommu/amd: move wait_on_sem() out of spinlock
Date: Sat, 28 Feb 2026 12:39:02 -0500
Message-ID: <20260228174750.1542406-231-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ankit Soni <Ankit.Soni@amd.com>

[ Upstream commit d2a0cac10597068567d336e85fa3cbdbe8ca62bf ]

With iommu.strict=1, the existing completion wait path can cause soft
lockups under stressed environment, as wait_on_sem() busy-waits under the
spinlock with interrupts disabled.

Move the completion wait in iommu_completion_wait() out of the spinlock.
wait_on_sem() only polls the hardware-updated cmd_sem and does not require
iommu->lock, so holding the lock during the busy wait unnecessarily
increases contention and extends the time with interrupts disabled.

Signed-off-by: Ankit Soni <Ankit.Soni@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 30dd482fe0953..3f2b687947dba 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1156,7 +1156,12 @@ static int wait_on_sem(struct amd_iommu *iommu, u64 data)
 {
 	int i = 0;
 
-	while (*iommu->cmd_sem != data && i < LOOP_TIMEOUT) {
+	/*
+	 * cmd_sem holds a monotonically non-decreasing completion sequence
+	 * number.
+	 */
+	while ((__s64)(READ_ONCE(*iommu->cmd_sem) - data) < 0 &&
+	       i < LOOP_TIMEOUT) {
 		udelay(1);
 		i += 1;
 	}
@@ -1401,14 +1406,13 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	raw_spin_lock_irqsave(&iommu->lock, flags);
 
 	ret = __iommu_queue_command_sync(iommu, &cmd, false);
+	raw_spin_unlock_irqrestore(&iommu->lock, flags);
+
 	if (ret)
-		goto out_unlock;
+		return ret;
 
 	ret = wait_on_sem(iommu, data);
 
-out_unlock:
-	raw_spin_unlock_irqrestore(&iommu->lock, flags);
-
 	return ret;
 }
 
@@ -3088,13 +3092,18 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 	raw_spin_lock_irqsave(&iommu->lock, flags);
 	ret = __iommu_queue_command_sync(iommu, &cmd, true);
 	if (ret)
-		goto out;
+		goto out_err;
 	ret = __iommu_queue_command_sync(iommu, &cmd2, false);
 	if (ret)
-		goto out;
+		goto out_err;
+	raw_spin_unlock_irqrestore(&iommu->lock, flags);
+
 	wait_on_sem(iommu, data);
-out:
+	return;
+
+out_err:
 	raw_spin_unlock_irqrestore(&iommu->lock, flags);
+	return;
 }
 
 static inline u8 iommu_get_int_tablen(struct iommu_dev_data *dev_data)
-- 
2.51.0

