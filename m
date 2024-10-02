Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A361D042F;
	Wed,  2 Oct 2024 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875772; cv=none; b=jyUwPZsoJmWjBxBUwwR3pLcvqTLAB+oNJXIXZp1kOrSAj/C3unNo7pxbBJEj5OTL9XcX9Yvoywufvwc+RzqC/sqhNl8M0TcimdgH6IohtsGhbC42aiY4pYrSVKOO+VXJlU/+aNg5oB33DmyzKMJCiMgFCGGmnGnsBTiU2ztzg5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875772; c=relaxed/simple;
	bh=5k9I4ZqmwhiBgm6309ClYRFWNhEWWI6jNDmSWSYKvSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzVuZ19n19IFs92DQSqZfdQVXkQ2ErllfVOnmkxkvJA77sUHABmb3x6+Jrn6LyLD7yags2rq7K/9I+xbuahhJ6kA50Z5QHFRX8BpTblZ+yz1K52K2Ms62isNlVJBLfDYf5tWwh6Kxu9XnjoS5xoIHAbXxPuMohUI54WLVhEHFa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MF6xQWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MF6xQWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C2FC4CEC5;
	Wed,  2 Oct 2024 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875771;
	bh=5k9I4ZqmwhiBgm6309ClYRFWNhEWWI6jNDmSWSYKvSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MF6xQWmWP2IwoMk1gkHY9ine+jCTaDITBkIonzteuEmWkZtQ/BKoTqd8QktXMEec
	 8oFSkuoEHyYKLncJxmhnP9IDj503GG8475S8PqSgS5CHVoAr9F/i2bEJAsI++dXGHt
	 SRcqgnAZl4+0hS9oNQJwrKGS070Wk33iHV6B63/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 188/695] mtd: powernv: Add check devm_kasprintf() returned value
Date: Wed,  2 Oct 2024 14:53:06 +0200
Message-ID: <20241002125829.974934849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 66044f4f5bade..10cd1d9b48859 100644
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



