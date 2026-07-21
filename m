Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2A6470138;
	Tue, 21 Jul 2026 19:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663071; cv=none; b=d6woqh/VnIws7yKHQ/JRmMt7yhV6zlzSXzm/zlD9Jh5Xvr9F/XF+V42HEH+Fu+pxQXDQzY3/dFWoaHMo775ncsKOs8jxGe5lLZx8IHTYMlXdcxCux8Keduzd3M3QN6mgJLalK6urt8OFpLyfg6njGJ1f9J7Es+XK4PzSH2oaBO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663071; c=relaxed/simple;
	bh=RIQypqWn5xWcg+J2ayq5R6p3eGAwGQYo5lym/w0q5Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5d+yqJYO0PxgIS3z0TOUD438KkjJ1HaQycK3KvwdhLY4bUeSPnSN4/VCEiLzAhk9Za1eWhFMXmI2VY7ltO0QUv1tZV2froqEVxKCRNDuxr+h7tcJx1VMu/Xg+s9BwdsNcph/XmC2cMlF0UzPiy89Mp8/GmKGduFjyKj/C74oJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye1PWtzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye1PWtzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C281F000E9;
	Tue, 21 Jul 2026 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663070;
	bh=fsVm1eQHLggrWRe93JoCscMetCc7N/LkwVKXKakb4+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ye1PWtzSslZoTKfd5hO9NNMc2DlOXdg5P2bWdzycYlYWS1LCShAhDu2oMtX0ZuBtv
	 SYDEDCVnu9dcIcmQVTzlh1b+/b1pm1IdLsCmHQEAJ5X+S39BWM8V8U9kjbH3a7i6Li
	 SyV8G5Nt33VZldeJpX3/pkE7bye1CROx66ahUHF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0647/1276] gpio: davinci: fix IRQ domain leak on devm_kzalloc failure
Date: Tue, 21 Jul 2026 17:18:10 +0200
Message-ID: <20260721152500.589080325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit 4e8eb6952aa6749726c6c3763ae0032a6332c24f ]

In davinci_gpio_irq_setup(), after successfully creating an IRQ domain
with irq_domain_create_legacy(), a subsequent devm_kzalloc() failure
in the bank loop causes the function to return -ENOMEM without
removing the IRQ domain.

Unlike devm-managed resources, irq_domain_create_legacy() does not
auto-clean up on probe failure, so the domain is leaked.

Fix by calling irq_domain_remove() before returning on allocation
failure.

Fixes: b5cf3fd827d2 ("gpio: davinci: Redesign driver to accommodate ngpios in one gpio chip")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Link: https://patch.msgid.link/20260623023106.117229-1-fffsqian@163.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 76b58c70b2577f..6d12a65b075288 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -552,8 +552,10 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 				       sizeof(struct
 					      davinci_gpio_irq_data),
 					      GFP_KERNEL);
-		if (!irqdata)
+		if (!irqdata) {
+			irq_domain_remove(chips->irq_domain);
 			return -ENOMEM;
+		}
 
 		irqdata->regs = g;
 		irqdata->bank_num = bank;
-- 
2.53.0



