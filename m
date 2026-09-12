Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B1C275AEB;
	Sat, 12 Sep 2026 10:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208575; cv=none; b=WDrdyEOlD2ouHTcli6txNnVH0tIcnpiSARVnEofV70H6sHXwZs/ifFOyQvxkF21Uvp4yhDCdgtKxbs48zBHYrFPQ3elZnfG0bfp1WrT9Z36pNM3kR08On/dre7vp+JNKGzS7QFLC9IGEI6MacbaoZodWxIdWZBIHhdwf+nUm61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208575; c=relaxed/simple;
	bh=vSQlXRlnFbz7FGBWnsTAnKw5dOpXUqe4nUKeVV5eqq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkpaQGMZYWmGnDH83Q/692xfyLKkHL5aRvVF7Q8mqI0n/S4uYOSOfW0kzg73nX7PV9mL7EpMnXoLmv1osesjMF0hDkVFmG//bGSODXU315W6qrZe2REKnL6IMJXZsTasHTFUDjakhOQbsO3jTFaRWGojYVfLjzfeAk8A3UnJ/xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRQvuDuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRQvuDuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E001F00898;
	Sat, 12 Sep 2026 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208574;
	bh=k9JWa6pHX+qMVKj/qh6ZGYv9o4k3nejJEl5QVqTHL1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRQvuDucjO3NS6tcmsFlHYubaxi1oED0dNMSSEAOoKJAhQqsqPTYMObyTucirJQWm
	 pva2e6hN+UFjlI3G1PjAoxUyFMQR0j204rP37wmHBwUeMl6IZTGmknOc3b8/6I27lZ
	 iBaWwQIKp3pnCuptVmsjksA+toj614/UrGw+Guck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0602/1518] iommu/tegra241-cmdqv: Synchronize the error ISR against VINTF (de)init
Date: Sat, 12 Sep 2026 08:46:11 +0200
Message-ID: <20260912065637.040560625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit a491be376abd1c80a314cdd658632c85cd660b73 ]

A user VINTF is torn down by tegra241_cmdqv_deinit_vintf(), which runs from
the destroy callback and from the init-failure unwind in the alloc handler.
It clears the cmdqv->vintfs[] slot and lets the iommufd core free it, but
nothing serializes that against the error interrupt: tegra241_cmdqv_isr()
reads cmdqv->vintfs[idx] and dereferences the vintf. A concurrent error can
make the ISR read a slot mid-clear (a NULL deref) or use a vintf which is
about to be freed (a use-after-free).

deinit_vintf() also returns idx to the IDA before clearing the slot, so a
concurrent create that reuses idx can publish its new vintf into the slot,
only for this teardown to erase it again with the stale NULL store.

On the other end, tegra241_cmdqv_init_vintf() publishes a new vintf with a
plain store to the cmdqv->vintfs[] slot, and the ISR dereferences fields of
a published vintf such as vintf->base. A plain store gives no ordering on a
weakly-ordered CPU, and a stale VINTF_ERR_MAP bit on a reused idx can make
the ISR pick a vintf the moment it is published, before its fields are set
or tegra241_vintf_hw_init() runs.

The cmdqv->vintfs[0] slot stays NULL until tegra241_cmdqv_init_structures()
first creates VINTF0, so the slot 0 read needs the same NULL check.

Publish every slot with an smp_store_release(), and read each slot in the
ISR with an smp_load_acquire() under a NULL check, so the ISR always sees
a fully built vintf or NULL. Also make deinit_vintf() clear the slot, and
synchronize_irq() prior to returning idx to the IDA, so no vintf is freed
under a running handler and no reused idx is clobbered.

Fixes: 4dc0d12474f9 ("iommu/tegra241-cmdqv: Add user-space use support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 37 +++++++++++++++++--
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 3c4465289b44a..c9f6729c98588 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -339,6 +339,13 @@ static void tegra241_vintf0_handle_error(struct tegra241_vintf *vintf)
 	}
 }
 
+/*
+ * The CMDQV error interrupt is edge-triggered, so a pending VINTF error fires
+ * this ISR once and does not re-assert. An unacked guest therefore cannot
+ * storm the host. The HW latches and forwards each new error event on its
+ * own, so an already-set ERR_MAP bit does not suppress the interrupt for a
+ * new error.
+ */
 static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
 {
 	struct tegra241_cmdqv *cmdqv = (struct tegra241_cmdqv *)devid;
@@ -361,16 +368,27 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
 
 	/* Handle VINTF0 and its LVCMDQs */
 	if (vintf_map & BIT_ULL(0)) {
-		tegra241_vintf0_handle_error(cmdqv->vintfs[0]);
+		struct tegra241_vintf *vintf0;
+
 		vintf_map &= ~BIT_ULL(0);
+
+		/* NULL until tegra241_cmdqv_init_structures() publishes it */
+		vintf0 = smp_load_acquire(&cmdqv->vintfs[0]);
+		if (vintf0)
+			tegra241_vintf0_handle_error(vintf0);
 	}
 
 	/* Handle other user VINTFs and their LVCMDQs */
 	while (vintf_map) {
 		unsigned long idx = __ffs64(vintf_map);
+		struct tegra241_vintf *vintf;
 
-		tegra241_vintf_user_handle_error(cmdqv->vintfs[idx]);
 		vintf_map &= ~BIT_ULL(idx);
+
+		/* The slot may be published or torn down (NULL'd) concurrently */
+		vintf = smp_load_acquire(&cmdqv->vintfs[idx]);
+		if (vintf)
+			tegra241_vintf_user_handle_error(vintf);
 	}
 
 	return IRQ_HANDLED;
@@ -734,8 +752,18 @@ tegra241_vintf_alloc_lvcmdq(struct tegra241_vintf *vintf, u16 lidx)
 static void tegra241_cmdqv_deinit_vintf(struct tegra241_cmdqv *cmdqv, u16 idx)
 {
 	kfree(cmdqv->vintfs[idx]->lvcmdqs);
+	/*
+	 * Clear the slot and drain any in-flight ISR before returning idx to
+	 * the IDA, so a concurrent create that reuses idx cannot have its
+	 * freshly published VINTF erased here. A plain WRITE_ONCE() suffices
+	 * since clearing the slot publishes no data. This also covers the
+	 * init-failure unwind, which reaches deinit_vintf() without the
+	 * destroy callback.
+	 */
+	WRITE_ONCE(cmdqv->vintfs[idx], NULL);
+	if (cmdqv->irq > 0)
+		synchronize_irq(cmdqv->irq);
 	ida_free(&cmdqv->vintf_ids, idx);
-	cmdqv->vintfs[idx] = NULL;
 }
 
 static int tegra241_cmdqv_init_vintf(struct tegra241_cmdqv *cmdqv, u16 max_idx,
@@ -761,7 +789,8 @@ static int tegra241_cmdqv_init_vintf(struct tegra241_cmdqv *cmdqv, u16 max_idx,
 		return -ENOMEM;
 	}
 
-	cmdqv->vintfs[idx] = vintf;
+	/* Pairs with the smp_load_acquire() in tegra241_cmdqv_isr() */
+	smp_store_release(&cmdqv->vintfs[idx], vintf);
 	return ret;
 }
 
-- 
2.53.0



