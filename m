Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039956;
	b=WaPrftPTSo6b/54mLfGFvVhm/T4BxdEmPFon72uKRHLfHK97aVumX1SHV6pTdgZVwkct
	 dNAXP6RhfNu4/0v43KeVMvA2fs6zHeXpy2RmEEn1H7puyO9Al0voaQlH4VnAf3GfKMBxB
	 QIPaxv8W9oZgPz5x4S1mZrM4mIjBN56RM9urcqIERTo8nTi0rwUvE9jWdJijOuPnewvUB
	 mJAW0gKA0tmXAzzgRWgy7UDEkPoHbVmxGxF+vnS3/xgy04lBWEPVU3R4l1tfDHqoJux7L
	 rG/tiZMaqLGSz0lwtv6LiIREcygoaUL5ooor6LU6QNhDd9tKYAf404+5L/dV0orrYNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ueSwjvYbwWS90i3ZKu32MxxIH8QxpvR388L7Y92KkLg=;
	b=SRnQNbcatrrjrLQZzOGsjHOYVxDQ5WfMgKZOfibmLCHGzJN179D6r0MH+U/tN/wMkCrr
	 UNjLD394GwRUpGz0B1DM3hP7UN6ysbLaMs10RsZBw3z2XVDHtTzVb5YUKgKCjxO/ttLxG
	 3ZMYRwx8mY9S5ow4V3hoL6dd/uqDNk7jTzPMgZKJATqK25VvQm7CFKt6uQZEitSt4+y9+
	 oXuK37M9ZhytnEh12chq5RrVNhIWFyn90aLC8ynOT99g/poqkXNKe+AlXdase3NqyDNDq
	 CvItDyLTpKB7ryZGtU+IozbZjNDZMJzjI+W58WhRfQEBZes4YYF4nlq1OdFpXnGtORw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2j+D8OB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78996606A325;
	Wed, 18 Nov 2026 22:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2j+D8OB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4EE1F000C4;
	Wed, 18 Nov 2026 22:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039956;
	bh=ueSwjvYbwWS90i3ZKu32MxxIH8QxpvR388L7Y92KkLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2j+D8OBeCXlEE7IazhQR9uUr8C3al+47S8Q970SY71XWRacGRlTDBVZm35NZPDyk
	 RnvmOHQStYVJfF4yPQal9vq/deP21Uj0n7ehyuUy8I1Cy2bULiiTVnqMfstLe63g7K
	 9hRI00KElwCLZdeMb3wImwcFkRlVzL2xQ9BxvGe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2286/3318] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:48:28 +0100
Message-ID: <20261118150430.337858270@linuxfoundation.org>
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
index f8ad61e47a192..7292615b304fa 100644
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



