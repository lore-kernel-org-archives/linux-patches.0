Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6E5262BE;
	Mon, 27 May 2024 19:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838165; cv=none; b=Uv8KDa/PVIKHiR4DECzm1H0GcSwoi9TjEoTQ2exauTVghqaE1k5Me8buvllN2zCCCMxk19dQP4OhtgWRRKVftnQUmsRJmAt/d+dFjJCBEK4x8Xrznc2oSqbFtMyiXyXNfrzwJToVh+RhlP0zF7myMpoRPP53nVGB6pK8TBXp3Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838165; c=relaxed/simple;
	bh=KGWlZA89Jr8lqD9STaXudB/DYzyb5RzMMW5Ix3bPzt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jzw7DXaOG5lCrXYXE4biULPxmV4/54y0pmyCV640wPbTSf8ZVimGzvwOtKjXnR3VE5lXxGWnLyVGPGgmGFdkVhkKXjEuXGeyzwPmlQsUI9MkrGdeo4+xlGkh6gEw8LSSYo+N37qe2IHIXSQwqA51dktxtDRfdylNKi34ULgDeEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SIRX6fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SIRX6fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ED2C2BBFC;
	Mon, 27 May 2024 19:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838165;
	bh=KGWlZA89Jr8lqD9STaXudB/DYzyb5RzMMW5Ix3bPzt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SIRX6fnBl5Sn5d206hHCQkKO3mq2H6GerkDgyby4rBvfdkNxojOPYKnj25FR9YKU
	 ESbqYPvLIHg4MIcLgxE+KgOJkJC8AsFhHtEWIf9GYUjaKNm4GkGcAGjkK2rm3CEUkV
	 8KF6SMVu8nBECNoA6l4/NswfGEsCcIoq6MBYyUz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Rokosov <ddrokosov@salutedevices.com>,
	George Stark <gnstark@salutedevices.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 264/493] pwm: meson: Add check for error from clk_round_rate()
Date: Mon, 27 May 2024 20:54:26 +0200
Message-ID: <20240527185638.921314633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Stark <gnstark@salutedevices.com>

[ Upstream commit 3e551115aee079931b82e1ec78c05f3d5033473f ]

clk_round_rate() can return not only zero if requested frequency can not
be provided but also negative error code so add check for it too.

Also change type of variable holding clk_round_rate() result from
unsigned long to long. It's safe due to clk_round_rate() returns long.

Fixes: 329db102a26d ("pwm: meson: make full use of common clock framework")
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Signed-off-by: George Stark <gnstark@salutedevices.com>
Link: https://lore.kernel.org/r/20240425171253.2752877-3-gnstark@salutedevices.com
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-meson.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-meson.c b/drivers/pwm/pwm-meson.c
index 8f67d6ba443de..6fefa80af0a4c 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -149,7 +149,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct meson_pwm *meson = to_meson_pwm(chip);
 	struct meson_pwm_channel *channel = &meson->channels[pwm->hwpwm];
 	unsigned int cnt, duty_cnt;
-	unsigned long fin_freq;
+	long fin_freq;
 	u64 duty, period, freq;
 
 	duty = state->duty_cycle;
@@ -169,12 +169,13 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 		freq = ULONG_MAX;
 
 	fin_freq = clk_round_rate(channel->clk, freq);
-	if (fin_freq == 0) {
-		dev_err(pwmchip_parent(chip), "invalid source clock frequency\n");
-		return -EINVAL;
+	if (fin_freq <= 0) {
+		dev_err(pwmchip_parent(chip),
+			"invalid source clock frequency %llu\n", freq);
+		return fin_freq ? fin_freq : -EINVAL;
 	}
 
-	dev_dbg(pwmchip_parent(chip), "fin_freq: %lu Hz\n", fin_freq);
+	dev_dbg(pwmchip_parent(chip), "fin_freq: %ld Hz\n", fin_freq);
 
 	cnt = div_u64(fin_freq * period, NSEC_PER_SEC);
 	if (cnt > 0xffff) {
-- 
2.43.0



