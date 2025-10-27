Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F8932D0C5;
	Mon, 27 Oct 2025 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593389; cv=none; b=tQxO+1my/sUMeE6ZfuYYBqo+4Ids8ln5LlepEY/+Cyag+hWvOFDluxFZyBy7KQ8kltfcNEnf/2EvJfh31pTY36AiMyktGFU4vw6lUXr2zXUmiHadG8wjCYcQ0vBdSm2uAyJn5jygYEdDRPnT7ayOjMac/upE2tpvdG0fjSKGi6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593389; c=relaxed/simple;
	bh=p9T++zmoVRJh+b1ln0XJ3QsFUIBNZMEBLMOazirhkF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYXPx1oNU0M1ipYaRxElmpbQ1ZZSJ5jFyHIyqfSl/JoVwl1b1CtTHc4UBWdhM8RSpF1N5jY/UrdslKQy66c1x/hmtafM10FAcfXiI46/1GC3qsUv3irh6v51T0sdIpCYrEKGZqFdcOd0jpK6TKvu6/av5d4BEtbumJzdvE3Bry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJxTNPl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJxTNPl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C43AC4CEF1;
	Mon, 27 Oct 2025 19:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593388;
	bh=p9T++zmoVRJh+b1ln0XJ3QsFUIBNZMEBLMOazirhkF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJxTNPl/94UXjbylNw19ZnDvaKUC01xPobsLPFlV/qYD10FySsARVixrIx/y+3tNk
	 DLjynnH0thKUht05gj/2r1BsLsFtmdYAiDvIhu2yzpdsLIokkJ9mvADbzNvXjZeMMT
	 vE4WEwKqIx7/KdQ1QLxdfz5t4v9KRy6I8ezEtZm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 119/184] spi: spi-nxp-fspi: limit the clock rate for different sample clock source selection
Date: Mon, 27 Oct 2025 19:36:41 +0100
Message-ID: <20251027183518.147521354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit f43579ef3500527649b1c233be7cf633806353aa ]

For different sample clock source selection, the max frequency
flexspi supported are different. For mode 0, max frequency is 66MHz.
For mode 3, the max frequency is 166MHz.

Refer to 3.9.9 FlexSPI timing parameters on page 65.
https://www.nxp.com/docs/en/data-sheet/IMX8MNCEC.pdf

Though flexspi maybe still work under higher frequency, but can't
guarantee the stability. IC suggest to add this limitation on all
SoCs which contain flexspi.

Fixes: c07f27032317 ("spi: spi-nxp-fspi: add the support for sample data from DQS pad")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250922-fspi-fix-v1-3-ff4315359d31@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index bde6d131ab8b7..ab13f11242c3c 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -404,6 +404,8 @@ struct nxp_fspi {
 	int flags;
 	/* save the previous operation clock rate */
 	unsigned long pre_op_rate;
+	/* the max clock rate fspi output to device */
+	unsigned long max_rate;
 };
 
 static inline int needs_ip_only(struct nxp_fspi *f)
@@ -675,10 +677,13 @@ static void nxp_fspi_select_rx_sample_clk_source(struct nxp_fspi *f,
 	 * change the mode back to mode 0.
 	 */
 	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
-	if (op_is_dtr)
+	if (op_is_dtr) {
 		reg |= FSPI_MCR0_RXCLKSRC(3);
-	else	/*select mode 0 */
+		f->max_rate = 166000000;
+	} else {	/*select mode 0 */
 		reg &= ~FSPI_MCR0_RXCLKSRC(3);
+		f->max_rate = 66000000;
+	}
 	fspi_writel(f, reg, f->iobase + FSPI_MCR0);
 }
 
@@ -793,6 +798,7 @@ static void nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	dev_dbg(f->dev, "Target device [CS:%x] selected\n", spi_get_chipselect(spi, 0));
 
 	nxp_fspi_select_rx_sample_clk_source(f, op_is_dtr);
+	rate = min(f->max_rate, op->max_freq);
 
 	if (op_is_dtr) {
 		f->flags |= FSPI_DTR_MODE;
-- 
2.51.0



