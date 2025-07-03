Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FF12EF2B3;
	Thu,  3 Jul 2025 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553935; cv=none; b=i0SbAKSnvtVi15v4gleWgcHkhxKoZdezFZDamgz90a6go3nRPGDqvhk3t2aY1Exiutcj1snTNI2g4Ae5LzLajV1+Kh4dOo2Uq+hv4rMJM706QQtHgxqN9QgmMDNwsu6td4ayAW/x9DIajk1Si/49ekqpCT6tDMpO4idTTvSjspY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553935; c=relaxed/simple;
	bh=REhjrUiMYeXu9FkTT4OPQf8W+ebHTTLxx1gweNmagC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgiA30ORxCS5TuW26AeyQN2hg9GyPn6WMJ199ujZ7wEfcPcqDED/AXmgNMe+kX3RDd51AupbqXabwkWX7SXsvRWcM3rIAU2Dnbk8CJatUEXYHnIRoT0ITSP9wNbAsNqlT1N4hAQwEoso75UB1BazC4Hhwc6agtn81gkCXqokEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGUrvbSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGUrvbSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD5EC4CEE3;
	Thu,  3 Jul 2025 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553935;
	bh=REhjrUiMYeXu9FkTT4OPQf8W+ebHTTLxx1gweNmagC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGUrvbSYGYq5/wuBGaUSOYR1akgjyvEB7PBKS24E3ceRii34I8kMOGeWhwhBYIWwK
	 HQ9abSZFcFwZkrJlsCJqtaRGs/lRm/Z5z8KsLmyh5Qn3AP/Ufvt/zic+a7EN2ZyZZi
	 wI3Slthuf0WXZ3Fq2G/3T4+v+yApBWchEnlCCygE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/218] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Thu,  3 Jul 2025 16:39:16 +0200
Message-ID: <20250703143956.290503111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



