Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D088F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B6EC433C9;
	Sun, 16 Jul 2023 20:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537905;
	bh=WeDdmF1jhn9s0NSur76mXO6jxWqYLBUPJNatxsTRSEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQaD0RGeVOLtPoAgDzTg8E7gaphQLX+ExEYdCRVibReYnPkC9uYxGjSMGBOUqH8ss
	 xOIw84Yyh1ssJkItxeoGk5PneBgaYTOb1FaD8KMqRX7pzHypFFXejKHNECHvb6Fx5t
	 J/YGy6td6gVkHa3rXAM9vdhj3wbce4eZl8gCHU74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 262/800] bus: ti-sysc: Fix dispc quirk masking bool variables
Date: Sun, 16 Jul 2023 21:41:55 +0200
Message-ID: <20230716194955.182387583@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit f620596fa347170852da499e778a5736d79a4b79 ]

Fix warning drivers/bus/ti-sysc.c:1806 sysc_quirk_dispc()
warn: masking a bool.

While at it let's add a comment for what were doing to make
the code a bit easier to follow.

Fixes: 7324a7a0d5e2 ("bus: ti-sysc: Implement display subsystem reset quirk")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-omap/a8ec8a68-9c2c-4076-bf47-09fccce7659f@kili.mountain/
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 6c49de37d5e90..21fe9854703f9 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1791,7 +1791,7 @@ static u32 sysc_quirk_dispc(struct sysc *ddata, int dispc_offset,
 	if (!ddata->module_va)
 		return -EIO;
 
-	/* DISP_CONTROL */
+	/* DISP_CONTROL, shut down lcd and digit on disable if enabled */
 	val = sysc_read(ddata, dispc_offset + 0x40);
 	lcd_en = val & lcd_en_mask;
 	digit_en = val & digit_en_mask;
@@ -1803,7 +1803,7 @@ static u32 sysc_quirk_dispc(struct sysc *ddata, int dispc_offset,
 		else
 			irq_mask |= BIT(2) | BIT(3);	/* EVSYNC bits */
 	}
-	if (disable & (lcd_en | digit_en))
+	if (disable && (lcd_en || digit_en))
 		sysc_write(ddata, dispc_offset + 0x40,
 			   val & ~(lcd_en_mask | digit_en_mask));
 
-- 
2.39.2



