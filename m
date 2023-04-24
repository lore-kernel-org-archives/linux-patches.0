Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B185C7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DD7C433EF;
	Mon, 24 Apr 2023 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342523;
	bh=50zKGSO8Bw8Uo6ayP9XfVPJ6fGmXRAPG/UjIuMTDXnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QAyOfZAITW+qldenR9Wq8PWArnMKGO0ObhwXEir49TA6hij0VmVTTrkwWj7KNTC/
	 m+AQXSo5NtrEZuXk5sbS32e5Lgs0dfflvFDYJKThBUbD7dWItuMA3L58IEUsfVGrUQ
	 xhxbQUI9zfdSEZYbc1yshbFgMX0t7gxN18KVcxik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.15 71/73] soc: sifive: l2_cache: fix missing iounmap() in error path in sifive_l2_init()
Date: Mon, 24 Apr 2023 15:17:25 +0200
Message-Id: <20230424131131.727740347@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
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

commit 73e770f085023da327dc9ffeb6cd96b0bb22d97e upstream.

Add missing iounmap() before return error from sifive_l2_init().

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[conor: ccache -> l2_cache]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/sifive/sifive_l2_cache.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -212,7 +212,8 @@ static int __init sifive_l2_init(void)
 	intr_num = of_property_count_u32_elems(np, "interrupts");
 	if (!intr_num) {
 		pr_err("L2CACHE: no interrupts property\n");
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err_unmap;
 	}
 
 	for (i = 0; i < intr_num; i++) {
@@ -220,7 +221,7 @@ static int __init sifive_l2_init(void)
 		rc = request_irq(g_irq[i], l2_int_handler, 0, "l2_ecc", NULL);
 		if (rc) {
 			pr_err("L2CACHE: Could not request IRQ %d\n", g_irq[i]);
-			return rc;
+			goto err_unmap;
 		}
 	}
 
@@ -233,5 +234,9 @@ static int __init sifive_l2_init(void)
 	setup_sifive_debug();
 #endif
 	return 0;
+
+err_unmap:
+	iounmap(l2_base);
+	return rc;
 }
 device_initcall(sifive_l2_init);


