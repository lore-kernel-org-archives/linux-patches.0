Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C401863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C872C433EF;
	Wed, 28 Dec 2022 15:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240646;
	bh=Ce5wsrwXVklwECNR+An862ZImLkfgMufqhCRFkyt+Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMPLe6oF17u2ORbwzIpF2tvtYccTIRzARScky+qaiBnCb2DU9lh/oihTgMUabVapu
	 jeg3emYu6WuElixf3d0iTCoP1Uu332CI3QDUbMDqDnH93MSxzWjJ09zN+AvCINmgGZ
	 h3ZxqhPVfgv8dM6+ecgdNu+XCePsMAeLsuAfpljg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Peibao <liupeibao@loongson.cn>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0149/1146] irqchip/loongson-liointc: Fix improper error handling in liointc_init()
Date: Wed, 28 Dec 2022 15:28:08 +0100
Message-Id: <20221228144334.199335378@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Peibao <liupeibao@loongson.cn>

[ Upstream commit 4a60a3cdcf1875c965095eb9e22c3d12bbc5a53d ]

For cores less than 4, eg, loongson2k1000 with 2 cores, the
of_property_match_string() may return with an error value,
which causes that liointc could not work. At least isr0 is
what should be checked like previous commit b2c4c3969fd7
("irqchip/loongson-liointc: irqchip add 2.0 version") did.

Fixes: 0858ed035a85 ("irqchip/loongson-liointc: Add ACPI init support")
Signed-off-by: Liu Peibao <liupeibao@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221104110712.23300-1-liupeibao@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-liointc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-liointc.c b/drivers/irqchip/irq-loongson-liointc.c
index 0da8716f8f24..c4584e2f0ad3 100644
--- a/drivers/irqchip/irq-loongson-liointc.c
+++ b/drivers/irqchip/irq-loongson-liointc.c
@@ -207,10 +207,13 @@ static int liointc_init(phys_addr_t addr, unsigned long size, int revision,
 					"reg-names", core_reg_names[i]);
 
 			if (index < 0)
-				goto out_iounmap;
+				continue;
 
 			priv->core_isr[i] = of_iomap(node, index);
 		}
+
+		if (!priv->core_isr[0])
+			goto out_iounmap;
 	}
 
 	/* Setup IRQ domain */
-- 
2.35.1



