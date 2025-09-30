Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE61487F4;
	Tue, 30 Sep 2025 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245024; cv=none; b=NMibChgXgD+W2h/XS/KKoWr4S/jEPp17eSs9m40/8moJMc/vvmPzrwe3vPEbPHIH5ENxcIS9foVBiLXmTMwINhh86Z9ooSECllbyPZorFHKvf1Yho3SXl9/HYwLq1gumjMg1+7KXMbEb9fGw/+6/5s6ws/dY8bQpR9t5J7gPg1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245024; c=relaxed/simple;
	bh=7IwALrQeTBHtVekRRyaV1DhUK3XniLGCYqnQ8AtWnY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxFOpUK620OT3+qyTBYIJUJg1kYrhPkmAXkgrahnHj45wfqYIHB19IsR/3b0zX4WBraxpfuRX61Yi4v8p6bQP09S46Hysws0UpYI1bePIlF3XnJ9kv6Jpsud7e+V3RbHsFZuERj+d+pu6QKowcuZEj1aEbartHq5Oy7tevlhrLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POXFA3L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POXFA3L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22502C4CEF0;
	Tue, 30 Sep 2025 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245023;
	bh=7IwALrQeTBHtVekRRyaV1DhUK3XniLGCYqnQ8AtWnY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POXFA3L1+2Ydhjnf3i6EpNW2VJQ9Zo3zOh2t6lkzKcDAdqnCgh/daWNhXdI8Nr4Ks
	 Khw0RZhfw8i0HRu4pSb3dyGGzeF+5/8GR1+smwmCRzX9unFvOC9XSvp5qzz53aqeVM
	 clpOt/8iiBEtAnkqkBlxtaO5/DQzli1mBlbDwGIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitesh Narayan Lal <nitesh@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/151] i40e: Use irq_update_affinity_hint()
Date: Tue, 30 Sep 2025 16:46:12 +0200
Message-ID: <20250930143829.284976762@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitesh Narayan Lal <nitesh@redhat.com>

[ Upstream commit d34c54d1739c2cdf2e4437b74e6da269147f4987 ]

The driver uses irq_set_affinity_hint() for two purposes:

 - To set the affinity_hint which is consumed by the userspace for
   distributing the interrupts

 - To apply an affinity that it provides for the i40e interrupts

The latter is done to ensure that all the interrupts are evenly spread
across all available CPUs. However, since commit a0c9259dc4e1 ("irq/matrix:
Spread interrupts on allocation") the spreading of interrupts is
dynamically performed at the time of allocation. Hence, there is no need
for the drivers to enforce their own affinity for the spreading of
interrupts.

Also, irq_set_affinity_hint() applying the provided cpumask as an affinity
for the interrupt is an undocumented side effect. To remove this side
effect irq_set_affinity_hint() has been marked as deprecated and new
interfaces have been introduced. Hence, replace the irq_set_affinity_hint()
with the new interface irq_update_affinity_hint() that only sets the
pointer for the affinity_hint.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/20210903152430.244937-4-nitesh@redhat.com
Stable-dep-of: 915470e1b44e ("i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2a3b8dd72686d..9fb598f56be4a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4152,10 +4152,10 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		 *
 		 * get_cpu_mask returns a static constant mask with
 		 * a permanent lifetime so it's ok to pass to
-		 * irq_set_affinity_hint without making a copy.
+		 * irq_update_affinity_hint without making a copy.
 		 */
 		cpu = cpumask_local_spread(q_vector->v_idx, -1);
-		irq_set_affinity_hint(irq_num, get_cpu_mask(cpu));
+		irq_update_affinity_hint(irq_num, get_cpu_mask(cpu));
 	}
 
 	vsi->irqs_ready = true;
@@ -4166,7 +4166,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		vector--;
 		irq_num = pf->msix_entries[base + vector].vector;
 		irq_set_affinity_notifier(irq_num, NULL);
-		irq_set_affinity_hint(irq_num, NULL);
+		irq_update_affinity_hint(irq_num, NULL);
 		free_irq(irq_num, &vsi->q_vectors[vector]);
 	}
 	return err;
@@ -4987,7 +4987,7 @@ static void i40e_vsi_free_irq(struct i40e_vsi *vsi)
 			/* clear the affinity notifier in the IRQ descriptor */
 			irq_set_affinity_notifier(irq_num, NULL);
 			/* remove our suggested affinity mask for this IRQ */
-			irq_set_affinity_hint(irq_num, NULL);
+			irq_update_affinity_hint(irq_num, NULL);
 			synchronize_irq(irq_num);
 			free_irq(irq_num, vsi->q_vectors[i]);
 
-- 
2.51.0



