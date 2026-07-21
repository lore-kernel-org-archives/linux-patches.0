Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD2F47143F;
	Tue, 21 Jul 2026 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662921; cv=none; b=C7pvFOlvdVMQFIYeVCxOVgwj1iwS6BfYjnfn8/83u40GvsGfveiAwscrEDuJVsy4SWLqk4oPFF5SzTP9Tpk/gAJ3mw60qFljE1qR/+CKlEcjZU7DoqadlJ/fdIOXMMcBx6gGiWHb+lrXvsVQOf1tIndDkjL4vj5iI97yHkVjNVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662921; c=relaxed/simple;
	bh=VFxeTJbgSYLL2Vlq6z6ON8EU5qV7zHxk4wAdtqgk0Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMDXuZCaPP2KgWBR5sZe4jVX4DRnPgeVredGtbv8vXT6zEIAmxZ/Gfd2BrzmgAQsu37w+UwvKI0Dd5oYHHS89/6P8sr1Hmv5XfZdroHtmez5sw/apBK5vt80Ld/PF2/mvQOEf9oBTkrnIHgHnLvCCqkS2NjWhNKl1yDP4hlM4gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qii9lCUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qii9lCUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8321F000E9;
	Tue, 21 Jul 2026 19:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662919;
	bh=kdv/MRtBD+3aRQ9uChQ9w3C+HUi/a7QqEWhBAsVJyA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qii9lCUeQFsXwBiOky+mAezYaXyrAK10x5je4t1XA/RAtbD95PDEeYRHHN359v3sX
	 TJL6Ykx1j3KNUfogF7qLBGu9oOvaZyC2fxXFDbTN1Z63eeaqp+CO19o80ApCeUbNLW
	 likXCue9MWXwbEzvxvaxTG341/lDg2xUDSbqvj8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0600/1276] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:17:23 +0200
Message-ID: <20260721152459.541745159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



