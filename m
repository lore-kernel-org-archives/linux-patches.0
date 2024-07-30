Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664901A76BA;
	Tue, 30 Jul 2024 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360366; cv=none; b=IypgwZBvk8/UM//dI9vK0x9JdER5deRDFgn9qbtgUh/ene0l4wd5n75CW+86cnhSYn+70EcJ8LnSm/wD3XvFxdTJ5m8JPSDKT2oD2diz7FPGPJjVhBOfhGn4GiENlw9IYQtAlGeYSEQcYwY2ayanDvL9+iuH2xgnvPERjtMv7mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360366; c=relaxed/simple;
	bh=WPKffu0ibB/7NUGxrEHGxwNdTiiQQZfVtgJzEIlrAAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWdLmiBjikUCiG66Th7bKtQOa1koNtyNEZ5HH7S2j27Ou7JvA1Mfwnrj6yrV/PDEzjDU671EOdfTqHvmN39crSaeCf69L0nflpvJ4nrPZwA6sOOS9g6plSgmfQjY01RO+sgQ2yJ+zfq0zJdS9Wtf71p1zxeRtshahosa0oXqmi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MB9Fk682; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB9Fk682"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3694C32782;
	Tue, 30 Jul 2024 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360366;
	bh=WPKffu0ibB/7NUGxrEHGxwNdTiiQQZfVtgJzEIlrAAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MB9Fk6821GO2WOb0h2RuaYHPtUZvjwXYr5gGYTaS/8N252sxF4cHd8jtq0Wa9A5wH
	 57l2ErdO48+SoUqs3Qymo3HtXi99VFRQnWfktfr/Rvnuwcy60AS07oVw6G/EkzhMzv
	 7vbaARU6XeasMXdIhC4JuUnd7l63nfjZRekDRnRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 677/809] irqdomain: Fixed unbalanced fwnode get and put
Date: Tue, 30 Jul 2024 17:49:13 +0200
Message-ID: <20240730151751.643516823@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 6ce3e98184b625d2870991880bf9586ded7ea7f9 upstream.

fwnode_handle_get(fwnode) is called when a domain is created with fwnode
passed as a function parameter. fwnode_handle_put(domain->fwnode) is called
when the domain is destroyed but during the creation a path exists that
does not set domain->fwnode.

If this path is taken, the fwnode get will never be put.

To avoid the unbalanced get and put, set domain->fwnode unconditionally.

Fixes: d59f6617eef0 ("genirq: Allow fwnode to carry name information only")
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240614173232.1184015-4-herve.codina@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -155,7 +155,6 @@ static struct irq_domain *__irq_domain_c
 		switch (fwid->type) {
 		case IRQCHIP_FWNODE_NAMED:
 		case IRQCHIP_FWNODE_NAMED_ID:
-			domain->fwnode = fwnode;
 			domain->name = kstrdup(fwid->name, GFP_KERNEL);
 			if (!domain->name) {
 				kfree(domain);
@@ -164,7 +163,6 @@ static struct irq_domain *__irq_domain_c
 			domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 			break;
 		default:
-			domain->fwnode = fwnode;
 			domain->name = fwid->name;
 			break;
 		}
@@ -184,7 +182,6 @@ static struct irq_domain *__irq_domain_c
 		}
 
 		domain->name = strreplace(name, '/', ':');
-		domain->fwnode = fwnode;
 		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 	}
 
@@ -200,8 +197,8 @@ static struct irq_domain *__irq_domain_c
 		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 	}
 
-	fwnode_handle_get(fwnode);
-	fwnode_dev_initialized(fwnode, true);
+	domain->fwnode = fwnode_handle_get(fwnode);
+	fwnode_dev_initialized(domain->fwnode, true);
 
 	/* Fill structure */
 	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);


