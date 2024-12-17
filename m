Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EDF140E38;
	Tue, 17 Dec 2024 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456355; cv=none; b=idhNUtAlkPT6HmCr1U3rEv0o9tnDUvs5jjvVo7z+BeGEF+AGz96LBvoYr3pi5G7w4EdvU4qM++9icVSKJ8TbbQ7b8fs+hp61KJUWufapepcEA09qZ3vVMDKvkZK+FtFhYOfGj5AgaQSgZJIfvpltr92JT8cDwzWinwVznUeKjtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456355; c=relaxed/simple;
	bh=Fxav36wyEyWd7Yyaa7BCsAB9rgGUVMsPWsyialfVVHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmFerxwBJ3WBGpVVVJ173nOf46w4UfDHnmWA1p6BDSz+dE542WnpFumkhpTkiTfT4wDa8yHTb7QKv9GXaus/vRAXoUnFeAcG7y3uYVfP9QIneQyjtGvqgvxQIIpKMrswgljlKy92QKm8cbLJ7szX5Wnsl6lo9STSqPJQAeuJbGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjvoewL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjvoewL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C199C4CED3;
	Tue, 17 Dec 2024 17:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456354;
	bh=Fxav36wyEyWd7Yyaa7BCsAB9rgGUVMsPWsyialfVVHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjvoewL5fIZ3vicftCZYNUp73JygBs+SgdeATIpr8AsyuobwkDDYu9TpCPH+xIPfz
	 KAOVG9KHMAFWdYwZ6X5SNlgQATHyE1kbVXABple8GQeJd25SN/h0U5f74Cxab8ITzF
	 +RXfQMmdr2ucHRqNAsMnNMze1rRF3wYNHdjglh6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 032/172] gpio: graniterapids: Fix vGPIO driver crash
Date: Tue, 17 Dec 2024 18:06:28 +0100
Message-ID: <20241217170547.594930447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit eb9640fd1ce666610b77f5997596e9570a36378f upstream.

Move setting irq_chip.name from probe() function to the initialization
of "irq_chip" struct in order to fix vGPIO driver crash during bootup.

Crash was caused by unauthorized modification of irq_chip.name field
where irq_chip struct was initialized as const.

This behavior is a consequence of suboptimal implementation of
gpio_irq_chip_set_chip(), which should be changed to avoid
casting away const qualifier.

Crash log:
BUG: unable to handle page fault for address: ffffffffc0ba81c0
/#PF: supervisor write access in kernel mode
/#PF: error_code(0x0003) - permissions violation
CPU: 33 UID: 0 PID: 1075 Comm: systemd-udevd Not tainted 6.12.0-rc6-00077-g2e1b3cc9d7f7 #1
Hardware name: Intel Corporation Kaseyville RP/Kaseyville RP, BIOS KVLDCRB1.PGS.0026.D73.2410081258 10/08/2024
RIP: 0010:gnr_gpio_probe+0x171/0x220 [gpio_graniterapids]

Cc: stable@vger.kernel.org
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-2-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -234,6 +234,7 @@ static int gnr_gpio_irq_set_type(struct
 }
 
 static const struct irq_chip gnr_gpio_irq_chip = {
+	.name		= "gpio-graniterapids",
 	.irq_ack	= gnr_gpio_irq_ack,
 	.irq_mask	= gnr_gpio_irq_mask,
 	.irq_unmask	= gnr_gpio_irq_unmask,
@@ -324,7 +325,6 @@ static int gnr_gpio_probe(struct platfor
 
 	girq = &priv->gc.irq;
 	gpio_irq_chip_set_chip(girq, &gnr_gpio_irq_chip);
-	girq->chip->name	= dev_name(dev);
 	girq->parent_handler	= NULL;
 	girq->num_parents	= 0;
 	girq->parents		= NULL;


