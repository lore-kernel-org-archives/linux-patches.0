Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62E330B09;
	Fri, 17 Oct 2025 15:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715536; cv=none; b=OfKrrSpPwzKISmVOKBwX1IdSgIlYunfzGs1mmF5mDTTVOpU0zvOPhB+PEUIjCDFfT1cUGPmLSGfgUaBOW4ZsoFShD8rDWyUSJXuwwZTuCNOS9ELBsPdmjp9cqqhgbTSnlZ0Y/z/7gGYN3x+dv1QqaTrAZggmqot5frj5mwk9Pmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715536; c=relaxed/simple;
	bh=mU01hixpbzMCd+o7HqdgnHIttFYd0x7u3LH2fVUUO00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uO70GDmnJabugOll4wEGvMeS94JX3caXATqBzwg28oHLTVmFNETd/JaxHUebfBYU5X6P/FoHQPa64pWBSTSM+d0EC1yzsS1YNVeef5EWxovx3tpO4MMJxlyHe4fxRi6tJp3wZUX5zCRc1hlcmWio9ScZ6/8HrnGHYPMM3zoOLsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znAxQYds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znAxQYds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9203FC4CEE7;
	Fri, 17 Oct 2025 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715536;
	bh=mU01hixpbzMCd+o7HqdgnHIttFYd0x7u3LH2fVUUO00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znAxQYdsbfneVifqaZ6j5Ks5BlnzpMw4NCvlt3jF3RDoNfEbHqcZLcnRRI71q/khW
	 4QKhNZZ5meZsba6J5jlSVgJ+XGx27v1oWz23Rka1Bg7u6x7S/GxkAfrxMRUFVLwwC9
	 Rxk/FaUuvjKiQ/EL5B94EUI6wCHGsexnWnEj6LhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.17 251/371] pwm: berlin: Fix wrong register in suspend/resume
Date: Fri, 17 Oct 2025 16:53:46 +0200
Message-ID: <20251017145211.160945335@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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


