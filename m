Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B473A50279A;
	Wed, 30 Sep 2026 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789602; cv=none; b=j0rl0pBk9jMKwTSzYiplKgTiSi/1lBVv79QKP+yab9RB3NY1lLNvGGJalYi2YrdfCNJgVvA2TShNtg4CYmWztU4Vsh/TK+TKqgnTS9as9dWsa2Cm5/CT+m+yGKanlIYhIVlu4n4qIo14nT2/kVAE7E7zWTtDFHcuihqzVNJhM+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789602; c=relaxed/simple;
	bh=DPCrUG7WhM5mahPfMgyDvIeAX2CLpT6dp6rfAX8VkKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKMpnVTyXR4huwWGg9I2lfM/FvKpH3OBJ7s4DpqbnXT53wqLrvYqUIAHNJUYrXvesSU6aOunmgG3/3i3N1RiM/nXlSeeXM5fdmckymv257yafWisNJ+QeERHV1ECbu3fifzgPZ+BmeichyofRmyuWoilHRW+EseRJ606H4GEEOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8qleCoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8qleCoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1739C1F00898;
	Wed, 30 Sep 2026 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789601;
	bh=L+Z+eZZVFUhZClNcYGmq0vpjZThnWrX6JX3Dhue6MIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8qleCoCcC5Ib1m3yNxjol8qXZyJmOHOqyqD5KzCSTwhPXX8CWq1VKUnxKNu+7DQ7
	 by9hAwbPyjAOjd1GzIoB9/J9BfVZ5st2OqGbI452e/GG6LHchVRJi0RVyvGtyS6yC4
	 SSh5Z2qYBSmgHbu/Rv4+cuXtuPAUNmb8eiSRKMDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jonathan Cormier <jcormier@criticallink.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 498/877] gpio: tps65219: Fix GPIO input value reads
Date: Wed, 30 Sep 2026 17:23:29 +0200
Message-ID: <20260930152425.408868590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,7 +53,7 @@ static int tps65219_gpio_get(struct gpio
 	if (ret)
 		return ret;
 
-	ret = !!(val & BIT(TPS65219_MFP_GPIO_STATUS_MASK));
+	ret = !!(val & TPS65219_MFP_GPIO_STATUS_MASK);
 	dev_warn(dev, "GPIO%d = %d, MULTI_DEVICE_ENABLE, not a standard GPIO\n", offset, ret);
 
 	/*


