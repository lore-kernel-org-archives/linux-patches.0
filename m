Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016773;
	b=oI7nahTjKkLS1tvHbS9vpZstI+k9LGP0B2Csk0YpbXEYqnrC1c9UvCTCyv9fiuq127ES
	 I8GRwu1clHSO/MJBlVvvdaihjwW0cm4GayVAkE/zj/GO8RX0im64wHiK7XFJyLoQ0IAZ9
	 sljfEG6nA6TtWgQA7DZ48FbHqlBcLh37pJpZVVQP7s1jGws1dXhj4lRXnNc01wp8en2Ih
	 17Y5sDuvOzpifFVVzA12t9KkRDUSzg6dlPeuCztAwQWJrdUs0BBNF1M4Ta0cXTBMk/xo/
	 GeZ9FMNq8YCWZKS3M7v09U2eZqCi3PP2rytCTf8ylkVNWV8mxiL+Qvk6VV9cUQe+qLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t4fPdIxTKhscMaBGXOc7EPdIxal0JaT6vWYbTVIsv2A=;
	b=SvAMjnYRJXvUUMFxdfbrqINQQh9CfaujJEjDampLtnrdDrN2XiBMjnm1YVQmmR6F8D1I
	 B7dXMd+K9BBMwajKf/512H+n9/1mcCBkpqKS+5E5zYtzTcMLYyrEqqDm4sjpOvxux+PEU
	 1r0tCw/4wNgearIWoE7Z1lcwi8bkOK1x1syj4gfwhXcu7whU9TKQ1xSrkyOm6gsnMRtq8
	 rc5eDsOT2d4vFrU7U1+ispM4IAnk6gqqhlvWRAVJLwX5J+tp/kP6ppkRayE0UAMBIYPFq
	 tLlfp5um4YHW9ktgyrS6ibe5kkn2S+Rpm+HYNSnoesKjYt90KEpXtBT7i21T5v2S3uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5XHnHe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2391606A325;
	Wed, 18 Nov 2026 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5XHnHe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B3E1F000C4;
	Wed, 18 Nov 2026 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016773;
	bh=t4fPdIxTKhscMaBGXOc7EPdIxal0JaT6vWYbTVIsv2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5XHnHe+xEPZThPIWeuS5knQXe45J/0W1wR2CU0NUhBT/PFq9zciQCmAYYVMKXNzz
	 gXsHJndc5kCli/P/mgaaagmBc3qfDVNz4HPL99HYuB9h480SfSHk1Nw3zYyeRfk3Wn
	 GZeDkOa8fFpdJJ2b05cHWQjoMCEuIudwrddvhvPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0646/2651] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:31:26 +0100
Message-ID: <20261118150310.937303971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8d2678dc9e4fd..9c58d54c57830 100644
--- a/drivers/leds/leds-lm3692x.c
+++ b/drivers/leds/leds-lm3692x.c
@@ -276,9 +276,11 @@ static int lm3692x_leds_enable(struct lm3692x_led *led)
 
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



