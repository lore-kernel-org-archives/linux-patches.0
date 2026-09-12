Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40BF1FCFFC;
	Sat, 12 Sep 2026 14:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223317; cv=none; b=Z7zsilGOIOb0J8aYAVR4d1xOP2dPXggWtiVUK2a2fmdzlLsiD5r1hY7txaSaXqDyLa7tpRhqfrXak/Q6TSw4Dv7UB23u7u91aLTmQxou6lQDyVxtty6ocgeDSaDk2gIcuwVzEnVmbgBfntCRmJlcxEBnA/jnIxkrskIBd27MDlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223317; c=relaxed/simple;
	bh=EEBJSFGHtJMWFd34w4MaTR8o0cRtUBZn0IgXwN/zXH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFt38yBSe3LofaWD9D9qCHoALFzgyIPBjeQRQHelrVgWQJCFgR3knLbpRyYMAO9u1B39QZaXf3SQ+dIifnYvTf2K86O3dfLCNXLVmwprQi2rETtaNdn8b/rQCI1KTnut/o2PJCNGPhgHsFeFzxRuZIkxsq4kU2fVYUBfn3n3VYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGRss2YJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGRss2YJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43541F000FF;
	Sat, 12 Sep 2026 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223316;
	bh=1YwrPKVejGWM9AhFedZA1a8/yYpTgI8mWvgOkyGlN+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGRss2YJ+S2ifoTXvnMaG67BlQYh0NHmN8P9Q1EQ1l1JXbvd8YX6NsSHfKj6wUn0I
	 QB4G7VOyDE1z1Rxtba4YuILUm6JuLQqDQgUEIjP6GzSa+fSqp1osZ6KNZzlxM38xde
	 Um9b7gLug/tYbLMn33TQ/4t76OfDxfT0Ei7HLhlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Herve Codina <herve.codina@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0763/1424] irqdomain: Handle additional domain flags in irq_domain_instantiate()
Date: Sat, 12 Sep 2026 08:53:15 +0200
Message-ID: <20260912065624.383689650@linuxfoundation.org>
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
index 542b1bb78aa83..ea38870641b26 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -260,6 +260,7 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
 /**
  * struct irq_domain_info - Domain information structure
  * @fwnode:		firmware node for the interrupt controller
+ * @domain_flags:	Additional flags to add to the domain flags
  * @size:		Size of linear map; 0 for radix mapping only
  * @hwirq_max:		Maximum number of interrupts supported by controller
  * @direct_max:		Maximum value of direct maps;
@@ -269,6 +270,7 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode);
  */
 struct irq_domain_info {
 	struct fwnode_handle			*fwnode;
+	unsigned int				domain_flags;
 	unsigned int				size;
 	irq_hw_number_t				hwirq_max;
 	int					direct_max;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 80e0477beca2e..ffafc27efe990 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -260,6 +260,8 @@ struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
+	domain->flags |= info->domain_flags;
+
 	__irq_domain_publish(domain);
 
 	return domain;
-- 
2.53.0



