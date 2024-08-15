Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC42B1AD9E8;
	Thu, 15 Aug 2024 14:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730963; cv=none; b=TQy+DJN5aKqFkj8IiLKho5O79eH1o0vfAu394As3r1XZevePOjtikWFQoSTEtyLsaMTKhM+dRuL1lXOyFJUwt6ZixZjpPVGTmIGbAciAtBi4N7gq1VePAk6ChKT01zxUs9l5SCoX/oMCbiZQmHsnpBMREk92UcxDXkay5sVB1lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730963; c=relaxed/simple;
	bh=HvGQJ/J9mLylRVilvVG0RyrxK5M7Q8YWChhvffl4xGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5KIR19EIGY37dgEhJIVTIhp+LcFzr0n8d2XDeX7Dcznj/DBmyW6HFJyx+8grcgCrn1vk3j6t8h+Zqa2buMMcni2PqYvYYpXRsl5W53AYqKFfM10VCrk3mQKckUG51BhT9HSRHGEnlx0ur2EHwHIXwEpRV6M9iKEBz1gIbEx/tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2KfEvcu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2KfEvcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031C3C32786;
	Thu, 15 Aug 2024 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730962;
	bh=HvGQJ/J9mLylRVilvVG0RyrxK5M7Q8YWChhvffl4xGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2KfEvcuvM7zmAQLnuyxw2xp9zdgiFip65H3cqjBdK8sZ3x08oHKcgFhYLSt7y+QG
	 dSWMH6ky1PbdlHsQOc/75NbjD2N9wI3kLwEL5D/8zMFh3oZsgweqHn6sYIDi2JCAsw
	 3+knQvaOK7V4AaNe5k/qNC5Cw2AyJk+Dxu+WFAg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.6 20/67] genirq/cpuhotplug: Retry with cpu_online_mask when migration fails
Date: Thu, 15 Aug 2024 15:25:34 +0200
Message-ID: <20240815131839.111621911@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Dongli Zhang <dongli.zhang@oracle.com>

commit 88d724e2301a69c1ab805cd74fc27aa36ae529e0 upstream.

When a CPU goes offline, the interrupts affine to that CPU are
re-configured.

Managed interrupts undergo either migration to other CPUs or shutdown if
all CPUs listed in the affinity are offline. The migration of managed
interrupts is guaranteed on x86 because there are interrupt vectors
reserved.

Regular interrupts are migrated to a still online CPU in the affinity mask
or if there is no online CPU to any online CPU.

This works as long as the still online CPUs in the affinity mask have
interrupt vectors available, but in case that none of those CPUs has a
vector available the migration fails and the device interrupt becomes
stale.

This is not any different from the case where the affinity mask does not
contain any online CPU, but there is no fallback operation for this.

Instead of giving up, retry the migration attempt with the online CPU mask
if the interrupt is not managed, as managed interrupts cannot be affected
by this problem.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240423073413.79625-1-dongli.zhang@oracle.com
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/cpuhotplug.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -130,6 +130,22 @@ static bool migrate_one_irq(struct irq_d
 	 * CPU.
 	 */
 	err = irq_do_set_affinity(d, affinity, false);
+
+	/*
+	 * If there are online CPUs in the affinity mask, but they have no
+	 * vectors left to make the migration work, try to break the
+	 * affinity by migrating to any online CPU.
+	 */
+	if (err == -ENOSPC && !irqd_affinity_is_managed(d) && affinity != cpu_online_mask) {
+		pr_debug("IRQ%u: set affinity failed for %*pbl, re-try with online CPUs\n",
+			 d->irq, cpumask_pr_args(affinity));
+
+		affinity = cpu_online_mask;
+		brokeaff = true;
+
+		err = irq_do_set_affinity(d, affinity, false);
+	}
+
 	if (err) {
 		pr_warn_ratelimited("IRQ%u: set affinity failed(%d).\n",
 				    d->irq, err);


