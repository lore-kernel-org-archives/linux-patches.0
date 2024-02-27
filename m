Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16C54BD4;
	Tue, 27 Feb 2024 13:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041783; cv=none; b=kp7o8eZRUztOslj08mYs+G5yoaHNZDzTEmcpzOxTtmJeBW1PxkfG6RaMIs7bnyRR2A3xWVKvccN+jgDuVD65FIX4E8VmKC32HsavDFrkEjr6Lax9LjTbOCEmbETCBqL+b6kOlfn0YGRBCMmTxDQyoXT48+UIbbdu1Y45CSGrBm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041783; c=relaxed/simple;
	bh=FgCyPxh5tomjKln7A+/VpkFdYSJtZiLboN3Z4wU4yL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQnOJRPW8wpzL+dIVnPFTbKSGX7AuuPPFj30B9g5B3SNm4unqOuLow/aFUg04wF56zOmG8f+lh0vjeWOihOdlleSAX9xUoomNI3v9FixdrmqMp7RI8rhgkpFQx370MNqChSVW3HCJ+J0kZvgURcgoTgyL+JVZ/C0WS/HK5mKW6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcctqImZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcctqImZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BB5C433C7;
	Tue, 27 Feb 2024 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041782;
	bh=FgCyPxh5tomjKln7A+/VpkFdYSJtZiLboN3Z4wU4yL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcctqImZW4uOaD5WZ+dk4nVuHH/Rhxil5LD849wrjaNNnHoXh4zkV3lc6jd63VMOO
	 oPK85m6R6tkmDYZDPYcah80s+Xca+KEro7jwtdSNgugjDTCv2tWzoPi2XGilCQQvE3
	 eNw3BU+UQFItH05+NA0ClvRN6PA02hDl8Gu5zUHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/299] regulator: pwm-regulator: Add validity checks in continuous .get_voltage
Date: Tue, 27 Feb 2024 14:22:30 +0100
Message-ID: <20240227131627.241749045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit c92688cac239794e4a1d976afa5203a4d3a2ac0e ]

Continuous regulators can be configured to operate only in a certain
duty cycle range (for example from 0..91%). Add a check to error out if
the duty cycle translates to an unsupported (or out of range) voltage.

Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://msgid.link/r/20240113224628.377993-2-martin.blumenstingl@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pwm-regulator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/pwm-regulator.c b/drivers/regulator/pwm-regulator.c
index 2aff6db748e2c..e33d10df7a763 100644
--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -158,6 +158,9 @@ static int pwm_regulator_get_voltage(struct regulator_dev *rdev)
 	pwm_get_state(drvdata->pwm, &pstate);
 
 	voltage = pwm_get_relative_duty_cycle(&pstate, duty_unit);
+	if (voltage < min(max_uV_duty, min_uV_duty) ||
+	    voltage > max(max_uV_duty, min_uV_duty))
+		return -ENOTRECOVERABLE;
 
 	/*
 	 * The dutycycle for min_uV might be greater than the one for max_uV.
-- 
2.43.0



