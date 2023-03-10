Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEFF847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFF0C433EF;
	Fri, 10 Mar 2023 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456740;
	bh=qgBWcSuqsd86vyiJtME/EBTG/dZrfhB4LIYVvAuMZL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W67XzSUtg4p8XwCCXhBKsMfIeVCazTAjZ0BEX0AEZ9PdWxj5hhN+/q0iTJviVD+io
	 Qx9jPO1ENVQa4c8VlS1FGDUKt9ap1kdJgF5KMGl0Z/2tPM28esrGG/glRnz4kqVcFB
	 +QWg4bAMG2Y96IMs/MIm3xDFdYhOtrNmdWpsTS7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 106/211] genirq/ipi: Fix NULL pointer deref in irq_data_get_affinity_mask()
Date: Fri, 10 Mar 2023 14:38:06 +0100
Message-Id: <20230310133721.982963519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit feabecaff5902f896531dde90646ca5dfa9d4f7d ]

If ipi_send_{mask|single}() is called with an invalid interrupt number, all
the local variables there will be NULL. ipi_send_verify() which is invoked
from these functions does verify its 'data' parameter, resulting in a
kernel oops in irq_data_get_affinity_mask() as the passed NULL pointer gets
dereferenced.

Add a missing NULL pointer check in ipi_send_verify()...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: 3b8e29a82dd1 ("genirq: Implement ipi_send_mask/single()")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/b541232d-c2b6-1fe9-79b4-a7129459e4d0@omp.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/ipi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/ipi.c b/kernel/irq/ipi.c
index bbd945bacef08..961d4af76af37 100644
--- a/kernel/irq/ipi.c
+++ b/kernel/irq/ipi.c
@@ -188,9 +188,9 @@ EXPORT_SYMBOL_GPL(ipi_get_hwirq);
 static int ipi_send_verify(struct irq_chip *chip, struct irq_data *data,
 			   const struct cpumask *dest, unsigned int cpu)
 {
-	const struct cpumask *ipimask = irq_data_get_affinity_mask(data);
+	const struct cpumask *ipimask;
 
-	if (!chip || !ipimask)
+	if (!chip || !data)
 		return -EINVAL;
 
 	if (!chip->ipi_send_single && !chip->ipi_send_mask)
@@ -199,6 +199,10 @@ static int ipi_send_verify(struct irq_chip *chip, struct irq_data *data,
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
+	ipimask = irq_data_get_affinity_mask(data);
+	if (!ipimask)
+		return -EINVAL;
+
 	if (dest) {
 		if (!cpumask_subset(dest, ipimask))
 			return -EINVAL;
-- 
2.39.2



