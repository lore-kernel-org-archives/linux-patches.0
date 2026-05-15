Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9833FF1D5;
	Fri, 15 May 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860335; cv=none; b=L5ONedKJotd2QQ2ca0e23okqOkNlNMP0BtvX54zCx9hai3tCN1iaqIiGcS2bKH+IN3K5cGV8Rk8P/YBD0B/Uxrf98RhkKAooPoeJJ3NuQzj7Gc2NeYXV5mZ6ZSB2+vxsoaCceSFBytRmFDNJ1c+5jTcNNDSMO0zyFyubfZinBuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860335; c=relaxed/simple;
	bh=9lCKff/vvwyp5tA0mSokY5A963Oo5YEoEg2AIPcm5YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FY7vVnOjRWYGGN59XCFCTO+ebzeVHFB0UYbodsxeOwjzkaMwhnfqtDf3SYL0xkzroFCWnVs7/98mKy3vAfaRMWIKdVQxTK/gMACuxqUfI4z9f7/RtloK8YZclLPY/N/Zhxw8/QYw1tIo554SXw1fEkWtKEsU+I9Rc36+4/nZXQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r805+GC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r805+GC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C61BC2BCB0;
	Fri, 15 May 2026 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860335;
	bh=9lCKff/vvwyp5tA0mSokY5A963Oo5YEoEg2AIPcm5YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r805+GC7GQ/uwIQK9Xr/XfsJRhN4fXJPQtdFxLyzNNslrCR0rYXmJstE8rbyvt9Wa
	 L45BxhlcZhlCPd7T+thH+MKd2zSnjn3zdzz7HfjiGOF2w07czKHo6Rb2LfRT5Ia80g
	 ekJz/RUcbnVK0f2vDPa+9mjXVXua+cVCcuslyVdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 048/144] spi: bcmbca-hsspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:54 +0200
Message-ID: <20260515154654.650545635@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit c3d97c3320b9a1ebbd6119857341be034f7b3efc upstream.

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind to allow SPI drivers to
do I/O during deregistration.

Note that clocks were also disabled before the recent commit
e532e21a246d ("spi: bcm63xx-hsspi: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org	# 6.3: deb269e0394f
Cc: stable@vger.kernel.org	# 6.3
Cc: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -550,7 +550,7 @@ static int bcmbca_hsspi_probe(struct pla
 	}
 
 	/* register and we are done */
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_sysgroup_disable;
 
@@ -572,6 +572,8 @@ static void bcmbca_hsspi_remove(struct p
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	/* reset the hardware and block queue progress */
 	__raw_writel(0, bs->regs + HSSPI_INT_MASK_REG);
 	clk_disable_unprepare(bs->pll_clk);


