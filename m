Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82F23603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300959; cv=none; b=mNrMmXKETWc8Mh4cjUkE9HRJ7EG4Kw6KuqrvAU+AVIqEuK56jBvdq6VRQ8nHMuIXEexeHYgoX9z5a00vajw2sn2bPWYq/9hOnpcdCL+biJb+RHvKyfoVn9RwKLGqwn5BYUL5YEvNQbDw25ZLPSRjXC8Eq3/DWOaC1jbH9q9ddsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300959; c=relaxed/simple;
	bh=O0zjvxCnfgAxetSvkvrDx7ywm50HRLlddW+o6X9PQbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iot/m28g8sopjy9pFJ+fQoOGi96MVphTC+6+Fl81aCDlD1UPyH5X0uobLnmcROFdV99hUvOcRGtTx7J68PzpvSrg+Xz90qHW1GIFC05GcPdVbvZvj55n8Nkxth6rGGpxH0phSENRcW5oYEVupAO78VU6UzxwXq2DCA8nd7ZQHM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMsD3kf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMsD3kf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C38C19423;
	Sat, 28 Feb 2026 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300959;
	bh=O0zjvxCnfgAxetSvkvrDx7ywm50HRLlddW+o6X9PQbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMsD3kf9eYijIIL9wdcnxsd79T6oivaxqR/1Bgql2QYhkCE4csVsRtjRoJXoxKIhr
	 VcaS5vDhziDHbLxxlAxkcCpS7Pmxrun9aKzbIflCdZ+AhHS6g0Ee6EfDUSrji0GgXq
	 ELUB6naZiNa02KlzX5LxsKkmKb9AxKpUSulU/RamoAa/PE9LlY7wmgIrCh4bovayVt
	 YC//XP7y+6Kytm11ZSagSTnFk7UPvE0qq2cq8Py5RASB3GwbFE1LGtAL1G7XY08/Th
	 oLd95t9B3DeX7p/uAxdxD3XWzeoi4CqxY8vwTru5Yh+Sfnz5RFL7VwQF/eg9hNVAxf
	 I5WVHt5cqdCmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Imran Khan <imran.f.khan@oracle.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/752] genirq/cpuhotplug: Notify about affinity changes breaking the affinity mask
Date: Sat, 28 Feb 2026 12:36:35 -0500
Message-ID: <20260228174750.1542406-84-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Imran Khan <imran.f.khan@oracle.com>

[ Upstream commit dd9f6d30c64001ca4dde973ac04d8d155e856743 ]

During CPU offlining the interrupts affined to that CPU are moved to other
online CPUs, which might break the original affinity mask if the outgoing
CPU was the last online CPU in that mask. This change is not propagated to
irq_desc::affinity_notify(), which leaves users of the affinity notifier
mechanism with stale information.

Avoid this by scheduling affinity change notification work for interrupts
that were affined to the CPU being offlined, if the new target CPU is not
part of the original affinity mask.

Since irq_set_affinity_locked() uses the same logic to schedule affinity
change notification work, split out this logic into a dedicated function
and use that at both places.

[ tglx: Removed the EXPORT(), removed the !SMP stub, moved the prototype,
  	added a lockdep assert instead of a comment, fixed up coding style
  	and name space. Polished and clarified the change log ]

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260113143727.1041265-1-imran.f.khan@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/cpuhotplug.c |  6 ++++--
 kernel/irq/internals.h  |  2 +-
 kernel/irq/manage.c     | 26 ++++++++++++++++++--------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/kernel/irq/cpuhotplug.c b/kernel/irq/cpuhotplug.c
index 755346ea98196..cd5689e383b00 100644
--- a/kernel/irq/cpuhotplug.c
+++ b/kernel/irq/cpuhotplug.c
@@ -177,9 +177,11 @@ void irq_migrate_all_off_this_cpu(void)
 		bool affinity_broken;
 
 		desc = irq_to_desc(irq);
-		scoped_guard(raw_spinlock, &desc->lock)
+		scoped_guard(raw_spinlock, &desc->lock) {
 			affinity_broken = migrate_one_irq(desc);
-
+			if (affinity_broken && desc->affinity_notify)
+				irq_affinity_schedule_notify_work(desc);
+		}
 		if (affinity_broken) {
 			pr_debug_ratelimited("IRQ %u: no longer affine to CPU%u\n",
 					    irq, smp_processor_id());
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 0164ca48da59e..5568ed3a8b852 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -135,6 +135,7 @@ extern bool irq_can_set_affinity_usr(unsigned int irq);
 
 extern int irq_do_set_affinity(struct irq_data *data,
 			       const struct cpumask *dest, bool force);
+extern void irq_affinity_schedule_notify_work(struct irq_desc *desc);
 
 #ifdef CONFIG_SMP
 extern int irq_setup_affinity(struct irq_desc *desc);
@@ -142,7 +143,6 @@ extern int irq_setup_affinity(struct irq_desc *desc);
 static inline int irq_setup_affinity(struct irq_desc *desc) { return 0; }
 #endif
 
-
 #define for_each_action_of_desc(desc, act)			\
 	for (act = desc->action; act; act = act->next)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 400856abf6721..c09751b7a0c49 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -347,6 +347,21 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
 	return true;
 }
 
+/**
+ * irq_affinity_schedule_notify_work - Schedule work to notify about affinity change
+ * @desc:  Interrupt descriptor whose affinity changed
+ */
+void irq_affinity_schedule_notify_work(struct irq_desc *desc)
+{
+	lockdep_assert_held(&desc->lock);
+
+	kref_get(&desc->affinity_notify->kref);
+	if (!schedule_work(&desc->affinity_notify->work)) {
+		/* Work was already scheduled, drop our extra ref */
+		kref_put(&desc->affinity_notify->kref, desc->affinity_notify->release);
+	}
+}
+
 int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 			    bool force)
 {
@@ -367,14 +382,9 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 		irq_copy_pending(desc, mask);
 	}
 
-	if (desc->affinity_notify) {
-		kref_get(&desc->affinity_notify->kref);
-		if (!schedule_work(&desc->affinity_notify->work)) {
-			/* Work was already scheduled, drop our extra ref */
-			kref_put(&desc->affinity_notify->kref,
-				 desc->affinity_notify->release);
-		}
-	}
+	if (desc->affinity_notify)
+		irq_affinity_schedule_notify_work(desc);
+
 	irqd_set(data, IRQD_AFFINITY_SET);
 
 	return ret;
-- 
2.51.0

