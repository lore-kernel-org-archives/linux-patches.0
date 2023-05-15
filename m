Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB30FFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37BCC433EF;
	Mon, 15 May 2023 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169924;
	bh=4m9WUvZG61KQPOHZvdylmdVpjIVfjslntFbLEp/+F18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ap+9Xb1SjlIyoHOU5rpADeJjevVNmG0xTlh3Imo39AROG0G2r/OFRer+V3ga67/sg
	 89Zjaa47RZvffT5kG0uFl6LbMR076NoHifCpVTBrD2Lqa+RGcFu/ty0fjPRZ5Avbye
	 5KwuojrnKyd9a0ZYEMgbOreQyIcmlEpgO1tGLfqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 185/246] irqchip/loongson-pch-pic: Fix registration of syscore_ops
Date: Mon, 15 May 2023 18:26:37 +0200
Message-Id: <20230515161728.173914179@linuxfoundation.org>
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

commit c84efbba46901b187994558ee0edb15f7076c9a7 upstream.

When support suspend/resume for loongson-pch-pic, the syscore_ops
is registered twice in dual-bridges machines where there are two
pch-pic IRQ domains. Repeated registration of an same syscore_ops
broke syscore_ops_list, so the patch will corret it.

Fixes: 1ed008a2c331 ("irqchip/loongson-pch-pic: Add suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-5-lvjianmin@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -311,7 +311,8 @@ static int pch_pic_init(phys_addr_t addr
 	pch_pic_handle[nr_pics] = domain_handle;
 	pch_pic_priv[nr_pics++] = priv;
 
-	register_syscore_ops(&pch_pic_syscore_ops);
+	if (nr_pics == 1)
+		register_syscore_ops(&pch_pic_syscore_ops);
 
 	return 0;
 


