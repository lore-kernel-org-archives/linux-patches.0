Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B8D1C2432;
	Wed, 19 Feb 2025 09:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956006; cv=none; b=Pf70PYTXSUN6u7ZUJlxkoow6usxi0H7r2o8dMf34UXCLdyGHktB+OC/uBG/4j5Y7q0l85jvDFthdMh+6aA20R0/XsOtZDuIv0hnlrfgHlQeg+VkeeWo+sK6okCBBdiRdH4MWPJHYV2u1q/sMtOGcyEEIPk8jE54J+cSCQCejHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956006; c=relaxed/simple;
	bh=rz0Cq1OKqlgnZmbvm5xL8Z3oUfZxYXeqFFHKUlAjHBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuBUcMEuRIRRb18cf+9vhddzrTcIqtb+Bk1JwExIZGkCAibOuoXvs+dN9cRRuVJJ6QfeQdm2YBic5LTn0pE+QSOxOW82iMpZdP2RUWtwQ/AlBAezvZ0WpzO0Ed5lMf62P5Nzjvqfn7c+HsBq3flPNlO9CjPk9E1kvtoGCsDVLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+1+0hsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+1+0hsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE45BC4CED1;
	Wed, 19 Feb 2025 09:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956006;
	bh=rz0Cq1OKqlgnZmbvm5xL8Z3oUfZxYXeqFFHKUlAjHBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+1+0hsxfQQfcce4z7lT5Zm3Ntg3ZP77UNhsy7CPVBpYf4Md7mbjuIv2dKIgKYl8E
	 QwLPBEjzNSMUvdiHju8s9KmN1svmRUrv2irW/wJeI/BWJ63+io1uv7YOxPQ+Wi4XV5
	 dWP9CYc9wGUygEWC+UtLYnkYLGXpTHeFZwVcmbSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/578] genirq: Make handle_enforce_irqctx() unconditionally available
Date: Wed, 19 Feb 2025 09:20:37 +0100
Message-ID: <20250219082654.199329639@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8d187a77f04c14fb459a5301d69f733a5a1396bc ]

Commit 1b57d91b969c ("irqchip/gic-v2, v3: Prevent SW resends entirely")
sett the flag which enforces interrupt handling in interrupt context and
prevents software base resends for ARM GIC v2/v3.

But it missed that the helper function which checks the flag was hidden
behind CONFIG_GENERIC_PENDING_IRQ, which is not set by ARM[64].

Make the helper unconditionally available so that the enforcement actually
works.

Fixes: 1b57d91b969c ("irqchip/gic-v2, v3: Prevent SW resends entirely")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241210101811.497716609@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/internals.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 5fdc0b5575797..35e85323940c3 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -429,10 +429,6 @@ static inline struct cpumask *irq_desc_get_pending_mask(struct irq_desc *desc)
 {
 	return desc->pending_mask;
 }
-static inline bool handle_enforce_irqctx(struct irq_data *data)
-{
-	return irqd_is_handle_enforce_irqctx(data);
-}
 bool irq_fixup_move_pending(struct irq_desc *desc, bool force_clear);
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 static inline bool irq_can_move_pcntxt(struct irq_data *data)
@@ -459,11 +455,12 @@ static inline bool irq_fixup_move_pending(struct irq_desc *desc, bool fclear)
 {
 	return false;
 }
+#endif /* !CONFIG_GENERIC_PENDING_IRQ */
+
 static inline bool handle_enforce_irqctx(struct irq_data *data)
 {
-	return false;
+	return irqd_is_handle_enforce_irqctx(data);
 }
-#endif /* !CONFIG_GENERIC_PENDING_IRQ */
 
 #if !defined(CONFIG_IRQ_DOMAIN) || !defined(CONFIG_IRQ_DOMAIN_HIERARCHY)
 static inline int irq_domain_activate_irq(struct irq_data *data, bool reserve)
-- 
2.39.5



