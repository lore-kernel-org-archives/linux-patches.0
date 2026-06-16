Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D541843D4F7;
	Tue, 16 Jun 2026 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625278; cv=none; b=Hh0O3azwwZNXgf/p6scwJxDtllLtmXtylkwS0p98435XhcO7GYPziNTfaFFIL6J6QY4wfbk/JdeAaWYE+ze9pmekV1FUnUKSns4DgrxYfZ7JPS8PrRsSLxBsDB3tURY27G3K+tSPSal1kKI/C8xVAsjiUK2lcQHNpR5LoC0SyqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625278; c=relaxed/simple;
	bh=98hOUEik7NMYb+VGuqlfYeZVYLjMSlBW54mcbcbT2nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMZLHgbnyfkt1CtCwVhlsnfrMB4YGl9cwtOyVsPB20hVJu7KkumhtVds4fC7xtZ1pPcdsp7Ee+JprAjAsjntDaLKYD5GZMD4erRRGQwWzR3RHkseW8Bi4N2SWfxmxObSWbhPvkJasr2hxOBfAMkIjwYFDAiCYpUjQ2ATqGhHkNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTJXuzmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTJXuzmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF2E1F000E9;
	Tue, 16 Jun 2026 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625277;
	bh=jTA9gSFynZ/Fg0ha+X1zvwlnV+MFSIIxyJjWxsEUG+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTJXuzmtgcFl9lx69OPbOZXFMmBxAqntS2D3kRfIgHu5jZ1j6yNYFlReWsj9TW+Dx
	 tCg3C1eG7m3/HjeOD2T9pfIIhnrJ/bXJ6GL3W3TbW+K5nKybPZAsL1LG6aVI9N4nnV
	 uNMd66f7YtboKzzoNvro7aWEPsGM0gmDTlWOCl8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/325] gpio: zynq: fix runtime PM leak on remove
Date: Tue, 16 Jun 2026 20:28:26 +0530
Message-ID: <20260616145103.189014373@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 6edb934de9bda3b7abcec856eaee6fc8b4278dd1 ]

pm_runtime_get_sync() increments the runtime PM usage counter even when it
returns an error. zynq_gpio_remove() uses it to keep the controller active
while removing the GPIO chip, but never drops the usage counter again.

Balance the get with pm_runtime_put_noidle() after disabling runtime PM.

Fixes: 3242ba117e9b ("gpio: Add driver for Zynq GPIO controller")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260609073313.5-1-ruoyuw560@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-zynq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index 0ffd76e8951fc0..c2e4a79cd6d8ce 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1017,6 +1017,7 @@ static void zynq_gpio_remove(struct platform_device *pdev)
 	gpiochip_remove(&gpio->chip);
 	device_set_wakeup_capable(&pdev->dev, 0);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 static struct platform_driver zynq_gpio_driver = {
-- 
2.53.0



