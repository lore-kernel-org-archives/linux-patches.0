Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831721FBEA6;
	Sat, 12 Sep 2026 19:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242556; cv=none; b=s4eul0yaW2gPAKJC3foG1xgEP0dTANi4DO1w88V39OL384B2SpJSgR1TxabwAryUIvKnFSgqrbksAMogKyrRgNj1bf7enAtJwBT/oStMmTOQWz6XXcDihG/LmRT1JwN9Q8C4OZZSQ8AiNH8Tpdrlh9kGdfjxS+AaH4VHwlKFMTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242556; c=relaxed/simple;
	bh=ar5KHeUIgk5D/ehU0NddJiyAztwRVhxN2PNobgN/xQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oP40JrOaTThqNEmOoAxFn3t0vsAbFTFUErvfzzk/4br2RJ2Xgl+gDXAmSM9tmJePlbo4566jRfjvPPIIg9nT5W40wVPXCxMlBoEMBr1vyfDEXC3I4n8pDZhNG1JbcTyDMHbmK04HtESA5I1AI8kwe3/WWsUS7csc7S2cuqrpAf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdhSDAyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdhSDAyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8891F000FF;
	Sat, 12 Sep 2026 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242555;
	bh=UKwzVWu93DNcRJEVhw812znfWDQRQFnbDSIMScWgYIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdhSDAyyDrCQAgX1AOZkW5QIRUYzIswfdZKPuInFvdkV4bU5AjmMcrbZZe2zAVDab
	 8Qqq6jeTM/QyY8GYUuxzN706kVKI4lonygzdWm6BJ0KjY2AfnlvPVWM1pafYid/zeo
	 MiFghdJX4O2hXhWABM8opXFYCe5L7mDrr+ChPXXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/798] irqdomain: Handle additional domain flags in irq_domain_instantiate()
Date: Sat, 12 Sep 2026 09:01:13 +0200
Message-ID: <20260912065527.339558116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 32fad6e260832..4d253628be786 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -269,6 +269,7 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
 /**
  * struct irq_domain_info - Domain information structure
  * @fwnode:		firmware node for the interrupt controller
+ * @domain_flags:	Additional flags to add to the domain flags
  * @size:		Size of linear map; 0 for radix mapping only
  * @hwirq_max:		Maximum number of interrupts supported by controller
  * @direct_max:		Maximum value of direct maps;
@@ -278,6 +279,7 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
  */
 struct irq_domain_info {
 	struct fwnode_handle			*fwnode;
+	unsigned int				domain_flags;
 	unsigned int				size;
 	irq_hw_number_t				hwirq_max;
 	int					direct_max;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 21884956af569..b318826c8a415 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -227,6 +227,8 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
+	domain->flags |= info->domain_flags;
+
 	__irq_domain_publish(domain);
 
 	return domain;
-- 
2.53.0



