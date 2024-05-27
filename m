Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9350C262BE;
	Mon, 27 May 2024 19:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838193; cv=none; b=s6VJheTMyUOj1xlEsSnOce9r4To9YgdqRiba2YE6sKUWkCgR1E5Ut4W3yxnw+e4al5X9aZvYP1digeaRdiakxnu3OWIzCcH/FC63W9TT2AeX7xcGQZxAzrXEwI+7HzxgSi+4EURYp1MjJBMaly4lehvJNSPTopY8OvOy/PtQ8L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838193; c=relaxed/simple;
	bh=IzrnfSfW+dlg1rxVni7Q8jcafDzF/cOKf0xxEBNtLtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQ1ryjiv0X4xsk2CBtQcHzrVCyWSWVnDD21lWSL6n+kFBGyca3mQr0Nq2+LRpMC2zJnkoUZ4kMpYrLkjW3mOlyDUmoVTJNb4JrT9XS5TZ0IarryMtnQ9t85Xau9dej7qJXiJlGZTxZTiBOV9hyANmY3rxxJYSmDlJPBFBbeDPvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzTrL5lQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzTrL5lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2237DC2BBFC;
	Mon, 27 May 2024 19:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838193;
	bh=IzrnfSfW+dlg1rxVni7Q8jcafDzF/cOKf0xxEBNtLtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzTrL5lQeG3/I/OE1XKSBhrYhH58xEDJC1ueyP9x/Hf1q4os5sTCQOp8uTPl5RxGL
	 7dwp1rtyEtlAV4eqokygTOfTvfQpc/HhMrJpIRrxCa61CdcE3uGqHdsq8f/ASBeXH5
	 3pzsGUjXTFdGgu0Sq+1ZEEWcAFnrPGEy7E5ir7ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	George Stark <gnstark@salutedevices.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 265/493] pwm: meson: Use mul_u64_u64_div_u64() for frequency calculating
Date: Mon, 27 May 2024 20:54:27 +0200
Message-ID: <20240527185638.958357182@linuxfoundation.org>
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
index 6fefa80af0a4c..52ac3277f4204 100644
--- a/drivers/pwm/pwm-meson.c
+++ b/drivers/pwm/pwm-meson.c
@@ -177,7 +177,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	dev_dbg(pwmchip_parent(chip), "fin_freq: %ld Hz\n", fin_freq);
 
-	cnt = div_u64(fin_freq * period, NSEC_PER_SEC);
+	cnt = mul_u64_u64_div_u64(fin_freq, period, NSEC_PER_SEC);
 	if (cnt > 0xffff) {
 		dev_err(pwmchip_parent(chip), "unable to get period cnt\n");
 		return -EINVAL;
@@ -192,7 +192,7 @@ static int meson_pwm_calc(struct pwm_chip *chip, struct pwm_device *pwm,
 		channel->hi = 0;
 		channel->lo = cnt;
 	} else {
-		duty_cnt = div_u64(fin_freq * duty, NSEC_PER_SEC);
+		duty_cnt = mul_u64_u64_div_u64(fin_freq, duty, NSEC_PER_SEC);
 
 		dev_dbg(pwmchip_parent(chip), "duty=%llu duty_cnt=%u\n", duty, duty_cnt);
 
-- 
2.43.0



