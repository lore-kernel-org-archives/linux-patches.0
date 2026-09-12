Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE0432A3DA;
	Sat, 12 Sep 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223322; cv=none; b=k8ktlrnUUjKd80gX3ED/7dmQ8k0ITEdt3FowIlgMpz7ooYnwAUhg8Q1oSBLMlvpGBU1Fy6+XkQcJpLI1WweEUGgkFOoplxlEUZlMWHtrj/9LikOLMMpOH5IhP8dl1Gdc1M41KdpGevbcAuVzAltySEosbrJ8SDebDjgtdvla4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223322; c=relaxed/simple;
	bh=WFvo9BSFFWkBK7zj/+4urwkni6PQAx30rjdX3fHnEAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/MhLW3ubRijIsRf7O3vtOa5a/pJllxItZ73ZVJea0LYD0k+95H+3glLdn10WgN6fI7uo3zcrUefEiAUqBZzMLpEuyzGDYZ6NfrgSvR1N2axntStX8Y8DwRdb3MaDcgyxi0GE+AB1M8XNBVtU1WDg11pCQf2NEvbB7bQCbJcmw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynY//lQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynY//lQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7787D1F000FF;
	Sat, 12 Sep 2026 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223321;
	bh=N5GI/ZG5UbKSm9x4OXQTCC5hAj1+dnA853rqXl+k2XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynY//lQRll7FPMvpkIqbZV1j82PznrxDsGm4iHnLz4ud6uDUZg/IIC7k+1CN95TZb
	 TaQNbkHhDfBAiLmZ7/9NPU2gEpntdpf+97/C63JV2MlgMQTrDYmUx0AlEAnHvpZnzc
	 3ezmtQDM9fFANkHqz4li+shYQaQzGULJlnRRnE0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0764/1424] irqdomain: Handle domain hierarchy parent in irq_domain_instantiate()
Date: Sat, 12 Sep 2026 08:53:16 +0200
Message-ID: <20260912065624.405351555@linuxfoundation.org>
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

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 419e3778ff295c00aa158d9f2854a70b47ba1136 ]

To use irq_domain_instantiate() from irq_domain_create_hierarchy(),
irq_domain_instantiate() needs to handle the domain hierarchy parent.

Add the required functionality.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-9-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h | 6 ++++++
 kernel/irq/irqdomain.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index ea38870641b26..a2a55882253b7 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -276,6 +276,12 @@ struct irq_domain_info {
 	int					direct_max;
 	const struct irq_domain_ops		*ops;
 	void					*host_data;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	/**
+	 * @parent: Pointer to the parent irq domain used in a hierarchy domain
+	 */
+	struct irq_domain			*parent;
+#endif
 };
 
 struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index ffafc27efe990..6ff6c6e11aa0c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -262,6 +262,13 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 
 	domain->flags |= info->domain_flags;
 
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	if (info->parent) {
+		domain->root = info->parent->root;
+		domain->parent = info->parent;
+	}
+#endif
+
 	__irq_domain_publish(domain);
 
 	return domain;
-- 
2.53.0



