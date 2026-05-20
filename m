Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748543A3E79;
	Wed, 20 May 2026 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294502; cv=none; b=NLK9eAEh+DCoyi+5PNUuXJGjRQE3fM6rOjK/yhDC4uGgtqLyA2P9EC0076Na/iXwi+b+oFYlnNaOCz35wjDF/Wm6JE596KI4jxbccQugegMs/0BzeGP5WA8anPtjemw4LTUvhT0HNDRvgc4O3sud+rUMw1cixN7R8WPm2iiUMkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294502; c=relaxed/simple;
	bh=i+bVDtFSsbxDnA3MmBnwTbm3mwg0d45MW6rnKZhUx1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDCtqDITUAA5kSbmP2Frc7+MyIGLCdBxenUztguvtmU4+3xFLn6jZCdmjRz6BCDgNR17xlnEDP67x6Zjaus2g+z/9rgFnXn2piQUYyQcv/FQoHhDXoOWA65jhjKOlV6zjgzjPyiW2cP1QzfwARWyNm66C83IYOuZMG8JW5meNps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9Np7pO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9Np7pO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761411F00894;
	Wed, 20 May 2026 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294498;
	bh=yiDG/VDZw06dnWRYf2cQSQs0O1/65pUD1qBE3QWQQ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9Np7pO5QZcvwzMGhxJB/A2LdQdqBeFUaOG3ksKcjgKlreIeey77OY/veyVxXDw4w
	 6pj8WDIeSxGwJ9IyAGKcviL3LF51ZVAbt3FyNs+tCKduKVLJqo9V+BoMs9FCNClgid
	 VOWCQjIOTwh62UzGM7xJGwk5pvbIz400a782v9dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0062/1146] irqchip/renesas-rzg2l: Fix error path in rzg2l_irqc_common_probe()
Date: Wed, 20 May 2026 18:05:12 +0200
Message-ID: <20260520162149.771080898@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit fb74e35f78105efd8635c89b39f4389f567edbdc ]

Replace pm_runtime_put() with pm_runtime_put_sync() when
irq_domain_create_hierarchy() fails to ensure the device suspends
synchronously before devres cleanup disables runtime PM via
pm_runtime_disable().

[ tglx: Fix up subject and change log to be precise ]

Fixes: 7de11369ef30 ("irqchip/renesas-rzg2l: Use devm_pm_runtime_enable()")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260325192451.172562-4-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index e73d426cea6d3..eb01d4c5aca75 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -577,7 +577,7 @@ static int rzg2l_irqc_common_probe(struct platform_device *pdev, struct device_n
 	irq_domain = irq_domain_create_hierarchy(parent_domain, 0, IRQC_NUM_IRQ, dev_fwnode(dev),
 						 &rzg2l_irqc_domain_ops, rzg2l_irqc_data);
 	if (!irq_domain) {
-		pm_runtime_put(dev);
+		pm_runtime_put_sync(dev);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



