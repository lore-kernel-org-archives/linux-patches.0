Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F73715E296;
	Tue, 23 Jan 2024 00:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969784; cv=none; b=M6ENjzeaGj+3UTRKI5MztbVJsctIh9+nmK8zy8RH2iehHgpekqIa4/1Dpk0f5VBuA4/V7o79PWEK0xlmAWlTKDzUx/uqdqa2gl9l+v4fbFZJilApBXpwZFeUD8PV4tE+CflX/VmSUf31PR7tnOd6FXqhOzMBuYdLNB8LhfwdYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969784; c=relaxed/simple;
	bh=8djTW4HbNtPPXgPgI9OQIxBT6aMX/pOPcyfNqYdbUlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eV0cIgiXUOq0I5/J1sBcljpWQb4AQhgr2gV+O5voYSuLouAOlkK6EGzpxNuykM4UvOWJOT0MbkURPIqLLRBYOr4Jwubh/tixdTdaif1y5cB5Zb88RagMtpFLaaMwQEcqMXWLLtPnMtGKVHMiFyMUKA86yqkSvKE+rSrpBmEGoKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6rFwGMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6rFwGMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A23C433C7;
	Tue, 23 Jan 2024 00:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969784;
	bh=8djTW4HbNtPPXgPgI9OQIxBT6aMX/pOPcyfNqYdbUlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6rFwGMSWiDg/jzBOUZTwnHsEKPm6S0lF4pbjV33BdSJRyqjjp81GVAKNmzkprp2T
	 UxpUYD+PjnLyt02TOuAAq+7L/u2AF0zxavDPoWsMv6vj7BFKe+21TajhcHLyK6Dzrx
	 j45QTPO3PFx7YZ+7TPCXlTieeXmrUvMg1JzvRyQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.7 446/641] pwm: Fix out-of-bounds access in of_pwm_single_xlate()
Date: Mon, 22 Jan 2024 15:55:50 -0800
Message-ID: <20240122235831.975185466@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit a297d07b9a1e4fb8cda25a4a2363a507d294b7c9 upstream.

With args->args_count == 2 args->args[2] is not defined. Actually the
flags are contained in args->args[1].

Fixes: 3ab7b6ac5d82 ("pwm: Introduce single-PWM of_xlate function")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/243908750d306e018a3d4bf2eb745d53ab50f663.1704835845.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -176,7 +176,7 @@ of_pwm_single_xlate(struct pwm_chip *chi
 	pwm->args.period = args->args[0];
 	pwm->args.polarity = PWM_POLARITY_NORMAL;
 
-	if (args->args_count == 2 && args->args[2] & PWM_POLARITY_INVERTED)
+	if (args->args_count == 2 && args->args[1] & PWM_POLARITY_INVERTED)
 		pwm->args.polarity = PWM_POLARITY_INVERSED;
 
 	return pwm;


