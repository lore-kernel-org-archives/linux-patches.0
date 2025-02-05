Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ABC126C18;
	Wed,  5 Feb 2025 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763410; cv=none; b=aOfFF303yA4j354Yb4/8jhpJ5lGBnfrMfyn/uOrFfbp5N2PU8rjP+K22Dgxvw9ILEYBUfkA5lUbzGwsFkH17Ubmd2rxuO66cexPAb2Yt7eSE0AJm5gLNW+skepL7W1p4WqyxZCBZbRGJOj35iz4fZNH32HdCqM4hiq9uX+efxBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763410; c=relaxed/simple;
	bh=ytWIpCo7Me3G8gZfLuRIrYZCTdDAN1Rh+wb5w6h253I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1KIwWeKTAOGHZUG3ui1wV+aU3uM93jWptZkJ7ixSGJT6KjI93bUrSPXhn1m4Jdz2SkXCYoz8nXeFUKYn3LwVJVP9gi9knOMmASA+TcSDYYXqILEbUVDHF3CK1ZQpwp66kmNprKMjTYBTTJsVzGipw4Csx9IeriHgL0aR4dPQeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhBwe9kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhBwe9kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF54C4CED1;
	Wed,  5 Feb 2025 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763409;
	bh=ytWIpCo7Me3G8gZfLuRIrYZCTdDAN1Rh+wb5w6h253I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhBwe9kVkybdjRfKISeRVJTQfT0ed625Ur6iNrog0xsv1TceVaw6HenHcrFMGPud1
	 GNOgb6qy1j8KLZlDYCzlbu104q+eXBZPRMWivXbCB6NC1+YE1uWFHTiyU80X6kfsHW
	 mWp8iFraSJ/4qG5YUOug6TgzJAN5bFJQpeyHcHGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/393] spi: zynq-qspi: Add check for clk_enable()
Date: Wed,  5 Feb 2025 14:39:37 +0100
Message-ID: <20250205134422.516090735@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit 8332e667099712e05ec87ba2058af394b51ebdc9 ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: c618a90dcaf3 ("spi: zynq-qspi: Drop GPIO header")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20241207015206.3689364-1-zmw12306@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 0db69a2a72ffc..9358c75a30f44 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -379,12 +379,21 @@ static int zynq_qspi_setup_op(struct spi_device *spi)
 {
 	struct spi_controller *ctlr = spi->master;
 	struct zynq_qspi *qspi = spi_controller_get_devdata(ctlr);
+	int ret;
 
 	if (ctlr->busy)
 		return -EBUSY;
 
-	clk_enable(qspi->refclk);
-	clk_enable(qspi->pclk);
+	ret = clk_enable(qspi->refclk);
+	if (ret)
+		return ret;
+
+	ret = clk_enable(qspi->pclk);
+	if (ret) {
+		clk_disable(qspi->refclk);
+		return ret;
+	}
+
 	zynq_qspi_write(qspi, ZYNQ_QSPI_ENABLE_OFFSET,
 			ZYNQ_QSPI_ENABLE_ENABLE_MASK);
 
-- 
2.39.5



