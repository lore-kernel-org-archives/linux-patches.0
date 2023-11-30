Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F248495C2;
	Thu, 30 Nov 2023 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk0iWbQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2F9C433C8;
	Thu, 30 Nov 2023 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361433;
	bh=Um0P2lzvLS2CLlTNMUua+gBPi8d6c4YGTzw+qRDe/ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tk0iWbQP8qjBO4qCCaI7aLu7mMIWcAYxgan+4zZCWNoeqeO98UZCeJTnD8lrWZlBX
	 KJXHydVFmBYWa/AwauaLJAT0tfx4zfxczLNWc5XbLgqCZ6ZZUlOkL4IpCtz//6sqwm
	 n3n3QIzvHD2UuSVmtBJrq+2X7bLA/FdkOnukkCM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fang Xiang <fangxiang3@xiaomi.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/112] irqchip/gic-v3-its: Flush ITS tables correctly in non-coherent GIC designs
Date: Thu, 30 Nov 2023 16:20:50 +0000
Message-ID: <20231130162140.425801170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fang Xiang <fangxiang3@xiaomi.com>

[ Upstream commit d3badb15613c14dd35d3495b1dde5c90fcd616dd ]

In non-coherent GIC designs, the ITS tables must be flushed before writing
to the GITS_BASER<n> registers, otherwise the ITS could read dirty tables,
which results in unpredictable behavior.

Flush the tables right at the begin of its_setup_baser() to prevent that.

[ tglx: Massage changelog ]

Fixes: a8707f553884 ("irqchip/gic-v3: Add Rockchip 3588001 erratum workaround")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fang Xiang <fangxiang3@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231030083256.4345-1-fangxiang3@xiaomi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index a8c89df1a9978..9a7a74239eabb 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2379,12 +2379,12 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		break;
 	}
 
+	if (!shr)
+		gic_flush_dcache_to_poc(base, PAGE_ORDER_TO_SIZE(order));
+
 	its_write_baser(its, baser, val);
 	tmp = baser->val;
 
-	if (its->flags & ITS_FLAGS_FORCE_NON_SHAREABLE)
-		tmp &= ~GITS_BASER_SHAREABILITY_MASK;
-
 	if ((val ^ tmp) & GITS_BASER_SHAREABILITY_MASK) {
 		/*
 		 * Shareability didn't stick. Just use
@@ -2394,10 +2394,9 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 		 * non-cacheable as well.
 		 */
 		shr = tmp & GITS_BASER_SHAREABILITY_MASK;
-		if (!shr) {
+		if (!shr)
 			cache = GITS_BASER_nC;
-			gic_flush_dcache_to_poc(base, PAGE_ORDER_TO_SIZE(order));
-		}
+
 		goto retry_baser;
 	}
 
@@ -2609,6 +2608,11 @@ static int its_alloc_tables(struct its_node *its)
 		/* erratum 24313: ignore memory access type */
 		cache = GITS_BASER_nCnB;
 
+	if (its->flags & ITS_FLAGS_FORCE_NON_SHAREABLE) {
+		cache = GITS_BASER_nC;
+		shr = 0;
+	}
+
 	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
 		struct its_baser *baser = its->tables + i;
 		u64 val = its_read_baser(its, baser);
-- 
2.42.0



