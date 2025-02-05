Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08BB1891AA;
	Wed,  5 Feb 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768681; cv=none; b=ta+4nsdqfIpocaek3nB5MotyJyGbXoCWzGXfaAL5/znxB5ISlTFkZ3pL4q7zPHheH6socc+vTyqaRNJjjh0LBJI3ASLL337Bu9w66VQR31bYlLxfKJ4GpFtBrzIxmLtMG0+2568JCcMnQDbF8dS8Jcz7hdIlMrpAhXQmrZ0Ivb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768681; c=relaxed/simple;
	bh=udKYhnY2Lk1w+uAr2dl5buHkxa9fLAEtvtVjHtMN8vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D9ZDkSKql0G5PoPNgIooGfidX0aDBh78aJrKM4EBydKLI+54Zp87ULiTpiJeNnWosS+AVAY5hD8JnwS2FRAmt+BNJ2c/V8hOGxDTadBUiftrJa0gLiKHKDeqyp7A+YOgZ/5c/c88pAMaXL/nfImJNbB1sL/PZOVoMp0NpHgqoao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiCRO/xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiCRO/xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AB9C4CED6;
	Wed,  5 Feb 2025 15:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768680;
	bh=udKYhnY2Lk1w+uAr2dl5buHkxa9fLAEtvtVjHtMN8vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiCRO/xgzIknGta/JfIuMVA4AuRluRecju0ghCnvtwSf2edyPcqretwr6WdA7s5VK
	 i5lIrE0dNk4+74oxPoABuWbI24HaZfO4ph6Bc043P2HUIs1I0sF/LOFVEYf3VW2oVE
	 oT38MF6MtWzqBIe5Go/KSYG499P/npqz0QCvrOlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.13 620/623] pwm: Ensure callbacks exist before calling them
Date: Wed,  5 Feb 2025 14:46:02 +0100
Message-ID: <20250205134519.931296906@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit da6b353786997c0ffa67127355ad1d54ed3324c2 upstream.

If one of the waveform functions is called for a chip that only supports
.apply(), we want that an error code is returned and not a NULL pointer
exception.

Fixes: 6c5126c6406d ("pwm: Provide new consumer API functions for waveforms")
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Tested-by: Trevor Gamblin <tgamblin@baylibre.com>
Link: https://lore.kernel.org/r/20250123172709.391349-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/core.c  | 13 +++++++++++--
 include/linux/pwm.h | 17 +++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 9c733877e98e..1a36ee3cab91 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -242,6 +242,9 @@ int pwm_round_waveform_might_sleep(struct pwm_device *pwm, struct pwm_waveform *
 
 	BUG_ON(WFHWSIZE < ops->sizeof_wfhw);
 
+	if (!pwmchip_supports_waveform(chip))
+		return -EOPNOTSUPP;
+
 	if (!pwm_wf_valid(wf))
 		return -EINVAL;
 
@@ -294,6 +297,9 @@ int pwm_get_waveform_might_sleep(struct pwm_device *pwm, struct pwm_waveform *wf
 
 	BUG_ON(WFHWSIZE < ops->sizeof_wfhw);
 
+	if (!pwmchip_supports_waveform(chip) || !ops->read_waveform)
+		return -EOPNOTSUPP;
+
 	guard(pwmchip)(chip);
 
 	if (!chip->operational)
@@ -320,6 +326,9 @@ static int __pwm_set_waveform(struct pwm_device *pwm,
 
 	BUG_ON(WFHWSIZE < ops->sizeof_wfhw);
 
+	if (!pwmchip_supports_waveform(chip))
+		return -EOPNOTSUPP;
+
 	if (!pwm_wf_valid(wf))
 		return -EINVAL;
 
@@ -592,7 +601,7 @@ static int __pwm_apply(struct pwm_device *pwm, const struct pwm_state *state)
 	    state->usage_power == pwm->state.usage_power)
 		return 0;
 
-	if (ops->write_waveform) {
+	if (pwmchip_supports_waveform(chip)) {
 		struct pwm_waveform wf;
 		char wfhw[WFHWSIZE];
 
@@ -746,7 +755,7 @@ int pwm_get_state_hw(struct pwm_device *pwm, struct pwm_state *state)
 	if (!chip->operational)
 		return -ENODEV;
 
-	if (ops->read_waveform) {
+	if (pwmchip_supports_waveform(chip) && ops->read_waveform) {
 		char wfhw[WFHWSIZE];
 		struct pwm_waveform wf;
 
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 78827f312407..b8d78009e779 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -347,6 +347,23 @@ struct pwm_chip {
 	struct pwm_device pwms[] __counted_by(npwm);
 };
 
+/**
+ * pwmchip_supports_waveform() - checks if the given chip supports waveform callbacks
+ * @chip: The pwm_chip to test
+ *
+ * Returns true iff the pwm chip support the waveform functions like
+ * pwm_set_waveform_might_sleep() and pwm_round_waveform_might_sleep()
+ */
+static inline bool pwmchip_supports_waveform(struct pwm_chip *chip)
+{
+	/*
+	 * only check for .write_waveform(). If that is available,
+	 * .round_waveform_tohw() and .round_waveform_fromhw() asserted to be
+	 * available, too, in pwmchip_add().
+	 */
+	return chip->ops->write_waveform != NULL;
+}
+
 static inline struct device *pwmchip_parent(const struct pwm_chip *chip)
 {
 	return chip->dev.parent;
-- 
2.48.1



