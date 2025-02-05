Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBE11553AB;
	Wed,  5 Feb 2025 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764636; cv=none; b=uxCjF/TxEC0X8hMv5Sx0CM1Vcl7kNGU74H41OcbvWW7wAn1zMbdea2ZcDmiMCM8Hp7KfNWwVRH3dAYwS3MxVruhd0tX99gjJhu/bQtVTQSpIp5wiBiFEE7qQ400eOkl3ggvufhZctPUi+GaqjdMgY7vV52azSOw6tpyXdLWL4lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764636; c=relaxed/simple;
	bh=tt+tuTojqaXoY60uWCusBZDD6RP51vZTl6zroAL11UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYnJNDfkS2Y2ASTIYJIMxnE0IG1RunHHOJvrtS8HLAGlmUqfbF7CDBndcHM4zQwlzHHW7pZ+VeaUgpgYsibIolHx76+f/ubEZSltI5D5WDchAXseTTEXO4oDS6qE+ApBw5xhr1MVnCyt7Zld79UQwUsboaKRmGkMvqoB2k5K6lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEchbN5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEchbN5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CB2C4CED1;
	Wed,  5 Feb 2025 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764635;
	bh=tt+tuTojqaXoY60uWCusBZDD6RP51vZTl6zroAL11UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEchbN5/VHIuBCC0FTI5TpE/wMZN3zky1pi2rXUHxv/rIJ38SeUjcfr+9BL8eap19
	 fBuTSrJMSKofAZKQuFhb/GPHnmUH1hUWI2jzqOJ5DLrl02W5EQjAjdOJyPDEpftn84
	 E5147H5iCSAS3mU7G6pQamSZFrzHlN7Pm+TVB8L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/623] genirq: Make handle_enforce_irqctx() unconditionally available
Date: Wed,  5 Feb 2025 14:37:04 +0100
Message-ID: <20250205134459.361145150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index fe0272cd84a51..a29df4b02a2ed 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -441,10 +441,6 @@ static inline struct cpumask *irq_desc_get_pending_mask(struct irq_desc *desc)
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
@@ -471,11 +467,12 @@ static inline bool irq_fixup_move_pending(struct irq_desc *desc, bool fclear)
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



