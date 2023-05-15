Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20741FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77287C433EF;
	Mon, 15 May 2023 16:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169915;
	bh=tPSVz4NBhSMOYeOgTzwDoMxs1IxWrZOBVBJI9KE2Op8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0GbCqOItRy5Yoz1ayVP9XwXpm1dFLChtiaWoHkaH6S7JPcCu//SdllcfYPwSwGFZ
	 gzh9LyS7RMV4jgu7iOdVkINQW4Ezi7yWqN6Ha+YmqBEP1CpcYLyujQMZHhdxFIfZpD
	 m4XWAHmJzoFSbuKXwjWSR1/Qqs5JZ5fqJzysrt98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 184/246] irqchip/loongson-pch-pic: Fix pch_pic_acpi_init calling
Date: Mon, 15 May 2023 18:26:36 +0200
Message-Id: <20230515161728.144903463@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianmin Lv <lvjianmin@loongson.cn>

commit 48ce2d722f7f108f27bedddf54bee3423a57ce57 upstream.

For dual-bridges scenario, pch_pic_acpi_init() will be called
in following path:

cpuintc_acpi_init
  acpi_cascade_irqdomain_init(in cpuintc driver)
    acpi_table_parse_madt
      eiointc_parse_madt
        eiointc_acpi_init /* this will be called two times
                             correspondingto parsing two
                             eiointc entries in MADT under
                             dual-bridges scenario*/
          acpi_cascade_irqdomain_init(in eiointc driver)
            acpi_table_parse_madt
              pch_pic_parse_madt
                pch_pic_acpi_init /* this will be called depend
                                     on valid parent IRQ domain
                                     handle for one or two times
                                     corresponding to parsing
                                     two pchpic entries in MADT
                                     druring calling
                                     eiointc_acpi_init() under
                                     dual-bridges scenario*/

During the first eiointc_acpi_init() calling, the
pch_pic_acpi_init() will be called just one time since only
one valid parent IRQ domain handle will be found for current
eiointc IRQ domain.

During the second eiointc_acpi_init() calling, the
pch_pic_acpi_init() will be called two times since two valid
parent IRQ domain handles will be found. So in pch_pic_acpi_init(),
we must have a reasonable way to prevent from creating second same
pch_pic IRQ domain.

The patch matches gsi base information in created pch_pic IRQ
domains to check if the target domain has been created to avoid the
bug mentioned above.

Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-6-lvjianmin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -403,6 +403,9 @@ int __init pch_pic_acpi_init(struct irq_
 	int ret, vec_base;
 	struct fwnode_handle *domain_handle;
 
+	if (find_pch_pic(acpi_pchpic->gsi_base) >= 0)
+		return 0;
+
 	vec_base = acpi_pchpic->gsi_base - GSI_MIN_PCH_IRQ;
 
 	domain_handle = irq_domain_alloc_fwnode(&acpi_pchpic->address);


