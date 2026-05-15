Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5208A3C819C;
	Fri, 15 May 2026 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862635; cv=none; b=uwjHU5BXMxmaB5JKzeXAY02t/9i8J3jumTo5YJa4J9xVKWA6mw+cvX61jU4f2N+ewxtn1Pmgu6+ht982WNhc0E7p7sAGO0Br5csrmtupACz0YV2dUGidohGNSi4I5XoQ9WH6ma5soi5/dskpLca2NpWDH/wDVW0YpNyzrZXuS20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862635; c=relaxed/simple;
	bh=PEZiYa8DinnzpD2yAr0sMLF3k48dqY08Sq4rud9PFTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw+Jm6tSGJLrvh5c8JnE28gMnb7ykeEQ1CRVoof0IVhKjfpi+g1qsM8qvmria33AkD4OYlDBKf5AgwBsqVog+4hY4r46xved42+vkMfnpvN96e1OefIfju5S8+MymiDQPgw7lVx9Olmlv75P25h2WJPPWUTDe/yjcpLGbgeUpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN9LKHEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN9LKHEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD775C2BCB0;
	Fri, 15 May 2026 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862635;
	bh=PEZiYa8DinnzpD2yAr0sMLF3k48dqY08Sq4rud9PFTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN9LKHENQK4YE5ferfr6Vf+tx/l/LZPP2pB//6YLGkxktzvimJXqIE4GjIFOGhwj3
	 tXSBUz53rP2U060loO6fFExpNEundFuAHpiX0bu6O1WjUvGbM+XgFBLlYF5xTeCFGu
	 v1mk/QxE8fVKDgRELnSz03qlm9zP1VsH2x1OXprM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 123/201] spi: cadence-quadspi: fix unclocked access on unbind
Date: Fri, 15 May 2026 17:49:01 +0200
Message-ID: <20260515154701.227232469@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

commit 233db2cb14db8b1935dda52a6affd97276462b82 upstream.

Make sure that the controller is runtime resumed before disabling it
during driver unbind to avoid an unclocked register access.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support")
Cc: stable@vger.kernel.org	# 6.7
Cc: Dhruva Gole <d-gole@ti.com>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=2
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125354.1534871-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2029,14 +2029,13 @@ static void cqspi_remove(struct platform
 	if (cqspi->rx_chan)
 		dma_release_channel(cqspi->rx_chan);
 
-	cqspi_controller_enable(cqspi, 0);
-
-
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
 		ret = pm_runtime_get_sync(&pdev->dev);
 
-	if (ret >= 0)
+	if (ret >= 0) {
+		cqspi_controller_enable(cqspi, 0);
 		clk_bulk_disable_unprepare(CLK_QSPI_NUM, cqspi->clks);
+	}
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
 		pm_runtime_disable(&pdev->dev);


