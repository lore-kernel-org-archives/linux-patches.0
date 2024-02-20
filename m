Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748AD446C9;
	Tue, 20 Feb 2024 21:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465082; cv=none; b=fOT7J/GQ3p5Zd21BmNgbJTPDLYKxzEwwGzdtYvGh/Td5SvjmCKg/p/ArAx6WBRBOtg56pPFjvgCQgEkFIytUkISDEcYwGDIUl32w+hTNg6u/Gfhg/lJpc0ARladjI6HHP2l0xKaI6pltDTTVBsRRjaGh4/9RU6IaSsCN7Lg9Ng8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465082; c=relaxed/simple;
	bh=aUqR0GQniyR9R+yUA9ZogmAM7BUpfTZ2wJaYwh2us0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u5P2eD10zeD/WdlBXcZO6qkP/UkgPYyu0G5bzp02rld/iGfJdppL0T6JeA14IlMG/8ihzXaqx32qdaGJMEBlh9N5TlS794jfG7D6If/59NDBb2MPEqx0E4hzB6fY15fpGTxMNg/2gw5vUtSsiKNbRszNpL/byidJvih9t7A4Wds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReDPLocw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReDPLocw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6912C433C7;
	Tue, 20 Feb 2024 21:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465082;
	bh=aUqR0GQniyR9R+yUA9ZogmAM7BUpfTZ2wJaYwh2us0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReDPLocw2obKOJWA+luGSFDy2h9v6zZgs25snxKpoXxIJSqXKUMX1lO2k4aZEJoVm
	 TDtEURdAbkBNkk0/mMiVxxJStdn7/NINg5a2X/6klD0ccExVKoVfYTvhBx+8Y3pcne
	 wzf19uHsNg3GtzmHNk2wj+bQuGC2Jp9T4/59YTlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 223/309] serial: max310x: fail probe if clock crystal is unstable
Date: Tue, 20 Feb 2024 21:56:22 +0100
Message-ID: <20240220205640.138526392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 8afa6c6decea37e7cb473d2c60473f37f46cea35 upstream.

A stable clock is really required in order to use this UART, so log an
error message and bail out if the chip reports that the clock is not
stable.

Fixes: 4cf9a888fd3c ("serial: max310x: Check the clock readiness")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kundrát <jan.kundrat@cesnet.cz>
Link: https://www.spinics.net/lists/linux-serial/msg35773.html
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-4-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -587,7 +587,7 @@ static int max310x_update_best_err(unsig
 	return 1;
 }
 
-static u32 max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
+static s32 max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
 			       unsigned long freq, bool xtal)
 {
 	unsigned int div, clksrc, pllcfg = 0;
@@ -657,7 +657,8 @@ static u32 max310x_set_ref_clk(struct de
 		} while (!stable && (++try < MAX310X_XTAL_WAIT_RETRIES));
 
 		if (!stable)
-			dev_warn(dev, "clock is not stable yet\n");
+			return dev_err_probe(dev, -EAGAIN,
+					     "clock is not stable\n");
 	}
 
 	return bestfreq;
@@ -1282,7 +1283,7 @@ static int max310x_probe(struct device *
 {
 	int i, ret, fmin, fmax, freq;
 	struct max310x_port *s;
-	u32 uartclk = 0;
+	s32 uartclk = 0;
 	bool xtal;
 
 	for (i = 0; i < devtype->nr; i++)
@@ -1360,6 +1361,11 @@ static int max310x_probe(struct device *
 	}
 
 	uartclk = max310x_set_ref_clk(dev, s, freq, xtal);
+	if (uartclk < 0) {
+		ret = uartclk;
+		goto out_uart;
+	}
+
 	dev_dbg(dev, "Reference clock set to %i Hz\n", uartclk);
 
 	for (i = 0; i < devtype->nr; i++) {


