Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DF01C07C2;
	Tue, 15 Oct 2024 12:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997190; cv=none; b=Co6qI6eGLqUmjsBHtJ7bChn7SmhSgwDphx5j4c0aW/NcazHFvZbjJDdNzHl9W+42Hukf7Okzud05HAAgZ//H7COCSfhjOzv/eOdx+1u+Uuu2TEl5rnZn6TbuEeK9goMOJZCspY51X+jDyETGgOhgWY2kQQOziGhHPoptSpE4mIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997190; c=relaxed/simple;
	bh=HChRqMU6XAK00BYI/k3ynuclXi6UsZRbyAlzco3hH14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCZNHprWE1YXQqomXCEvKhee1NDBixADG5ACjrWhmTfXhfCq4yrApx2hlNzpOrGdrkmY/SG4YLwDTGIj5jKACVZh/MmItjvhKjpz9mrFS+0XQSms5OtMdnj5+vsvuYsUAEnnlzf75DK0FVBkgU+LVc3inuGOm3lisNJ1se0pvsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BW4LQZ/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BW4LQZ/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65A2C4CEC6;
	Tue, 15 Oct 2024 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997190;
	bh=HChRqMU6XAK00BYI/k3ynuclXi6UsZRbyAlzco3hH14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BW4LQZ/pJf35yRXl0F0e8Ea+iqcE7NxBbqqcxjEHbLVFqXwL2S4S1d2ZWB5GmKcnW
	 dfAvEjmmahx8nJYyfDrn1F4mCnI5z7y2+IfDJ5o+rv03Gd0bVvO+csGhsukufwcSTw
	 n2jEctc+LtxydEPx3u33liHz+IYFjHkhcMRgGX2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/518] mtd: powernv: Add check devm_kasprintf() returned value
Date: Tue, 15 Oct 2024 14:40:17 +0200
Message-ID: <20241015123921.360909233@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



