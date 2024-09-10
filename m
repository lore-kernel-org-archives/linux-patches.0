Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA6119068E;
	Tue, 10 Sep 2024 10:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964320; cv=none; b=FrPgyF920s20GyBs0fd686d92Ezoj77TLd4n7PgYm31Gf2o3UmaFg3VlqFSERVkOC39yooWJQwZLpWVGO1nkmzrQoDNEZjkX6TLd/xsAkoUhtutb61rlTTRTN+d4UxJut1rN0XP6P0OnXs0o28mQ8hvcFvIUk1cyIyMCN01RUw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964320; c=relaxed/simple;
	bh=mFFshYL3NTitb6Ej9eISvbAzfD+a9z2QfdgKHMpMu64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH7vsuS9QSQS3TE9kg74I2JnnAUTip14pthlcgFegokl6ECOjprL4JHtKuC/l4ez/kdVZEs434XKfbEFc/ie1GVR8buw2oyUJkopwzHa7xy6+XkOsJfWGpmrqlKVWtk/Cz/SE9S/753qAEfYjwAGLGnDmWDh1TxZDhtDGEvjskk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwv6yRc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwv6yRc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A3CC4CEC3;
	Tue, 10 Sep 2024 10:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964320;
	bh=mFFshYL3NTitb6Ej9eISvbAzfD+a9z2QfdgKHMpMu64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwv6yRc0/0gXf+Dm2FOP2ClTu0VtNxxwltvlcya5tPwdkh+eFzqSkE25pHRRk09XW
	 Ia+Sh5/9YPAAp8rophKFBDd46h5gzqwgGUZFY41KZiYMKacs7VEqL+6i+xPFh2cdAr
	 S3GRJ9EIOuFIgaV8bNOYg4ANXDTgmFk+FJndIhkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 142/269] iommu/vt-d: Handle volatile descriptor status read
Date: Tue, 10 Sep 2024 11:32:09 +0200
Message-ID: <20240910092613.268656017@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

[ Upstream commit b5e86a95541cea737394a1da967df4cd4d8f7182 ]

Queued invalidation wait descriptor status is volatile in that IOMMU
hardware writes the data upon completion.

Use READ_ONCE() to prevent compiler optimizations which ensures memory
reads every time. As a side effect, READ_ONCE() also enforces strict
types and may add an extra instruction. But it should not have negative
performance impact since we use cpu_relax anyway and the extra time(by
adding an instruction) may allow IOMMU HW request cacheline ownership
easier.

e.g. gcc 12.3
BEFORE:
	81 38 ad de 00 00       cmpl   $0x2,(%rax)

AFTER (with READ_ONCE())
    772f:       8b 00                   mov    (%rax),%eax
    7731:       3d ad de 00 00          cmp    $0x2,%eax
                                        //status data is 32 bit

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Link: https://lore.kernel.org/r/20240607173817.3914600-1-jacob.jun.pan@linux.intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20240702130839.108139-2-baolu.lu@linux.intel.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 23cb80d62a9a..84f0459e503c 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1422,7 +1422,7 @@ int qi_submit_sync(struct intel_iommu *iommu, struct qi_desc *desc,
 	 */
 	writel(qi->free_head << shift, iommu->reg + DMAR_IQT_REG);
 
-	while (qi->desc_status[wait_index] != QI_DONE) {
+	while (READ_ONCE(qi->desc_status[wait_index]) != QI_DONE) {
 		/*
 		 * We will leave the interrupts disabled, to prevent interrupt
 		 * context to queue another cmd while a cmd is already submitted
-- 
2.43.0



