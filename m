Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D5D374E6C;
	Tue, 21 Jul 2026 18:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657657; cv=none; b=WCmMEKv3lfyEjxgiv7dpqmnXMss8rAwe/UjQPoMLrKrzvYf4v5RZDgEP9sWyEredisPtU2ciQIp3SdLsvhtWOISl7BFGFK6UgK2PxT3o+++uAbtElqWGZSo1lP24OTS/0ueZcmj5ymMan5Aux4Zo42U/8U8FzYr5cX6m/uVLAoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657657; c=relaxed/simple;
	bh=U/WmZDkXvmYLMVcCDVwM6onZI+0sxIP/fsZt46MLTmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlWoGOF2Y1qJqzwPOUw7Fn/7EKmKgQu8HwQ4uS6Zo7yoEjFErDOga29WYbk2GML0LMX1CY+lRopvFIg5LMYla3q3iCnZiDuWDYBQmlxqJ6kbOjeXokU6VrIomuM7vE/l+i9R8oZhqzn3gZrBjFQJqttP9X8aNZu2W3KoPZBg8s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWWmYEjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWWmYEjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3AC1F000E9;
	Tue, 21 Jul 2026 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657656;
	bh=oUV3mIjCJBmc9WooMzq1dfTzjc9MVvV263lztoTpYE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWWmYEjFassX64NEGSkPo4wmEBCQRh7Nlb2w/x1h1MG4TqNkLsg5N6ZJwTThRnlJb
	 rSBwbiwLNgbBsat8B+V6vX2RPa1TALdJyrbpJUEnliJmJ2H1tpzEivc8j4zrhlyQ1g
	 kOKYaORnQP9g94T1Hs/td98VfyA7PKtzKn39Pfpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhargav Joshi <j.bhargav.u@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0848/1611] irqchip/crossbar: Fix parent domain resource leak
Date: Tue, 21 Jul 2026 17:16:04 +0200
Message-ID: <20260721152534.459226069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 66bb39e24a5217..aaf1823ba43fc6 100644
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



