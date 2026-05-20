Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15387317160;
	Wed, 20 May 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295107; cv=none; b=UJMJz90RbtFyPeZp6Rz6VxmKXpNjgeWP1rO80o8fqbyItYykt8hhxRcDS+Zmia2q3fMVpHoPWJ1KwdzFHbH/xxNirs17Vemz3jE5Klmwb0JqppJFZS1hobVGjHkMQqFLAFkHOUBacbl/NOM9p+da+IMN/ZbbH4kRRz4Sw6fWml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295107; c=relaxed/simple;
	bh=RKGWQFSrXasYV8T/PeUUM0H6jfG1L2HFLre5jV+kq4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSM/RMueUhXcoSDkEx9LBq9635/1exKd8Tj5wn33hoeiMIAIk4yltJecoxzqmLVsI8Fd1TYLSlGlfHZGdHB39/YwMcm95QQ82f6Vt+D7QkfuVaYkqhBTpwnQssOBsv8gD4bhxt4Zh92NtGzrxWkj18RzHsOT33jf3csW/j2NB04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrBYkWFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrBYkWFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9E71F000E9;
	Wed, 20 May 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295106;
	bh=Npz8cKLFK4NZioD+Ob+imlYxjXtk5lg24cs1XKAG914=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrBYkWFEyunT5N6uZ0oN7C5Ijlr3YVbC/Ejw+MJkfau8Pny7gtLn8gpug4TwYxNH0
	 Gkpz23sN0tpUHnU+eq8Q6i0E2XJb6vcrHnO8PPcSxwJ9q/LQXmCA4hVnuec0KoqdQV
	 drIixtYCb0pgP6SqKXHBedRsM9e+Qp2B7WFoXVFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0292/1146] iommu/riscv: Stop polling when CQCSR reports an error
Date: Wed, 20 May 2026 18:09:02 +0200
Message-ID: <20260520162154.824221541@linuxfoundation.org>
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

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit b2e5684558edf3e9bbe18d0e0043854994eab1be ]

The cmdq wait loop busy-polls the consumer index until it advances
or the software timeout expires. If the IOMMU has already signaled
a command queue failure in CQCSR, continuing to poll for progress is
pointless.

Make riscv_iommu_queue_wait() also terminate the poll when any of these
CQCSR error bits are observed.

This helps the caller return earlier in failure cases and avoids
spinning until the full timeout interval when the hardware has already
reported an error. On single-core systems in particular, the current
busy-wait can delay servicing the command-timeout interrupt until the
software timeout expires (90s by default).

Fixes: 856c0cfe5c5f ("iommu/riscv: Command and fault queue support")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index aadfbc181138f..6ac7e3edef8aa 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -368,6 +368,8 @@ static int riscv_iommu_queue_wait(struct riscv_iommu_queue *queue,
 				  unsigned int timeout_us)
 {
 	unsigned int cons = atomic_read(&queue->head);
+	unsigned int flags = RISCV_IOMMU_CQCSR_CQMF | RISCV_IOMMU_CQCSR_CMD_TO |
+			     RISCV_IOMMU_CQCSR_CMD_ILL;
 
 	/* Already processed by the consumer */
 	if ((int)(cons - index) > 0)
@@ -375,6 +377,7 @@ static int riscv_iommu_queue_wait(struct riscv_iommu_queue *queue,
 
 	/* Monitor consumer index */
 	return readx_poll_timeout(riscv_iommu_queue_cons, queue, cons,
+				 (riscv_iommu_readl(queue->iommu, queue->qcr) & flags) ||
 				 (int)(cons - index) > 0, 0, timeout_us);
 }
 
-- 
2.53.0



