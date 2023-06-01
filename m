Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794AE54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD96C433D2;
	Thu,  1 Jun 2023 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625909;
	bh=wlVPKzhzZ/o4VuXL/7VYQfF+MG0nPzJ0ii6nrvwSAVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tw/uF3RAQ9yNN42gGY/sG8XGIHMnTra1FbatPva5zI1laPlI+mxUJZEo61nmToQXC
	 413BQhUMxrTCz29ksQsTih2C2pCFU0oe4qC3yqmUN8f/dJbkNYsFu2Id/bMKnhvdAO
	 ptyJyselSRIy+VI6dnBMxuhLnmqnmD2/5B/dNurw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/42] irqchip/mips-gic: Dont touch vl_map if a local interrupt is not routable
Date: Thu,  1 Jun 2023 14:21:21 +0100
Message-Id: <20230601131938.245009616@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 2c6c9c049510163090b979ea5f92a68ae8d93c45 ]

When a GIC local interrupt is not routable, it's vl_map will be used
to control some internal states for core (providing IPTI, IPPCI, IPFDC
input signal for core). Overriding it will interfere core's intetrupt
controller.

Do not touch vl_map if a local interrupt is not routable, we are not
going to remap it.

Before dd098a0e0319 (" irqchip/mips-gic: Get rid of the reliance on
irq_cpu_online()"), if a local interrupt is not routable, then it won't
be requested from GIC Local domain, and thus gic_all_vpes_irq_cpu_online
won't be called for that particular interrupt.

Fixes: dd098a0e0319 (" irqchip/mips-gic: Get rid of the reliance on irq_cpu_online()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230424103156.66753-2-jiaxun.yang@flygoat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 0d4515257c59c..c654fe22fcf33 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -399,6 +399,8 @@ static void gic_all_vpes_irq_cpu_online(void)
 		unsigned int intr = local_intrs[i];
 		struct gic_all_vpes_chip_data *cd;
 
+		if (!gic_local_irq_is_routable(intr))
+			continue;
 		cd = &gic_all_vpes_chip_data[intr];
 		write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
 		if (cd->mask)
-- 
2.39.2



