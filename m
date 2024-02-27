Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E87113EFE9;
	Tue, 27 Feb 2024 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043749; cv=none; b=T6m3rhBsXmYbxG9YHi0ycRcrAUI3zg0940DbTPCICWbvo1Kc6iTiApwXUAcJsN4DfjT+73uv2/MUyvlwYjAqtGv+AyR6ClOWuwKjxz8eouwEyXpThtPAjSzN+qZTsVDNj98Ho3Y1CIFaLa4uhRbd5sniz/kXJXUUNo15kB0s9J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043749; c=relaxed/simple;
	bh=RyyU+57vru81qLXOjufNpaSepU9x4MIkAOjPA+ypVx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MoMeXv6/pGNMeQFKDOj6VB2CXfm3yK28cWCsKj8/MUhXpCXUfvSrylHAHZDnKu6+qYBoTdCBAICZT069JLgwWJHT2qErg7wRRvpirx25pxJRAMPgneCcyy4De59XBN9H8fXC9Vn9saolpynzvYTrzm5L40NwOVBsWgAV/2BWCP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuwLGVPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuwLGVPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AA3C433F1;
	Tue, 27 Feb 2024 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043748;
	bh=RyyU+57vru81qLXOjufNpaSepU9x4MIkAOjPA+ypVx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuwLGVPfDeyobF+G74d6Mocuv1NxNix2CrEHX0kjiY2gtOOjLZCAkhUr3waSH0CSM
	 jIT98qPBZCtgvU8EyU7J5uw2EHkYmrR54+xiEmPMNGFW3qCLj9f4BDd3W8K6VdQOxH
	 f+MzZDJFbYRZ53Oela1CU8Uj+U3JVHW6cyy1Em60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/84] regulator: pwm-regulator: Add validity checks in continuous .get_voltage
Date: Tue, 27 Feb 2024 14:26:50 +0100
Message-ID: <20240227131553.621814513@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0a9d61a91f436..1b06aaaaf8b8e 100644
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



