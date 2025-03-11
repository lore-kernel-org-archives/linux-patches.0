Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9297425E83F;
	Tue, 11 Mar 2025 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706377; cv=none; b=mbXgJ9Xio7PJNxcqVJbq9pXn3hj/b3AYf8V+O9M6qbDlqEuglCW5U1vZpSD7kMHyjLZodds3thi4FOHMd9fN59PuKlUvTFetQUWNkC6HMiJDgbCXCw54liwpZINywcwzmERz0UHQi+5W5KDIR4gf0TZF0fvp+Dk5T22DwVGA95s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706377; c=relaxed/simple;
	bh=Y6qlsi0Tjk6xZJUb3epg2sCUX63WByDZsUdQhRnpaPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS9jwF9VyJRNt4EYvrfOD+ghFSF8QKCKctrk8WuWyS+Ps2vAholgtdO3w6wjXvWZSIpd8CGvt7zzG5MATDCWR1PB5WNDygomuAK9d+sWsc/0/2TuxhJiaBlGJpyGkuUw4BeLd2HjULe8bgoVTQ+dhAqeHS46ZH+cYS4CEUerQ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxRkkc+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxRkkc+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D30BC4CEE9;
	Tue, 11 Mar 2025 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706377;
	bh=Y6qlsi0Tjk6xZJUb3epg2sCUX63WByDZsUdQhRnpaPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxRkkc+MpTAQAjvxDA4/ycvY9TVHDW53q985kUdKIf1hDZySWZM1pimMtcvZb5Y4i
	 +gljve+WB57bwPmHCyaI9MBIY34O7JMIDTZWOz/TCSBQiI54UVgitz8NOl9g3MsjvX
	 LXf+ItxX5c3pd5urDvpH3WZ7wEmjk6dLZ8yvxFfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/462] genirq: Make handle_enforce_irqctx() unconditionally available
Date: Tue, 11 Mar 2025 15:54:36 +0100
Message-ID: <20250311145758.759257879@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1d83a8b44171..da1f282d5a1d1 100644
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



