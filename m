Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDB12E7367;
	Fri,  7 Aug 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115097; cv=none; b=Ej/IpsHuYYM9khtLEzr2GUtulRMfJIguJPNQLeLHBZVfpeU+2PsgFk4AqJyfcKWjdXQhsAkg9COhngeOU5GiiFPCQlt1JQVack6HkKt81wDU/zwJaLRbnx1akOAXsFKYyyOK0u8uyhMo+DakawBW329ZBo/IRkDBdxrxYqFCfhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115097; c=relaxed/simple;
	bh=INw04GjCBvstd/xNnRc5OAOSH1tKo7EWYNDXAToM36g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDWdM3Gn067Bw0fpWOa4l9UXPMOooWgbyIt9gjLduXSmt2zkIPCc6n60liICfchVl7nitghUxSWVlXhpn2NyPW7QtRnZ46v89o/6f09sqp0HHs8iTTCmu5Mst3N/MEZZdYmT1eVrCjFLJ18t1UsY1iVwBmIbOis+B+A1uz6OYeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjZ/M81J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjZ/M81J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCE81F000E9;
	Fri,  7 Aug 2026 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115096;
	bh=qSmdmR84ilazq+EVK8BPM2b52x6xZzA8YwvW8P6ssSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjZ/M81JiWOF6/eRa+0Q1kuJYOA1E1v2VX5MRAu1VuMaSRL6AiQMp8utXaLAVcYGo
	 TaLOf5QIVdKQx+zqu6FSmtHTZ0kPU7Xkb3Q29iQhZbN/BlRqIPUICh+x4myp/N4/gr
	 n80W8cK99xL/+u+zR1+F+KNlHW64JgrDVCsWncH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinank Jain <jinankjain@microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/396] mshv: adjust interrupt control structure for ARM64
Date: Fri,  7 Aug 2026 16:35:17 +0200
Message-ID: <20260807143427.696013932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Jinank Jain <jinankjain@microsoft.com>

[ Upstream commit 9d70ef7a18e0ec1653ac63020a13a5d4dda7cc0d ]

Interrupt control structure (union hv_interupt_control) has different
fields when it comes to x86 vs ARM64. Bring in the correct structure
from HyperV header files and adjust the existing interrupt routing
code accordingly.

Signed-off-by: Jinank Jain <jinankjain@microsoft.com>
Signed-off-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 0289a67cd70b ("mshv: Fix level-triggered check on uninitialized data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_eventfd.c      | 6 ++++++
 drivers/hv/mshv_irq.c          | 4 ++++
 drivers/hv/mshv_root_hv_call.c | 6 ++++++
 include/hyperv/hvhdk.h         | 6 ++++++
 4 files changed, 22 insertions(+)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index 586a9f99b3405..311aa9fecbc48 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -164,8 +164,10 @@ static int mshv_try_assert_irq_fast(struct mshv_irqfd *irqfd)
 	if (hv_scheduler_type != HV_SCHEDULER_TYPE_ROOT)
 		return -EOPNOTSUPP;
 
+#if IS_ENABLED(CONFIG_X86)
 	if (irq->lapic_control.logical_dest_mode)
 		return -EOPNOTSUPP;
+#endif
 
 	vp = partition->pt_vp_array[irq->lapic_apic_id];
 
@@ -197,8 +199,10 @@ static void mshv_assert_irq_slow(struct mshv_irqfd *irqfd)
 	unsigned int seq;
 	int idx;
 
+#if IS_ENABLED(CONFIG_X86)
 	WARN_ON(irqfd->irqfd_resampler &&
 		!irq->lapic_control.level_triggered);
+#endif
 
 	idx = srcu_read_lock(&partition->pt_irq_srcu);
 	if (irqfd->irqfd_girq_ent.guest_irq_num) {
@@ -469,6 +473,7 @@ static int mshv_irqfd_assign(struct mshv_partition *pt,
 	init_poll_funcptr(&irqfd->irqfd_polltbl, mshv_irqfd_queue_proc);
 
 	spin_lock_irq(&pt->pt_irqfds_lock);
+#if IS_ENABLED(CONFIG_X86)
 	if (args->flags & BIT(MSHV_IRQFD_BIT_RESAMPLE) &&
 	    !irqfd->irqfd_lapic_irq.lapic_control.level_triggered) {
 		/*
@@ -479,6 +484,7 @@ static int mshv_irqfd_assign(struct mshv_partition *pt,
 		ret = -EINVAL;
 		goto fail;
 	}
+#endif
 	ret = 0;
 	hlist_for_each_entry(tmp, &pt->pt_irqfds_list, irqfd_hnode) {
 		if (irqfd->irqfd_eventfd_ctx != tmp->irqfd_eventfd_ctx)
diff --git a/drivers/hv/mshv_irq.c b/drivers/hv/mshv_irq.c
index 743777b4886d3..7422a36199b40 100644
--- a/drivers/hv/mshv_irq.c
+++ b/drivers/hv/mshv_irq.c
@@ -119,6 +119,10 @@ void mshv_copy_girq_info(struct mshv_guest_irq_ent *ent,
 	lirq->lapic_vector = ent->girq_irq_data & 0xFF;
 	lirq->lapic_apic_id = (ent->girq_addr_lo >> 12) & 0xFF;
 	lirq->lapic_control.interrupt_type = (ent->girq_irq_data & 0x700) >> 8;
+#if IS_ENABLED(CONFIG_X86)
 	lirq->lapic_control.level_triggered = (ent->girq_irq_data >> 15) & 0x1;
 	lirq->lapic_control.logical_dest_mode = (ent->girq_addr_lo >> 2) & 0x1;
+#elif IS_ENABLED(CONFIG_ARM64)
+	lirq->lapic_control.asserted = 1;
+#endif
 }
diff --git a/drivers/hv/mshv_root_hv_call.c b/drivers/hv/mshv_root_hv_call.c
index c9c274f29c3c6..a23b5ba09fb40 100644
--- a/drivers/hv/mshv_root_hv_call.c
+++ b/drivers/hv/mshv_root_hv_call.c
@@ -388,7 +388,13 @@ int hv_call_assert_virtual_interrupt(u64 partition_id, u32 vector,
 	memset(input, 0, sizeof(*input));
 	input->partition_id = partition_id;
 	input->vector = vector;
+	/*
+	 * NOTE: dest_addr only needs to be provided while asserting an
+	 * interrupt on x86 platform
+	 */
+#if IS_ENABLED(CONFIG_X86)
 	input->dest_addr = dest_addr;
+#endif
 	input->control = control;
 	status = hv_do_hypercall(HVCALL_ASSERT_VIRTUAL_INTERRUPT, input, NULL);
 	local_irq_restore(flags);
diff --git a/include/hyperv/hvhdk.h b/include/hyperv/hvhdk.h
index 1057455b84f28..cdc74199ba3fb 100644
--- a/include/hyperv/hvhdk.h
+++ b/include/hyperv/hvhdk.h
@@ -540,9 +540,15 @@ union hv_interrupt_control {
 	u64 as_uint64;
 	struct {
 		u32 interrupt_type; /* enum hv_interrupt_type */
+#if IS_ENABLED(CONFIG_X86)
 		u32 level_triggered : 1;
 		u32 logical_dest_mode : 1;
 		u32 rsvd : 30;
+#elif IS_ENABLED(CONFIG_ARM64)
+		u32 rsvd1 : 2;
+		u32 asserted : 1;
+		u32 rsvd2 : 29;
+#endif
 	} __packed;
 };
 
-- 
2.53.0



