Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C446246BCD;
	Sat, 12 Sep 2026 10:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207376; cv=none; b=GhdzX8tDwuB3aYRE70XtDTFOkfJvkOwv1GWF0qXfjjiCAJ4AA5LXM7r4RdY/vpG0b5Zgg/UmitcZQd5XuVSW4llxyGGm9TxhKfnmWzF06xSLLxGQd20MV5/vxXnBniK/R1FGQvzUTtPFJsKy6+tQv3AiCvdkcN06DDFMv8GSZDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207376; c=relaxed/simple;
	bh=r5b5RoSvoQtV4IVI69ENzbPj3wTPov6VzwwITEl+xSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb7Ewo32iIAQEGEGbyd8lWFd++WYo9UHsi22eHFJSvCAwQbQSJqUfvub6L1O57VGuo0dOJriq3QfnQNnnI2ZX9HxPrY2XwifrQkzAucNXAWpLH2n6lz3i4AG13Su7iwovtNtOyoj0pTt6aG2mQMLgbU5Vq/+gmls3SSJFaeQxbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMWtQHrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMWtQHrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E838F1F000FF;
	Sat, 12 Sep 2026 10:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207375;
	bh=BN/8sw7ZqfKjf6U9JktGkT8CQHHa1eJTialJgTmU+GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMWtQHrDfOHd0Jjva6W2Vaa/bqdJOWuph9cikXL9rZWRD1QsNMsbWbUBMdkqjuaCf
	 2kkDiI90aGOfiGQUIOsTw/ZBRHfmdmS5922mb004PBRLkwai12FeDyCjpyDDzz51lU
	 Kk4Llmi58ao3P8OT80efbKoV5OsLSWjXEQTnfzgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0399/1518] irqchip/renesas-irqc: Fix generic interrupt chip leak on remove
Date: Sat, 12 Sep 2026 08:42:48 +0200
Message-ID: <20260912065632.483273610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit 616dd89d81ad9a3cf1cfff4088a4c43e4e00d6ba ]

The driver allocates domain generic chips probe. However, on driver
removal, the generic chips are not automatically freed when the interrupt
domain is removed because the domain flags do not include
IRQ_DOMAIN_FLAG_DESTROY_GC.

This causes both the domain generic chips structure and the associated
generic chips to be leaked. Additionally, the generic chips remain on the
global list and may later be accessed by generic interrupt chip suspend,
resume, or shutdown callbacks after the driver has been removed,
potentially resulting in a use-after-free and kernel crash.

Fix the resource leak by setting IRQ_DOMAIN_FLAG_DESTROY_GC on the
interrupt domain; this lets the interrupt domain core automatically
release all generic chips when irq_domain_remove() is invoked, removing
the need for manual cleanup calls in error paths and remove callback.

Fixes: 99c221df33fbfa1b ("irqchip/renesas-irqc: Move over to nested generic chip")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260708100846.506314-1-fffsqian@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-irqc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-renesas-irqc.c b/drivers/irqchip/irq-renesas-irqc.c
index a20a6471b0e48..1ff3535a4617f 100644
--- a/drivers/irqchip/irq-renesas-irqc.c
+++ b/drivers/irqchip/irq-renesas-irqc.c
@@ -176,6 +176,7 @@ static int irqc_probe(struct platform_device *pdev)
 		goto err_runtime_pm_disable;
 	}
 
+	p->irq_domain->flags |= IRQ_DOMAIN_FLAG_DESTROY_GC;
 	ret = irq_alloc_domain_generic_chips(p->irq_domain, p->number_of_irqs,
 					     1, "irqc", handle_level_irq,
 					     0, 0, IRQ_GC_INIT_NESTED_LOCK);
-- 
2.53.0



