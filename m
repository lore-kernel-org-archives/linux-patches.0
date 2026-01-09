Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C294633A712;
	Fri,  9 Jan 2026 12:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963172; cv=none; b=HrZY9ZpwZ63d+j3PGjlmKoaXPsT6fgru5aHUe/FP23xcbvXw55PjRtW81D8pP5f4scc5FnXv53aMR7YfsLJfLlTTC4n6rUnqFmhwU1YRSELWgvZUkQFzn1bacH7QFMKATIjlmq27XpEVrCY8BYjD9Mdr/qqlQpvCJUB/XxbgJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963172; c=relaxed/simple;
	bh=oh/MSMg4NcHfvbPtxalSt2MRsU23vUR8YDahwlsvpTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qeh/MxP8Z6QuZgBQharB6aCV+HMHfY0ewur4IpRKRR73ILvXYRqVQ3ZYAYpDOPjITe9rotVXX2h6uGdGMfNQ2L1OQqiHX8NdwrteFAe7rS9wuRLeEVp3fhPJ/tLw50csJmJNCR0V1gYEqpscwz2OoipJFr1QiyAFb8+rV37ZDUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGssxQfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGssxQfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E67DC4CEF1;
	Fri,  9 Jan 2026 12:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963172;
	bh=oh/MSMg4NcHfvbPtxalSt2MRsU23vUR8YDahwlsvpTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGssxQfPthVmM15kv7RHkwBkmTo0ZjiFjWcXTYBLgVM2lSf1kbvPgSyI+5GkEYpbC
	 RxzT5ZVYz4deMkUIXPKy10E6BN6qwKjTNomwSAW0v/94yKYvDiCZpfLCOPetyuMR8y
	 31B73IkfiMuGRsTmAUoEBUAbQ/oTsqloF1yKVF7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	=?UTF-8?q?Uwe=20Kleine-K=F6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.1 621/634] pwm: stm32: Always program polarity
Date: Fri,  9 Jan 2026 12:44:59 +0100
Message-ID: <20260109112141.005224573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


