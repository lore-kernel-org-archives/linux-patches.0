Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048797;
	b=mH0AMGg5GCNuw2k0vQBAE6DjvJ9nlsJ8GWvoOaFK81AQvCKbl6RPtr0hrithn3OqDcqN
	 e6AmW9gDvq2Ocwst3bpUTibadbRDN6FZ4PEVEhWkc/bGYlUbXbiP2IJFhd0nmSIEqvqqc
	 tSrjFdN8MfNNG2JNdnOBorZi6qSiiPxh0iiQEKlGpNtLB8iz1uAI3OPw6+q7G7cQ+L1DJ
	 XzD83zsHuqYY7UBbBF/aZf5V5JKlBCciXPJDYYFWrh0Z1dV81wri+6hmjUwCGs2ilegwk
	 OoJD9yzJrfQT+gGTdUldGC+7LhyQWX89YK/vjP0907Tr4zOPXrwuX+KoPqcohfAl1Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/S4E3WV0maCSyB1/RXVnL0L5qJaL+U1PoFca2q5uO8M=;
	b=a2y9BfaTOM260QefWqiZavkW0QiGy0whPrDE/YVf/RMvZSXo7UrJpRCORPtsTwlaPgAn
	 941AdFnG+YXMDB+0Q9FTbXU3YKryAN8ubM4WMJ2JXwoTmxTF34ymkQyuRWYQ+CfYhBlTx
	 jxvbmrMDQyFK16ieAdiLmSABBinrnAGK4IdMd2xO/sNxZ66Cd06SuvGCJ5xMO7Mc/QSpc
	 W4isJSj73PlGL4ybOYcPDihV4Aef5kMBwEZ0h7Tf3xXOBNpbLMpLxxnuSq08evJOD/ylM
	 9t39FF8nzYckrtEgUfADuCMRLwMCbF39KaL/DH6NnDT+A3omUDVkEE5gb6VPBkO8s+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6XVJGT8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F277606A32A;
	Thu, 19 Nov 2026 00:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6XVJGT8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC13F1F000C4;
	Thu, 19 Nov 2026 00:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048797;
	bh=/S4E3WV0maCSyB1/RXVnL0L5qJaL+U1PoFca2q5uO8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6XVJGT8zKFCHR86bgYlq2IVDZGLfKWcZcJNtdbYhv4zW8IKSFsiItxZ5YG6BSt6a
	 R+hZVT+DIp76OBUoRuNN/C9bBH2e1lGtZdFlcV3zZBUzUBiSDV5tDmPYZeHY+qskqC
	 6NePSsgkswMp+sYEnyeBrN4nOqjox8fU3vob4Lbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2082/2857] iommu/vt-d: Fix IQE handling to cover all descriptors in submission range
Date: Wed, 18 Nov 2026 15:51:56 +0100
Message-ID: <20261118150316.372025990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 754d07b940c4ce025fab022b548fb5c3d11bf766 ]

When an Invalidation Queue Error (IQE) occurs, hardware halts fetching
and IQH points at the faulting descriptor. The previous code only
checked whether IQH matched the first descriptor index of the current
submission, missing faults on any other descriptor within the batch.

Expand the check to cover the entire submission range [index, wait_index],
accounting for circular wrap-around.

Furthermore, after detecting IQE, the old recovery only replaced the
single faulting slot with a copy of the wait descriptor and immediately
returned -EINVAL. This left two problems:

  a) Hardware resumed fetching and could hit another invalid descriptor
     in the same abandoned batch, raising a second IQE that no submitter
     would claim — permanently deadlocking the queue.

  b) The caller reclaimed all batch slots (QI_FREE) while hardware might
     still be asynchronously processing descriptors from that batch,
     allowing concurrent overwrite and descriptor corruption.

Fix both by introducing qi_drain_remaining_descs(): upon IQE detection,
overwrite the stranded slots in [IQH, wait_index) with fenced no-op wait
descriptors, resubmit the wait descriptor at wait_index, clear IQE, and
spin until hardware signals QI_DONE (with DMAR_OPERATION_TIMEOUT). This
guarantees hardware has fully drained the batch before the caller
reclaims slots.

Fixes: 8a1d82462540 ("iommu/vt-d: Multiple descriptors per qi_submit_sync()")
Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 72 ++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 1d330852fb0bb..5df4cf097bd8c 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1256,6 +1256,49 @@ static void qi_dump_fault(struct intel_iommu *iommu, u32 fault)
 	       (unsigned long long)desc->qw1);
 }
 
+static int qi_drain_remaining_descs(struct intel_iommu *iommu, int head,
+				    int wait_index)
+{
+	struct q_inval *qi = iommu->qi;
+	int shift = qi_shift(iommu);
+	struct qi_desc wait_desc = {};
+	struct qi_desc nop_desc = {};
+	cycles_t start;
+
+	nop_desc.qw0 = QI_IWD_FENCE | QI_IWD_TYPE;
+
+	wait_desc.qw0 = QI_IWD_STATUS_DATA(QI_DONE) | QI_IWD_PRQ_DRAIN |
+			QI_IWD_STATUS_WRITE | QI_IWD_FENCE | QI_IWD_TYPE;
+	wait_desc.qw1 = virt_to_phys(&qi->desc_status[wait_index]);
+
+	while (head != wait_index) {
+		memcpy(qi->desc + (head << shift), &nop_desc, 1 << shift);
+		head = (head + 1) % QI_LENGTH;
+	}
+
+	WRITE_ONCE(qi->desc_status[wait_index], QI_IN_USE);
+	memcpy(qi->desc + (wait_index << shift), &wait_desc, 1 << shift);
+
+	/*
+	 * Order the descriptor rewrites before the writel() that restarts
+	 * the fetch engine.
+	 */
+	wmb();
+
+	writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+
+	start = get_cycles();
+	while (READ_ONCE(qi->desc_status[wait_index]) != QI_DONE) {
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start)) {
+			pr_err("Timeout draining invalidation queue after IQE\n");
+			return -ETIMEDOUT;
+		}
+		cpu_relax();
+	}
+
+	return 0;
+}
+
 static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 {
 	u32 fault;
@@ -1276,18 +1319,25 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 	 * is cleared.
 	 */
 	if (fault & DMA_FSTS_IQE) {
+		int head_idx, ret;
+
 		head = readl(iommu->reg + DMAR_IQH_REG);
-		if ((head >> shift) == index) {
-			struct qi_desc *desc = qi->desc + head;
-
-			/*
-			 * desc->qw2 and desc->qw3 are either reserved or
-			 * used by software as private data. We won't print
-			 * out these two qw's for security consideration.
-			 */
-			memcpy(desc, qi->desc + (wait_index << shift),
-			       1 << shift);
-			writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+		head_idx = (head >> shift) % QI_LENGTH;
+
+		/*
+		 * The faulting descriptor can be anywhere within the current
+		 * submission's range [index, wait_index]. Since the queue is
+		 * circular, this submission may wrap around QI_LENGTH
+		 * (index > wait_index in that case), so check both the
+		 * non-wrapped and wrapped cases of the range.
+		 */
+		if (index <= wait_index ?
+		    (head_idx >= index && head_idx <= wait_index) :
+		    (head_idx >= index || head_idx <= wait_index)) {
+			ret = qi_drain_remaining_descs(iommu, head_idx, wait_index);
+			if (ret)
+				return ret;
+
 			pr_info("Invalidation Queue Error (IQE) cleared\n");
 			return -EINVAL;
 		}
-- 
2.53.0



