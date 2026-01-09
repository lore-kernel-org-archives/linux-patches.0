Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9555126ED41;
	Fri,  9 Jan 2026 12:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961383; cv=none; b=gYRk5S0Mf48EOlZ0B6T1o4cet2j3Uu9khJwNJlJG4sJlKEUXIXSW1QeqWKyFDQPxDFBZEKxuSlSaM5B8RVniyUYojIdLPjvo2mETISDGgG/sBpetgH22fedgaPiHrWtZ/LJcVs1Pqi4URneyMDWbvTo0lqDfwHWFPpkm0fW4ulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961383; c=relaxed/simple;
	bh=1YHFqgirNvWIfxmFR+BmDR9vFOESO9Fu67eHYf8yF4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJZru2y3jaikXw4ZXtFTQ3Jr5heULAd1QD4TePtJTxFBhknuQf4rleddbVC4o1axAx2oa1f0ckD/xNp2iVDH2eTrt0wz3NpjT9n5/mFLbC0iXtCBDbrPtG+Mr5cgJdUAiFiI1GoqnBQdHnkcLolHGr4UElrRVZjLZJO5HXsRc2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOzjT6oS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOzjT6oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243DFC4CEF1;
	Fri,  9 Jan 2026 12:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961383;
	bh=1YHFqgirNvWIfxmFR+BmDR9vFOESO9Fu67eHYf8yF4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOzjT6oS3vCHPN/rSskJIv61LSrT+1JxKJpniCTuZEM2d5Aon7979i/UVmN7MNXx+
	 3kB8kY+T65ZtiMQAIRFyOcfinu15Amc7pXtvtWM6nq5RshRi3ZG/iNs/zscOdsA9eA
	 9Zos9uzaEwi2n982E+K3Rp3jScAkpplqa5gSCh5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	=?UTF-8?q?Uwe=20Kleine-K=F6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.6 733/737] pwm: stm32: Always program polarity
Date: Fri,  9 Jan 2026 12:44:32 +0100
Message-ID: <20260109112201.680293398@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

Commit 7346e7a058a2 ("pwm: stm32: Always do lazy disabling") triggered a
regression where PWM polarity changes could be ignored.

stm32_pwm_set_polarity() was skipped due to a mismatch between the
cached pwm->state.polarity and the actual hardware state, leaving the
hardware polarity unchanged.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org # <= 6.12
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Co-developed-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
---
 drivers/pwm/pwm-stm32.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -462,8 +462,7 @@ static int stm32_pwm_apply(struct pwm_ch
 		return 0;
 	}
 
-	if (state->polarity != pwm->state.polarity)
-		stm32_pwm_set_polarity(priv, pwm->hwpwm, state->polarity);
+	stm32_pwm_set_polarity(priv, pwm->hwpwm, state->polarity);
 
 	ret = stm32_pwm_config(priv, pwm->hwpwm,
 			       state->duty_cycle, state->period);


