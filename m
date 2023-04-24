Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0852108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F78C433EF;
	Mon, 24 Apr 2023 13:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342526;
	bh=bwelsVxkOzj8FH6fmXQrjrrab8H2so4U//WTuhsiysY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDDXVEyMtz5l6qdj4kt8IS2ZKFTlRn6z9yOou1Ks0vr0nmhFeVkyC4gSa8bv/5ZTq
	 f9OdLH1x3fbt4NoUXQkrmdJaSLPqJQfnlGzHbniy9ngYtlKkHVKyiPg7+1L8MueSaW
	 Otn04PTnuxV29XNhYjEUSZLz3j3tOvCBG/NncN5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.15 72/73] soc: sifive: l2_cache: fix missing free_irq() in error path in sifive_l2_init()
Date: Mon, 24 Apr 2023 15:17:26 +0200
Message-Id: <20230424131131.758489772@linuxfoundation.org>
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

commit 756344e7cb1afbb87da8705c20384dddd0dea233 upstream.

Add missing free_irq() before return error from sifive_l2_init().

Fixes: a967a289f169 ("RISC-V: sifive_l2_cache: Add L2 cache controller driver for SiFive SoCs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
[conor: ccache -> l2_cache]
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/sifive/sifive_l2_cache.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/soc/sifive/sifive_l2_cache.c
+++ b/drivers/soc/sifive/sifive_l2_cache.c
@@ -221,7 +221,7 @@ static int __init sifive_l2_init(void)
 		rc = request_irq(g_irq[i], l2_int_handler, 0, "l2_ecc", NULL);
 		if (rc) {
 			pr_err("L2CACHE: Could not request IRQ %d\n", g_irq[i]);
-			goto err_unmap;
+			goto err_free_irq;
 		}
 	}
 
@@ -235,6 +235,9 @@ static int __init sifive_l2_init(void)
 #endif
 	return 0;
 
+err_free_irq:
+	while (--i >= 0)
+		free_irq(g_irq[i], NULL);
 err_unmap:
 	iounmap(l2_base);
 	return rc;


