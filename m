Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18501882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5ECC433D2;
	Fri, 10 Mar 2023 15:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461302;
	bh=n9HIzfW9zUY/LGygjXlPo2BnJxVkEXukBbQA5ynWBWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpHDq2UTJJNn7AfKNc4GM8ZwmyvKzOXY5xqNtddWrIsZPuGbmTr6gTu2TDba6U7Dj
	 2gg2uvc6BLj6NAr4l4OdTFCE3B+MhP+n64IfjwR3p/annJE69alJoSvETR63JfFKTF
	 uQqbezdX/ek5uyfwyhsVJTu/YxEzbrkA7dptmIEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/136] genirq: Refactor accessors to use irq_data_get_affinity_mask
Date: Fri, 10 Mar 2023 14:43:04 +0100
Message-Id: <20230310133709.022574009@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 961343d7822624d0e329ab4167c7e1d02bb53112 ]

A couple of functions directly reference the affinity mask. Route them
through irq_data_get_affinity_mask so they will pick up any refactoring
done there.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220701200056.46555-6-samuel@sholland.org
Stable-dep-of: feabecaff590 ("genirq/ipi: Fix NULL pointer deref in irq_data_get_affinity_mask()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index c8293c817646c..5f8f0f24a2801 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -875,16 +875,16 @@ static inline int irq_data_get_node(struct irq_data *d)
 	return irq_common_data_get_node(d->common);
 }
 
-static inline struct cpumask *irq_get_affinity_mask(int irq)
+static inline struct cpumask *irq_data_get_affinity_mask(struct irq_data *d)
 {
-	struct irq_data *d = irq_get_irq_data(irq);
-
-	return d ? d->common->affinity : NULL;
+	return d->common->affinity;
 }
 
-static inline struct cpumask *irq_data_get_affinity_mask(struct irq_data *d)
+static inline struct cpumask *irq_get_affinity_mask(int irq)
 {
-	return d->common->affinity;
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	return d ? irq_data_get_affinity_mask(d) : NULL;
 }
 
 #ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
@@ -906,7 +906,7 @@ static inline void irq_data_update_effective_affinity(struct irq_data *d,
 static inline
 struct cpumask *irq_data_get_effective_affinity_mask(struct irq_data *d)
 {
-	return d->common->affinity;
+	return irq_data_get_affinity_mask(d);
 }
 #endif
 
-- 
2.39.2



