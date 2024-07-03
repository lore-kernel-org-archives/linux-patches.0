Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5243E175555;
	Wed,  3 Jul 2024 10:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003698; cv=none; b=OJVHzOzwp75HfNQMJ1cnRYPIvVTAEBr9ZzrzSrXUFjetMKQlEI7l/dYRzAH0YjciIiGv8+oyf29c0filOFcvETMRlas6u0DHBeGrnlWmyZPD4XXWNryVazz5RbrTPyrmF8dx1Fynlq+Ge1vfr2SutNU8nSche33domVPNrSsKNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003698; c=relaxed/simple;
	bh=u232e3M6800SFe793uI/+SMWFZIJhMQh/aJ1yR139tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuK67icPv0sN/NBnfj/DZ1L+EMjswY4ohdKm/VwVjdxcadFdvsmsAxpIV/il19c3AQC/X3m2Qr+QAk5fuUV/O/0Ks/wmgHex8+FpLDQNPHIAFOo3UAywWwo2ARan3nWmz7sUCIuyHw0xuD/AZOzxJYrbmI7IJiiOZJ+W3htBraQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YL94piCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YL94piCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897ABC32781;
	Wed,  3 Jul 2024 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003697;
	bh=u232e3M6800SFe793uI/+SMWFZIJhMQh/aJ1yR139tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YL94piCPxvap1PrQFq/NrCGZ3ZLTqFw1WPIp1LQGAbcl59ZRoRXLjgdrtZjUGIUbW
	 7T/j3vtchHgHYj6xEMuGrnvYVenPFQ9gpkQFk7S3zRWIzhD+hE0jfjPq+S422EbQaQ
	 YmFcy3JwtdH/WDGHpvCAjBdBx+5XB3V4OY5hepKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 4.19 135/139] pwm: stm32: Refuse too small period requests
Date: Wed,  3 Jul 2024 12:40:32 +0200
Message-ID: <20240703102835.531449444@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit c45fcf46ca2368dafe7e5c513a711a6f0f974308 upstream.

If period_ns is small, prd might well become 0. Catch that case because
otherwise with

	regmap_write(priv->regmap, TIM_ARR, prd - 1);

a few lines down quite a big period is configured.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b86f62f099983646f97eeb6bfc0117bb2d0c340d.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-stm32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -337,6 +337,9 @@ static int stm32_pwm_config(struct stm32
 
 	prd = div;
 
+	if (!prd)
+		return -EINVAL;
+
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 


