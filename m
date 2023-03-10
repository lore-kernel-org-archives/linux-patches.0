Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FD18821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89351C433EF;
	Fri, 10 Mar 2023 15:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460547;
	bh=cf7Y2M9VYQEyJ+TV0DCwDQW351JEYE2Da3ijU/YZfIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLfOIfFmqKyZXu9Fd0RrX916MVVuHl6a/t8RKyMXm+pOoLTafCZpt73LJTB6ZvXjm
	 TbSCfIw3QNliq5bSxQRj4QEy+qhP+em5PWO88j5KPTgod047x+ouTY9idcGNeXXPtW
	 4ZC54vdq6mPwNW4kPwO3oDUyTOW/Al8RXgkAI3iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 371/529] irqdomain: Fix disassociation race
Date: Fri, 10 Mar 2023 14:38:34 +0100
Message-Id: <20230310133822.178907750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 3f883c38f5628f46b30bccf090faec054088e262 upstream.

The global irq_domain_mutex is held when mapping interrupts from
non-hierarchical domains but currently not when disposing them.

This specifically means that updates of the domain mapcount is racy
(currently only used for statistics in debugfs).

Make sure to hold the global irq_domain_mutex also when disposing
mappings from non-hierarchical domains.

Fixes: 9dc6be3d4193 ("genirq/irqdomain: Add map counter")
Cc: stable@vger.kernel.org      # 4.13
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -495,6 +495,9 @@ void irq_domain_disassociate(struct irq_
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -514,6 +517,8 @@ void irq_domain_disassociate(struct irq_
 
 	/* Clear reverse map for this hwirq */
 	irq_domain_clear_mapping(domain, hwirq);
+
+	mutex_unlock(&irq_domain_mutex);
 }
 
 static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,


