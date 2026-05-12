Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541D234405B;
	Tue, 12 May 2026 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609154; cv=none; b=HLsmOmmlLQJR7ErmahfI96nL0kdWgf+T6NJlkyw4LEhcYEBgWyvUdGgCEUPgJ8datbmmHe0SRo/4XgAUjS+3eYdBk3fe6N32Gz+SbhapMe7Rd97WKRWVJk1pr7DHVFmr2WSAvfdHJt63Kq8Do7wXZZLUmQ0qanMAiJccjk9duEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609154; c=relaxed/simple;
	bh=lrRoHLooTkS5FpufrLQcbv6LuXBB/nhU10LNpPrgSUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpzVnc6W8Ac4G1v132M4Cbfxy9bRX8OqnwpPq5OSRCIH1uk3/aReyJy4Km53OryqQpY2g9XPrVO573Y7dVpRpZwX+waIy3jU4NZ3XbpAuOBh6zi6MlXRqWSWQWUiuADeASneHuRGRuXeLvObk3OulIhytkTUn96hCLrDasxQW8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAA7pTE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAA7pTE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16F0C4AF0B;
	Tue, 12 May 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609154;
	bh=lrRoHLooTkS5FpufrLQcbv6LuXBB/nhU10LNpPrgSUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAA7pTE51DN7tqFnzx0UcLIh3BTvewCAJv4sBf48Chhdb7Ad72mPO3iYFEMcVEaKS
	 ihGxQpIFc14US+n03KR78iiCv/4iJygv0VaBBVk7uZ4zgjFmwRAXh22mBfUOKLRTLx
	 RZFYwQEDnxXLqg0GMjJ5lLfcdxU7uZ+bgWiTImrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjit Waghmode <ranjit.waghmode@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 087/307] spi: zynqmp-gqspi: fix controller deregistration
Date: Tue, 12 May 2026 19:38:02 +0200
Message-ID: <20260512173941.962353431@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6895fc4faafc9082e15e4e624b23dd5f0c98feb5 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: dfe11a11d523 ("spi: Add support for Zynq Ultrascale+ MPSoC GQSPI controller")
Cc: stable@vger.kernel.org	# 4.2: 64640f6c972e
Cc: stable@vger.kernel.org	# 4.2
Cc: Ranjit Waghmode <ranjit.waghmode@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-26-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynqmp-gqspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1324,7 +1324,7 @@ static int zynqmp_qspi_probe(struct plat
 	ctlr->dev.of_node = np;
 	ctlr->auto_runtime_pm = true;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 		goto clk_dis_all;
@@ -1362,6 +1362,8 @@ static void zynqmp_qspi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(xqspi->ctlr);
+
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);


