Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F408449B23;
	Wed, 23 Sep 2026 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174766; cv=none; b=Zv4XENtMqHYjVtg0aKYdQ/HCT99Uadxjek3SDd3Yx9I+6vunFf/9bT2W8Dc6o7vI1jAWJ/ZOMEajMF3A1JDreFoqGRCwwD3nEYhc/ssgfgnVTR9nrAAHeNhlxO8ePUhED8QNtqCI2ICnMtLhLdaYm5mlTWd5xzwACI8B0qUS9co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174766; c=relaxed/simple;
	bh=qED+TMPXJ9sIiXr46OanUMZgbMqUym/t2CfYZNOACdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZGPHJ6zx+yATWN6cwFnI4zraGiYHNU/5UDAc8k19kaqM90OPEuKagGG9h4LY5U28CZWM6ELxf6+jSRqRCqHgVzx2RtBr/IMV+5lQG26+tXZ0xL/9yus08ZOSu9afDMpIvr5Dv5gEc2RDQLYl6Vxg2zn5PUTthHsE0M4HO+JhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvov3gYC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvov3gYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1881C1F000FF;
	Wed, 23 Sep 2026 14:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174764;
	bh=VbS6fenwN/K0vR/84Kpqjj9O8QENLg3PI3hywSOJqbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvov3gYC7BnMQrY2K735CSQKkua5WsPUCH82gV3cA+Zj7h/wNueXaC2iSqAf82Nzj
	 rvPYyaadec/Ah2oDI/03tqBohgteRQ8v9RLD/9/zjQ0hvRr5JLJ/eTo27fac2RjGsG
	 dUYK+TDCczAYVDQvYfCC3sb1lFcc4j873cvH0S60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Han Xu <han.xu@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 219/398] spi: fsl-qspi: Reprogram the clock rate when the operation frequency changes
Date: Wed, 23 Sep 2026 16:04:53 +0200
Message-ID: <20260923140649.098252320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -271,6 +271,7 @@ struct fsl_qspi {
 	struct pm_qos_request pm_qos_req;
 	struct device *dev;
 	int selected;
+	u32 selected_freq;
 	u32 memmap_phy;
 };
 
@@ -528,7 +529,8 @@ static void fsl_qspi_select_mem(struct f
 	unsigned long rate = op->max_freq;
 	int ret;
 
-	if (q->selected == spi_get_chipselect(spi, 0))
+	if (q->selected == spi_get_chipselect(spi, 0) &&
+	    q->selected_freq == op->max_freq)
 		return;
 
 	if (needs_4x_clock(q))
@@ -545,6 +547,7 @@ static void fsl_qspi_select_mem(struct f
 		return;
 
 	q->selected = spi_get_chipselect(spi, 0);
+	q->selected_freq = op->max_freq;
 
 	fsl_qspi_invalidate(q);
 }


