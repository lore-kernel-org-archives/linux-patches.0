Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0EC4508E4;
	Tue, 16 Jun 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626903; cv=none; b=WkysIyz87yDqaIl0pBgX26FrwugNQ8/S2p1cp7eUuBgSgsfJ1AYHi7DE3zkUtpY5YH7nHXXRHqLwZDpmUsMdp9OhAV5kL79izrcRQLraLitAwUX3tB5ks6r8oN4lI6G7omvjivY2etj3boi/GhoOIFn/dfYzOUPKAo7nRD3DblI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626903; c=relaxed/simple;
	bh=dT63aIfT90nJ3bpGj5KVLL1MP4GqiyMyfOxZ2AqnK6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT5NW19aFrwvDrWLUBptevhgZeYAnWN2zZ0x+HVGnW2o2hiwS2OvDroaj4sGyVsMO5UUrZOSyXYd8MGDxLKYIcotO0z69PmZWjfSPZbfVuDLVzAzSE/mVPOp7mU/rkmtLKQlGorEoLAoGksuqknet+z8JPLsJjufb2rOrLHVBtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxK1wh55; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxK1wh55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4941F000E9;
	Tue, 16 Jun 2026 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626902;
	bh=XJMqU8LHyU8DCw9SN5/HzlLfaez06qCMEkmAw6bKYmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxK1wh55REzlgD04WhoJ+ad4ZXgn8MhxXR7jLunfxBKcuOL+tWnY0/FP8qjdmQBZ7
	 Tk63fdlwSdmrAWCxuKx+7G7bct0xS5JPJiZePRoKIpQiyIUgWyQUcMJqx9uOhrsVyW
	 o6F/z1dgawj4qsOgmV1V0O7ZQpxJTMBPU0xYXxaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/261] gpio: zynq: fix runtime PM leak on remove
Date: Tue, 16 Jun 2026 20:28:49 +0530
Message-ID: <20260616145049.252311036@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index cc53e6940ad7e6..50fa4938161dde 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1015,6 +1015,7 @@ static void zynq_gpio_remove(struct platform_device *pdev)
 	gpiochip_remove(&gpio->chip);
 	device_set_wakeup_capable(&pdev->dev, 0);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 static struct platform_driver zynq_gpio_driver = {
-- 
2.53.0



