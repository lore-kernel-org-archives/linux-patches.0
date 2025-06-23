Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D596D23A9BE;
	Mon, 23 Jun 2025 13:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684957; cv=none; b=VQzNY6To8+wCij6ZhZxQ5xO0N+E9KGQPQ6D57+AGmNNJYx+QK6u8rcM9KFJdf+tvZIiaMhG/LwzjOZUrz9XFGk7+s5j0M8mHOiI8Fl72KflI/Ep+WJBBfXkzN6FHpxhDGRnKGwP5lhfCSALGvwoYc6TGRXZ3J8oYSD0mOmxmGmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684957; c=relaxed/simple;
	bh=arV5++ewlBMfbhOGToIvyeyx/QMojJD0/4+XAghDIq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxxJ0/WmZgWcqpZXmfp/1flXPLw+lC48nuPtewk+3uZbIOxjWM/G5i3j2eu2yehdL5vXJc0sUCH/YkOyOYJBZzthWbbRuMSkpS93Vmpm9ydI1lnCl0rhmZMyFfMhyrs2GVGf3aANRr2Q7UutXlhpq6etdxWGqzs+7gxRONcpWBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hELL3Lcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hELL3Lcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD56C4CEEA;
	Mon, 23 Jun 2025 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684957;
	bh=arV5++ewlBMfbhOGToIvyeyx/QMojJD0/4+XAghDIq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hELL3LcfOBIT+ax74PRS/beDAObYJAsGaDJvdGvY/HFE9/s9oYXyBvWpQJZsXPdyJ
	 pMIcT3bxoWkT87ugTCcy2GzTP7Be+rVDi7EmaJ1xm7gSA4+1VMxQrkkPI+E7XoLOQT
	 lH1KBQoNYGH0T/1/4bg2+XTABpzP5lOw9+zT0Fss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/222] soc: aspeed: Add NULL check in aspeed_lpc_enable_snoop()
Date: Mon, 23 Jun 2025 15:06:26 +0200
Message-ID: <20250623130613.626717085@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit f1706e0e1a74b095cbc60375b9b1e6205f5f4c98 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
aspeed_lpc_enable_snoop() does not check for this case, which results in a
NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 3772e5da4454 ("drivers/misc: Aspeed LPC snoop output using misc chardev")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20250401074647.21300-1-bsdhenrymartin@gmail.com
[arj: Fix Fixes: tag to use subject from 3772e5da4454]
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index 8a2a22c40ef53..43e30937fc9da 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -202,11 +202,15 @@ static int aspeed_lpc_enable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 	lpc_snoop->chan[channel].miscdev.minor = MISC_DYNAMIC_MINOR;
 	lpc_snoop->chan[channel].miscdev.name =
 		devm_kasprintf(dev, GFP_KERNEL, "%s%d", DEVICE_NAME, channel);
+	if (!lpc_snoop->chan[channel].miscdev.name) {
+		rc = -ENOMEM;
+		goto err_free_fifo;
+	}
 	lpc_snoop->chan[channel].miscdev.fops = &snoop_fops;
 	lpc_snoop->chan[channel].miscdev.parent = dev;
 	rc = misc_register(&lpc_snoop->chan[channel].miscdev);
 	if (rc)
-		return rc;
+		goto err_free_fifo;
 
 	/* Enable LPC snoop channel at requested port */
 	switch (channel) {
@@ -223,7 +227,8 @@ static int aspeed_lpc_enable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 		hicrb_en = HICRB_ENSNP1D;
 		break;
 	default:
-		return -EINVAL;
+		rc = -EINVAL;
+		goto err_misc_deregister;
 	}
 
 	regmap_update_bits(lpc_snoop->regmap, HICR5, hicr5_en, hicr5_en);
@@ -233,6 +238,12 @@ static int aspeed_lpc_enable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 		regmap_update_bits(lpc_snoop->regmap, HICRB,
 				hicrb_en, hicrb_en);
 
+	return 0;
+
+err_misc_deregister:
+	misc_deregister(&lpc_snoop->chan[channel].miscdev);
+err_free_fifo:
+	kfifo_free(&lpc_snoop->chan[channel].fifo);
 	return rc;
 }
 
-- 
2.39.5



