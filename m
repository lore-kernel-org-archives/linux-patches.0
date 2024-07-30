Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A12818B466;
	Tue, 30 Jul 2024 17:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359253; cv=none; b=N843CDAdQAub6TZTcnOU9Cs1res3MHTZmOMH6nlwoW6ali0SfMrJemt13xM0WDqLjBaYN6j3r/WYE4pcoP0wvYuvPLdKDTRwzi/0Zt4Fa7b9+78sEv/ySXakJjyp2hWN9QjcZzLexWcyZN7QTC3PedMlQ7ORzgpBjBkI8mIvOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359253; c=relaxed/simple;
	bh=Fql3uANjaqYycJtp5pHaOOCv5V8NVW6YgSZw8QYo7HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc48ey2/kfQkjDgpjCf//iiVrlJ0cb9u9cekikQHsTxblEzWX411JBs8cAIv/4XVWHZbQs/qgOh8TYo0GPHs9ho6wfMIrdQ/9GWViU1cjA2SgC4e6cjzM9qvRwH3reggPNQjKziAekr+NGUwRTv4aHhS6Y7G5gShDOOgJoTIFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keKU+sV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keKU+sV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4662C32782;
	Tue, 30 Jul 2024 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359253;
	bh=Fql3uANjaqYycJtp5pHaOOCv5V8NVW6YgSZw8QYo7HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keKU+sV3tEc6/up/G2Y8OUzu6tpajrM7UbAE80Rqo3ZRabv6VzhvXYKwNSeLAvF6F
	 mWbJsJNAxly1FSaBFXnGAZWy3XkzDNvSmt3C01APe7s/MHmqRncoFnsiyOOC+a1lf6
	 1MPj682IWkUlE/086+SUQY1/OkmGPeaN1Nhlft58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 454/568] irqdomain: Fixed unbalanced fwnode get and put
Date: Tue, 30 Jul 2024 17:49:21 +0200
Message-ID: <20240730151657.756262327@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -154,7 +154,6 @@ static struct irq_domain *__irq_domain_c
 		switch (fwid->type) {
 		case IRQCHIP_FWNODE_NAMED:
 		case IRQCHIP_FWNODE_NAMED_ID:
-			domain->fwnode = fwnode;
 			domain->name = kstrdup(fwid->name, GFP_KERNEL);
 			if (!domain->name) {
 				kfree(domain);
@@ -163,7 +162,6 @@ static struct irq_domain *__irq_domain_c
 			domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 			break;
 		default:
-			domain->fwnode = fwnode;
 			domain->name = fwid->name;
 			break;
 		}
@@ -183,7 +181,6 @@ static struct irq_domain *__irq_domain_c
 		}
 
 		domain->name = strreplace(name, '/', ':');
-		domain->fwnode = fwnode;
 		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 	}
 
@@ -199,8 +196,8 @@ static struct irq_domain *__irq_domain_c
 		domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 	}
 
-	fwnode_handle_get(fwnode);
-	fwnode_dev_initialized(fwnode, true);
+	domain->fwnode = fwnode_handle_get(fwnode);
+	fwnode_dev_initialized(domain->fwnode, true);
 
 	/* Fill structure */
 	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);


