Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90D0749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B55C433EF;
	Thu, 12 Jan 2023 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532549;
	bh=S8B+7BUL+uRwVISrw8I+/MgAHOjDqUc4NVsmGQ2/cNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MANaZhqqoPj7I9AFn1f0WShGKl2o+/1x90yZLZW7efyeFyM6YvGtM/u/SVGRF6pj6
	 8lem16pt8nc3AHBcXAFx+YaQJ9j9WKalD3aZPXzM16VLM4pAvuyHxo0afGBUtXDIjs
	 /VRfSlqjFp/fUPw3D4ZHpSb1/S88DzZGchhN9s4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yongjun <zhengyongjun3@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/783] mtd: maps: pxa2xx-flash: fix memory leak in probe
Date: Thu, 12 Jan 2023 14:48:07 +0100
Message-Id: <20230112135532.247193684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 2399401feee27c639addc5b7e6ba519d3ca341bf ]

Free 'info' upon remapping error to avoid a memory leak.

Fixes: e644f7d62894 ("[MTD] MAPS: Merge Lubbock and Mainstone drivers into common PXA2xx driver")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
[<miquel.raynal@bootlin.com>: Reword the commit log]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221119073307.22929-1-zhengyongjun3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/pxa2xx-flash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 7d96758a8f04..6e5e55755970 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -66,6 +66,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 	if (!info->map.virt) {
 		printk(KERN_WARNING "Failed to ioremap %s\n",
 		       info->map.name);
+		kfree(info);
 		return -ENOMEM;
 	}
 	info->map.cached = ioremap_cache(info->map.phys, info->map.size);
@@ -87,6 +88,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 		iounmap((void *)info->map.virt);
 		if (info->map.cached)
 			iounmap(info->map.cached);
+		kfree(info);
 		return -EIO;
 	}
 	info->mtd->dev.parent = &pdev->dev;
-- 
2.35.1



