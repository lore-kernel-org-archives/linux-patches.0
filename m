Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C59213D601;
	Thu, 13 Jun 2024 12:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280632; cv=none; b=oBMnA9ayl2gzov2E2WLSgvw/QY8k7zvTqWoHHhlSaCJmBTLLhAXupus+SNzLyzfikRxm8f1RYJXX34vTnxeRXCPl9HMiWoP0wt9omW5ODUjeL3vwJMaDpJkoHGrOhqN9lKKTptiABCIUwkAnEe10OT6tYfuPwnqBiSUNUYeIlmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280632; c=relaxed/simple;
	bh=YYa6FzmPY/ua8sUgtDwKrMYoEraBh3a+PrqtNgVwbX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fpx9vcSb+mMnSOUo+OzbHuNic4PtwXMKWITuBkmhnd/at4LqZk2re9wjlFANxgflQMLQz4ojKB482s/k6idRJkMajOIiEbaywd/fI3gYKn/5Gnp9SA4oFKsH+12+oAV2z2oFWIIxMIaMQwLzyehC7QR0aTWEOGGt8J6e95WH2PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXtAdKqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXtAdKqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14337C2BBFC;
	Thu, 13 Jun 2024 12:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280632;
	bh=YYa6FzmPY/ua8sUgtDwKrMYoEraBh3a+PrqtNgVwbX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXtAdKqJ51GKvCJLymqpXvkSZyT3hqmagUh7FJ0VcZzV0tTCWOMUV21JtGdLIu30z
	 vgjc8gJ3GFStuZBQKjCjVmAcCEsM25UOiFse57p8UyTV8VgnqnkJkk9gE0JkooFVuA
	 nKRDDBIwwdTSM+E0N+vYPoTAjjLWnzGDl4zVH6vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"dicken.ding" <dicken.ding@mediatek.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 120/137] genirq/irqdesc: Prevent use-after-free in irq_find_at_or_after()
Date: Thu, 13 Jun 2024 13:35:00 +0200
Message-ID: <20240613113227.955167134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: dicken.ding <dicken.ding@mediatek.com>

commit b84a8aba806261d2f759ccedf4a2a6a80a5e55ba upstream.

irq_find_at_or_after() dereferences the interrupt descriptor which is
returned by mt_find() while neither holding sparse_irq_lock nor RCU read
lock, which means the descriptor can be freed between mt_find() and the
dereference:

    CPU0                            CPU1
    desc = mt_find()
                                    delayed_free_desc(desc)
    irq_desc_get_irq(desc)

The use-after-free is reported by KASAN:

    Call trace:
     irq_get_next_irq+0x58/0x84
     show_stat+0x638/0x824
     seq_read_iter+0x158/0x4ec
     proc_reg_read_iter+0x94/0x12c
     vfs_read+0x1e0/0x2c8

    Freed by task 4471:
     slab_free_freelist_hook+0x174/0x1e0
     __kmem_cache_free+0xa4/0x1dc
     kfree+0x64/0x128
     irq_kobj_release+0x28/0x3c
     kobject_put+0xcc/0x1e0
     delayed_free_desc+0x14/0x2c
     rcu_do_batch+0x214/0x720

Guard the access with a RCU read lock section.

Fixes: 721255b9826b ("genirq: Use a maple tree for interrupt descriptor management")
Signed-off-by: dicken.ding <dicken.ding@mediatek.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240524091739.31611-1-dicken.ding@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdesc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -148,7 +148,10 @@ static int irq_find_free_area(unsigned i
 static unsigned int irq_find_at_or_after(unsigned int offset)
 {
 	unsigned long index = offset;
-	struct irq_desc *desc = mt_find(&sparse_irqs, &index, nr_irqs);
+	struct irq_desc *desc;
+
+	guard(rcu)();
+	desc = mt_find(&sparse_irqs, &index, nr_irqs);
 
 	return desc ? irq_desc_get_irq(desc) : nr_irqs;
 }


