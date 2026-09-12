Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1736B923;
	Sat, 12 Sep 2026 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238749; cv=none; b=Rqr1FPtgQWVr0BytUJIvX+CoWVWDNtvkYcAbiOUicIUFdT+412fqA1Le+PLmX2YVmNRXIf7Hwth24NC4aQ8Dc0hPJdiAVyNu1Eqpsu0tx7DVr34uUqz4uhVyZrPEujk+55eKI6ZDZF1/uJlON/FMpMTcnh2PyuzeU89/jZ4KTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238749; c=relaxed/simple;
	bh=IybKGnoDQCWdAPUoScy7hXAcZDKuQ/YKKpCekC7FOsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuZxwneztKZCfzcTBRkhOySYYVy+6I7hmPaH6DlVbZ1w7y017Q9mffR7zvzOAs6YCuLz2yinfu1e48lb4UPRpnsWIY/ZyoQU7AWRh2Bzfr1xsHv7ySGd+e9fc5N/VlgXqDrbZmAZue0Zq9h100nZhZOCFKpzvjhyZQiS6f4TVQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PP0tYsut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP0tYsut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E151F000FF;
	Sat, 12 Sep 2026 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238748;
	bh=4k/21nubaSAdg8HePUCuH/y6cDVC74n5VIsB+4EJu+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PP0tYsutBprVhZM4owTkDA0S2R38ZIH6l6cBV9RRUgBkr3i4XIk7MfrgiQnOCgKim
	 lTR6okQ1pCbW6O8OhB59sfJ8OMI80FivKOhF0Gw00i3cNGj2re6htH60CsUBvCSCX/
	 WhMhkljDLEvd+Fh3+9ep/x+umiIZNveqwKNTD2pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/935] irqdomain: Handle additional domain flags in irq_domain_instantiate()
Date: Sat, 12 Sep 2026 08:59:14 +0200
Message-ID: <20260912065538.841293497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 757398541c30a5e898169763b43f08dab71ea3bd ]

In order to use irq_domain_instantiate() from several places such as
irq_domain_create_hierarchy(), irq_domain_instantiate() needs to handle
additional domain flags.

Add the required infrastructure.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240614173232.1184015-8-herve.codina@bootlin.com
Stable-dep-of: 616dd89d81ad ("irqchip/renesas-irqc: Fix generic interrupt chip leak on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irqdomain.h | 2 ++
 kernel/irq/irqdomain.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index c3ef4ce5c9f80..43d25fd4d37b2 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -264,6 +264,7 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
 /**
  * struct irq_domain_info - Domain information structure
  * @fwnode:		firmware node for the interrupt controller
+ * @domain_flags:	Additional flags to add to the domain flags
  * @size:		Size of linear map; 0 for radix mapping only
  * @hwirq_max:		Maximum number of interrupts supported by controller
  * @direct_max:		Maximum value of direct maps;
@@ -273,6 +274,7 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
  */
 struct irq_domain_info {
 	struct fwnode_handle			*fwnode;
+	unsigned int				domain_flags;
 	unsigned int				size;
 	irq_hw_number_t				hwirq_max;
 	int					direct_max;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7ae53e4534cee..c6152a6942e6e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -253,6 +253,8 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
+	domain->flags |= info->domain_flags;
+
 	__irq_domain_publish(domain);
 
 	return domain;
-- 
2.53.0



