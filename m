Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E17531629;
	Wed, 23 Sep 2026 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173596; cv=none; b=rh+C9jCgspD7ZydsOrsZEYG7PwS3I/c/SZQvdsybYOikJW4vDrbX9gX2nNRyKbVIOf8A2vxdOpWzoDJc4BCUz1bNKiuefT7Z1jcplI4sabGl7P8qVfeZKOtW3EOt56LESaufFj7L+zDWXrhVcvsOYcK+30BD+BtcMd8k/hwSvoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173596; c=relaxed/simple;
	bh=0EmL7u26kpMUx2WcgnW2XsGsZyLjGYsX88QFSMjApOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgP1o0QXnZFbK+T9VPxpuIp08fLy6G+tC02+25gCYg6UxcAMfd7rH6jMlNz+RmtlOF6scCDI82lGsufDidWFsVFuGOSKROKeWm2IEUMbNGlTmEU4tgEhj5vt2fyNgzy5czLt5vlqB5S39/xOpwDuQXSqBUXU0Imi3lWyFgHxmI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXMK+I1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXMK+I1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BF91F000FF;
	Wed, 23 Sep 2026 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173594;
	bh=czFmwGNizmhxBP6qFtX/ypj3lPo5L6G48gfhO84ntEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXMK+I1wfLhmy3FsZCdmHriiozdYOCp8Gvg4nFu7N82ubbjDgEjeklzaLILhAKUA5
	 Fo4Q/SLF52OZz8f7X1NEv2Ccqe5UkNBYvGXxjYqw+ljaKdt4SJ/znmstcfFsJQS2oq
	 Pn5wa7eLnN1oVgSK9DuzmWBLprAJUSOixLH1p9tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 262/438] spi: fsl-qspi: Reprogram the clock rate when the operation frequency changes
Date: Wed, 23 Sep 2026 16:04:43 +0200
Message-ID: <20260923140651.563153864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 3d743adf090cd4c9a2120c1e02b0482e88aa0d2d upstream.

fsl_qspi_select_mem() returns early when the chip select has not changed,
which happens before it reaches clk_set_rate(). Since the rate is now
taken from the spi-mem operation rather than from the SPI device, the
controller honours op->max_freq exactly once per chip select and ignores
it for every operation after that.

q->selected is only reset to -1 in fsl_qspi_default_setup(), i.e. at probe
and on resume, so on the common single chip select board the very first
operation latches a rate that all subsequent operations inherit, whatever
frequency they asked for.

This results in operations being issued with the wrong frequency.

Cache the operation frequency the clock was programmed for next to the
selected chip select, and redo the clock setup when either changes.

Fixes: 2438db5253eb ("spi: fsl-qspi: Support per spi-mem operation frequency switches")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Acked-by: Han Xu <han.xu@nxp.com>
Link: https://patch.msgid.link/20260917-fsl-qspi-freq-op-fix-v1-1-5fbe6b02f738@kontron.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-qspi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -289,6 +289,7 @@ struct fsl_qspi {
 	struct pm_qos_request pm_qos_req;
 	struct device *dev;
 	int selected;
+	u32 selected_freq;
 	u32 memmap_phy;
 };
 
@@ -551,7 +552,8 @@ static void fsl_qspi_select_mem(struct f
 	unsigned long rate = op->max_freq;
 	int ret;
 
-	if (q->selected == spi_get_chipselect(spi, 0))
+	if (q->selected == spi_get_chipselect(spi, 0) &&
+	    q->selected_freq == op->max_freq)
 		return;
 
 	if (needs_4x_clock(q))
@@ -571,6 +573,7 @@ static void fsl_qspi_select_mem(struct f
 	}
 
 	q->selected = spi_get_chipselect(spi, 0);
+	q->selected_freq = op->max_freq;
 
 	fsl_qspi_invalidate(q);
 }


