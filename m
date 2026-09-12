Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DA0191F93;
	Sat, 12 Sep 2026 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221236; cv=none; b=fx8TyWyRY6QPZ5KUVYFzMGWoSV9Oa3RzTriDBatS5zhRYjNCVBy/saDx0fmMzwoswm1MLLdOC20HMQ+hxYwYB0yxFL3Qzdmej7ga9tGHEc8sKhJAJJNf56ljD7Y/IipIXaXaPX2YxSqbsITzAKqEePT3eltT7TTGnionG/hnY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221236; c=relaxed/simple;
	bh=BNCN5G59vNh2uFUVTkM293I3LVlzzL/zZIIUjjW1UaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbXOpn5KmyuJcWueNZr4aM5REEZajpjNx+FqMOy1tPF2bnduLwo1Fe/fI7Idv0lz8aLd6K2BfpcXhQGLQi2/0ZL1m+8iTRjZ4p8JEhXrGSSQfoj6g3Vx0FGIn5En8UbRY6q/13VDgemLPjQ5agbHzZyOw5ZjgvEaNLqQIZzDWog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8QlCvWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8QlCvWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9170F1F000FF;
	Sat, 12 Sep 2026 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221235;
	bh=AtBoAf/nOTTipUJFy4XRI/YzIJbkzXPnjXLDf3v/244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8QlCvWDAXTe6+04mvTNmDDsRex6BI6h5Sx2ri03Bv/wsA2C3MpSIgnRhjJSYOg/1
	 p8FIFWXIPaQQJ6CTVrypu4ydPizKW6XmF2AjWMKV5uUcvt8o13PPrkpdyQ3bO84ZV7
	 rXsAnLhSq4qFKOGHnWCXv/95JrgQb3mxMxNULst8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0339/1424] spi: bcm63xx-hsspi: disable clocks on resume failure
Date: Sat, 12 Sep 2026 08:46:11 +0200
Message-ID: <20260912065614.877179665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Peng <pengcan@kylinos.cn>

commit 3b0cee02664041aea7e4f787c66cb86c82eb4e97 upstream.

bcm63xx_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: 142168eba9dc ("spi: bcm63xx-hsspi: add bcm63xx HSSPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804072017.860974-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -921,7 +921,13 @@ static int bcm63xx_hsspi_resume(struct d
 		}
 	}
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


