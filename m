Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829A513DBBC;
	Tue, 27 Feb 2024 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043995; cv=none; b=kFUKTFsbj1rew7S4ao72DoGXpO+rfXlZEPY9LzIi3aMfmD4CcQ9Gp/sbuhNyOh64PGjcEOuk4TI9/XvOj7NwftIIRT0kHj7y9JPj0OWqP8Agggl/ZOqwvxhYrs/XxbwGBHZKWZSgUG/ptix1oJocNKu8nmpInXLrJdaen/ukupU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043995; c=relaxed/simple;
	bh=a40EGyk2ADHVf+AFhfDnFxmaL60j7CMtn9DIc7b3DKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPXyRyqNEWKmX+5FW5VFGvZwgMV2/EkSnP+aq9JEu6eF103LZ1v8Xwl2gj4PGz1PVCh9je1msKLkvGQf5y90PpkK+Gs+T0gD+41DU3AX1ZfAy/YyAC3Z1bLk1meTHYDmlyiY/TZPnObZx89WuifYE6f+j1098PdczGZfgGbprTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBjjqZTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBjjqZTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B52C433F1;
	Tue, 27 Feb 2024 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043995;
	bh=a40EGyk2ADHVf+AFhfDnFxmaL60j7CMtn9DIc7b3DKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBjjqZTyhxb6CLwliGE1xUDyAEx6PK3dFl1a+3Bbvoco3b7OfCWzIBimiXG/Lhvm/
	 E7MfqHnGOmG6qEK1lfpgvYhKi8goFv3k1eQEsXuiUGYzGau94GFghMFbtuBpsCzsUi
	 xsetaNb014Hzgo9EzhcXqIYfy/L5+WT4wrfxFFIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/122] regulator: pwm-regulator: Add validity checks in continuous .get_voltage
Date: Tue, 27 Feb 2024 14:26:26 +0100
Message-ID: <20240227131559.531142324@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7629476d94aeb..f4d9d9455dea6 100644
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



