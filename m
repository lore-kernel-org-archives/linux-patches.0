Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445F79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A73EC433D6;
	Wed, 30 Nov 2022 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833114;
	bh=7BsYg0Wu24udDsEfeVOVwU5rmbccxKV3SpG0/Fd7mGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn9SejUhZtI4LLcDo+mHjB4hHCeRhb7aEyfe2QNy6Bx++0/DU7tq2i9xWB0awQP9B
	 0GO6ESTiHZRTBqFqywygU8k/BpvFa+0a62zgHBkFGWv/BSaxpyqRRJa5stsxu0WizD
	 BQ5E8ZKKJK0+BHXeAt5J0Tjte+EFLL+2ce1TeQMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.10 155/162] genirq: Take the proposed affinity at face value if force==true
Date: Wed, 30 Nov 2022 19:23:56 +0100
Message-Id: <20221130180532.677827540@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Capitulino <luizcap@amazon.com>

From: Marc Zyngier <maz@kernel.org>

commit c48c8b829d2b966a6649827426bcdba082ccf922 upstream.

Although setting the affinity of an interrupt to a set of CPUs that doesn't
have any online CPU is generally frowned apon, there are a few limited
cases where such affinity is set from a CPUHP notifier, setting the
affinity to a CPU that isn't online yet.

The saving grace is that this is always done using the 'force' attribute,
which gives a hint that the affinity setting can be outside of the online
CPU mask and the callsite set this flag with the knowledge that the
underlying interrupt controller knows to handle it.

This restores the expected behaviour on Marek's system.

Fixes: 33de0aa4bae9 ("genirq: Always limit the affinity to online CPUs")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/4b7fc13c-887b-a664-26e8-45aed13f048a@samsung.com
Link: https://lore.kernel.org/r/20220414140011.541725-1-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/manage.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -267,10 +267,16 @@ int irq_do_set_affinity(struct irq_data
 		prog_mask = mask;
 	}
 
-	/* Make sure we only provide online CPUs to the irqchip */
+	/*
+	 * Make sure we only provide online CPUs to the irqchip,
+	 * unless we are being asked to force the affinity (in which
+	 * case we do as we are told).
+	 */
 	cpumask_and(&tmp_mask, prog_mask, cpu_online_mask);
-	if (!cpumask_empty(&tmp_mask))
+	if (!force && !cpumask_empty(&tmp_mask))
 		ret = chip->irq_set_affinity(data, &tmp_mask, force);
+	else if (force)
+		ret = chip->irq_set_affinity(data, mask, force);
 	else
 		ret = -EINVAL;
 


