Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0B02309B3;
	Mon, 10 Mar 2025 17:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628651; cv=none; b=P8im5YLDug0jJnr5+fyXGmr+BnKKfhklFUVlPu/0b1YQFzV37bXZjjZhYc1wv1EkNiJXIzOkwMCH+1gQ4CQG/0kdoHFEAoJcUXSBvdcmVcpXR7OerwRic8CWUvV7Qrp1nOH2jwKKQMRN7WyzRXLiH7UHCJLxdvDW9wlv4fsBUZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628651; c=relaxed/simple;
	bh=msXZn7RNtu67hYyJIDsuRp2grTSEyyFgl9Et/0ULDMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9GOqbt/4x6Td75tG0sfOv91tjT5i7iliYZuFRgFtYYr7O2qJzNFS0gT1CSoFGVgunDoVcyfLcPObHtFzHOB7YSjFGErPbHMLDbRPHtSNalDAJdYluwLEbLCvVdOFt4Uwslz9iv6bbA/Dk6MvM9B47TMWWOFTLPNZXiEtSRZTB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xulceqxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xulceqxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3C5C4CEE5;
	Mon, 10 Mar 2025 17:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628651;
	bh=msXZn7RNtu67hYyJIDsuRp2grTSEyyFgl9Et/0ULDMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xulceqxPR4D1PHBLfHnDnQFYy21j+3sTBhzNvUPUinyT0HW02Wqr7J8BG12rcdg5d
	 tycb+Cmuz3cr0vhQIJa7pijHZZlUia1z9KD3EzwlFMrZRrwy7bZti2liMNUmMGJZIN
	 EFSVtYvMxIDKN5ORGMYBxx6CmoTUMxFIhgoIU7Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/620] genirq: Make handle_enforce_irqctx() unconditionally available
Date: Mon, 10 Mar 2025 17:57:48 +0100
Message-ID: <20250310170546.450513506@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



