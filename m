Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3FB1714A1;
	Thu, 15 Aug 2024 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730146; cv=none; b=FFnwYbMRecpCBwo6S3gghMYX16HwOiNtwviP//xd+IYoTtwMWKU5zJ9XOcL1heIk4rd4xCUapFJw4iB3TNglbqyclqXsVJ34GFw/UjmAxrMvx6Qg6mb8cPUUSQjx1L9GCiILZIAbmu2vHetmaqmM8MGWj5JfyxbwZndlVTEOsJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730146; c=relaxed/simple;
	bh=JtD3ek2HPjFv86H31UL7qZgkkQI3AN/q5VkceHLyGxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlQChByvzkVHOkDwLOuUUWDJjn+UcfQi+2tzs8hYxNyCfYyHpSZmgLnn0IVs4o9JceO2yAyVSyjqi7xO8w1e/IyTJZZo8EQg/ARPkTh1BcRLFWTs6KyJCNTofVqa7VQ8Yf8KocEagLSKhNfE0v/fAOWQJnciynxnZlkGSrVWPoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzw7ARO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzw7ARO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D648BC32786;
	Thu, 15 Aug 2024 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730146;
	bh=JtD3ek2HPjFv86H31UL7qZgkkQI3AN/q5VkceHLyGxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vzw7ARO768Ra4bg+K8qBOW3WYQhrhBelNcvtuQVJ6wL2FUkubr/XzniYeJ/Vb8ETy
	 rRKTrZR3QoUhY9/eQpz2FCsxgjgKgC3y7dmeMll0WaYJ8i/H+n2dux5tt3GLhltXky
	 /G9J4T4VXjbeoVSBJhITVS9ohD0bFAeljvpXPZ8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/484] irqdomain: Fixed unbalanced fwnode get and put
Date: Thu, 15 Aug 2024 15:22:55 +0200
Message-ID: <20240815131953.650858241@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 6ce3e98184b625d2870991880bf9586ded7ea7f9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -153,7 +153,6 @@ static struct irq_domain *__irq_domain_c
 		switch (fwid->type) {
 		case IRQCHIP_FWNODE_NAMED:
 		case IRQCHIP_FWNODE_NAMED_ID:
-			domain->fwnode = fwnode;
 			domain->name = kstrdup(fwid->name, GFP_KERNEL);
 			if (!domain->name) {
 				kfree(domain);
@@ -162,7 +161,6 @@ static struct irq_domain *__irq_domain_c
 			domain->flags |= IRQ_DOMAIN_NAME_ALLOCATED;
 			break;
 		default:
-			domain->fwnode = fwnode;
 			domain->name = fwid->name;
 			break;
 		}
@@ -184,7 +182,6 @@ static struct irq_domain *__irq_domain_c
 		strreplace(name, '/', ':');
 
 		domain->name = name;
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


