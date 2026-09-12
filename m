Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA97357D10;
	Sat, 12 Sep 2026 18:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238962; cv=none; b=msd8+mdFjgnfYvVMabONZPaDQymNQhM5Yw9dklzodZXhx+ADCSs+2b0XW8xQ3DzOaiPqvqagB4NVQvb2ayzjutubBF2D0sfi3g3UxSvjhd7y/0W9AOj8ulGgHKqU2I3Niw93F0ToUoubusEaXVWIrO26ThFQywNpU//LuSbIYqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238962; c=relaxed/simple;
	bh=skgMu7pPuhsPzVv5akwYqkz0hrKcVoaXpLUnq0WIQ9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txra60Z4fxm2KVSwsxZnRa7RNNlYJFYAHlkUPpuqFOri2ONjkMaCwnbJpTKUB1tDtNRrJa/KGgQJyEop0ELeXZbT/Dv++8tgQ+/AA5/0Gah1kcb1/2J34cU7FhmIe7feABtxjzB1SuHHezSVx+NS2cu+7Mf2OKTcAObEihJMy0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoQk0FKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoQk0FKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3611F000FF;
	Sat, 12 Sep 2026 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238961;
	bh=wvZvqdtilr9M7JQq6rvCSJwVLNA02AmguP1wOpmDPSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoQk0FKdihC6/3ZDi7Rgx6hn1HuieE2l5hflW7sDai9jAok70JaWVOA0IjzelTQu6
	 91Z/e1gS6+3JjLqCWkX50B4Je796zX8w0AHEINzze4YcOZAfj7ymPAgigoG8EROiLD
	 3IkN8Z7jqmuYDZ1Fr1iUz4rQyo47Ix7Te1PQNn28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 567/935] irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()
Date: Sat, 12 Sep 2026 08:59:57 +0200
Message-ID: <20260912065539.840582806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 540ade8255420..37eb37b89f308 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4464,6 +4464,13 @@ static int its_vpe_init(struct its_vpe *vpe)
 
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
@@ -4542,8 +4549,10 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
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



