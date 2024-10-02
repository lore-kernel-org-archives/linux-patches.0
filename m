Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9511474BC;
	Wed,  2 Oct 2024 14:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879547; cv=none; b=OexKwLmu63oazFiW+yrScROxcf+7+HOs730OJTUR+lUpF0q+krqLs3OTRyYdxN/H9oQLRsWzAgQegc9E6kT+FFanhiEW+LuvGIKMtLWwuoNvcs371X0MW31/hlEi1qjcAGD2fXCvggJtjnUOtYMTUnA+tIf6e07CUZ7LXJvJaGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879547; c=relaxed/simple;
	bh=Ou78rOEFoWGf8dOKNVNvvDDxdV+gErF3IZZM2dSEPpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNQe9Ytw5+LuO+yawbHxKtVpp6jmedH4DsoW+Xb5/GXcu2FgUU3E82gPJebEnh8Y894rhsbfQanfWlgrZjrB3udYeltBgWgu+1tpZwOodsiOXD/jd1a8jJbtJLrHnr+AOd8D9SFu80MaO6dgAoSB+KPXOQrp9X409W8vmaUl78E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/xS3x0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/xS3x0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F76FC4CEC2;
	Wed,  2 Oct 2024 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879546;
	bh=Ou78rOEFoWGf8dOKNVNvvDDxdV+gErF3IZZM2dSEPpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/xS3x0fL4ttws3DutnhJBaKLtO6iwdYJvO2JSQdXWw6Rl1i3De1/rlWIUkbfe+BH
	 73xUIpqyIopcoBHkKYZ/coMd5I758MUJpwYTvk2CWQ6B7NIyjxoHyCf1I+nm+Ro1uD
	 EjvXCysGJz+cAv6XSwdY5FLgDNrVxNSI9+uwcrAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/538] mtd: powernv: Add check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 14:56:08 +0200
Message-ID: <20241002125757.334456165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



