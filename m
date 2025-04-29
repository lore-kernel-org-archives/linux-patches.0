Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0423C8D6;
	Tue, 29 Apr 2025 17:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946377; cv=none; b=bxLJbTi1TU0tSo8uW8UaIiy4w1AnnOX2DznVWKHjabQvsyGt5BsQ7Y/wDjJRh1fwROXSc8VD9eMadeeMuIbph4Ey30GlilBGcIuI11L6rmyOqwQZsPBsVKvqEDgQjfyYiy2XD3DqEbCNYYyB7wFtIJK1yI3ktd+sIBbPs8+JJAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946377; c=relaxed/simple;
	bh=aQqetLqE0UIhKHxW/vii40IyshwQEcERJWLoY1N8BKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4wP0Q48ktqspvQWidMtca2PQSEZpqMcENaJVupUMnumBBKkkoYVoHyVUYzvf+/tKs27S+HERTutolWGbDhnRgF7jDLrUKPD+9ERmLuuF2FxcHaUX7NXZwF9vBWTRyPjKsz5PaxaDPzhuY3L9wj1CYd2wFy3VDdM8hGZmAx2i/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nskUhpwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nskUhpwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89386C4CEE3;
	Tue, 29 Apr 2025 17:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946376;
	bh=aQqetLqE0UIhKHxW/vii40IyshwQEcERJWLoY1N8BKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nskUhpwAEfsNv1wMiZR3GvBRDJkwdiHtfiI1eVC69OG3ZVdAwLcYIGrjyZjqCJ0UY
	 7kipJwD7qQ80FMaS+4AMIdNxu4fJMpvzP9srcmyUTa1j+D4n+3kM++x9xIsHnq6yvS
	 qhqKVSzV4P34qteOIZTC8D9WFrk+SYQEg7abKOMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 245/311] pwm: Let pwm_set_waveform() succeed even if lowlevel driver rounded up
Date: Tue, 29 Apr 2025 18:41:22 +0200
Message-ID: <20250429161131.065560138@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 00e53d0f4baedd72196b65f00698b2a5a537dc2b ]

Waveform parameters are supposed to be rounded down to the next value
possible for the hardware. However when a requested value is too small,
.round_waveform_tohw() is supposed to pick the next bigger value and
return 1. Let pwm_set_waveform() behave in the same way.

This creates consistency between pwm_set_waveform_might_sleep() with
exact=false and pwm_round_waveform_might_sleep() +
pwm_set_waveform_might_sleep() with exact=true.

The PWM_DEBUG rounding check has to be adapted to only trigger if no
uprounding happend.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Tested-by: Trevor Gamblin <tgamblin@baylibre.com>
Link: https://lore.kernel.org/r/353dc6ae31be815e41fd3df89c257127ca0d1a09.1743844730.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/core.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index ccd54c089bab8..0e4df71c2cef1 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -322,7 +322,7 @@ static int __pwm_set_waveform(struct pwm_device *pwm,
 	const struct pwm_ops *ops = chip->ops;
 	char wfhw[WFHWSIZE];
 	struct pwm_waveform wf_rounded;
-	int err;
+	int err, ret_tohw;
 
 	BUG_ON(WFHWSIZE < ops->sizeof_wfhw);
 
@@ -332,16 +332,16 @@ static int __pwm_set_waveform(struct pwm_device *pwm,
 	if (!pwm_wf_valid(wf))
 		return -EINVAL;
 
-	err = __pwm_round_waveform_tohw(chip, pwm, wf, &wfhw);
-	if (err)
-		return err;
+	ret_tohw = __pwm_round_waveform_tohw(chip, pwm, wf, &wfhw);
+	if (ret_tohw < 0)
+		return ret_tohw;
 
 	if ((IS_ENABLED(CONFIG_PWM_DEBUG) || exact) && wf->period_length_ns) {
 		err = __pwm_round_waveform_fromhw(chip, pwm, &wfhw, &wf_rounded);
 		if (err)
 			return err;
 
-		if (IS_ENABLED(CONFIG_PWM_DEBUG) && !pwm_check_rounding(wf, &wf_rounded))
+		if (IS_ENABLED(CONFIG_PWM_DEBUG) && ret_tohw == 0 && !pwm_check_rounding(wf, &wf_rounded))
 			dev_err(&chip->dev, "Wrong rounding: requested %llu/%llu [+%llu], result %llu/%llu [+%llu]\n",
 				wf->duty_length_ns, wf->period_length_ns, wf->duty_offset_ns,
 				wf_rounded.duty_length_ns, wf_rounded.period_length_ns, wf_rounded.duty_offset_ns);
@@ -382,7 +382,8 @@ static int __pwm_set_waveform(struct pwm_device *pwm,
 				wf_rounded.duty_length_ns, wf_rounded.period_length_ns, wf_rounded.duty_offset_ns,
 				wf_set.duty_length_ns, wf_set.period_length_ns, wf_set.duty_offset_ns);
 	}
-	return 0;
+
+	return ret_tohw;
 }
 
 /**
-- 
2.39.5



