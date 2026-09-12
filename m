Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C89F2D0C75;
	Sat, 12 Sep 2026 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213035; cv=none; b=VQLRQFmzzUBRR7jLlTYzy2myAR1c+EmgQoC04LwYX2B0GNWr1Fr6V+vF0Jcvpa5LOByXlDqms/Bh8Q34JGtDWHh3LWD47pjAZ1vvt4SFfSqB9dTtCPjoIHPYINIVZAaIjO/ALnLslQxlPpBGwE8uqXriw+v6ecLq0IRm2RepY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213035; c=relaxed/simple;
	bh=2oBzmdO4w59KoJVegUx8T0bFhdI0nQ+x5Uhd6N5PnlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8asqA8mIMr2QbWJdGHxATOrnPdpFDB8kB2MqlH4xyXrQkSXAz3XiFJ+XZFwIXTjphIevRcwvSO/CM635pbeu3Bj3F0yu8VGPKEC9Lkx1bTokgWbLl60sIoKNxkLdQpu1fcyNt0muPPGxf9dkVLCBCd61fC3o1ns33OLk5EOc+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TF1cAqcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TF1cAqcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA1B1F000FF;
	Sat, 12 Sep 2026 11:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213034;
	bh=/LBAVwt5jvOpfWQGyuc51qSKcDwelsfyGp8bwCHu9Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TF1cAqcLOHfC+gWxvAWw1gZK2dZJiP1imGjDRsXvIjgZ4gJiskEwvTlWroofCqxfG
	 LWlTu/tQT3iL45OvF29gsafSEQIPZMAl8nTokQ8NOk9ImdyChjb1dYla7Riwzwt3xF
	 OyV/jU1GyKbpn33g1KgoZFclYKsvdgU31XTXgmkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0038/1376] spi: bcm63xx: disable clock on resume failure
Date: Sat, 12 Sep 2026 08:41:04 +0200
Message-ID: <20260912065608.400455559@linuxfoundation.org>
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

commit 2b62c2c134fa32d9d3a9e7323c8ac74518eeb4ac upstream.

bcm63xx_spi_resume() enables the controller clock before restarting the
SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves the clock enabled. Propagate the error and disable the clock
before returning.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Link: https://patch.msgid.link/20260804071831.860784-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -661,7 +661,11 @@ static int bcm63xx_spi_resume(struct dev
 	if (ret)
 		return ret;
 
-	spi_controller_resume(host);
+	ret = spi_controller_resume(host);
+	if (ret) {
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }


