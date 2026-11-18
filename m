Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060805;
	b=LhfqrU1u6uBh6ZWlPJXzNyP9y/mPO7WHb5cxvx3nuJiAGKELk52qgXaWILh+BPeaY72Q
	 Twp1neS8PLH2A6TILXYDyQP4Y0NhKxKBgSrbARlO4rfSE2I2nN/xJdJS2eqnuSQswVdIl
	 D/E21grb66N4sKha+fUAtV0Z2Uo7XC4ZX+W+ufKxRy1VVddDSm1ZQgidy35nIvU73/8VD
	 U5ug8AQ9FIy6M7FTH2/9UanfESdjTzP+TLQPZhPKNKQLcSZXrwbKvp1occZmLsml+cqYt
	 dlcAhuGAWthxEfLSA//yTwqyBzewSmO/GmiysalwMpTlFL8zrqzEKS86tnflNdp3qwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FpGb+SQI602HagbUE1cAy9UyVHPENAgziMygmpoO4Pg=;
	b=YreTwilmsxHkVg2UpGrIIE5DWECc+Oc7/34Tq8WhGXSxXxto3tD0/KXIfEKl5vXgcTxx
	 JWF5GdcnSfoG7h1O1KOx1n32O9OEbK7IrwlGVwbTBME9mOlDOQ2wDajGo5H8ISWw+FAAU
	 iYJh+Vo9AxNXeKSXo3b9s5J48NHF0ES/usvyOFOzn7rlqA51VSv09Nt9kRLb5RgUixrLS
	 XONWvQa4LqFQ/e5KvjY8H4tNcIWBWZkOeni8cJhERyiURFZs+SqovIhPypEGDoiPOrMA2
	 YJB3kRG4oeDdPE7bFOxIFqpEF0yxq9DPO/rpBc5gJatbOLF7vXC58RN+Zp5nbRYkGlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGKOXekr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D91A606A320;
	Thu, 19 Nov 2026 04:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGKOXekr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A831F000C4;
	Thu, 19 Nov 2026 04:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060805;
	bh=FpGb+SQI602HagbUE1cAy9UyVHPENAgziMygmpoO4Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGKOXekr4B3eWlKfQSzVobsE2Czw9/gl4hx4A7RZ9MXvHSYD0Ihg7k3ETmBmEQtMd
	 6nbLu6YLzhi6nZ1Avr3/bRYNkPWWOfkYt17NFakPr4GIcKf7NklcVYhM+m2MiJQpj4
	 W3ADp+rO/TCNfGAhT+6TjbG99VU19WSXRLNKy0oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1290/1848] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:55:28 +0100
Message-ID: <20261118150013.569188340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 145ca6bca2cc5fd8d9c7af216df58a9c75c0e84c ]

Every write in lm3692x_leds_enable() checks its return and jumps to
out: on failure -- except the last one, which falls through and sets
led->enabled = true regardless of whether it actually succeeded. Leaks
the regulator on a failing probe, and short-circuits later
brightness_set() calls without retrying.

Route it through out: like every other write here, and only set
enabled = true once it succeeds.

Fixes: 260718b3a35d ("leds: lm3692x: Disable chip on brightness 0")
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260915034515.4147981-1-congnt264@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm3692x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lm3692x.c b/drivers/leds/leds-lm3692x.c
index 55e6443997ec9..1b9cda7c6d778 100644
--- a/drivers/leds/leds-lm3692x.c
+++ b/drivers/leds/leds-lm3692x.c
@@ -275,9 +275,11 @@ static int lm3692x_leds_enable(struct lm3692x_led *led)
 
 	ret = regmap_update_bits(led->regmap, LM3692X_EN, LM3692X_ENABLE_MASK,
 				 enable_state | LM3692X_DEVICE_EN);
+	if (ret)
+		goto out;
 
 	led->enabled = true;
-	return ret;
+	return 0;
 out:
 	dev_err(&led->client->dev, "Fail writing initialization values\n");
 
-- 
2.53.0



