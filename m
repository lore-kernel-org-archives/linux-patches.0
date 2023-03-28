Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE78BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417DAC433EF;
	Tue, 28 Mar 2023 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016117;
	bh=HxvexkBp6jepse56a3EOBouS4kUcEj6PfLHXHUKlK+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YAsNbp149OqmIgxJpjU+0XPbD5XTQ17VMm1DXv2B9nENse4bBMRBkpYZPCNPJmmN
	 ZchiUIp6UloheCYyfFzxQk0As3R1BICpez4Wjdib/vdxeO1b2AQGGPOeDiiNi3bdGB
	 ylOGyUnx83949qkCKRlJew7oi9zYhWVFcYjgVyms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Crawford <frank@crawford.emu.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/146] hwmon (it87): Fix voltage scaling for chips with 10.9mV  ADCs
Date: Tue, 28 Mar 2023 16:42:41 +0200
Message-Id: <20230328142605.728304151@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Crawford <frank@crawford.emu.id.au>

[ Upstream commit 968b66ffeb7956acc72836a7797aeb7b2444ec51 ]

Fix voltage scaling for chips that have 10.9mV ADCs, where scaling was
not performed.

Fixes: ead8080351c9 ("hwmon: (it87) Add support for IT8732F")
Signed-off-by: Frank Crawford <frank@crawford.emu.id.au>
Link: https://lore.kernel.org/r/20230318080543.1226700-2-frank@crawford.emu.id.au
[groeck: Update subject and description to focus on bug fix]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/it87.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 1f93134afcb9f..485d68ab79e17 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -486,6 +486,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3098,7 +3100,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
-- 
2.39.2



