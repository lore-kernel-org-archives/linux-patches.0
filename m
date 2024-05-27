Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967BF1754B;
	Mon, 27 May 2024 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836796; cv=none; b=RGmViGkLmqhAE07eGtzx1dq74KWT5rrmh4uP8tSJUxZ4xoa96wm4o7DtLVNmC6CoV3mGTkkj+Frqj9EFCIrEmLEoCv/2yw5ajchvq562/Ht7Sy9nWePnsZ4r4Qy6jXDr8W3MO4zGIBQBao4pL9t3iKPSJdLu6tjGoND2hpiCfuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836796; c=relaxed/simple;
	bh=rioEFapkFWQbhNWzzIYkfHHKnkZTDCTPafj/iFA9fcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAuL3UuTUMRoUGf8DmLBgtN12fLSMjYdPr6d1TL5s8J+glhFMPJ/In0ixgwCEOlUZbOssToRBBeWExf38D2ovHgzFkRAi2LDiFMBFwqVWOdWvoFRi+QrGpwrGtxi5H9Tu98Xg1m4NzICvoGYf70fgR87jvF6OOmW2SdOdDdMv74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzZuIAoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzZuIAoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA72C2BBFC;
	Mon, 27 May 2024 19:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836796;
	bh=rioEFapkFWQbhNWzzIYkfHHKnkZTDCTPafj/iFA9fcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzZuIAoa5Ovjny4EedF0Pgg3H5ecCkasLfL/k/fUM4D4+6adJkChdVwLcjdxXIsY6
	 ORsSmEe789+a0Pgsj4UrUJOkq+oPnW+ECakmiMKimHz7yej5LBgtge6aedWbp2XQJq
	 /fdbZ+9e+klWyQxcLLhR+UD1eUm4gxjWzzR/EB7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Rokosov <ddrokosov@salutedevices.com>,
	George Stark <gnstark@salutedevices.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 192/427] pwm: meson: Add check for error from clk_round_rate()
Date: Mon, 27 May 2024 20:53:59 +0200
Message-ID: <20240527185620.176312311@linuxfoundation.org>
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
index a02fdbc612562..b5d5fe4669993 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -147,7 +147,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 	struct meson_pwm *meson = to_meson_pwm(chip);
 	struct meson_pwm_channel *channel = &meson->channels[pwm->hwpwm];
 	unsigned int cnt, duty_cnt;
-	unsigned long fin_freq;
+	long fin_freq;
 	u64 duty, period, freq;
 
 	duty = state->duty_cycle;
@@ -167,12 +167,13 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
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



