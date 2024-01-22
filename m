Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119ED7CF23;
	Tue, 23 Jan 2024 02:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975731; cv=none; b=bBXrAO99hofaIfvhRKZ8L0VA3RFZQYS1HhQFBBBMl4slb2yg0CZOEgDt/JVOCXJLCzOIvPov45iVpGvGXDnbntaftzbgGa1E0PNpQRmnsOGUzsLZThjqf95OJkC6NyH95upcbMvN2FjomQcXakmjq2DCDaWv+uMK7Z7U+JSZf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975731; c=relaxed/simple;
	bh=SwsN6L0TGbsnhDbYwJeBngGYdY0Cwe2kpmGA6+7RCX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwVj8YSlLX8tt+8VHqSd0qrqz+Sdp6mxv6V9iTjZIHXzup5e2GAkZPWgvtqRvER5vNCU9LPpIznhLxyrmx9nl+2mmoijbw0b26VA9fpsbpZ9GFG6RfqdT5hDaGF3pH95uqagZE/I1snhpZyV9cnkxRVDevE+Y87bqqOcRRj3Gw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CV0aMHrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CV0aMHrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92F9C43394;
	Tue, 23 Jan 2024 02:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975730;
	bh=SwsN6L0TGbsnhDbYwJeBngGYdY0Cwe2kpmGA6+7RCX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CV0aMHrCGIaF1ayUOTSOZAQBTRr29Hjf5v57HoGqfJRD48T2KCw4S5oRGRQtGA4lH
	 s+o5M9h1tfkCA0UnnBl0CSFgkXFzg4kEslTEgsqZwPSMPZyde02ocLLz6va4CfHWOa
	 AAkQW7JqkiA454r+JPJ5FkjkntMvmCwrYN0avHqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 515/583] spi: coldfire-qspi: Remove an erroneous clk_disable_unprepare() from the remove function
Date: Mon, 22 Jan 2024 15:59:26 -0800
Message-ID: <20240122235827.840545347@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 17dc11a02d8dacc7e78968daa2a8c16281eb7d1e ]

The commit in Fixes has changed a devm_clk_get()/clk_prepare_enable() into
a devm_clk_get_enabled().
It has updated the error handling path of the probe accordingly, but the
remove has been left unchanged.

Remove now the redundant clk_disable_unprepare() call from the remove
function.

Fixes: a90a987ebe00 ("spi: use devm_clk_get_enabled() in mcfqspi_probe()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://msgid.link/r/6670aed303e1f7680e0911387606a8ae069e2cef.1704464447.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-coldfire-qspi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index f0b630fe16c3..b341b6908df0 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -441,7 +441,6 @@ static void mcfqspi_remove(struct platform_device *pdev)
 	mcfqspi_wr_qmr(mcfqspi, MCFQSPI_QMR_MSTR);
 
 	mcfqspi_cs_teardown(mcfqspi);
-	clk_disable_unprepare(mcfqspi->clk);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.43.0



