Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DD4287268;
	Thu, 12 Mar 2026 20:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346623; cv=none; b=O0Q80YIVzE2D4IJpmm7bhNWETvGLECBiuaRXioPnIiYm14v4DJ4z3WI1+8wV8e6SS1Mck1w+t8sx2H1XIUqUrM6bnrHj02vg+AawAU6k9zdC4mDwwp9Nq/rz8RzwQjyLvZBca9ecqXxDcZNqBkj9qrTRr6IYYC7pZKC5TL5cRLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346623; c=relaxed/simple;
	bh=/PJj0/QfjU8hUxhDK/+dQQZSkxPiiyobGwOfJtkOvM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZUH5iPiNYeulxFXF7QjQM/mSka9AJfQZhYtNgXGQSKWy4m38ZKR6v8G76gbBY4ylRJkbQ/WLGWndcKB9BfmkZsz/yyRv3TvBSD9Vp9Yv0ih5JnliQErHPkn1aEQgTpenDf0+7kpwLpECMZfw/w3clltqCvQOqGK0sAQQ+0piWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxFE9Tjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxFE9Tjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D715C4CEF7;
	Thu, 12 Mar 2026 20:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346622;
	bh=/PJj0/QfjU8hUxhDK/+dQQZSkxPiiyobGwOfJtkOvM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxFE9Tjg+8Ez5FO1mGqvRfCXE+iWRFUMqVTXpvs4CpOcr1TObG95VyzzV+dCvAzFN
	 atCNpFR1Z4/Iygu4Ps8/swiV3P77dGHFUibhs7AeLNGqPnF1GsMrhL5eyoEwzwJXPi
	 7rDzuz542VfMmrUEVsFs1fvQTkfFmdtZlTc6WB6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Neil Sun <neil.sun@lcfuturecenter.com>,
	Naomi Huang <naomi.huang@lcfuturecenter.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/265] media: dw9714: Fix powerup sequence
Date: Thu, 12 Mar 2026 21:07:20 +0100
Message-ID: <20260312201020.123062192@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 401aec35ac7bd04b4018a519257b945abb88e26c ]

We have experienced seen multiple I2C errors while doing stress test on
the module:

dw9714 i2c-PRP0001:01: dw9714_vcm_resume I2C failure: -5
dw9714 i2c-PRP0001:01: I2C write fail

Inspecting the powerup sequence we found that it does not match the
documentation at:
https://blog.arducam.com/downloads/DW9714A-DONGWOON(Autofocus_motor_manual).pdf

"""
(2) DW9714A requires waiting time of 12ms after power on. During this
waiting time, the offset calibration of internal amplifier is
operating for minimization of output offset current .
"""

This patch increases the powerup delay to follow the documentation.

Fixes: 9d00ccabfbb5 ("media: i2c: dw9714: Fix occasional probe errors")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Neil Sun <neil.sun@lcfuturecenter.com>
Reported-by: Naomi Huang <naomi.huang@lcfuturecenter.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9714.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index e69dd3e14b844..8fee13e9b3a0b 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -149,7 +149,7 @@ static int dw9714_power_up(struct dw9714_device *dw9714_dev)
 
 	gpiod_set_value_cansleep(dw9714_dev->powerdown_gpio, 0);
 
-	usleep_range(1000, 2000);
+	usleep_range(12000, 14000);
 
 	return 0;
 }
-- 
2.51.0



