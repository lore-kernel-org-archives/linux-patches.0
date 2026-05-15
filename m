Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3F3FD965;
	Fri, 15 May 2026 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861117; cv=none; b=YjhYvreflhErX29aLqJFQ1SxKelGV9aV80J24eLUsSfItADFP7jCLSmqDC7lVHuw39v1zg3J9PwTad4Q6+fi1zPJF3qlZEoajIfUc/BTkNzR22CZv571A3Ov84eTHcoCD6yCMPaNBydWK9r8AM1P8PBSSs1hKEzqKVpDU1REjd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861117; c=relaxed/simple;
	bh=9DUedQb6aDjnRrx58knWGf7NoIOO/cI5uReMozDeSCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2FtkGm8wObjDcEJF0yy3Ifw8szxCEmrhpsExUMfmSrJf4ncf/FchPtu9aNBVU4/f5/dCna3VXlQ6w95YzqKwlbrUf4NIMolk8abJEuKE8INs3vMx7y2TCG/s/5jk5YTl7ZbQVXwgO3RkknIuyhk+4vaZcPEJI9+ZYJyY6Q9P9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgHHwlQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgHHwlQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8BEC2BCB0;
	Fri, 15 May 2026 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861117;
	bh=9DUedQb6aDjnRrx58knWGf7NoIOO/cI5uReMozDeSCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgHHwlQqhwXHS3N7pqY8vmxFk+BhaEqBoQs++j5qRcTgSD1NfRPcTZz8xjNbjOvwe
	 bSi8mP+XCGN3WU50FCUGCNxUZErpVtdgS2TtkkzwkUSHZLID9LpVZi97zjUsBGWFQr
	 DDfLlPpT1oN/iOgWyap2NPp96vo2N+T5bCY514C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikanth Aithal <sraithal@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/474] iommu/amd: serialize sequence allocation under concurrent TLB invalidations
Date: Fri, 15 May 2026 17:44:33 +0200
Message-ID: <20260515154718.573403214@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Ankit Soni <Ankit.Soni@amd.com>

commit 9e249c48412828e807afddc21527eb734dc9bd3d upstream.

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
[Salvatore Bonaccorso: Backport to v6.12.y where f32fe7cb0198
("iommu/amd: Add support to remap/unmap IOMMU buffers for kdump") is not
present]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h |  2 +-
 drivers/iommu/amd/init.c            |  2 +-
 drivers/iommu/amd/iommu.c           | 18 ++++++++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index d872054b874fa..2571a782b7b61 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -765,7 +765,7 @@ struct amd_iommu {
 
 	u32 flags;
 	volatile u64 *cmd_sem;
-	atomic64_t cmd_sem_val;
+	u64 cmd_sem_val;
 
 #ifdef CONFIG_AMD_IOMMU_DEBUGFS
 	/* DebugFS Info */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 6261bc7304e97..e5fee1aae587b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1805,7 +1805,7 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
 	iommu->pci_seg = pci_seg;
 
 	raw_spin_lock_init(&iommu->lock);
-	atomic64_set(&iommu->cmd_sem_val, 0);
+	iommu->cmd_sem_val = 0;
 
 	/* Add IOMMU to internal data structures */
 	list_add_tail(&iommu->list, &amd_iommu_list);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 6d0d28050052a..48cf9e9e15976 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1195,6 +1195,12 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
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
@@ -1209,11 +1215,11 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
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
 
@@ -2877,10 +2883,11 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
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
@@ -2894,7 +2901,6 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 
 out_err:
 	raw_spin_unlock_irqrestore(&iommu->lock, flags);
-	return;
 }
 
 static void set_dte_irq_entry(struct amd_iommu *iommu, u16 devid,
-- 
2.53.0



