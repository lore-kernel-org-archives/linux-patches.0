Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431123AEF58;
	Tue, 21 Jul 2026 22:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673934; cv=none; b=oTk1tN/r46cLDvqrSNk6r8c/WE1UTnWzwp833t+f7igd8dNOb8/5cK6kGg2cqgsV901VCMcowMHEc8ToTYdQIaMMS44QbWz7/hx8shcRWk/uXFf/DQzAiM7F6UHxgYbF9mvrmccD/zNjsoEEkXW/WgnSur7rh4aqT9OqpkiKFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673934; c=relaxed/simple;
	bh=3hWqZkFIUTl/mUm3n58JwWv6FJGhiGJzrxa/Kr+cAx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvgenHRuwz7K5TQPbfOBARq+gttE8bg2kbN3mQN3NYvD1rDY6vuqfPlobT0vHUOnZTCvM8KN6sAI4hKVZEZj5Wd7av1AxuFaxpfcomqvf9/eUNyIBeQKOUMxv0Ame4HKrnWPB4JTNT/ieMG9+swWNXWhOmcLwJtwqejyxAL1zFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4451q7f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4451q7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A341F000E9;
	Tue, 21 Jul 2026 22:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673933;
	bh=7WjJM4iIX3tIeDdWHpcKtIpoDJ2j+NokLupnQiDhF4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4451q7f1tnPycAAC/oj/5xzduQ3lXMxuv+Q0zwyAFaFdWO0qsJVJjYvsWzbSlotW
	 4IrvoLxH3xcQuyOzRv6ndQMyMl+jTMmV/5bEPzk7I8NK9xdCgd1Ryy1MAJ5tzgroBN
	 /1Zl4pOaLMnde5nJgpT6rePHpOnCl7vk/gcllRHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/699] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:21:48 +0200
Message-ID: <20260721152403.566604887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Bhargav Joshi <j.bhargav.u@gmail.com>

[ Upstream commit a1074dd62faa6572921d387e8a21589ccea00efc ]

irq_domain_alloc_irqs_parent() is called in allocate_gic_irq() but
irq_domain_free_irqs_parent() is never called which causes a resource leak.

Fix this by calling irq_domain_free_irqs_parent() in
crossbar_domain_free().

Fixes: 783d31863fb82 ("irqchip: crossbar: Convert dra7 crossbar to stacked domains")
Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260620-irq-crossbar-fix-v2-2-b8e8499f468a@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-crossbar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index a05a7501e10790..729492772ff46e 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -163,6 +163,7 @@ static void crossbar_domain_free(struct irq_domain *domain, unsigned int virq,
 		cb->write(d->hwirq, cb->safe_map);
 	}
 	raw_spin_unlock(&cb->lock);
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
 static int crossbar_domain_translate(struct irq_domain *d,
-- 
2.53.0



