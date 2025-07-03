Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C22EA49E;
	Thu,  3 Jul 2025 14:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554630; cv=none; b=Pyx3mIqFYJA6lv+6YEfzTbkojkENF9IDlrhcB9i6YdWOlSHHgp7V39Sq6L3UsepACdO6YoHHjXnU9KsyHUpfYp8gCh4ve6s8g12mhXlgHTl7XDnI7FnSyTq37D4sZ06IDXV8j/qEnGRt6QlRuX6CyfruAE5MFnm6lcH1zhpcak0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554630; c=relaxed/simple;
	bh=iX7u8ocsRSgKgX2YZP3qKSIzNEvMo7qE71BpSvW9EUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7hHVlE+dLXLLi/dx40Xi+LnNaKyP2Nw+Q3rDELBiHj21pqlG37DNw1Y3DCu73QGHLFtuEvKVVuPFOFr3oghrRx/XHFDxHRbiPfBk6LY0aj9DUoczUStCWgBbkR31wupzstk95P+KWKNIVVKwdgW0ypZfS6JGSvU6LiXJHmWKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUC4lolc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUC4lolc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEA0C4CEE3;
	Thu,  3 Jul 2025 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554630;
	bh=iX7u8ocsRSgKgX2YZP3qKSIzNEvMo7qE71BpSvW9EUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUC4lolc6WRyf8zg2IQiRlTEtntUbbR+MQ7N2uOAMQi8eaceTQKuC2ewLWbpeAo8+
	 inmMAcwIMNndIlZYCm6Lnmit4EhDQvhr1il9So9eWTR5ej+YJxTLcha35tH1CskliP
	 sJBF+YgYhQKf8AwhLEaq/bSE2uKjKveECmjH2Jxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 009/263] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:38:49 +0200
Message-ID: <20250703144004.665518239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d905d06e64b0eb3da43af6186c132f5282197998 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-3-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max14577.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 6fce79ec2dc64..7e7e8af9af224 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -456,6 +456,7 @@ static void max14577_i2c_remove(struct i2c_client *i2c)
 {
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
+	device_init_wakeup(max14577->dev, false);
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
-- 
2.39.5



