Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB99379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274C8C433EF;
	Thu, 12 Jan 2023 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533869;
	bh=CRY/T8PsxHx6HYu6Q95DGO5VlQ3cyv5vVESvY3rFo/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILBtEYxrspTqG6zIzjF5QvgvI05XBOZuM5zYkClWSdxXxamJXSh3x2VNVtztVQoUj
	 heQacUI/ru55uSvcH31fXyt/jNmPOpIrj4kXnIFUBKy0KDEnUft1+IuHkbOWXHLcDV
	 i56aBGySeE7Yx/RCYjgydKBQXF44vfBgjT/OBw7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	kernel test robot <lkp@intel.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 618/783] ARM: ux500: do not directly dereference __iomem
Date: Thu, 12 Jan 2023 14:55:34 +0100
Message-Id: <20230112135552.919802639@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 65b0e307a1a9193571db12910f382f84195a3d29 upstream.

Sparse reports that calling add_device_randomness() on `uid` is a
violation of address spaces. And indeed the next usage uses readl()
properly, but that was left out when passing it toadd_device_
randomness(). So instead copy the whole thing to the stack first.

Fixes: 4040d10a3d44 ("ARM: ux500: add DB serial number to entropy pool")
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/202210230819.loF90KDh-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20221108123755.207438-1-Jason@zx2c4.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/ux500/ux500-soc-id.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/soc/ux500/ux500-soc-id.c
+++ b/drivers/soc/ux500/ux500-soc-id.c
@@ -167,20 +167,18 @@ ATTRIBUTE_GROUPS(ux500_soc);
 static const char *db8500_read_soc_id(struct device_node *backupram)
 {
 	void __iomem *base;
-	void __iomem *uid;
 	const char *retstr;
+	u32 uid[5];
 
 	base = of_iomap(backupram, 0);
 	if (!base)
 		return NULL;
-	uid = base + 0x1fc0;
+	memcpy_fromio(uid, base + 0x1fc0, sizeof(uid));
 
 	/* Throw these device-specific numbers into the entropy pool */
-	add_device_randomness(uid, 0x14);
+	add_device_randomness(uid, sizeof(uid));
 	retstr = kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
-			 readl((u32 *)uid+0),
-			 readl((u32 *)uid+1), readl((u32 *)uid+2),
-			 readl((u32 *)uid+3), readl((u32 *)uid+4));
+			   uid[0], uid[1], uid[2], uid[3], uid[4]);
 	iounmap(base);
 	return retstr;
 }


