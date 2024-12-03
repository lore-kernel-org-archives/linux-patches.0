Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CBC1F130F;
	Tue,  3 Dec 2024 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239504; cv=none; b=DVGrJqY1pWpvdXFaIrv+KyO8pDcKPpC4GnZEKiEt70tSHy/WLb7H4KuMdHzXvbADkvoKKT4Z4107c77a1ruzKXlNLsPwZjPFIYdoGsk3S9HxZJJPVMQ7Hz2nMluM5h2BP29w+QQnyLG4nw7jFBtC5hw+e6zYelUmfSCPoVrZgt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239504; c=relaxed/simple;
	bh=HiMwcGwMMXkFO52suO5fHY/9FyRFeQQNCJnvUyOU0gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JN95mNUSAK50z3cO61tpxhNqLEG7Gf+FdQNsXekph90HSDgfFYGWSuH4py/Jm3lSkzIr8ATdjiBy7/E7MGlKo/ScOMTTJA6ViGa8UB+UO7o8YTcf5kRLMvY5unBpX92qqWasRK/ZLsJ/kvz5UyCpAcYrzXqiwxIO4pquVW/o+oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3O9OO5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3O9OO5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37502C4CECF;
	Tue,  3 Dec 2024 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239504;
	bh=HiMwcGwMMXkFO52suO5fHY/9FyRFeQQNCJnvUyOU0gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3O9OO5shAKw5xd6jkoldyG6jpG9u2LHw1x8HqM2IftZBGn6H8EhczwKCsWqeCLjV
	 76rtKIEDcu/kDkvMKxIBqxTWl7Vf0ea6K1qLDZZKxSU13BNpWsjC5RChTQ88SZXYXg
	 woU94BARiSdVEYTxelhTE3yocMSvtg7cM7f2Bwjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.11 636/817] irqdomain: Always associate interrupts for legacy domains
Date: Tue,  3 Dec 2024 15:43:28 +0100
Message-ID: <20241203144020.767902982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 24d02c4e53e2f02da16b2ae8a1bc92553110ca25 upstream.

The unification of irq_domain_create_legacy() missed the fact that
interrupts must be associated even when the Linux interrupt number provided
in the first_irq argument is 0.

This breaks all call sites of irq_domain_create_legacy() which supply 0 as
the first_irq argument.

Enforce the association for legacy domains in __irq_domain_instantiate() to
cure this.

[ tglx: Massaged it slightly. ]

Fixes: 70114e7f7585 ("irqdomain: Simplify simple and legacy domain creation")
Reported-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Link: https://lore.kernel.org/all/c3379142-10bc-4f14-b8ac-a46927aeac38@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -300,7 +300,7 @@ static void irq_domain_instantiate_descs
 }
 
 static struct irq_domain *__irq_domain_instantiate(const struct irq_domain_info *info,
-						   bool cond_alloc_descs)
+						   bool cond_alloc_descs, bool force_associate)
 {
 	struct irq_domain *domain;
 	int err;
@@ -336,8 +336,12 @@ static struct irq_domain *__irq_domain_i
 	if (cond_alloc_descs && info->virq_base > 0)
 		irq_domain_instantiate_descs(info);
 
-	/* Legacy interrupt domains have a fixed Linux interrupt number */
-	if (info->virq_base > 0) {
+	/*
+	 * Legacy interrupt domains have a fixed Linux interrupt number
+	 * associated. Other interrupt domains can request association by
+	 * providing a Linux interrupt number > 0.
+	 */
+	if (force_associate || info->virq_base > 0) {
 		irq_domain_associate_many(domain, info->virq_base, info->hwirq_base,
 					  info->size - info->hwirq_base);
 	}
@@ -360,7 +364,7 @@ err_domain_free:
  */
 struct irq_domain *irq_domain_instantiate(const struct irq_domain_info *info)
 {
-	return __irq_domain_instantiate(info, false);
+	return __irq_domain_instantiate(info, false, false);
 }
 EXPORT_SYMBOL_GPL(irq_domain_instantiate);
 
@@ -464,7 +468,7 @@ struct irq_domain *irq_domain_create_sim
 		.ops		= ops,
 		.host_data	= host_data,
 	};
-	struct irq_domain *domain = __irq_domain_instantiate(&info, true);
+	struct irq_domain *domain = __irq_domain_instantiate(&info, true, false);
 
 	return IS_ERR(domain) ? NULL : domain;
 }
@@ -513,7 +517,7 @@ struct irq_domain *irq_domain_create_leg
 		.ops		= ops,
 		.host_data	= host_data,
 	};
-	struct irq_domain *domain = irq_domain_instantiate(&info);
+	struct irq_domain *domain = __irq_domain_instantiate(&info, false, true);
 
 	return IS_ERR(domain) ? NULL : domain;
 }


