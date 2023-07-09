Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EED84699
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C00FC433C8;
	Sun,  9 Jul 2023 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901463;
	bh=y82BXBa3gUHLtgZibOoUflmazoHlF/tfiVIIOVK3dHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR6vqWlbBgWK2AOcnjNK8a5xSp5gVSihMU8D5tkA67J124Nq76Vbp4mD0R22lq8il
	 ewyAv66ZM5KHIaPboIMOYtGEgWRy1rZQBCywzflx2CplWql8fgjOcPG5pKx5ln7t8U
	 /7UQbvSeXqlcNM/ZODxT9/x9et7FKMbg+bqcrKAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 029/431] irqchip/stm32-exti: Fix warning on initialized field overwritten
Date: Sun,  9 Jul 2023 13:09:37 +0200
Message-ID: <20230709111451.782410798@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 48f31e496488a25f443c0df52464da446fb1d10c ]

While compiling with W=1, both gcc and clang complain about a
tricky way to initialize an array by filling it with a non-zero
value and then overrride some of the array elements.
In this case the override is intentional, so just disable the
specific warning for only this part of the code.

Note: the flag "-Woverride-init" is recognized by both compilers,
but the warning msg from clang reports "-Winitializer-overrides".
The doc of clang clarifies that the two flags are synonyms, so use
here only the flag name common on both compilers.

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Fixes: c297493336b7 ("irqchip/stm32-exti: Simplify irq description table")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230601155614.34490-1-antonio.borneo@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-stm32-exti.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/irqchip/irq-stm32-exti.c b/drivers/irqchip/irq-stm32-exti.c
index 6a3f7498ea8ea..8bbb2b114636c 100644
--- a/drivers/irqchip/irq-stm32-exti.c
+++ b/drivers/irqchip/irq-stm32-exti.c
@@ -173,6 +173,16 @@ static struct irq_chip stm32_exti_h_chip_direct;
 #define EXTI_INVALID_IRQ       U8_MAX
 #define STM32MP1_DESC_IRQ_SIZE (ARRAY_SIZE(stm32mp1_exti_banks) * IRQS_PER_BANK)
 
+/*
+ * Use some intentionally tricky logic here to initialize the whole array to
+ * EXTI_INVALID_IRQ, but then override certain fields, requiring us to indicate
+ * that we "know" that there are overrides in this structure, and we'll need to
+ * disable that warning from W=1 builds.
+ */
+__diag_push();
+__diag_ignore_all("-Woverride-init",
+		  "logic to initialize all and then override some is OK");
+
 static const u8 stm32mp1_desc_irq[] = {
 	/* default value */
 	[0 ... (STM32MP1_DESC_IRQ_SIZE - 1)] = EXTI_INVALID_IRQ,
@@ -266,6 +276,8 @@ static const u8 stm32mp13_desc_irq[] = {
 	[70] = 98,
 };
 
+__diag_pop();
+
 static const struct stm32_exti_drv_data stm32mp1_drv_data = {
 	.exti_banks = stm32mp1_exti_banks,
 	.bank_nr = ARRAY_SIZE(stm32mp1_exti_banks),
-- 
2.39.2



