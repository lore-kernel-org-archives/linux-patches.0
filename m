Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D56C4CDDFE;
	Thu, 17 Sep 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663985; cv=none; b=UYPeeRx8Amkzj2ZV8Kb0x0GXL0Y/SE+VYn1I4Jkod8jHa7YOd8vtjE0RJUbXrziZZgpjTwCJ9wf04748Itvv9ABGYRaFqInf9OnLjYpCp9NWLv4GhiCrXw6lhujqG/6dEyzR56USP97Uzcb910NKzsj8vAAVP/ZqIi77w3BtNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663985; c=relaxed/simple;
	bh=47R9tyVfCLYWJl4jDyCZphgWjKO6gjOoR4dH+VQM6cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP7cZfFU++/f7EYrPoGLxucRAbGI5NIrCPpans2ly5Jv1OVtyiSyObt1czvw3iCcqBCSD/Ntg3684NmA512+Ta61Pfp7ZYBxFjH+ocJ+V0sSVzQqrwS8AtTiTvAk3Yn8/ekLu/X3Hk1zRyfHORR2k0hEBQRssBmc3Vqw1w1t7l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owiUQZuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owiUQZuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F87F1F000FF;
	Thu, 17 Sep 2026 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663984;
	bh=O77IRp0W2DtaO4nE84R1lXx+dxT/o63D4avjH1xUhYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owiUQZuVVPyPKgKWNN2RhZOmDnOFpdxpmbe8kiJsiCreVBCC1KBiH/dH4gYOMtMw+
	 75twTNna1aQTmg6dRv6T2b/rAdsZhhPtHvggS+gPoq6xRkX3ePwaM1Rpn6MA5P5Jcn
	 oOiAZchyfkP9gWOelpaIk4oUzrcp3MGpn3xUKqNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0221/1250] genirq/manage: Make NMI cleanup RT safe
Date: Thu, 17 Sep 2026 16:00:16 +0100
Message-ID: <20260917151558.129971490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 3ba92f6a28203e30d0b2c7d75b59f48d5ff9fbcc ]

Eventually blocking functions cannot be invoked with interrupts disabled
and a raw spin lock held. Restructure the code so this happens outside of
the descriptor lock held region.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/20260517194931.601972758@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/manage.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c09751b7a0c49..881d95c5af64d 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1987,24 +1987,30 @@ const void *free_irq(unsigned int irq, void *dev_id)
 }
 EXPORT_SYMBOL(free_irq);
 
-/* This function must be called with desc->lock held */
 static const void *__cleanup_nmi(unsigned int irq, struct irq_desc *desc)
 {
+	struct irqaction *action = NULL;
 	const char *devname = NULL;
 
-	desc->istate &= ~IRQS_NMI;
+	scoped_guard(raw_spinlock_irqsave, &desc->lock) {
+		irq_nmi_teardown(desc);
 
-	if (!WARN_ON(desc->action == NULL)) {
-		irq_pm_remove_action(desc, desc->action);
-		devname = desc->action->name;
-		unregister_handler_proc(irq, desc->action);
+		desc->istate &= ~IRQS_NMI;
 
-		kfree(desc->action);
+		if (!WARN_ON(desc->action == NULL)) {
+			action = desc->action;
+			irq_pm_remove_action(desc, action);
+			devname = action->name;
+		}
 		desc->action = NULL;
+
+		irq_settings_clr_disable_unlazy(desc);
+		irq_shutdown_and_deactivate(desc);
 	}
 
-	irq_settings_clr_disable_unlazy(desc);
-	irq_shutdown_and_deactivate(desc);
+	if (action)
+		unregister_handler_proc(irq, action);
+	kfree(action);
 
 	irq_release_resources(desc);
 
@@ -2028,8 +2034,6 @@ const void *free_nmi(unsigned int irq, void *dev_id)
 	if (WARN_ON(desc->depth == 0))
 		disable_nmi_nosync(irq);
 
-	guard(raw_spinlock_irqsave)(&desc->lock);
-	irq_nmi_teardown(desc);
 	return __cleanup_nmi(irq, desc);
 }
 
@@ -2279,13 +2283,14 @@ int request_nmi(unsigned int irq, irq_handler_t handler,
 		/* Setup NMI state */
 		desc->istate |= IRQS_NMI;
 		retval = irq_nmi_setup(desc);
-		if (retval) {
-			__cleanup_nmi(irq, desc);
-			return -EINVAL;
-		}
-		return 0;
 	}
 
+	if (retval) {
+		__cleanup_nmi(irq, desc);
+		return -EINVAL;
+	}
+	return 0;
+
 err_irq_setup:
 	irq_chip_pm_put(&desc->irq_data);
 err_out:
-- 
2.53.0



