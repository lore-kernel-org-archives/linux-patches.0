Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960042E3AE9;
	Tue, 15 Jul 2025 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587479; cv=none; b=gzRKXOgWvCtKhM7cvIAsGmeJgOmsRMwTZFDB431llbl/6XqaCsXFa/dhuUW6t8WifUrv5MeYa3TV+Lctuf/S2uBUIUp0Bf6j0HbQnEyDKaaCquBzNV9RhkZ9aYwqEOpGS9ZggISetKnidNof6K6u8kXkMMxsCHL7zBglzXHY8IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587479; c=relaxed/simple;
	bh=iBsN+hQi2r7+Mvgm6b7n9RSVk00hYCZi0KRhaBhfl6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvU953TMrTcfKVvHBHFIWda+RZ8S/tELH39JVNVLH6dnuOvPR90kRPEmAP7gnvnMfSBcJakNcjcmI2WtuXucm7ylF9LDUf49rJ3fwgdF3/LPx5iJy7UDHdt4DLRZAW51vhRVUTLijnuzVlajjd2mtpp3vwQj2EI5d0V4rPnHVhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEDyRqdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEDyRqdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C47C4CEE3;
	Tue, 15 Jul 2025 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587479;
	bh=iBsN+hQi2r7+Mvgm6b7n9RSVk00hYCZi0KRhaBhfl6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEDyRqdBWWCdbFMee7t63P1TKfVooXNQ5U1loc4AZjeA207dms46B7uQG2gVkfCgL
	 m8zkvk+0kIPGfnzctcrczBOyG+9SurI6Q8+22Prr8CjhurKk4X/dPBiE5KXOprZcfY
	 t6Nk6i4TtnjR+Fs2QLQvqSyI/pZyb0HZjffgMroc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/208] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Tue, 15 Jul 2025 15:11:53 +0200
Message-ID: <20250715130811.012778653@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index be185e9d5f16b..c9e56145b08bd 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -467,6 +467,7 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 {
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
+	device_init_wakeup(max14577->dev, false);
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
-- 
2.39.5



