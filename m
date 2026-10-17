Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB48E394470;
	Sat, 17 Oct 2026 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257365; cv=none; b=oS3UDk0lpNpUA47GliokE4ajai3/XuVORdNv41u9XnAEeRAG+aSERLBydN+3+SqdtYWuzUJWh2zFwxpS/tMTPDqBHRbhqL26WiPjzH7WsXVHsh1VaGrdm3K9aPDGKQylAX8ieR65mFR7xpShzoj0ZLzCrDEq6DmmeJZgEvKK+Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257365; c=relaxed/simple;
	bh=GqP0X+HhxtD2nFkVBtNxE+h44g1FLW0vk6jNP80ZW8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSLW/17iZrMXEnEMB0xsQ1sxjrJUCdlLjEadffs13v4n1+1ojK3FHM1WK1MXdlwyZ1Dy0Zq9ibcA0gXP90giwaq19LHqyKw1/Om1sbZaSn6gbgtiLBxYG+WNt6hhYUt8JNts9xskwbpO9gZ0CzZYvtVqEKBHncjxdVy82yUS0pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHzXC5D1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHzXC5D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0347F1F000C4;
	Sat, 17 Oct 2026 17:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257364;
	bh=Swf5YFz9iEX8n2RJ+TIlCU6b2aKxqDcnl420llij1F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHzXC5D1QZmvoJoc/K+CfkZTYQ5bdGOlhlrI41HSpPlIwLGn5CALBM8ftefl7q1WU
	 SpM4SVhhCuQBnqx4KZ7mK3+D++JztWgHJf3RsaOUn2IgVz1q1mB1BY2jwxCRyuMjiW
	 uvdMllW71jQ/9QzvYftIyxL1QRJxbLzmXSTG7yLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0537/1674] gpio: exar: initialize the ID before registering its cleanup
Date: Sat, 17 Oct 2026 17:46:49 +0200
Message-ID: <20261017160444.886642332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4d69e74034b208588636ecc177e0dd43a7696af3 ]

devm_add_action_or_reset() invokes the cleanup action immediately when
registering the action fails.  gpio_exar_probe() currently stores the
allocated ID in exar_gpio only after registering the action, so that
failure makes exar_devm_ida_free() release ID 0.  If the allocated ID is
nonzero, this leaks that ID and can free ID 0 belonging to another device.

Store the ID before registering the cleanup action so both the immediate
failure path and normal device teardown release the correct allocation.

Fixes: 5300ebb695fa ("gpio: exar: use devm action for freeing the IDA and drop remove()")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/179070265834.12871.48183786512201899.idr-bug-79@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-exar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-exar.c b/drivers/gpio/gpio-exar.c
index d5909a4f0433c..e526fdee4c43b 100644
--- a/drivers/gpio/gpio-exar.c
+++ b/drivers/gpio/gpio-exar.c
@@ -197,6 +197,7 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	index = ida_alloc(&ida_index, GFP_KERNEL);
 	if (index < 0)
 		return index;
+	exar_gpio->index = index;
 
 	ret = devm_add_action_or_reset(dev, exar_devm_ida_free, exar_gpio);
 	if (ret)
@@ -212,7 +213,6 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	exar_gpio->gpio_chip.set = exar_set_value;
 	exar_gpio->gpio_chip.base = -1;
 	exar_gpio->gpio_chip.ngpio = ngpios;
-	exar_gpio->index = index;
 	exar_gpio->first_pin = first_pin;
 
 	ret = devm_gpiochip_add_data(dev, &exar_gpio->gpio_chip, exar_gpio);
-- 
2.53.0



