Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5C73081CE;
	Mon, 13 Oct 2025 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369181; cv=none; b=fZlkpcpM8GhgWknwW3tpmq3+Qp/ErM1tJNUkCxO1Fll9GQ4MXCebIEaQ15KofE2CFe8kSUpVRzUMV3blSSJRF4ise1LldQWtnvtPHDmWIHziS+iTvegRFUtwYl1xg2tcNP6PgQ+MEajU5Twq+ceHeksnJer2mYPrCtUEi3hA1E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369181; c=relaxed/simple;
	bh=/LxIyWOKsT+r2i8Qu5HWN/XLDGdb0Fcs7ZJrl6Mg2zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pu6rKo7SCZtbBAwRpShKdwqZqZGJdqldqQtXpZ5TDYRkF49EjfX7QV6nUx2u496htKGtxYdPe0gvw1Z/bz2ZgkEmTqJ0oYmcMJa3iANg4pfhdg+Pl6GrXUEeVO9o4/pi/feRlvGQgOqiO1B10d1o3r08dcRkai+qygJIh6g1l0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl47HQiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl47HQiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576A8C4CEE7;
	Mon, 13 Oct 2025 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369181;
	bh=/LxIyWOKsT+r2i8Qu5HWN/XLDGdb0Fcs7ZJrl6Mg2zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl47HQiy0ToDyb7FevODtkb6dWFUEc5r9ORyitm51IA4sU+TiKPuS+EPZ0RMTO4hX
	 7CVR+edkILnNTsl8k9+KlobJBfJW16Nl6Khi2EbE+qpIhxEnXk8Sumxl9GYT6GXuPj
	 gwNpzFUOpwbbcfqxPpH5r+hc62CKGMTuEFr5xBME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 155/563] pwm: tiehrpwm: Dont drop runtime PM reference in .free()
Date: Mon, 13 Oct 2025 16:40:16 +0200
Message-ID: <20251013144416.904327880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 21a5e91fda50fc662ce1a12bd0aae9d103455b43 ]

The pwm driver calls pm_runtime_get_sync() when the hardware becomes
enabled and pm_runtime_put_sync() when it becomes disabled. The PWM's
state is kept when a consumer goes away, so the call to
pm_runtime_put_sync() in the .free() callback is unbalanced resulting in
a non-functional device and a reference underlow for the second consumer.

The easiest fix for that issue is to just not drop the runtime PM
reference in .free(), so do that.

Fixes: 19891b20e7c2 ("pwm: pwm-tiehrpwm: PWM driver support for EHRPWM")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/bbb089c4b5650cc1f7b25cf582d817543fd25384.1754927682.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-tiehrpwm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 0125e73b98dfb..5e674a7bbf3be 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -391,11 +391,6 @@ static void ehrpwm_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct ehrpwm_pwm_chip *pc = to_ehrpwm_pwm_chip(chip);
 
-	if (pwm_is_enabled(pwm)) {
-		dev_warn(pwmchip_parent(chip), "Removing PWM device without disabling\n");
-		pm_runtime_put_sync(pwmchip_parent(chip));
-	}
-
 	/* set period value to zero on free */
 	pc->period_cycles[pwm->hwpwm] = 0;
 }
-- 
2.51.0



