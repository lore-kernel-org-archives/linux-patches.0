Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029842;
	b=Y2zExNg1GY7S11NzmxnfMVj/VxSUazrTob35vHsB3NPIBGTWl9ndqIpiWxd1a+2OEzsf
	 CEguHF6bMLKTX0cuXn5lLkkM6ZzLMzZ1pO/zkujwX13DOK0CXoK/lIKRzW2r6xl73Q4v9
	 DPuo7/QPVwFJ7yKoV2YrSecpxwwsXldkdzy4x9AlhnBCmgTy7jWzZH7/zH9szuIzk6zBj
	 z8VPKxOwIEF/jgJ6X21PgTsS5aL4M/EaUxgam/J5+IJYjaX4+eKuJwUfMHHsXSGraf7rR
	 VxTZKemevEhlEjyl+OSArNtxdKd9JqViK9DvxWz/nb+CjEezBuARk8iBJBc/9HNd7TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DaVjhdNIQGZGptAm9oktCkdMdYB6JZc9vmWcvV18KtQ=;
	b=HLLp//iUy6/VB4wlLkWlJOSAnCqd+sIl5MVMfJpb/zARMfwuRoKMUFSJinmNsOFINu7Q
	 cBR8nUI7nKqubBSlKIyVsNmxXNx8TkDBR6cDedeD4caFxhZPgzN0Y8MJun7aji+OTSe7M
	 u+RwndermnglEnMiadzSrd9rwhOrv8yjVpXA9ogascGiCqA0DKlx+dBh8oJz3CLEmlTYr
	 zVKjPFaFPuiMgTvqR87iKZyGMJP4XlQ3LBE5AOjJmPw6Dcli2rlRyhjpaHv1yxbuLMPEa
	 ey2P+tYduDjwkIqYcjYjhRXOJkefgHGyskd+f76fBFJr5B8U2TCQS1hlrQ+IGIfDvTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=joBdeG0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FEE606A31C;
	Wed, 18 Nov 2026 19:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=joBdeG0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E971F000C4;
	Wed, 18 Nov 2026 19:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029841;
	bh=DaVjhdNIQGZGptAm9oktCkdMdYB6JZc9vmWcvV18KtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joBdeG0rCtTJjgCLlYq+uY4NLQmOK+dyX7Ogaf3E2ZejYEEb+7wq05BRwCwVvDijU
	 aMg1mllE4WAhjpxOVFmYY8V0xnXdku1kh0mcHHdvqII/H8kTxQjCkKA++17OcZYD8t
	 77/MADDpl4sTfe2GjRqssIeeyBg+SW0r7TDoVVD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0493/1756] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:43:40 +0100
Message-ID: <20261118150028.724654541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c319ff4d70b2a..03f2196836751 100644
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



