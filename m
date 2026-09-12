Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB2433C18B;
	Sat, 12 Sep 2026 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226551; cv=none; b=Iysfvvwz0ASX1DKUWRrsBf0V4oYZwHoyMx1JFV99XeNak4445nZuR9PXhwGSLk23p5UW7+iqcLJ9bE6g3LoI5lb5OuY9HEf4wABn+p4xnEMUwC+HANN82Y6kmNlWt6EMaKmQ7xArj1cpknxCk6p1RLkuUpglo8cdH9aHvbKOgh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226551; c=relaxed/simple;
	bh=4Q6SZvSiMnCZYg2HmYh2fzI5mcMTSK2WXMEe4U8mh0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs50G00NRCzb1cp/Q1GHg4VrF5ThoCBEJZkrAcWKk32XBrmsNPB5H+JrfGli8MZ1ti0w5HPRaTEHq/OjpQRJl55hscv+nU+PNNIVccYuUvSHSTIXPsrkA4nYHm8MFjxJj+gxTREV1axdsy74VMuEUTY6pgcHFDxj00HjWwHw1/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYWX5D/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYWX5D/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C681F000FF;
	Sat, 12 Sep 2026 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226550;
	bh=KSGlrxLHTzP2/DzLWMTNMBFSke/3TObLeVaW5iNMW3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYWX5D/7bP3erIiIxARebqMqk3h887JRPXjZjZbZc55yHAD6ysDtO/YcThN4S+XqM
	 OyBD1rUkSicrPhRRP6wfUDOCHpsLqDlUd/oFnyGyVmbwMbm/OXG2Ehk1nCz6+h0eEI
	 94QcyGW1FNBPL0FqHg7v/8K2JRhUJpKOJnYamnsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Betkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1412/1424] irqdomain: Make build work for CONFIG_GENERIC_IRQ_CHIP=n
Date: Sat, 12 Sep 2026 09:04:04 +0200
Message-ID: <20260912065638.880774819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8cb2dbf94e44bcde4cff0223f2f900f8fb9083a4 ]

ld: kernel/irq/irqdomain.o: in function `irq_domain_instantiate':
kernel/irq/irqdomain.c:296:(.text+0x10dd): undefined reference to `irq_domain_alloc_generic_chips'
ld: kernel/irq/irqdomain.c:313:(.text+0x1218): undefined reference to `irq_domain_remove_generic_chips'
ld: kernel/irq/irqdomain.o: in function `irq_domain_remove':
kernel/irq/irqdomain.c:349:(.text+0x1ddf): undefined reference to `irq_domain_remove_generic_chips'

Provide the required stubs.

Fixes: e6f67ce32e8e ("irqdomain: Add support for generic irq chips creation before publishing a domain")
Reported-by: Borislav Betkov <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7bbd613c9e5a9..77fb0c510119a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -1174,9 +1174,19 @@ int devm_irq_setup_generic_chip(struct device *dev, struct irq_chip_generic *gc,
 
 struct irq_chip_generic *irq_get_domain_generic_chip(struct irq_domain *d, unsigned int hw_irq);
 
+#ifdef CONFIG_GENERIC_IRQ_CHIP
 int irq_domain_alloc_generic_chips(struct irq_domain *d,
 				   const struct irq_domain_chip_generic_info *info);
 void irq_domain_remove_generic_chips(struct irq_domain *d);
+#else
+static inline int
+irq_domain_alloc_generic_chips(struct irq_domain *d,
+			       const struct irq_domain_chip_generic_info *info)
+{
+	return -EINVAL;
+}
+static inline void irq_domain_remove_generic_chips(struct irq_domain *d) { }
+#endif /* CONFIG_GENERIC_IRQ_CHIP */
 
 int __irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 				     int num_ct, const char *name,
-- 
2.53.0



