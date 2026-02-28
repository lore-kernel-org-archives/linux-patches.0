Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F7233F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301219; cv=none; b=qz3smZd4GFKVyA1VsPNWTbONYvnXMUEm1PYoPIilE6oaumudoT1NblNFPfv0YycOqj3MuNWpuVM38ghQlTkAnDP4Qvdo9JKc/SNvIXPbOsMpR0CRQB+jZqo6ZKoE4RqwsaDM/7/0C4sOsKTurRSQpFDUhqe7RcUy9rBhVW4TOUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301219; c=relaxed/simple;
	bh=S/ufkfKndE1lpRAhzFu7Mh9CvfodgAG6rXN3XCUlDeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMH7GLycZM6LBqjmAEmTej7hDTlOWt2wtljlltx33GlQ7hKxGhp7JcMuNv8xTqzgg/mxmbLMI96huvr74UIcH6zIBwv3hh8AhYO6YUcNUrdaRZWtEOCUxojKbMTs45MbcAKbznozy+auczirPQXH63eP/yPLuNadOW2sIco/LEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xxpa7S1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xxpa7S1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F8DC116D0;
	Sat, 28 Feb 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301219;
	bh=S/ufkfKndE1lpRAhzFu7Mh9CvfodgAG6rXN3XCUlDeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xxpa7S1Mfp36mMrqO5B+/CENWGGHHV1eMxfmnlKrdpbKTd38P/83gR4noSrIZib4R
	 e3PmcYsvAoQ4H2lHpC2Y/pH1HF1hu3BfxxUk4J0XZwidmMX+oPpOofSXLdJwOAa+Ht
	 r4CQiFti5uhR1SFM0tQh1BmEV6A7IUeH8PA853lZ8NLUJKwT0MqtpCr1WqFo2TgmSA
	 7TuLfaRzv4i2A0Wu0eHtjBLGw7xnBvrwe1h1w6jGUlgT4f5IGXGwqkZGOl8jTVTbnZ
	 0yIqBRXkrfFK/a5HqFOo8ms9LGfViLTC/N4seJee9Nhhf5rWBnonKHM5+d8Ra48+8V
	 OAVbmbkZBtvOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ankit Soni <Ankit.Soni@amd.com>,
	Srikanth Aithal <sraithal@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/752] iommu/amd: serialize sequence allocation under concurrent TLB invalidations
Date: Sat, 28 Feb 2026 12:41:47 -0500
Message-ID: <20260228174750.1542406-396-sashal@kernel.org>
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

[ Upstream commit 9e249c48412828e807afddc21527eb734dc9bd3d ]

With concurrent TLB invalidations, completion wait randomly gets timed out
because cmd_sem_val was incremented outside the IOMMU spinlock, allowing
CMD_COMPL_WAIT commands to be queued out of sequence and breaking the
ordering assumption in wait_on_sem().
Move the cmd_sem_val increment under iommu->lock so completion sequence
allocation is serialized with command queuing.
And remove the unnecessary return.

Fixes: d2a0cac10597 ("iommu/amd: move wait_on_sem() out of spinlock")

Tested-by: Srikanth Aithal <sraithal@amd.com>
Reported-by: Srikanth Aithal <sraithal@amd.com>
Signed-off-by: Ankit Soni <Ankit.Soni@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h |  2 +-
 drivers/iommu/amd/init.c            |  2 +-
 drivers/iommu/amd/iommu.c           | 18 ++++++++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index a698a2e7ce2a6..b0d919cd1a8fb 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -791,7 +791,7 @@ struct amd_iommu {
 
 	u32 flags;
 	volatile u64 *cmd_sem;
-	atomic64_t cmd_sem_val;
+	u64 cmd_sem_val;
 	/*
 	 * Track physical address to directly use it in build_completion_wait()
 	 * and avoid adding any special checks and handling for kdump.
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 53afb1cb0a6fc..76efd74124b33 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1879,7 +1879,7 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
 	iommu->pci_seg = pci_seg;
 
 	raw_spin_lock_init(&iommu->lock);
-	atomic64_set(&iommu->cmd_sem_val, 0);
+	iommu->cmd_sem_val = 0;
 
 	/* Add IOMMU to internal data structures */
 	list_add_tail(&iommu->list, &amd_iommu_list);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3f2b687947dba..4beef73139611 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1386,6 +1386,12 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 	return iommu_queue_command_sync(iommu, cmd, true);
 }
 
+static u64 get_cmdsem_val(struct amd_iommu *iommu)
+{
+	lockdep_assert_held(&iommu->lock);
+	return ++iommu->cmd_sem_val;
+}
+
 /*
  * This function queues a completion wait command into the command
  * buffer of an IOMMU
@@ -1400,11 +1406,11 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (!iommu->need_sync)
 		return 0;
 
-	data = atomic64_inc_return(&iommu->cmd_sem_val);
-	build_completion_wait(&cmd, iommu, data);
-
 	raw_spin_lock_irqsave(&iommu->lock, flags);
 
+	data = get_cmdsem_val(iommu);
+	build_completion_wait(&cmd, iommu, data);
+
 	ret = __iommu_queue_command_sync(iommu, &cmd, false);
 	raw_spin_unlock_irqrestore(&iommu->lock, flags);
 
@@ -3086,10 +3092,11 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 		return;
 
 	build_inv_irt(&cmd, devid);
-	data = atomic64_inc_return(&iommu->cmd_sem_val);
-	build_completion_wait(&cmd2, iommu, data);
 
 	raw_spin_lock_irqsave(&iommu->lock, flags);
+	data = get_cmdsem_val(iommu);
+	build_completion_wait(&cmd2, iommu, data);
+
 	ret = __iommu_queue_command_sync(iommu, &cmd, true);
 	if (ret)
 		goto out_err;
@@ -3103,7 +3110,6 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 
 out_err:
 	raw_spin_unlock_irqrestore(&iommu->lock, flags);
-	return;
 }
 
 static inline u8 iommu_get_int_tablen(struct iommu_dev_data *dev_data)
-- 
2.51.0

