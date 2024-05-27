Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825241078F;
	Mon, 27 May 2024 19:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836799; cv=none; b=nPrm0w7D0pkYdmmV3lK2P6BCWVZFgnt5vF+uCHVpCC1OFF+qZWta+RHdwEA34zXMyyL+kWPH5kETRIGFgAs2Jpr4reAtPVvSzyMrTyU8+aMFBkGAhpB6oWT9GNLejohIpm3Z48XPf2pJSP8oje7501VtTjSh7Px/0WWvXyzKfwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836799; c=relaxed/simple;
	bh=fo1IyFyxkVzdAMDwAHimlVKJHW1ooNV7J7BhMx+2sKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuTElmzRIjwnb+Z9YRWrmggUuGouADpv69E4uXssY8ulnxBIvwYxLWhZLOYXXQj6ekTrBa8ioM8daaBUBosaeMnTUA2vx0aUJeKrSTxzLIzWcO6eMjQfBZRLiy4ehmIxA8mEDMrN2bblTGZaMLmA3vJOlNNrOQPKNPbbCtXQmyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4zJWvCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4zJWvCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09023C2BBFC;
	Mon, 27 May 2024 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836799;
	bh=fo1IyFyxkVzdAMDwAHimlVKJHW1ooNV7J7BhMx+2sKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4zJWvCs4a+Eqk4WYsQCpFHkx6NL7We5Oe2a9RzhCF0CMoSWFC7+yHghTklBqMo5k
	 0RxEfWiLkoz8tNX96/4ub0kbvK2EmkcNIxiCA5FoHFt+UV8fw/fxcwrCkGWJO7M3gJ
	 rCZzTaghm9wF/EmV0NuEXfqmg82zucAmyW8P2+7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	George Stark <gnstark@salutedevices.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 193/427] pwm: meson: Use mul_u64_u64_div_u64() for frequency calculating
Date: Mon, 27 May 2024 20:54:00 +0200
Message-ID: <20240527185620.259438974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Stark <gnstark@salutedevices.com>

[ Upstream commit 32c44e1fa921aebf8a5ef9f778534a30aab39313 ]

While calculating frequency for the given period u64 numbers are
multiplied before division what can lead to overflow in theory so use
secure mul_u64_u64_div_u64() which handles overflow correctly.

Fixes: 329db102a26d ("pwm: meson: make full use of common clock framework")
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: George Stark <gnstark@salutedevices.com>
Link: https://lore.kernel.org/r/20240425171253.2752877-4-gnstark@salutedevices.com
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index b5d5fe4669993..e12b6ff70baba 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -175,7 +175,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	dev_dbg(pwmchip_parent(chip), "fin_freq: %ld Hz\n", fin_freq);
 
-	cnt = div_u64(fin_freq * period, NSEC_PER_SEC);
+	cnt = mul_u64_u64_div_u64(fin_freq, period, NSEC_PER_SEC);
 	if (cnt > 0xffff) {
 		dev_err(pwmchip_parent(chip), "unable to get period cnt\n");
 		return -EINVAL;
@@ -190,7 +190,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 		channel->hi = 0;
 		channel->lo = cnt;
 	} else {
-		duty_cnt = div_u64(fin_freq * duty, NSEC_PER_SEC);
+		duty_cnt = mul_u64_u64_div_u64(fin_freq, duty, NSEC_PER_SEC);
 
 		dev_dbg(pwmchip_parent(chip), "duty=%llu duty_cnt=%u\n", duty, duty_cnt);
 
-- 
2.43.0



