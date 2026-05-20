Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED53F6C4E;
	Wed, 20 May 2026 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297947; cv=none; b=rB4r7mQ9UIJILcI9YwiC/9BeSrj+VkdP8f1jtN6rUAlpVzNv4+Ol9IjgEqYf6DTviNFmLM+jKmuL5XSYy2jnfRc4Q78T57zyE2U+buHUIftvlEvjqQJEeeljKYBruDq+rn8qdVVzcAsUS27Q/n+pUG2OwQy1UDORPZAcduhkb48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297947; c=relaxed/simple;
	bh=QAQCnOIEnhKBZGaBFZKRHRusEN2r2uk1OFGN1kDbz+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrIeTsS7oYq2kvc8L3/nrEZMlquTm7EXm8p6XzHHG33iDr6nPRMWSPJudW1Bi0fGap0uNu0gQb9TnnfRO3mQVDmtE6MVSbGwW5GKSuWfNmV12X58rO66qhw7gXcVhP7XK2jcwDx6zt2kEZcgs3vBn6B2qqJkLhmbx0yWsWmRP/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMWxrWsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMWxrWsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBF1F000E9;
	Wed, 20 May 2026 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297946;
	bh=XU/bS2/s1+TzdwqGJ0uV83Zs22iICnKEjMRGLdVUUaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMWxrWsdiF34s299v7K2/xJA34iPG22ihh4hTKYmlEP049O3pVJNXZDEs3dKQSk+w
	 aOgBBAYbyW4lQFNV//hqvy1hHQu7d4n9suvijBPKD7l4B7Ri2+5f4nRG3f4W6NDctW
	 CMCzzD360NLQtUSsy9dW4lWwiKFp+FPJc2MwJM+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 225/957] iommu/riscv: Stop polling when CQCSR reports an error
Date: Wed, 20 May 2026 18:11:48 +0200
Message-ID: <20260520162139.420678207@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c183818015813..1e8007a153c32 100644
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



