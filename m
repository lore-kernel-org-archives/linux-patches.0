Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629A2FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C24C433D2;
	Mon, 15 May 2023 17:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171351;
	bh=ryAdVc9K59P8Wlf7GrkyPM5m24cLx8P0TkQ/L740pGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xa3D18qXBW3AkZ0Lda65nJS8UH5HU5Lv0XXtUsQo3dzsZGgUvsKB3nedtb2LybLPp
	 BrfM/AigmLawQRBoqlWIgYR9eXHywgkvfDRMKxYGDgN4sBa7NltqwRdwj/LSlXrYXB
	 /p9Pk2fSyQx6RewjUGYTsIyVR9j222G7lA8suUog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianmin Lv <lvjianmin@loongson.cn>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.2 182/242] irqchip/loongson-pch-pic: Fix registration of syscore_ops
Date: Mon, 15 May 2023 18:28:28 +0200
Message-Id: <20230515161727.332873295@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
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
 drivers/irqchip/irq-loongson-pch-pic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 437f1af693d0..64fa67d4ee7a 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -311,7 +311,8 @@ static int pch_pic_init(phys_addr_t addr, unsigned long size, int vec_base,
 	pch_pic_handle[nr_pics] = domain_handle;
 	pch_pic_priv[nr_pics++] = priv;
 
-	register_syscore_ops(&pch_pic_syscore_ops);
+	if (nr_pics == 1)
+		register_syscore_ops(&pch_pic_syscore_ops);
 
 	return 0;
 
-- 
2.40.1



