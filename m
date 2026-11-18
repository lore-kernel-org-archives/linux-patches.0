Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055207;
	b=DR5sBmqLn9EhBMAqGbnpHbxV4IcSr6dH7M2EA20cGRPgXVQJIz2lC/m+T9o/WOpaePpG
	 iptztaR6ef471YQCkyegBtuc89a+Ps5Fukdw4rv2Di3s/GfAM+Er1Xwt2v84GRoIG2seo
	 M90PPd8IhJjIRXC4LiKdMdahZ5Z7igVNQ4J01RqcTTcFXs8dobZZJ77bSvgOTdoQugdYP
	 je4apFFlJzUEyiuFJre1VzuE/TbSrYKe9H+5zIi2/B6C9VzFcLw1hrgQvrsyoW0APFXro
	 faoH6WAX4glDOWkn3T4zgpsT6SaJl+8TqnJdaynzBeEcKSAeuSSatRAcaeuqH+DUKVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E6gqe2pxJRnBwjYLqQaYvvTk5KKsovkZLS8scTUbfhw=;
	b=EcemDcUxBG2SmNjXCQSBsC48uCYqdEAN6K13JHTTYP7xWmpPEnCaV02j2T4elap+aMpc
	 6PKm29F+9QZ7n2j2hfhOu109RK3IPg7KuAg2oT8Y7JiDQzcxag3rlYc1EESOJ/4S03Xoh
	 LRckSrG1HrwExi5RdjOMkTnVLRNibBnT+AmZ+bfEOk6Uk+cjt1Ju2twQzNYljQ87haOfz
	 QCVe0+VJGtTYSQocTKqMRTkaCKWjT1wFWkqMX3WYBnPVru3Ykq5F3fwreZ0fx7YjnlXzp
	 T+464vBdVp3E2aJ4YRr7Ebsi/4eurdRD83902a5zt1T4jdzPoEWBlQfCEbLQ883NyaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+XwyW38;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC43606A31C;
	Thu, 19 Nov 2026 02:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+XwyW38
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2601F000C4;
	Thu, 19 Nov 2026 02:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055207;
	bh=E6gqe2pxJRnBwjYLqQaYvvTk5KKsovkZLS8scTUbfhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+XwyW38PRaSvRM6/pquuU0Mez/t0mC6o9YS0AlnGHbdsE31vATA6iPNIwjaoPf/m
	 uBFFutazVNU/4Vk3LGiQdIG8JZUSLBr+YHlrGDiPgI17IGuS4NcVb2Wms+n8CotLSr
	 RYoIpCdWwunzi7VmP2ogBcFdrkTkV7APedhRWOjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1547/2214] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:53:43 +0100
Message-ID: <20261118150114.012226961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index afe6fb297855f..d67b58f0ea018 100644
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



