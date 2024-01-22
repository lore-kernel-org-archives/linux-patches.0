Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B347166B52;
	Tue, 23 Jan 2024 01:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971692; cv=none; b=me3aJj6rHukn67Qm5PcF5AnsoMq3KRseDkbkOE8MfGgpwMm+eqCcGuCsY6Jum7hqkDuVB1TJz3EnmW7AwDNfV1Huu/qHa6I2t7AHJues/nq/zdrPjKChI/nW7VwXxl5JzB50v1OQCdo0oGzjBlbc1+eYDiMmdd6b+b8jYMaBfM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971692; c=relaxed/simple;
	bh=eZN7VyBFepHO5ONq+niQBqnknaQHyd1QeCdmSkzyO1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcjJOufcBUNhnaBolohBKLOuvNX5ll2d/hXpeC9eVMe5WDWagX2X/9FREV5r06esSJCzwkiTJnZMPzRqZSWBc4NxsVqZF1s1Wl8/MI0c0rjue9dutTyTaJy2tz2THVPIZY4MXJUk4JMZCAXyZaXsln1AwLWHi1tIU7stQYALkdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5mFsd/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5mFsd/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E74AC433C7;
	Tue, 23 Jan 2024 01:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971692;
	bh=eZN7VyBFepHO5ONq+niQBqnknaQHyd1QeCdmSkzyO1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5mFsd/jqF6ndscGBmnmj5T55iOFg288oXCUVCf9qrVuPuZefTjp/xSj9eT+i79Jz
	 ntCHYA3fy3lrXcD3k2+PynW45lX0fyXJDCJwGDDKilsy9Ym+mijy1ASmKz07OtvLpE
	 Qc96yCRpJ0ZIIaoI3gfKhqp0OkUqdBiLN9kw1a2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.1 299/417] pwm: Fix out-of-bounds access in of_pwm_single_xlate()
Date: Mon, 22 Jan 2024 15:57:47 -0800
Message-ID: <20240122235802.185648308@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -171,7 +171,7 @@ of_pwm_single_xlate(struct pwm_chip *pc,
 	pwm->args.period = args->args[0];
 	pwm->args.polarity = PWM_POLARITY_NORMAL;
 
-	if (args->args_count == 2 && args->args[2] & PWM_POLARITY_INVERTED)
+	if (args->args_count == 2 && args->args[1] & PWM_POLARITY_INVERTED)
 		pwm->args.polarity = PWM_POLARITY_INVERSED;
 
 	return pwm;


