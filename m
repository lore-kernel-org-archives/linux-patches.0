Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8959242FCC9;
	Tue, 21 Jul 2026 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662858; cv=none; b=tgNKsX7RO9hKHtCZYLBHEmeWxT/CU6qmwGEfjugvZwV2z5sQ4NgEAdAOm9No/iOjYs6kCxcZ4hmYvJI7pZdbUqqB6WDAfvre2OE7iHH2cVz9ihhNHUFJ3I4DSJGUPfPh2lsfZdZFVbDpzyZZNlLKoOQRGZ0uTkIpchsDFVGSWR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662858; c=relaxed/simple;
	bh=TnnwRXItpafM7msbzpBq15Oce+aKgFiJFSnBpqDriTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/fLoYetoBcvNOybIO8IpT0H/orPg3VaFBimhme3JgY+dUbM4E8PLzhb4VOVZNp2RvW9Idvk8hoUJq3tkpUhHNGBndGkMFw7yyl0yJSkwcn7WRffoHOk3EpQNzUH2iM1ufLjQ4tBJ6Tsjkm1Ya4wpVaxvc0pW7otPS8lUgJkSdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=er3M/Pp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er3M/Pp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93761F00A3A;
	Tue, 21 Jul 2026 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662856;
	bh=zEa3ykBcSsVDdfXHv3sdjHk7zQsyBLaxUd9U57SGCt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=er3M/Pp7lxJAiw1hmNpa3hHSwWHpFBc5ZRHEuI/R14g8OBp2lIeC0OXfwJBt0Iep/
	 Zd5p0w0MVNNW20K2ymrAokV4av58QYCIpPuBdaGjSQ7HUjmV0XdcNxcN+m7ubCrIv6
	 OdB7YJHwqHFH1Lgb/nUtJHVBfskoqeOYqgC6gHg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0560/1276] gpio: mlxbf3: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:16:43 +0200
Message-ID: <20260721152458.650588537@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 0482862a90169f4daaba0ed31a85d8304bf51e04 ]

mlxbf3_gpio_probe() logs a devm_gpiochip_add_data() failure but still
returns success. That leaves the platform device bound even though the
GPIO chip was not registered.

Return the registration error so probe failure matches the missing
gpiochip state.

Fixes: cd33f216d241 ("gpio: mlxbf3: Add gpio driver support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260615091918.43333-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mlxbf3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mlxbf3.c b/drivers/gpio/gpio-mlxbf3.c
index ed29b07d16c190..a662989ff21e7c 100644
--- a/drivers/gpio/gpio-mlxbf3.c
+++ b/drivers/gpio/gpio-mlxbf3.c
@@ -252,7 +252,8 @@ static int mlxbf3_gpio_probe(struct platform_device *pdev)
 
 	ret = devm_gpiochip_add_data(dev, &gs->gc, gs);
 	if (ret)
-		dev_err_probe(dev, ret, "Failed adding memory mapped gpiochip\n");
+		return dev_err_probe(dev, ret,
+				     "Failed adding memory mapped gpiochip\n");
 
 	return 0;
 }
-- 
2.53.0



