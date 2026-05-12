Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D04385D85;
	Tue, 12 May 2026 17:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607859; cv=none; b=hwH5/XSqBD+dp8yBDwEHjaQcNP3PxwiD7ywqyX68l5WEPEfIOgXFtEC+cDqx0yzmZsEw/NCeYff+8Lbvxe16FDJGT1pNKWKqbeGF1E5Dfr4ssq2tJ8YA0ylgSAk8GJGkGFrs5XNr16ThkaYBay9ploG/V946O+wyU8OuP17OiHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607859; c=relaxed/simple;
	bh=58ML7axCbbrg36w9k1r+PCJ5XqPGH/gynbHcQL0niSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5ePB22ezVrLgQNo0IkleYeXWKJS83n/AwiqW0rXCsZBlQgTHOzS1tihA7h0eCsfYYOC0VA2TPpvqMThz55sVBRzdaa/UrdYaM4w5QS4KJn8rwzxqMjs3WItkYJfcEWJJQrF3KTOw0pFl+/mAi0Bw6WUbL9ju3c3R3xeKFAvwdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TvIxrSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TvIxrSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F12C2BCB0;
	Tue, 12 May 2026 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607859;
	bh=58ML7axCbbrg36w9k1r+PCJ5XqPGH/gynbHcQL0niSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TvIxrSwacv1mQFYpMcBrYf9VdYFgJw61buyvbousSCjikntNJ0lIwwpnOhf+DrFE
	 dE3CO1jVsbw5C3Mee134StcG3Ey9KDZSVWK04rZxCYukRmMiwJPNZQmrvoVUoYpsLo
	 t2S7N/PNLXVL1zxiQ58Y93+Zk1w4Ft2htAgF6z/E=
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
Subject: [PATCH 6.12 019/206] iommu/amd: serialize sequence allocation under concurrent TLB invalidations
Date: Tue, 12 May 2026 19:37:51 +0200
Message-ID: <20260512173933.229702912@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a14ee649d3da3..df2aa1c4fafcf 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -781,7 +781,7 @@ struct amd_iommu {
 
 	u32 flags;
 	volatile u64 *cmd_sem;
-	atomic64_t cmd_sem_val;
+	u64 cmd_sem_val;
 
 #ifdef CONFIG_AMD_IOMMU_DEBUGFS
 	/* DebugFS Info */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e1816ae8699dd..78e9ceda2338f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1742,7 +1742,7 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h,
 	iommu->pci_seg = pci_seg;
 
 	raw_spin_lock_init(&iommu->lock);
-	atomic64_set(&iommu->cmd_sem_val, 0);
+	iommu->cmd_sem_val = 0;
 
 	/* Add IOMMU to internal data structures */
 	list_add_tail(&iommu->list, &amd_iommu_list);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 24e2de90ac2e4..d0e53a03eff02 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1252,6 +1252,12 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
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
@@ -1266,11 +1272,11 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
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
 
@@ -2929,10 +2935,11 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
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
@@ -2946,7 +2953,6 @@ static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 
 out_err:
 	raw_spin_unlock_irqrestore(&iommu->lock, flags);
-	return;
 }
 
 static void set_dte_irq_entry(struct amd_iommu *iommu, u16 devid,
-- 
2.53.0



