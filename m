Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CBA436BF8;
	Thu, 30 Jul 2026 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425759; cv=none; b=h7YlvUGXPUMIqqFFe/juc5Si7H56qZgOnVCfhpe0oYEmdsdr+KuC2GMFDuDlrdsuiYh4BEYz5xhsc4yAhz6c4BL03iCHcf9AhGcv/d0QAo8Jdc5pE3l7HkMLJA9ECOuPCMz418FgEP7x8smpN/U0lSfZaRQGYN1bX+YoMxXWFzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425759; c=relaxed/simple;
	bh=EeE/zcWZFFORSyFN1ssMbUXRmY+r7kfZ0GLzEaPf8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+1P22nuTFs6/QspnnBdq2XYl0lF+WWs7r0uqkcYXwQUCOVBM8sn5p2qWQdO3ubiNbaXix10l7v8JZZYoN/vB/83uKcW17VA5taOZHOG6ZjBg84Q997dsBjocCjhpFbpzMnln483diU+Y8Cujgu1qvqw+7UqkMTcVx5mxaQkTWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U2IwgCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U2IwgCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268B41F000E9;
	Thu, 30 Jul 2026 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425757;
	bh=NzDHL8LkpKtncEjbzATKT41WfAa/g6rJ/7FhzNUc2Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0U2IwgCI83oadyVbtktnG8YDU/rgmhQv/8MMqNYgYIbRlfRtgOXbHf0WN1DTecyPD
	 HJD0e4oxv0+lrtA0Fe9U1PDEiFzDqyUFNhySfwCcsMiWIXUc0heckzk4Mb2/NvL6lH
	 QW2bPHNF0DszL2plFkYl+TTnR4jUlON9JLetNprE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/602] iommu/amd: Wait for completion instead of returning early in iommu_completion_wait()
Date: Thu, 30 Jul 2026 16:09:31 +0200
Message-ID: <20260730141439.727181677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 1e75a8255f11c81fb07e81e5029cfd75804350a0 ]

need_sync is a per-IOMMU flag shared by all domains and devices behind
that IOMMU. It is set whenever a command is queued with sync == true and
cleared when a completion-wait (CWAIT) command is queued. However, a
cleared need_sync only means that a covering CWAIT has been queued, not
that all previously queued commands have actually completed in hardware.

iommu_completion_wait() read need_sync locklessly and returned early
when it was false. This breaks the "block until all previously queued
commands have completed" contract in a multi-CPU scenario:

  CPU2: queue inv-B                  => need_sync = true
  CPU1: queue CWAIT(N); need_sync = false; then wait_on_sem(N)
  CPU2: read need_sync == false      => return 0 (no wait!)

CPU2 returns without waiting for any sequence number even though its
inv-B may not have completed yet (CWAIT(N), queued after inv-B, has not
been signaled). CPU2 then proceeds to, for example, free page-table
pages while the IOMMU can still walk stale translations, opening a
use-after-free window. This is a logical race in the meaning of the
flag, not a memory-visibility issue, so barriers alone do not help.

Fix it without losing the optimization of avoiding redundant CWAIT
commands: take iommu->lock before testing need_sync, and when it is
false do not return early but wait for the last allocated sequence
number (cmd_sem_val). Since need_sync == false implies no sync command
was queued after the last CWAIT, that CWAIT is FIFO-ordered after every
not-yet-completed command, so waiting for its sequence number guarantees
all prior commands (possibly queued by another CPU) have completed. The
common path with pending work is unchanged and no extra hardware command
is issued.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Fixes: 815b33fdc279 ("x86/amd-iommu: Cleanup completion-wait handling")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b4052fa9cc76bc..3f109a99a9e401 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1424,11 +1424,23 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	int ret;
 	u64 data;
 
-	if (!iommu->need_sync)
-		return 0;
-
 	raw_spin_lock_irqsave(&iommu->lock, flags);
 
+	if (!iommu->need_sync) {
+		/*
+		 * No command has been queued since the last completion-wait.
+		 * A concurrent CPU may have already queued that CWAIT and
+		 * cleared need_sync; need_sync == false only means a covering
+		 * CWAIT is queued, not that all prior commands have completed.
+		 * Wait for the last allocated sequence number so that any
+		 * command queued before this call (possibly on another CPU)
+		 * is guaranteed to have completed before returning.
+		 */
+		data = iommu->cmd_sem_val;
+		raw_spin_unlock_irqrestore(&iommu->lock, flags);
+		return wait_on_sem(iommu, data);
+	}
+
 	data = get_cmdsem_val(iommu);
 	build_completion_wait(&cmd, iommu, data);
 
@@ -1438,9 +1450,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (ret)
 		return ret;
 
-	ret = wait_on_sem(iommu, data);
-
-	return ret;
+	return wait_on_sem(iommu, data);
 }
 
 static void domain_flush_complete(struct protection_domain *domain)
-- 
2.53.0



