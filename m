Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6281863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EDEC433F2;
	Wed, 28 Dec 2022 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239806;
	bh=B4JV8fVQxiavIExuYqt2xzmGg3Y49E6jSeTZ/F3C7UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2R/0FTVLP9mtG518rldC59jhdMHikJroUTvg83/uFYKCBCfhBxJUAtqA2Tr7h21sl
	 HQsvb/J4t6gFR/fI6ACDJ+BRcaaaS/pKX4rDHt671tk6ufTihQMXnc4NzgVLpIBpoo
	 JBxhm2D0gRNnntG+HHAU5CnHahYTzAe87tqt6LUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0045/1146] soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()
Date: Wed, 28 Dec 2022 15:26:24 +0100
Message-Id: <20221228144331.389926412@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 73e770f085023da327dc9ffeb6cd96b0bb22d97e ]

Add missing iounmap() before return error from sifive_ccache_init().

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/sifive/sifive_ccache.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 1c171150e878..25019c16d8ae 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -222,13 +222,16 @@ static int __init sifive_ccache_init(void)
 	if (!ccache_base)
 		return -ENOMEM;
 
-	if (of_property_read_u32(np, "cache-level", &level))
-		return -ENOENT;
+	if (of_property_read_u32(np, "cache-level", &level)) {
+		rc = -ENOENT;
+		goto err_unmap;
+	}
 
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
 		pr_err("No interrupts property\n");
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err_unmap;
 	}
 
 	for (i = 0; i < intr_num; i++) {
@@ -237,7 +240,7 @@ static int __init sifive_ccache_init(void)
 				 NULL);
 		if (rc) {
 			pr_err("Could not request IRQ %d\n", g_irq[i]);
-			return rc;
+			goto err_unmap;
 		}
 	}
 
@@ -250,6 +253,10 @@ static int __init sifive_ccache_init(void)
 	setup_sifive_debug();
 #endif
 	return 0;
+
+err_unmap:
+	iounmap(ccache_base);
+	return rc;
 }
 
 device_initcall(sifive_ccache_init);
-- 
2.35.1



