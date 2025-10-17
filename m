Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9731632C944;
	Fri, 17 Oct 2025 15:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714475; cv=none; b=P150TSjmIFs6pdgtqzItPehPLCq4eTxY+9I0SZJX3KQUeW0LCfmfWyn2zdFtr0UgOwiDVVzRZLdMnXV3UAcXJ1TG+A7Hen028ImttVneAAJcAvafpCqElvb2h+ULSlcf4xqtNyF1GGZkYE1etvnGygq4S+k+lyfgfwkLVL1Si5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714475; c=relaxed/simple;
	bh=5/x5vAuNxv7/llw97bzi+CgOAxB/OK114Jy9UKydeNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQZyybo3nwxvNfG4h0nc9FHb2RgZ+tIJSdYdosxrlZTnj+EXPYAQ4LDHWYhpQYfAEzV5C4i8ce0J6WFrDiDMKBxtOVQGqJE7DtGg8Rfyt4qCVSEkfi+hi4PXDXyU3D0tmpZF0OXduf99IohDTfIp4r28qk8VlgaiKt2anwCqFSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F76ihXLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F76ihXLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24277C113D0;
	Fri, 17 Oct 2025 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714475;
	bh=5/x5vAuNxv7/llw97bzi+CgOAxB/OK114Jy9UKydeNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F76ihXLhpYtsXG9JN5WvPSZBhuPeGKkjSYTZ9iGGBdTO4FDocN+gTQATOGH5P0dnX
	 Xxa0ORSN1+jt6iqmP38ejq3CfbKTSjDwjfqKk8mxR5StoC3gxYulBkU8yLqYTp/AvJ
	 u1IFXcS9SJgG2s17/sPX1Y73IVfCsm/Wi3lrV3Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.12 158/277] pwm: berlin: Fix wrong register in suspend/resume
Date: Fri, 17 Oct 2025 16:52:45 +0200
Message-ID: <20251017145152.893253829@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit 3a4b9d027e4061766f618292df91760ea64a1fcc upstream.

The 'enable' register should be BERLIN_PWM_EN rather than
BERLIN_PWM_ENABLE, otherwise, the driver accesses wrong address, there
will be cpu exception then kernel panic during suspend/resume.

Fixes: bbf0722c1c66 ("pwm: berlin: Add suspend/resume support")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20250819114224.31825-1-jszhang@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-berlin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -234,7 +234,7 @@ static int berlin_pwm_suspend(struct dev
 	for (i = 0; i < chip->npwm; i++) {
 		struct berlin_pwm_channel *channel = &bpc->channel[i];
 
-		channel->enable = berlin_pwm_readl(bpc, i, BERLIN_PWM_ENABLE);
+		channel->enable = berlin_pwm_readl(bpc, i, BERLIN_PWM_EN);
 		channel->ctrl = berlin_pwm_readl(bpc, i, BERLIN_PWM_CONTROL);
 		channel->duty = berlin_pwm_readl(bpc, i, BERLIN_PWM_DUTY);
 		channel->tcnt = berlin_pwm_readl(bpc, i, BERLIN_PWM_TCNT);
@@ -262,7 +262,7 @@ static int berlin_pwm_resume(struct devi
 		berlin_pwm_writel(bpc, i, channel->ctrl, BERLIN_PWM_CONTROL);
 		berlin_pwm_writel(bpc, i, channel->duty, BERLIN_PWM_DUTY);
 		berlin_pwm_writel(bpc, i, channel->tcnt, BERLIN_PWM_TCNT);
-		berlin_pwm_writel(bpc, i, channel->enable, BERLIN_PWM_ENABLE);
+		berlin_pwm_writel(bpc, i, channel->enable, BERLIN_PWM_EN);
 	}
 
 	return 0;


