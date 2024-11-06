Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA261EC011;
	Wed,  6 Nov 2024 12:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897956; cv=none; b=QCB3O6Wjol4wSLChiZQDkUMdRSrt3hmQQdL9Z+Rv0DiJw4+i4cDoN3FuJdOVSGfFl8XmSLQEzHZD8YqRLiphYHuJnTNOflpSLGlAFGk1GKsarUAUJCeb4OwvfQUuQtOfp4UtzcBdbaarbde6KDLxbj2b/HjPppynNYVR/OLWiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897956; c=relaxed/simple;
	bh=I6bfeVmlFLzwnvqbMZ9YhZ9X/mUnvHFynMnd7Hrg7gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpYoxQq16VWzGxfVqXDnvoriurpVkrmizBA6lbAb6PDE1LZiTxj8DYoiB01qk++nT3FB+yrUfwR/OP9ZqGyCcMIc0DGbvQQOOF/AneQACtjc1AaxiPA+HWXQvDjw5rY7sWsNqhlI6nxjAh57Qw/lWjX9UwjVEeytHoneBH3AJzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsNXdjtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsNXdjtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6568BC4CECD;
	Wed,  6 Nov 2024 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897955;
	bh=I6bfeVmlFLzwnvqbMZ9YhZ9X/mUnvHFynMnd7Hrg7gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsNXdjtJk9bRzkDyYggoxoPRgTMG3waT5JsFDEXJ5+yhUOJ6Qoa4/0vbtAaf1F32C
	 8onyiKSxSXjrUY6ErCKM08IAveWJVzOpx/oVW4iWsPMZkVXEXfm+1prnPUbWXnnyuz
	 IcTm/cBE6RepkF5pqTQC7VK/0CngQaZLWmTxZfQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/462] mtd: powernv: Add check devm_kasprintf() returned value
Date: Wed,  6 Nov 2024 12:59:21 +0100
Message-ID: <20241106120333.189867633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0b757d9ba2f6b..0ab64a1cec09e 100644
--- a/drivers/mtd/devices/powernv_flash.c
+++ b/drivers/mtd/devices/powernv_flash.c
@@ -204,6 +204,9 @@ static int powernv_flash_set_driver_info(struct device *dev,
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



