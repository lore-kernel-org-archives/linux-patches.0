Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D112745E;
	Fri, 17 Oct 2025 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713647; cv=none; b=VVEKB4CUqJvgJNkA7OpqG1O+jht5+qmMff+9MkZ/oLFv0OQZXnsfjvm30f3Ocy7CFMOTVgEUOnvezTP7ZUInsjXny+/lRx4FcvwVxTx7FO7eZ9AqO8JrQNUlZj7nnR2ZGOyrQabg30Wc42R6JlgG8GmXBeLeQAIRkoOHwV+u2g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713647; c=relaxed/simple;
	bh=g9dsxCADkjHqWVbqQun8/xX2qiE5PuvPlLTk2e9A4OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGmDIV+DcIoi/omWqpRuUJy6bhAdsPjuKlnPubYhtGEt0tcew/gz4Wz1EkBd6HaX9b/ivYPnHQpsNHkoK7KfE2E4v5Qj0PNOyK841VbnfOv8HQSBSXGACNg5mET6Igz8wvKSrVZvNDnbsb2jxnhl9lqEWP9luup2wVbKXl/gRqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0ijY62I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0ijY62I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BB9C4CEE7;
	Fri, 17 Oct 2025 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713647;
	bh=g9dsxCADkjHqWVbqQun8/xX2qiE5PuvPlLTk2e9A4OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0ijY62IaTErFwju9B+TDnTsYcV0chgisLXZg/cFo4km6RX4+7IiEzhJMJmFxz/kE
	 lnvDviIMAK0YEh0L4iUFSCDeSGwYtFsE+M9LVqxXluL5F2i9b4socwpgp3BHhCeJ00
	 qQRoY+uWvE0KxfHHgd14UdiKB5SvP8DSj3ED/DiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 070/201] xen/events: Update virq_to_irq on migration
Date: Fri, 17 Oct 2025 16:52:11 +0200
Message-ID: <20251017145137.324997549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit 3fcc8e146935415d69ffabb5df40ecf50e106131 upstream.

VIRQs come in 3 flavors, per-VPU, per-domain, and global, and the VIRQs
are tracked in per-cpu virq_to_irq arrays.

Per-domain and global VIRQs must be bound on CPU 0, and
bind_virq_to_irq() sets the per_cpu virq_to_irq at registration time
Later, the interrupt can migrate, and info->cpu is updated.  When
calling __unbind_from_irq(), the per-cpu virq_to_irq is cleared for a
different cpu.  If bind_virq_to_irq() is called again with CPU 0, the
stale irq is returned.  There won't be any irq_info for the irq, so
things break.

Make xen_rebind_evtchn_to_cpu() update the per_cpu virq_to_irq mappings
to keep them update to date with the current cpu.  This ensures the
correct virq_to_irq is cleared in __unbind_from_irq().

Fixes: e46cdb66c8fc ("xen: event channels")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250828003604.8949-4-jason.andryuk@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1809,9 +1809,20 @@ static int xen_rebind_evtchn_to_cpu(stru
 	 * virq or IPI channel, which don't actually need to be rebound. Ignore
 	 * it, but don't do the xenlinux-level rebind in that case.
 	 */
-	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
+	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0) {
+		int old_cpu = info->cpu;
+
 		bind_evtchn_to_cpu(info, tcpu, false);
 
+		if (info->type == IRQT_VIRQ) {
+			int virq = info->u.virq;
+			int irq = per_cpu(virq_to_irq, old_cpu)[virq];
+
+			per_cpu(virq_to_irq, old_cpu)[virq] = -1;
+			per_cpu(virq_to_irq, tcpu)[virq] = irq;
+		}
+	}
+
 	do_unmask(info, EVT_MASK_REASON_TEMPORARY);
 
 	return 0;


