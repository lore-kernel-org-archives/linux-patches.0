Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EA9143759;
	Wed,  5 Feb 2025 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763344; cv=none; b=q0bGIQnllWS6kccvqXFCGzWdNv6Hk5fBpoKwBv2F6LcoIPUMh2FmAlx07mcA032A29d4hFKfyBbOErk9H0lrxcnlZ5RrIt3K+U5NpO+ZP7KqfDowLAk4+FIUgLV7ag3z181/ZRc9NWtS7ZZO26pY2ofBOwk9//UMfVf3DIHLn94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763344; c=relaxed/simple;
	bh=KSop6/qXgeufH6i9I/mtJ3ElnVKKTHMWsNuQK4kZUNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4IgVsGtDLUrv1t9z7MHHsSVeRx4+qtxybuucjcepiCOzRr2y3eYZNxKsG25/q36RrB0yY4zI0SW5TEjyTyMfCaVT1zqZfPbqCd7QFqm4EzAQNHaqqr1bFGXJcitqCfqC0fseyLDEs7DvTGiGmZJIV+S414qY1HFcvyjacR3Bvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRaQVoL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRaQVoL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ED7C4CED1;
	Wed,  5 Feb 2025 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763344;
	bh=KSop6/qXgeufH6i9I/mtJ3ElnVKKTHMWsNuQK4kZUNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRaQVoL6k13RIw2SpKqLEtP5n/ENH7BHQGTh8dQVyXP9PeeeDlNW9pwUHsOlMeQ57
	 u2N0wbufSCUR4u4I0hD2dcwueKmgZpkEFVzmKY+JECQ8sqxG639u8K/y9enGYVOf5I
	 cDGrBgsqLIQygQr2QBc5UuQ+Vu0FUKMeMpC5AAdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/393] genirq: Make handle_enforce_irqctx() unconditionally available
Date: Wed,  5 Feb 2025 14:39:25 +0100
Message-ID: <20250205134422.064243908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bcc7f21db9eeb..fbeecc608f54c 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -434,10 +434,6 @@ static inline struct cpumask *irq_desc_get_pending_mask(struct irq_desc *desc)
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
@@ -464,11 +460,12 @@ static inline bool irq_fixup_move_pending(struct irq_desc *desc, bool fclear)
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



