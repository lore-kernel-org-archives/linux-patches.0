Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7134E41B8CD;
	Sat, 12 Sep 2026 09:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204557; cv=none; b=tRiV7b1SkM0NCoFZu23LxiZo5hKjjF2iniP5TLqZht9pVORP8Pit093ELMf2mByjPpgMpyBcv63GK4lGHHzUgLT0PoUEl3c+YC7VvCtp/oaufJSS6s/5R/pTLF9s6UaZE1lpIQJRmbTKv4lH75mTStvPMaH+lu5AksB+S8f1JLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204557; c=relaxed/simple;
	bh=EWibbWcjVXZVEAlUSSOf74SJNYWBMVwSaIoCqTCCzyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL41hP3dk/Mq65UYIgo2WtBHTg03n+74suZBKYFib4+fL/nqvFXBP9uI75LwtT+x+lPsBoxY5EnL+ypQ2hn3DYNaRLErS7IJIvwj3ROVxaEeK99vW8QOO3wboJfnX6PEI9Rms/+nRvGVmcJhwU2ryYDR+PZXdYfPcVuQJX0e640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oushUUHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oushUUHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65CD1F000FF;
	Sat, 12 Sep 2026 09:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204554;
	bh=/7PFcOZJNfL7ptdqJmryhBsyD4p7sVR8fVny25QCT+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oushUUHdIZRgwwxVIlS34kJH+mLtByquawesFCfA1ky6nZJGhK2U6Zf+AV2sVWjdV
	 6OBkSYkitP2LctOXkGg+DvV+lZxej3YYQz+Gg01gWVBI/ZlSKYASkOo96SXn/1dt6w
	 E27ojg1w/ecDML7Joc0qq+HEW5cqQsX7dUsFyMxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1636/1815] irqchip/ast2700-intc: Avoid allocating in the irq_domain activate() callback
Date: Sat, 12 Sep 2026 08:56:26 +0200
Message-ID: <20260912065727.398465065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Chen <ryan_chen@aspeedtech.com>

[ Upstream commit b76eee9c2157223aa4aac42ceebb563288e078aa ]

The interrupt core calls the irq_domain_activate() callback from
__setup_irq() with desc->lock held and interrupts disabled. Both
aspeed_intc1_irq_domain_activate() and aspeed_intc0_resolve_route() test a
compatible string with fwnode_device_is_compatible().

fwnode_device_is_compatible() invokes fwnode_property_match_string(), which
allocates with GFP_KERNEL. That's obviously not possible with interrupts
disabled and a raw spinlock held.

Both call sites are only ever handed OF nodes, so use
of_device_is_compatible() instead: it walks the property in place and does
not allocate.

Fixes: 07825e41519a ("irqchip/ast2700-intc: Add AST2700-A2 support")
Reported-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Ryan Chen <ryan_chen@aspeedtech.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20260819-fix-ast2700-intc-atomic-alloc-v1-1-d92a02e2a239@aspeedtech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ast2700-intc0.c | 2 +-
 drivers/irqchip/irq-ast2700-intc1.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-ast2700-intc0.c b/drivers/irqchip/irq-ast2700-intc0.c
index 14b8b88f1179b..c85b98a19bd41 100644
--- a/drivers/irqchip/irq-ast2700-intc0.c
+++ b/drivers/irqchip/irq-ast2700-intc0.c
@@ -312,7 +312,7 @@ int aspeed_intc0_resolve_route(const struct irq_domain *c0domain, size_t nc1outs
 		return -ENOENT;
 
 	if (!IS_ENABLED(CONFIG_ASPEED_AST2700_INTC_TEST) &&
-	    !fwnode_device_is_compatible(c0domain->fwnode, "aspeed,ast2700-intc0"))
+	    !of_device_is_compatible(to_of_node(c0domain->fwnode), "aspeed,ast2700-intc0"))
 		return -ENODEV;
 
 	intc0 = c0domain->host_data;
diff --git a/drivers/irqchip/irq-ast2700-intc1.c b/drivers/irqchip/irq-ast2700-intc1.c
index 59e8f0d5ddcd2..df6acbafce2d0 100644
--- a/drivers/irqchip/irq-ast2700-intc1.c
+++ b/drivers/irqchip/irq-ast2700-intc1.c
@@ -157,7 +157,8 @@ static int aspeed_intc1_irq_domain_activate(struct irq_domain *domain,
 					intc1->ranges.nranges,
 					intc1->ranges.ranges, &resolved);
 	if (rc < 0) {
-		if (!fwnode_device_is_compatible(intc1->upstream->fwnode, "riscv,aplic")) {
+		if (!of_device_is_compatible(to_of_node(intc1->upstream->fwnode),
+					     "riscv,aplic")) {
 			dev_warn(intc1->dev,
 				 "Failed to resolve interrupt route for hwirq %lu in domain %s\n",
 				 data->hwirq, domain->name);
-- 
2.53.0



