Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8419347A7C;
	Wed, 21 Feb 2024 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523321; cv=none; b=lP5Inu+D+KQCORsAAHsBV7bnOqUzbiVvNR7zIAXOAM2+WB8xQHhdb13jgkVMt+jkVd2nLuoXc2lbyhuGru4b5VXpxkXUkrJUBAOb9j2gMZhPaU8wjdTgAFMF5XCh4TU1u6MumcjByWYLpeZyEtBdHfaqiWS92FioEFZ5tVNoCgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523321; c=relaxed/simple;
	bh=sCbiJp3pzgqZHK5q0qEHmFWJREqO3lLMi5aVvaT/+Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6FmkUH2zREmlvt8n1NjANRBoCc/R2GNR+eyERr2TEEqdmCZspFHRUiwAUBcao94qFRq24gFglVofx8VQ1KaP6I+QKoUoV19EWUgCWIf46u45eWsVxXwDDc9a+zE0VFMyR2pUqkQ/UJw4jBXT0w4nKJER8DloWDWNdoZaxcoNQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtsUS0ab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtsUS0ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B0CC433F1;
	Wed, 21 Feb 2024 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523321;
	bh=sCbiJp3pzgqZHK5q0qEHmFWJREqO3lLMi5aVvaT/+Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtsUS0abupcbqGq+S169zveq8DzgWmdtP+nRBO6R4dXd8ONO3GhIEVdtND67wlPCc
	 vCOomFeYjy9qC9MXjmh866joz2un+JpX1+R2xf10Qsria4egJYtSbXSZeHpetMbGJC
	 m9pB+n3SdoN7BQj/xwnPqH4tZxfvRoXEF6B6PMuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Kundr=C3=A1t?= <jan.kundrat@cesnet.cz>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 5.15 401/476] serial: max310x: fail probe if clock crystal is unstable
Date: Wed, 21 Feb 2024 14:07:32 +0100
Message-ID: <20240221130022.824994767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -556,7 +556,7 @@ static int max310x_update_best_err(unsig
 	return 1;
 }
 
-static u32 max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
+static s32 max310x_set_ref_clk(struct device *dev, struct max310x_port *s,
 			       unsigned long freq, bool xtal)
 {
 	unsigned int div, clksrc, pllcfg = 0;
@@ -626,7 +626,8 @@ static u32 max310x_set_ref_clk(struct de
 		} while (!stable && (++try < MAX310X_XTAL_WAIT_RETRIES));
 
 		if (!stable)
-			dev_warn(dev, "clock is not stable yet\n");
+			return dev_err_probe(dev, -EAGAIN,
+					     "clock is not stable\n");
 	}
 
 	return bestfreq;
@@ -1266,7 +1267,7 @@ static int max310x_probe(struct device *
 {
 	int i, ret, fmin, fmax, freq;
 	struct max310x_port *s;
-	u32 uartclk = 0;
+	s32 uartclk = 0;
 	bool xtal;
 
 	if (IS_ERR(regmap))
@@ -1346,6 +1347,11 @@ static int max310x_probe(struct device *
 	}
 
 	uartclk = max310x_set_ref_clk(dev, s, freq, xtal);
+	if (uartclk < 0) {
+		ret = uartclk;
+		goto out_uart;
+	}
+
 	dev_dbg(dev, "Reference clock set to %i Hz\n", uartclk);
 
 	for (i = 0; i < devtype->nr; i++) {


