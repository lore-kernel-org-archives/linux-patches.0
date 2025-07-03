Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00AF2ED17E;
	Thu,  3 Jul 2025 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555512; cv=none; b=qov1hIeRzBw2nuaOqhQ0y/XQ/1zPsN0BcxhCKdREyGSvzm8AAkr46/AhCws5f4RsAjgP0cvTvkw3scbxQwFSeG083KM/b0H6/iiQnNJtgRM9WAh5/UnYCfPQy3BL0z8ZMJWU6tHK6CbIRegPDX6m8bKnG1m1HqfTH6nqge0BBt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555512; c=relaxed/simple;
	bh=gqdzqfU5XuZI7pbEYzOt/cebTNXRCNT6IkqIHYi1M2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shhthAYoqaC7ZnCuPEAf0rCV5K9iX0fXSIz+Lx6knRg9/kAwySu6z9Ao6qkWrRgXAUzIGjE/DTl1KKBZOfdkdZgS4xidtp4VqPCfoXneuO+yng8RK4hNsWruXpzdN0mN17Rrg643zU6bjLXk1iKkfDeAU/NRl5SpehbCRujDfrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idRWf99J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idRWf99J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB66C4CEF2;
	Thu,  3 Jul 2025 15:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555512;
	bh=gqdzqfU5XuZI7pbEYzOt/cebTNXRCNT6IkqIHYi1M2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idRWf99JWoySbgCw20FKWpZ1g2Q9tI23kS5gy9/iF8FK0/snxHDW1j8cx8NjdPnEK
	 InntKD+aMzZYpdz2e5bxHsDHDOf9A/vqTx90w2RMGNdhkolPazU2HIeaeN8WA6ehyl
	 v2riFiMDx0Kppx0gXseNwWs88yAbQi8SfzVyUMdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/139] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:41:10 +0200
Message-ID: <20250703143941.466615907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f4f5002595c0..17672eeb1732a 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -463,6 +463,7 @@ static void max14577_i2c_remove(struct i2c_client *i2c)
 {
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
+	device_init_wakeup(max14577->dev, false);
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
-- 
2.39.5



