Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048550;
	b=ZbwrkUxUsazKj1/WFOAjoLm0wCMrJ3AVDXheGEp+js3f/UgIZfQJsecY7FseALPZ19Jd
	 3D2v1fSgij4qRHV21VXBLMXkpU/TWuUewdtW7jnex6g1Qwlh0yRNWNEvGMtr3sB8aLORm
	 I+1sevTBZ0mVjqEmS5dCsh0s8U/1Ofo2Xy2tPvhPl0Z4XbyI65nQomYzRvZL0gWZg2G2W
	 xsHttKvW3uU8BMVLjZiIrmrwxozahRvyMBXEygqmD7JoM0Eb9UXsP22NS/vk+HiGTKWJJ
	 SHQLz92zD4J4Ygrl/GspN1cQb2DHVw84f64Suj998jnQAv3Nl7+iUGPJoBZL0r41jHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IXoaNd7LYkTWSujE0X1JkTTsOdpDP53yeZrxySdCj3Y=;
	b=JLOFCMaI06FvdTQbfE8fZsDW6rw7GVoYLOMQJoNTQmQlxXgGJR2UqJijc5C2T0G7uoeA
	 M/Ef89kqdOlMOqNNE+HKb+XhERHPmoIshNtotniz9ctzGkCz0d5m3B2OzkhEdf7aoUjM6
	 gvO+yaNLXW6i9a9UCY0wIVPI5eF2DveJmHVmc+oQF5kuedrP12nwR9ukGJ+EywZ8nQ+sx
	 PfPTPgdVR6KWZxqhrPmvsJB7R/HrY/LivnBiLNjI++ML9UkUu73eT7/uPoQQqYuI80mAO
	 iphsnvSuPEAJz8udt9yShmsoHIv36Y96kfDq52DhyEw96sT7vxgpWHwYBBR1NwgjyJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLRLKtrp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F023A606A320;
	Thu, 19 Nov 2026 00:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mLRLKtrp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1431F000C4;
	Thu, 19 Nov 2026 00:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048549;
	bh=IXoaNd7LYkTWSujE0X1JkTTsOdpDP53yeZrxySdCj3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLRLKtrpp7RLNoDgc+Ir5Z1nEz9ZvraXyZALxy/gG3z0i8T4No2KHSmvVEHTXPOFy
	 7QbDbYD9gLhpRL0c6jKc09cIyzUSHd8DrhdmwPtiuHqzrCsmlu+ToknHTQXHptaamL
	 wN4c8YUy5UPKsJaUvxlYGYjb/ktDV2qxXoEhK+qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1993/2857] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:50:27 +0100
Message-ID: <20261118150313.134931579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 54b4662bff41e..d100043fd2ba1 100644
--- a/drivers/leds/leds-lm3692x.c
+++ b/drivers/leds/leds-lm3692x.c
@@ -274,9 +274,11 @@ static int lm3692x_leds_enable(struct lm3692x_led *led)
 
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



