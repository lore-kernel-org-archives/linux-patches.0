Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F33345EB5;
	Sat, 12 Sep 2026 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242659; cv=none; b=RWX7BvC+uhKhp/yq9LL64U3B/gmkHpGYlus9/7lkUKGTJR8UMVfQ58YaCngDbl4tUUftO1ufbzJWf0INy8MqnF1jJp0jkTREF9uCex5ESB4Z7nCSy65ZlU/03ANHtViwln1ArPVWk2WziK+DivaPGOu3HCeqiDsZFxptV3R2+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242659; c=relaxed/simple;
	bh=Iu9uRs7y3rFBJI4UtKRBgu7x3SwjpxkE/eDeDAT1DE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFmHWM2ryJtfmfvG1NrApiyI0sQ2BM/i47iPaYpqF1gb4gQRbUQKQefozymlYfK0wa/ys0VS8L60ewFXG2QciJG8e+i7E6AgMrMMbgdTuMyd5WbCVp4cJNjBWanaIcbXxJNAqockEmqILUda/B0cjF7iBM+2vlNab6IW4ftinF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NW87zgOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NW87zgOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F2E1F000FF;
	Sat, 12 Sep 2026 19:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242657;
	bh=CJ9QMnMnvyuh62z0jrzfruOO+CMEAwLfBh1Si5wXX+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NW87zgOxy89RdEMxCQ/DhTtK9YhJQm+6uoz2lhTs4e82j3mFmF0oPSNKSwmWR0Y7M
	 WYLARcGZNT8hhEB4bRnaM0khsCx7ao0JtfNM9t3u/rbOKdguAIoYXMJ/zn3u6HM8WH
	 rUYUbHfKLXpiYHBtRDqzGL4wO6WbB5UkBTtKc2yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/798] irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()
Date: Sat, 12 Sep 2026 09:01:50 +0200
Message-ID: <20260912065528.189416206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 04b89f345c77c..b828737487bf0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4444,6 +4444,13 @@ static int its_vpe_init(struct its_vpe *vpe)
 
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
@@ -4522,8 +4529,10 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
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



