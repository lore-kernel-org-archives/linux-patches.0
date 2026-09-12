Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FACC366052;
	Sat, 12 Sep 2026 12:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216045; cv=none; b=kgXSSI7WXaPN6EJgrx39F/15NpSD5CSySHTLrLaZfA/8aO0DjrwRcbReWkU4AmMqPCsqlbZUFSK6+qD3eZGtjPdQhp+3MVPfeLnpASr1pvWaXCNyL8gPY+odDAiw6N4eQorrkX2zvHuFgIP/ydHulrJ5nwTrdINrP0rmnQ/Q9No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216045; c=relaxed/simple;
	bh=TNvuvLzP9LQdSkl2tIVIPihpdGJsaurIxO/5zxXB380=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+SsvE3/9VcxtWA33fMJCzLRJeRmq567p41N9+ZGXT/sI5j4vMtiyGQK5j9yNNPExID9hkCuIDUXj4Ypsx3xy1jKZbRTKV1MhGU2zUSP7Vj/d3Md8bzD5iH1aO46mzcMuCQ7jLvEaAh6g503OEhPNG/b1k2xKglkZxPe4i3EKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7gy7qe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7gy7qe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F541F000FF;
	Sat, 12 Sep 2026 12:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216044;
	bh=cVA9Vs9eND/8pnalvuZsDboZpkTZQ9PX4h7EF3R/x9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7gy7qe8oC5AryBWH281Sry83E6bHdcaSY5ndtuhTzKjTijzkaiiPVFs4CYHA2GWv
	 pKb/vLTjow7EFrVmnizMpRROl+uyJFT9OnI1Fx1lQK6/3ptCk4FVe9J9ppaIFvJ5m6
	 zAZc2eUIN1yeiGLee293UaIp/+vN2yD9yExq+KcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0613/1376] irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()
Date: Sat, 12 Sep 2026 08:50:39 +0200
Message-ID: <20260912065621.203255045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 325ff3e78c64cd619d52b99f7c8b09a3f31e1495 ]

When its_irq_gic_domain_alloc() fails, the following
its_vpe_irq_domain_free() fails to invoke its_vep_teardown() for the
corresponding interrupt, which leaks the resource.

Invoke its_vpe_teardown() in the error handling path to avoid the leak.

[ tglx: Massaged change log ]

Fixes: 7d75bbb4bc1ad ("irqchip/gic-v3-its: Add VPE irq domain allocation/teardown")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260721063241.52549-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 7050bf88b87d3..b489594df3294 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4503,6 +4503,13 @@ static int its_vpe_init(struct its_vpe *vpe)
 
 static void its_vpe_teardown(struct its_vpe *vpe)
 {
+	/*
+	 * If vpt_page is NULL, then its_vpe_init() has failed, and
+	 * there is nothing to do as no resource has been allocated.
+	 */
+	if (vpe->vpt_page == NULL)
+		return;
+
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
@@ -4583,8 +4590,10 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 		irqd_set_resend_when_in_progress(irq_get_irq_data(virq + i));
 	}
 
-	if (err)
+	if (err) {
+		its_vpe_teardown(vm->vpes[i]);
 		its_vpe_irq_domain_free(domain, virq, i);
+	}
 
 	return err;
 }
-- 
2.53.0



