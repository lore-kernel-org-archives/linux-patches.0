Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C243D332A;
	Thu, 15 Jan 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499952; cv=none; b=CKP5jAzj3yi5vYFBp797V6gncIF3Xj2nwTZNZgug5DxItJWYNAKzsPN8Mt+9pOvLkHKuxLCbdKlB62oEUXoUAZiQKxP+zPHKoN53N72d72UVJ47pTsiZ+IZoWW/BpZIe1WEJa6dXrISjDAyX6uUOVLRycPw6AaW5jG+ye22CihM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499952; c=relaxed/simple;
	bh=YWzlM9X6N2wvUxlFCdqhuVl7EIfnhR57dc1deiILRG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgNtXotgo8d5KWd+zZV7bYoPj4Zr3ayh9F1Pld6bdGRNtX8WoUob1ng3PfitcY2STEYZYl/3kKeqZH9s2xZRcKi6ReoAkh4dLdco2Ny7vhXM8vYqvJDLw6ZDH5NCceZ2FueU8fAYD1wAxlt9kgosw3R9fJBRCf39mctaNynpahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfujhRQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfujhRQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28E7C19422;
	Thu, 15 Jan 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499952;
	bh=YWzlM9X6N2wvUxlFCdqhuVl7EIfnhR57dc1deiILRG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfujhRQo6XpcVlEnOzQWsP8PNz1zlyklJ2U7p+0K53SHmK6dNFTmWlqsmdbtUxCMr
	 V6Ktpq88k8DPsFVph+UGwRSKJkwXGeyZCqP8jOwMwWZbIbeNB6Eou+g2jGOVdmQliQ
	 e9rDH0V0thTuJTfL8VS2L1Z0dRSi0QtfpGh0rOcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	=?UTF-8?q?Uwe=20Kleine-K=F6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.10 405/451] pwm: stm32: Always program polarity
Date: Thu, 15 Jan 2026 17:50:06 +0100
Message-ID: <20260115164245.591933947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -458,8 +458,7 @@ static int stm32_pwm_apply(struct pwm_ch
 		return 0;
 	}
 
-	if (state->polarity != pwm->state.polarity)
-		stm32_pwm_set_polarity(priv, pwm->hwpwm, state->polarity);
+	stm32_pwm_set_polarity(priv, pwm->hwpwm, state->polarity);
 
 	ret = stm32_pwm_config(priv, pwm->hwpwm,
 			       state->duty_cycle, state->period);


