Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E3415B96E;
	Mon, 29 Jan 2024 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548280; cv=none; b=hy6R6jhw0/tjKISi9ZF9Gx5Xy/1sYItBFwqGl6PlefCCtCPHAc75qNhdghTcz4Txv2ehQxNTY5TqIKSi7C1Nu1RBmOJF0TtFL/5K73Vm6BwOeSY4xqLiD+xypYx+wg9+62pXQH651C0FSmEdZvPc+rSRE81P4W3xJQxI6MtffR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548280; c=relaxed/simple;
	bh=YBYldfPdDPwiYRZOjKikI8iQN+XQcrCf993wYqkB190=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOcVGFXQ0Xh2ZZ8C2xkt2ll9MJcHJoBnMl3Vc+HuufvIQ6j+1E5R5HaSInNXIrsJos8/144BtZ9bvPXDekIpZ4amUqHZ/RjfQSTW89nXYIp5zPSe4FXF1bY6Ke62sERODcaCVVGvLWgf+1KTBJ53CMgvgMd3hwuitGD8w7b4MTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2KIddLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2KIddLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD93FC433F1;
	Mon, 29 Jan 2024 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548279;
	bh=YBYldfPdDPwiYRZOjKikI8iQN+XQcrCf993wYqkB190=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2KIddLuRv86UaAUHeLfKnZz5s5MjLfRu6cWoijIA4qFV4+YHzLDsi8UwSaUnZQ1K
	 HU/nl3p8G0as21oiUrYHzLKdztpFqTaivZGWm0NXuokijocIEnhzL8TKmgPHEChkwF
	 BH3/8lgpH3mqQngYP2kI6UI1LbHcJuO7J7Vy9ROg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 066/185] serial: sc16is7xx: improve do/while loop in sc16is7xx_irq()
Date: Mon, 29 Jan 2024 09:04:26 -0800
Message-ID: <20240129170000.727001003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit d5078509c8b06c5c472a60232815e41af81c6446 upstream.

Simplify and improve readability by replacing while(1) loop with
do {} while, and by using the keep_polling variable as the exit
condition, making it more explicit.

Fixes: 834449872105 ("sc16is7xx: Fix for multi-channel stall")
Cc:  <stable@vger.kernel.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-6-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -784,17 +784,18 @@ out_port_irq:
 
 static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 {
+	bool keep_polling;
+
 	struct sc16is7xx_port *s = (struct sc16is7xx_port *)dev_id;
 
-	while (1) {
-		bool keep_polling = false;
+	do {
 		int i;
 
+		keep_polling = false;
+
 		for (i = 0; i < s->devtype->nr_uart; ++i)
 			keep_polling |= sc16is7xx_port_irq(s, i);
-		if (!keep_polling)
-			break;
-	}
+	} while (keep_polling);
 
 	return IRQ_HANDLED;
 }


