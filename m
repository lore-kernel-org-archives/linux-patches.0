Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D713B52E7;
	Tue, 21 Jul 2026 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672096; cv=none; b=IeVITswePonrYu1w/B9Ckq1LzaLG1I79bQ89ro71lynf3aG6rwmAXKNIi0b5XlsaZJp5WqwY0Y1CvjD1+1jLh/Y/QE63p+RRwYZyqt2sqjJ21vha91+OpV49Kd+Lego0tPnE66OCfsIJ6uCLcFmBKByp8mxy80bNtNOMJ5naKqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672096; c=relaxed/simple;
	bh=a41dpg+5lXLY1DoocpSPvzvxgSBEq9S5xjF+8qqYbMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCTygbuQN2AooCZBRwOJjvwybvKTL4ZUIlG2nSXhx+2V1ACgWftst2eqG+WivhX9WTAnOZqijd8aN2PaxkhR8SLK8YYQV2x2GWoAaNNBe4ItgQ+ICBmZehik4UM3t3TAISpDd5I/Oh9HThNAWOuWXC6g35wsB1mrtTXzGovFE+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CS0oTlWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CS0oTlWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65ECF1F000E9;
	Tue, 21 Jul 2026 22:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672094;
	bh=UiqP+HaqoX33ao40iydf/itj1SB3dehn3F271Kwv13o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CS0oTlWqfu8JtIFBHPj4BVDyTfyDzY4Em8f7/C4YqweFQ0TW8/F29dRKT0mgJkAFF
	 jeQ7AtWXwKi6qMOORWFd0Nem0/UUEDsuSSR8Cm+fYd9Estw2PH91F2knsbJMnachun
	 IqqbDh5qx4/wL+VG22uKEgK/bNR6xV4P7bJNwrHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/843] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:21:28 +0200
Message-ID: <20260721152416.218305455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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



