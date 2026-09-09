Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4424B04B2;
	Wed,  9 Sep 2026 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961779; cv=none; b=EXxYzzI8Uk5oVnUm0e5jEjkwVLa0x9vB2LsseYwvqpY+6/4IYIT2D5OZTcxmBK500hy8QEoBertlSQU6pclm5350/e05vt88OnBTCsIWsAQRmZ/KJFJj7FZr3KIjkFvosbKs2eSVT7SrkipjRiHDMJHib7gVqiHzKSy/f4EH9Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961779; c=relaxed/simple;
	bh=kNUvu02HbIqi61rzvk34hQqC0kom8zCH/LaK8gEDYS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF4iLUIYdebwAvOh0XVI/cTremXII1pwriv4gqVRfsZ7H6Xdy0N2B9MbYlroQGBTwiYcNVMJlUqdxIM/eap55opK/PFa9qMXio6V8EqDHuF/dKnGLf4JeXlPiQHhSbrnfQEZRYSX1GmQiiq9DGaUTP8me8YKG04Wi4f2666L2NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AzlmSf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AzlmSf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE23B1F00A3A;
	Wed,  9 Sep 2026 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961778;
	bh=wZdAeBJstCzofrdSmHxR9hqFFsmhN8lJC7QcddIUMJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AzlmSf91FeEgqZzAs0VkgmfkBaQ1L/0/41KlziKgIKqLSeQRUMCaF6sDXeaQAifO
	 KsVylU9b0eIYxsSl9RPYD+Zg+vJ57KQVDG3z2+O1yx8Bi+MOfi37Q34Aq0g0Hbp0oW
	 V+wdc5rhg9qFCbSb1WoYsHw7i+iT2pp2lXjktXPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 063/556] spi: bcm63xx-hsspi: disable clocks on resume failure
Date: Wed,  9 Sep 2026 15:35:43 +0200
Message-ID: <20260909134232.683108105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -915,7 +915,13 @@ static int bcm63xx_hsspi_resume(struct d
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


