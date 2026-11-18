Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055661;
	b=G0wWOJqPupaz4w0zY5zNUJXsN6ikxH8eV+PeL5Lhfz73uQKS6jZG7fThBLdpdW6vF69q
	 M1R6aiorCHIyJ/CxBWqOaQNbtsxpSDfCmE5tAM0DfZkQxO3E1TlNLCFtfR4sx96XVJb+t
	 pNj4Fdx7JkyE1Athy3vq3ZfjajaUeHbq3m2zwKNKEBcYuh3/qDFBgb4IT9f9fgOve3lGR
	 uyYIjR+2jNWUVOfKolSIlv2DeiXsfuwVbylbrIEfKd62OT5dNEq8QNvb0NLi9KXPQk0oB
	 wtyLIkiv2Ua14BWFE5+cLE64F3JenS0z/PyRZyaqwLb2epY8RKo8N2m1pMgprU7AudA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pLTZYb9898ISoNdq0d1smfEaSvKKQYodcY9fjXifDvI=;
	b=g53s8o+dQyhhTlfyN09d6qH/vCL8NUE4nAjA94ziQZEap7CP3zlzjNtoGJ3HHFpZ9nQ2
	 1jG449gDlNEW2H/nAGQyTvANVtrtyR0KEmcFpUEQ9kT13+mXhJkUZWFOVSSRmOOiuFTQt
	 BA2kd7I6J46uC5pyO/2lAEBcJk1iCukKBANua2q0GfE1blD9koZ5k2IDliwjdhNsT7a8I
	 EotYggg+Q1CJ31WOwV8gUAMkYz4PkSnTSqXlqInBZBeBd779kHhnV/1Emqe9G/CuRg2ow
	 thqWDS0aX8R1vyfhO2lI1hIlxFUq8WNGL7Bo+fpolesTt0x+ibfvbnrd3IsgQvO8Lsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fov/aj9l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85B4606A31C;
	Thu, 19 Nov 2026 02:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fov/aj9l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098731F000C4;
	Thu, 19 Nov 2026 02:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055661;
	bh=pLTZYb9898ISoNdq0d1smfEaSvKKQYodcY9fjXifDvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fov/aj9lqawAEa+jivk4aYHsVAMMdIJVlzn3PSioSTk9crUlD9VAWHl8MpUuIoLH0
	 vmPM9dhJTPljM6sYgPti7WqDRGmYTKeqcpyBQUUPiNj9qxheHkp4LjiMt97w7369aN
	 upWW4iPTdPpx/+NDvr1YPanlG8M4iaKF/p2LbocI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1710/2214] rtc: ftrtc010: fix integer overflow in time calculation
Date: Wed, 18 Nov 2026 15:56:26 +0100
Message-ID: <20261118150120.177136710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit 32f04694fa87b8ac9fa58f9ceb2dc6cbc476e2a1 ]

In ftrtc010_rtc_read_time() and ftrtc010_rtc_set_time(), all
variables (offset, days, hour, min, sec) are u32. The expression
"days * 86400 + hour * 3600 + min * 60 + sec" is evaluated in
32-bit arithmetic, which silently wraps around for dates beyond
approximately year 2106 (U32_MAX / 86400 ≈ 49710 days).

In ftrtc010_rtc_read_time(), perform the addition in 32-bit
arithmetic first to preserve two's complement wrapping for negative
offsets, then cast the result to timeu64_t. In
ftrtc010_rtc_set_time(), cast individual u32 operands to timeu64_t
before multiplication to prevent overflow in the right-hand side
of the offset calculation.

Fixes: 1d61d2592c1f ("rtc: gemini/ftrtc010: rename driver and symbols")
Assisted-by: Sashiko AI [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/42C8FBD59AA34EA9+20260827080320.3351155-4-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index c0c8f6feb79ce..92458e7864d1a 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -73,7 +73,7 @@ static int ftrtc010_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	days = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 	offset = readl(rtc->rtc_base + FTRTC010_RTC_RECORD);
 
-	time = offset + days * 86400 + hour * 3600 + min * 60 + sec;
+	time = (timeu64_t)(offset + days * 86400 + hour * 3600 + min * 60 + sec);
 
 	rtc_time64_to_tm(time, tm);
 
@@ -93,7 +93,8 @@ static int ftrtc010_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	hour = readl(rtc->rtc_base + FTRTC010_RTC_HOUR);
 	day = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 
-	offset = time - (day * 86400 + hour * 3600 + min * 60 + sec);
+	offset = time - ((timeu64_t)day * 86400 + (timeu64_t)hour * 3600 +
+			 (timeu64_t)min * 60 + (timeu64_t)sec);
 
 	writel(offset, rtc->rtc_base + FTRTC010_RTC_RECORD);
 	writel(0x01, rtc->rtc_base + FTRTC010_RTC_CR);
-- 
2.53.0



