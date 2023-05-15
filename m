Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38796FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913A0C433D2;
	Mon, 15 May 2023 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169928;
	bh=0M0FAuG3Qyhr2jqM0j3vbsgcmFZMleMWj3HaMudskG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOv9tAFQNkeFzLM6dmAzdoHvV/ZVzCrA7trFrtDGdZotxcqdUP1PhOf79i7lSvBG7
	 VFvEj+vZg5tQKZMqsSDb8lE+DlP3DuD6ZUXb4OWAZZXNVwn8HM6SOBT5FPKP2wfJdq
	 3iQ8x2XX9wShfiC8+UX8sY8hT5qCRNaXBZz3Cc3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 186/246] irqchip/loongson-eiointc: Fix returned value on parsing MADT
Date: Mon, 15 May 2023 18:26:38 +0200
Message-Id: <20230515161728.202725194@linuxfoundation.org>
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

commit 112eaa8fec5ea75f1be003ec55760b09a86799f8 upstream.

In pch_pic_parse_madt(), a NULL parent pointer will be
returned from acpi_get_vec_parent() for second pch-pic domain
related to second bridge while calling eiointc_acpi_init() at
first time, where the parent of it has not been initialized
yet, and will be initialized during second time calling
eiointc_acpi_init(). So, it's reasonable to return zero so
that failure of acpi_table_parse_madt() will be avoided, or else
acpi_cascade_irqdomain_init() will return and initialization of
followed pch_msi domain will be skipped.

Although it does not matter when pch_msi_parse_madt() returns
-EINVAL if no invalid parent is found, it's also reasonable to
return zero for that.

Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-2-lvjianmin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-eiointc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -343,7 +343,7 @@ static int __init pch_pic_parse_madt(uni
 	if (parent)
 		return pch_pic_acpi_init(parent, pchpic_entry);
 
-	return -EINVAL;
+	return 0;
 }
 
 static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
@@ -355,7 +355,7 @@ static int __init pch_msi_parse_madt(uni
 	if (parent)
 		return pch_msi_acpi_init(parent, pchmsi_entry);
 
-	return -EINVAL;
+	return 0;
 }
 
 static int __init acpi_cascade_irqdomain_init(void)


