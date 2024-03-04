Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488277A70D;
	Mon,  4 Mar 2024 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588429; cv=none; b=uKGNexPoFqeWgnXmvmHo1Z33OAII6MxMGimOrBHTdDDSf6lbwPeb/rYanf/3t8qDB87D2jQtE4P35buLLcwUfcxhLCPg30mYI4HzoWNYgex9oGHyTy8qtF/whkQB8DwzFwMERtmv6zIOwGhMlYNX1L2LXj+K69NjtSL5yjaHBNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588429; c=relaxed/simple;
	bh=VUaq+fMGKeZ2C7PNGY0Hm7stQrLe3JhwRT9TfxPBeNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqxCaQ6kMe5266OBg9/it88PWiYgok6FJkV96SCbMZJItfKvnnfvyK87/ADFwlczw/+SvN7Wo6e0ZsMtGt6wwDZil8MYNU24+sBjlgsSwBLB/rv9J4BtLJQyUvYrme1fpvNsb24QFgYTEGZHuCMivAEgnfPOSI1rQx0mPFFr2FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jGeG1Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jGeG1Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D851C433F1;
	Mon,  4 Mar 2024 21:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588428;
	bh=VUaq+fMGKeZ2C7PNGY0Hm7stQrLe3JhwRT9TfxPBeNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jGeG1IrveUGLAorTQ0OWEIHHvV2L3Vx8MI2zl3fbEKlMuw/lu3EYAjWKP948h/WP
	 Y4kfWU/XPNrbu9nfBDch/DZStwR3gOqx9u3PzKrCR17GzO1Ll6dyV27xvFvZjjLqJT
	 9BrqwftXiR6uEIEgruIo+BgL7lqyFoXhJ3AT6hAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elad Nachman <enachman@marvell.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 079/143] mtd: rawnand: marvell: fix layouts
Date: Mon,  4 Mar 2024 21:23:19 +0000
Message-ID: <20240304211552.454950620@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Elad Nachman <enachman@marvell.com>

commit e6a30d0c48a1e8a68f1cc413bee65302ab03ddfb upstream.

The check in nand_base.c, nand_scan_tail() : has the following code:
(ecc->steps * ecc->size != mtd->writesize) which fails for some NAND chips.
Remove ECC entries in this driver which are not integral multiplications,
and adjust the number of chunks for entries which fails the above
calculation so it will calculate correctly (this was previously done
automatically before the check and was removed in a later commit).

Fixes: 68c18dae6888 ("mtd: rawnand: marvell: add missing layouts")
Cc: stable@vger.kernel.org
Signed-off-by: Elad Nachman <enachman@marvell.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/marvell_nand.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -290,16 +290,13 @@ static const struct marvell_hw_ecc_layou
 	MARVELL_LAYOUT( 2048,   512,  4,  1,  1, 2048, 32, 30,  0,  0,  0),
 	MARVELL_LAYOUT( 2048,   512,  8,  2,  1, 1024,  0, 30,1024,32, 30),
 	MARVELL_LAYOUT( 2048,   512,  8,  2,  1, 1024,  0, 30,1024,64, 30),
-	MARVELL_LAYOUT( 2048,   512,  12, 3,  2, 704,   0, 30,640,  0, 30),
-	MARVELL_LAYOUT( 2048,   512,  16, 5,  4, 512,   0, 30,  0, 32, 30),
+	MARVELL_LAYOUT( 2048,   512,  16, 4,  4, 512,   0, 30,  0, 32, 30),
 	MARVELL_LAYOUT( 4096,   512,  4,  2,  2, 2048, 32, 30,  0,  0,  0),
-	MARVELL_LAYOUT( 4096,   512,  8,  5,  4, 1024,  0, 30,  0, 64, 30),
-	MARVELL_LAYOUT( 4096,   512,  12, 6,  5, 704,   0, 30,576, 32, 30),
-	MARVELL_LAYOUT( 4096,   512,  16, 9,  8, 512,   0, 30,  0, 32, 30),
+	MARVELL_LAYOUT( 4096,   512,  8,  4,  4, 1024,  0, 30,  0, 64, 30),
+	MARVELL_LAYOUT( 4096,   512,  16, 8,  8, 512,   0, 30,  0, 32, 30),
 	MARVELL_LAYOUT( 8192,   512,  4,  4,  4, 2048,  0, 30,  0,  0,  0),
-	MARVELL_LAYOUT( 8192,   512,  8,  9,  8, 1024,  0, 30,  0, 160, 30),
-	MARVELL_LAYOUT( 8192,   512,  12, 12, 11, 704,  0, 30,448,  64, 30),
-	MARVELL_LAYOUT( 8192,   512,  16, 17, 16, 512,  0, 30,  0,  32, 30),
+	MARVELL_LAYOUT( 8192,   512,  8,  8,  8, 1024,  0, 30,  0, 160, 30),
+	MARVELL_LAYOUT( 8192,   512,  16, 16, 16, 512,  0, 30,  0,  32, 30),
 };
 
 /**


