Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DEA2C1586;
	Sat, 12 Sep 2026 11:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213030; cv=none; b=nkQV/CmiMNyd5RRo3kAy7+bHohOFxPyQAYl64wRwDrYwGJL1rkeSaYZrM0O7OaLLiEoNgVV52V4p0I8wybnrkPi6bNq8jU7XxkUJVrwIcMW3o5rL2/X8kgo83H8RiRpUPZS0+XVnr439hdyTXlxZywQNnI7npc7fnN4TDIPRw6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213030; c=relaxed/simple;
	bh=VMmnAVXFJ0SdHXtW71Vd5Z/tUS+LqWCJyH5ATkDZXXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKQHdip55SnxAvL/7ZCXb6IyR/I3qIwC2XxPOrgnBhQBw2OIbqwnrZXc0IahcEfg1WTHbV8VvmnTgIe5LHZfmdulE4fgd9V+9Vhhnw6OJpn+oB/FyLKkQb0RnFTu1TAL3v/ue3Z2NGBnzrOS8ETDykQkHCmxC5mt72sNJlyzm34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YevE3FwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YevE3FwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B13D1F000FF;
	Sat, 12 Sep 2026 11:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213029;
	bh=D0H135CI+faVHiLdWuLPL1ugOEdb+MBowlCNeYl/a5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YevE3FwLeXIoFI+irDeLu3VJvTV3LcEwZXqL0MzSyvc87OFN3Yxao9s2rYjrQs+/u
	 HjPJ9AoER1IuyRKmIvFTm1PTrJgfCrgY9qOL99yyGIK98LyU69ImR8IJl45Vw4U76Q
	 zPeLhu1KgBvLu/3IWU80zGqR0ZaF/Nz/YkPNk9gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0037/1376] spi: bcm63xx-hsspi: disable clocks on resume failure
Date: Sat, 12 Sep 2026 08:41:03 +0200
Message-ID: <20260912065608.379208477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


