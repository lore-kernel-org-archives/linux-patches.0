Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055435;
	b=q8JZYBqFyEn+SnfKHmLSXcGyl/CKouk26WEsawAt/LTaVuoX6BSCefI7n8EyPRhmhFkm
	 w/HZjBy8jmYpcNS1xCPDMjMkNisyI9fnTtpg58qqmAtikKa/+EwWpk7GOByza6eXzKiow
	 +I9lUqP9iP+X3kpQyjIk3g5Alhw5lbYMcz6B4vIcEGc/plMBoB6WkLupuQz25n72zSgn2
	 DJAkHdPjq9/7bKTtltm/eUoFtdQEci60hZppEP4ydpqv4EQkezhdNnWiTZavRMS7V6FU1
	 n5e3IxdOhuo12P4+bb3POjOa2rPUkeB1yO1dQK05fbZyL0fE8QuhapwCvk2sg/QcaBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ICXFDJL+nWKPv/Xp3O91M4RsMSQKR9uO7PsQGFGaVAg=;
	b=HTbzGRLQumrUND/pEI8CpXZ1gHVHlrE/3/JRxB4c09E00EYWm59GfemljLtm5CrGrJ5T
	 BwMv49bk4rTNSKwQwWihqaH0lUWKKGR6wWi9aKDFvg71LQgT2ET4yawJJePCbI/9O8ad+
	 OuTj5LfrKZzZPNy+f/BdK6jCj2BTgDocjf6472RylGZCEfPaGbfPOgno5zdgu926lPJVS
	 do9sgukcGpyspwKRqgkawb0SJDCBi98tz5K0av+xGcEu9xQzYr8wW5z3Yy3UN2W29G6Av
	 4PczfV3qUI0oD7nAfrlkL+af+O4yWVi9V6ts+clPDfpulZahx3vm/spg+asMkd8i0LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xrrhAaa8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E53606A31C;
	Thu, 19 Nov 2026 02:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xrrhAaa8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCD41F000C4;
	Thu, 19 Nov 2026 02:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055434;
	bh=ICXFDJL+nWKPv/Xp3O91M4RsMSQKR9uO7PsQGFGaVAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrrhAaa8yCdFe28rxPDPzesbewbsju5lOAvD+Rskh4zkrr1ytHDNl1zcH7Y5ZXdGB
	 yyMFsLRGXK0dmEcSBSMuMWOFU2wPhOWj6z0K8jDoXAukkl6XiPeKywQ+pvZrKEJS9t
	 DPf5SAQfqXxbK1KbNF2C9DXvQ+EpwRULq1nKU8pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1629/2214] iommu/vt-d: Fix IQE handling to cover all descriptors in submission range
Date: Wed, 18 Nov 2026 15:55:05 +0100
Message-ID: <20261118150117.123404479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f0d34ba78b4a9..51ba4ebc643f0 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1261,6 +1261,49 @@ static void qi_dump_fault(struct intel_iommu *iommu, u32 fault)
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
@@ -1281,18 +1324,25 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
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



