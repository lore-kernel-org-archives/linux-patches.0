Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578AA1AAE02;
	Mon, 14 Oct 2024 14:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917661; cv=none; b=LGMbhPevLY/VO0F7zo2kM6nUTNHiYhwZNwVAqF9VltvWUgcLe9IsQil3kXSf0sEoXYioSLacUPEEOkzZlL67NKgHxzBr/8yC3B9EHiX7RcYOjkD/RnNaNI4XA9aVgLlntDhSxGiKH1bblnKJUYFpPnw5J7ezOekHU6tQVC80bdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917661; c=relaxed/simple;
	bh=XJiAMbAtlhIMZDhmttSic65AL5OlPHpv5E0Zl/CJA5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOQ7lF2hhipukh3ri01AGdH0U2oHmC/IdMOR4NxIea+8Up7LJv8pmrEVv+C9HkJhHhMlcsP80Et+I5zkyySFeUBHA9e7m32hvNa97avh9EPZRsxW00EWDDnRwKAlMovXSRUjWLWymXcLRJkF+lrkWLd1grURJZLjtjVHiEZ3h9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNCnu32A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNCnu32A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6771C4CEC7;
	Mon, 14 Oct 2024 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917661;
	bh=XJiAMbAtlhIMZDhmttSic65AL5OlPHpv5E0Zl/CJA5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNCnu32Ad5f3tB6xl675yQ5iZsU2FOHcRR0HEKvsZh2rTpyiioEkS9wE1Lgh3HXul
	 bZvbsZS7lMBr2SapZtaTubjnDfkbalKsd2CoKybFGo1Nr1Idi7FcMGInhGuI4FhHIr
	 iuQY8XVbMSpOwmZqnWGnmF22celv3GhGo+rnjdE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/798] mtd: powernv: Add check devm_kasprintf() returned value
Date: Mon, 14 Oct 2024 16:10:51 +0200
Message-ID: <20241014141221.743625785@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 395999829880a106bb95f0ce34e6e4c2b43c6a5d ]

devm_kasprintf() can return a NULL pointer on failure but this
returned value is not checked.

Fixes: acfe63ec1c59 ("mtd: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240828092427.128177-1-hanchunchao@inspur.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/powernv_flash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/devices/powernv_flash.c b/drivers/mtd/devices/powernv_flash.c
index 36e060386e59d..59e1b3a4406ed 100644
--- a/drivers/mtd/devices/powernv_flash.c
+++ b/drivers/mtd/devices/powernv_flash.c
@@ -207,6 +207,9 @@ static int powernv_flash_set_driver_info(struct device *dev,
 	 * get them
 	 */
 	mtd->name = devm_kasprintf(dev, GFP_KERNEL, "%pOFP", dev->of_node);
+	if (!mtd->name)
+		return -ENOMEM;
+
 	mtd->type = MTD_NORFLASH;
 	mtd->flags = MTD_WRITEABLE;
 	mtd->size = size;
-- 
2.43.0



