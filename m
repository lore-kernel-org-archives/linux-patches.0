Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523201C7274;
	Tue, 15 Oct 2024 11:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992579; cv=none; b=PVY6lpq7RSA+b6Gh4drNWholqp/Jjo7H1o9rMtx+slZgGZxsgW+TIfuFtmAic8IDjzPKx6VXHOdqwdOTYKl2FqDG5Bx0XNrNb8Dl+tXCQYVTEo8c0TAE0hm+PxzSS0zcaHrjoK7TMoDyT1iSTxJR+7Qk9FbexYpVejmbGZBlZUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992579; c=relaxed/simple;
	bh=JCFefYmTZjA/yzLYAV3BcjqMkGikfpiHXw8MttmFmxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rm+foCcwR68ubb0apXl+W0tfaRn/xMjnaWK9ZAQQUx7vD49uNFo3q5mAPpGqEVJHccf9LfpBVQo3fn0nL4U9E9hZOzdcPq3mN2D4Q+CmaqI9Idt/23H4J/iI5rkcN90s4D6hcoImboAbisIaoEUACzhqccn5FDfzc3ZYGCTaV2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xObAj8SQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xObAj8SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1EFC4CEC6;
	Tue, 15 Oct 2024 11:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992579;
	bh=JCFefYmTZjA/yzLYAV3BcjqMkGikfpiHXw8MttmFmxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xObAj8SQMrCD6wR/w4izsh3tko1h/FMvCJuNIx7iBNKQK5TYPocd18oF+bVk2ElfQ
	 e7l4TRRZX9Bya1NJpJdsG498xn0ylXoWlp5K71uhvwEcq1sT73NVQrdrygTA/Y5izg
	 Gz4IsUNg+KSbAQA5uZ/arWXdEM9pEdXOedQ/xWb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/691] mtd: powernv: Add check devm_kasprintf() returned value
Date: Tue, 15 Oct 2024 13:21:46 +0200
Message-ID: <20241015112446.632486713@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6950a87648151..1277ca677becf 100644
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



