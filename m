Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042913;
	b=PHOOPlacN7yHfsDULrEhZvlKIqIZcKTeuGGryEUnlPfvghpeRQFYEF/A30hTWSQZUrUX
	 /qTt63Rwmiek5sg4hNFv7E1ckKRZ0Lvcu/rKU0nwR9XXmW6YxIcTvO3vWfwDBAngM8GD7
	 MT8XCUNi6PbRjiJ135Cyeed8DLMYix0muoNibN/oYMxnS6Q7BKUEvGu32+A0yPDcMwnwt
	 hV4HDWD3m/7y+UfbCgiSEJRHbkXM5ZFYjCwtVwHd3wqn4NJ5P1pOM1wLr0abHn4Ni8qoC
	 Gsoyv+uaAAQ6d76Mw40BPLtV1sY7OV3Ovy/4UG2fVR/0GsbsNxDyFpy19MDQ+UXcl2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vEmTPo+8nPhN44wBeMcjbexoBXoM5+A+KkmcCsUySp8=;
	b=z7n53xIS25YJSS1/FIoCq9HlKdzzMjgKgQhqo7NyVi/hg+4lvhlvaEQzG22pKrOKSBJA
	 YVHSVc1ywei7t7NlzunbKQKKm3jFwzgqH/t0KTVJp8Wj4/rg0VeC8eSOGBQ4ofnX8zZ3C
	 Q2CYW3em7N8cYa4xHbz3TPHiTYr8ITm7m68/zZQrdpZUalLRZ9eobwaTmPW002xdhckL1
	 MBU3nuGF7j9RCXQ9SfKZjdzqvp/yq0M6hzdAPZaaVn+Wsqr1NhLNgto/mq6132dvQsldv
	 lCBmAowMfO6tEEm2FI/HQaf59L3tr5bFWw8YNuqGXc8v0XwDARbWLCRlNMbGoD20Egw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+0UJZ3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EFF606A31C;
	Wed, 18 Nov 2026 23:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+0UJZ3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF67B1F000C4;
	Wed, 18 Nov 2026 23:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042913;
	bh=vEmTPo+8nPhN44wBeMcjbexoBXoM5+A+KkmcCsUySp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+0UJZ3HBSg7Niam5+g6MWVFvbs24OnRB2dTLXm5d4BspjNxkbd5/XiYNhVr5GVp8
	 F+qoPm9BuYSCcClLsdCawz3Xdhwz2I4V2raO1d2QEjAaRm6NIbaXwj6Dzhi98m9V88
	 3jcsy5R94Eio/byXO4zegnKmQ2DLu2dK2Q77N/so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0025/2857] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Wed, 18 Nov 2026 15:17:39 +0100
Message-ID: <20261118150202.267844076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 13856e22217fbf7c1200633716ff87ccb50fd89a ]

When irq_domain_trim_hierarchy() fails in irq_domain_alloc_irqs_locked(),
the error handling path fails to undo the hierarchy allocations.

Add the missing cleanup.

[ tglx: Massage change log ]

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260623075134.4432-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6aea9d25ab9ac..0642efc078c48 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1514,7 +1514,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1522,6 +1522,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0



