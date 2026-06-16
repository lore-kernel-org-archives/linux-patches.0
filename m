Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A3438B135;
	Tue, 16 Jun 2026 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623317; cv=none; b=Dsh0OwhPq2eeWcaNA0aFMzCbWTzz1IN5EEeN0mbRVQ8NK2E78Zn89x3IZcVYQGMtkeZkNXrOtiKdWV7Nhny+N+OYhp81Aw7v6fDE4LRCP3I8vc3Nip0hnIWWXaPuEBOp1cLfhePmt5k7YlwpxghCRnaRbk7bn4nO4X471pcYoog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623317; c=relaxed/simple;
	bh=NLOdzruKsG0xrK/DFvRa1q+6WFK6+5NPptku1eXHTfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zn5Ygu9tb5dzG5TFVW/plHrqhhzzWshXBmvkE2PZUJmOf8j5nywpqgslu9YnU5f/BtpVnkI7CnoG3qH3HR2vdeb677c9NmPxTO+vcfPqW4CGr84tYqguSg1bsrD0CCXsKaM1ShYX0jYJFnBlp9WheaIkM73VHRmeGGignG2lqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpsyemEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpsyemEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFB01F000E9;
	Tue, 16 Jun 2026 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623316;
	bh=CaTpJP6TmhY49PIv0I4LdF+Q49JcCn6vHkCB5aaD5qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpsyemEUfEMZC2P83sI2TbrtQu1DBsNkHL6MrADioWDvBmFfGxDMi7MxHb3YVWrhC
	 kXZRxMkPmdQZt2oI4L77CxqfEWff1VnM4VbzKBi1/s3p74Q3FWfZVllO0H62yUnkgq
	 HRLLiNkCZ7UiZGX4pCiJRcBaIpa6GCKDl6yx2aEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 125/378] gpio: zynq: fix runtime PM leak on remove
Date: Tue, 16 Jun 2026 20:25:56 +0530
Message-ID: <20260616145116.923073798@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 571e366624d2af..fafca91128b2e6 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -1014,6 +1014,7 @@ static void zynq_gpio_remove(struct platform_device *pdev)
 	gpiochip_remove(&gpio->chip);
 	device_set_wakeup_capable(&pdev->dev, 0);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 }
 
 static struct platform_driver zynq_gpio_driver = {
-- 
2.53.0



