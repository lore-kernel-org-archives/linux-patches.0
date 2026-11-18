Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036677;
	b=Z5719BW9zMUMH11EMQSWe7f1KumXO1K4H849ex98m76T6/9BnF6smzuYMzcFse2Zg5F3
	 XNM5Y8ZyaXJKV66IsTYR52Jx7exG+ViAdbsUBxY6BM1jnZnuuQSydAE2CqV6H6YjwitAS
	 fnhaNhZH40/Sc5Ss0C/BJbR9u1DEHjpEqN/lmYS8qhdK86UFwktQmJtzLHUMMZknqlxRw
	 0jChniPOOy9av+P/xJG9IzqPVkpVvL82cPycG3EhySXFI2bcWyJv5xMwj+8FD11ROE4sf
	 zqaPlbIYzvpFYyjkb0jwIDwNcX8vVPtYl6Us7OwoEODgGxcGAoz0+4ZK1Y2nttcEbGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TPrLSl5dLek/7cmaaCnQJLyWlba+/qbYLI88MlXQXP0=;
	b=E7Hbikcs/pv+XbmdiPSiMW4TWpO7x/LOTOcY1Kg7ITJPR66i2FgqAs8i0OV87b5eHCWy
	 rWMy8KTYNOZ7LdwAyl/2li+LUsoiddZA7s6ijyUBAdFNF9DyjAnwS6rAmm1VCO79O6EZJ
	 nwwpI507Av5A3gGnFVlmvqNxfvRCk4SOvdzezD5Hk2XDswy4PESTp7OrBxrBvscudIKqV
	 /WrLlFvWgcbKo5upeyW8DiTNkDc2t96KYQ/yRcraMAD3V0niF2gtu0o39jXCq04ML22nJ
	 tsOm17575Yp36ssrCL1OOdAL6KldYtA3xfpFe2vvQdF0r+c6usMFE2m89CXKW8wquUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KTV+Akc0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA57606A31C;
	Wed, 18 Nov 2026 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KTV+Akc0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6101F000C4;
	Wed, 18 Nov 2026 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036677;
	bh=TPrLSl5dLek/7cmaaCnQJLyWlba+/qbYLI88MlXQXP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTV+Akc0HAWc1osemNyn7IUuwVtrLu2xED5egA0s7ZsqBhkSY5dnOnLiGeKhVkmWX
	 Er+pVBAAwlcphDjroLe/GJUeyNxnKxOX9DygojkJya7FFBskQP0yiIhhx9VIB8v8Jv
	 SMCjmSNep9TQSshllNXIRn9zssYgO/iIxgnk7Lk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1144/3318] power: supply: generic-adc-battery: fix status with no supplier
Date: Wed, 18 Nov 2026 15:29:26 +0100
Message-ID: <20261118150354.393604776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8ae5a3f40045ff486826ed6b6a83e39a0f380073 ]

power_supply_am_i_supplied() returns -ENODEV when no registered power
supply supplies the battery. generic-adc-battery's gab_work() tests this
return value as a boolean, so -ENODEV takes the supplied branch and
reports CHARGING, or NOT_CHARGING if the charge-finished GPIO is asserted,
instead of DISCHARGING.

This was noticed while bringing up an out-of-tree Linux port to the
WikiReader: the driver reported CHARGING on a device powered by two AAA
batteries with no charging hardware.

Only a positive return value indicates an online supplier, so treat zero
and negative returns as discharging.

Fixes: 46cecd130d55 ("power: supply: Fix power_supply_am_i_supplied to return -ENODEV when apropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013022153.6707-1-me@timdoug.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index aebc824aa2ede..43b735d4d49c3 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -135,7 +135,7 @@ static void gab_work(struct work_struct *work)
 	adc_bat = container_of(delayed_work, struct gab, bat_work);
 	status = adc_bat->status;
 
-	if (!power_supply_am_i_supplied(adc_bat->psy))
+	if (power_supply_am_i_supplied(adc_bat->psy) <= 0)
 		adc_bat->status =  POWER_SUPPLY_STATUS_DISCHARGING;
 	else if (gab_charge_finished(adc_bat))
 		adc_bat->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-- 
2.53.0



