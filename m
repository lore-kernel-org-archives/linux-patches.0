Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CB92877E8;
	Sat, 12 Sep 2026 16:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229841; cv=none; b=NekzlrdfPoEwu01Kt2bMdERqUWfCwzLYgNYfsdv2UKVe64K3hnky3MvIPPeKD29rLc7hv+qavtq4H86o8UPCVaNVkiIcMKGYyitG3m7gW9ksgoqti44xSLMPP+Z75dR+72l5AAsYfuCriYtX235Zt8xReffFBmSd2p+zXFF9lc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229841; c=relaxed/simple;
	bh=CeEbzY320K1OU9m0+4Cl7/BjML0tJpeech5oxt12crY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMn46yofOzqt0GxlXuhLsT4UakgcLIuxNgSJ0RYfEk/U0uFnyhq7WC7YVdWaY2xlFdocvXORnkl+QsgvIN7AB8ASzkGhm4Gzc0PJ2qoGaFVY5wGL9XonzxxSxVsTQv8eYPwUZFu0pOnRduk5w10YHRzKnJHxlhZ/jiYx6pO59r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwMUQZP9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwMUQZP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A381F000FF;
	Sat, 12 Sep 2026 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229840;
	bh=w1Spdi9Jp9ilinP03cbpxKjbSEJQANBtP8n4gyWNrVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwMUQZP9l/asrYDtH4bBinGEFHy+vMkY/ohQceS8hIKKMZM2I71GnDkUCjIDnW+cU
	 GtBeCkLX/azh5VvQ+eFVgrHEdKVdwVV6y7H0HvtYQ5qgONZzunqB+4mFXlVKT/il+t
	 PVmrrYOI/XQatyxBQ9h/Y1P+PS+uMJ3/ZzU0Ae6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0672/1191] irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()
Date: Sat, 12 Sep 2026 08:56:40 +0200
Message-ID: <20260912065603.350687645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4ea52b26f9f8..84b00e14860eb 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4449,6 +4449,13 @@ static int its_vpe_init(struct its_vpe *vpe)
 
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
@@ -4527,8 +4534,10 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 		set_bit(i, bitmap);
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



