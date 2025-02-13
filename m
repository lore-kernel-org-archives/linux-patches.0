Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A6E26B096;
	Thu, 13 Feb 2025 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459665; cv=none; b=fIR+VfBxrPtg/sCbWhSPb21QV7TgxefZ074fO5nIujlVLxyb27IYRkHoH92VsGywqG1E7LtRkQiRODI8sCpgioa0KB8oXRYNcqNExq1z+RBd6CSCUS6STZiGwtUpKSwzsbaNhRM+7/QYXqFQ+SmOJ9ZQgpaFPZqanT/KpReEsSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459665; c=relaxed/simple;
	bh=ASjuVbbh/ca5mDGf7+7GRDNxBAcwz6OrJFaWnLyNsi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwoGvRe7kS/NrOp2yDiGKL51lpdc5U12m8MpompkuW62xZca41cEfjchm6D0aTpkIkd86PnsX01fZe4H/7aU66y53rLalUCUbCJCHdpie33E87c0+/h0ZpvJoKTrKSrRQZ0xClKAc2YVXlhuUwx7y0dPAoDOv/MR8jArEcvxq9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNfxe3pY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNfxe3pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5575C4CED1;
	Thu, 13 Feb 2025 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459665;
	bh=ASjuVbbh/ca5mDGf7+7GRDNxBAcwz6OrJFaWnLyNsi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNfxe3pYTum+clR7eC6w0eblqnLsOiG/02l/DX9GRplRgfVhOBo0dn6iO26Xs8Qq7
	 s+m3Dz8sN1SE3KwcaXMeDVPIGCDgLmCcGHFhKZ8onSFrLnYsr+5cCZnUWAFmofc6oj
	 jRxa3JjAZdPAbQsU496UTz6jURTDu0XDVcl9yGEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.13 328/443] pwm: microchip-core: fix incorrect comparison with max period
Date: Thu, 13 Feb 2025 15:28:13 +0100
Message-ID: <20250213142453.274933892@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 752b6e3af374460a2de18f0c10bfa06bf844dbe8 upstream.

In mchp_core_pwm_apply_locked(), if hw_period_steps is equal to its max,
an error is reported and .apply fails. The max value is actually a
permitted value however, and so this check can fail where multiple
channels are enabled.

For example, the first channel to be configured requests a period that
sets hw_period_steps to the maximum value, and when a second channel
is enabled the driver reads hw_period_steps back from the hardware and
finds it to be the maximum possible value, triggering the warning on a
permitted value. The value to be avoided is 255 (PERIOD_STEPS_MAX + 1),
as that will produce undesired behaviour, so test for greater than,
rather than equal to.

Fixes: 2bf7ecf7b4ff ("pwm: add microchip soft ip corePWM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250122-pastor-fancied-0b993da2d2d2@spud
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-microchip-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pwm/pwm-microchip-core.c
+++ b/drivers/pwm/pwm-microchip-core.c
@@ -327,7 +327,7 @@ static int mchp_core_pwm_apply_locked(st
 		 * mchp_core_pwm_calc_period().
 		 * The period is locked and we cannot change this, so we abort.
 		 */
-		if (hw_period_steps == MCHPCOREPWM_PERIOD_STEPS_MAX)
+		if (hw_period_steps > MCHPCOREPWM_PERIOD_STEPS_MAX)
 			return -EINVAL;
 
 		prescale = hw_prescale;


