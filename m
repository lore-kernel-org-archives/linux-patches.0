Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A30B389104;
	Wed, 30 Sep 2026 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787657; cv=none; b=PRlxPUn0+eWkohzvKqpmoTQ9KibfZ0JeEI+VTIIU88PJ+lgfif+ducarAxc3wZQwM/3LnEaFrikRO+1PEOe9O5eG09F/1p10+x2TS6ZafycsNyjh2cP5+uDJ3nGXUa2OGyNy/kOLiIwFtbVh8UkXgM3pP83nGOaQ7zAcYsSv8rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787657; c=relaxed/simple;
	bh=jbGQejqyWnXWs4JD/5H8nAktR5HFGK0bi4yG8/vnkd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LunH6N8uddIwBopziE5Sz9mchgJKG0E1lhTnsyQ4cGBcBI/t5SsBdTucJqa10nCVOAdN8yzNrQM++uM24vdp1Rg6Ct5PRjPbtcj4jPCe5J7WmartrEfhxZv9p3hNDCoCY9HxZW+akMkBOq1rSyidSEnpYf1cu3IVDTfFtgizkm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7sV3QxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7sV3QxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8651D1F000FF;
	Wed, 30 Sep 2026 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787656;
	bh=PSV74dNW5gWeLxbqramlHkLi/NrxS9S5E4rAHnpcv4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7sV3QxA0CRm30Z9X727YoNfg9E+ZCs3oxnm0GCuXytKKt1W3AJ5z77ntQfiu4M4e
	 ul4y1mhPDonqgPH7wiiM5We/58vcgGemAZZLeYXbF1jpcEOsZZvm+bmatpfptxOxL/
	 V5dACWE1pvWUWLv+CYDAuKdbXApdThv3qlXOPsBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 308/457] gpio: tps65219: Fix GPIO input value reads
Date: Wed, 30 Sep 2026 17:26:53 +0200
Message-ID: <20260930152352.676536313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 4cbe530c0233c7413aaaeb029a4f32dd6aadacbb upstream.

TPS65219_MFP_GPIO_STATUS_MASK is already BIT(4). Passing it to BIT()
again tests bit 16, which cannot be set in the 8-bit MFP_CTRL register,
so GPIO0 is always reported low when configured as an input.

Test the register value with the mask directly.

Fixes: 57e30e00bd5b ("gpio: tps65219: add GPIO support for TPS65219 PMIC")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jonathan Cormier <jcormier@criticallink.com>
Link: https://patch.msgid.link/20260919171100.90430-2-kmehltretter@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tps65219.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-tps65219.c
+++ b/drivers/gpio/gpio-tps65219.c
@@ -79,7 +79,7 @@ static int tps65219_gpio_get(struct gpio
 	if (ret)
 		return ret;
 
-	ret = !!(val & BIT(TPS65219_MFP_GPIO_STATUS_MASK));
+	ret = !!(val & TPS65219_MFP_GPIO_STATUS_MASK);
 	dev_warn(dev, "GPIO%d = %d, MULTI_DEVICE_ENABLE, not a standard GPIO\n", offset, ret);
 
 	/*


