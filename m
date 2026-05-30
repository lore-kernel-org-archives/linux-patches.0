Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41092332EA7;
	Sat, 30 May 2026 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160370; cv=none; b=OcScXsx+WTD47naXrJbrvLJzB0O2rEWfNE/sarjz7uSHw/rwl1VVU8MNYTH42TSZyG7fcb9AwMegFPKMvSpUUdog8Sa9AIls7hNCWnxkPOG+TavucoZLiRqI3vrDHBdWA9FZIXp2xbjGsWfNjtFCU1lQC19XTOGiO5RWL6eKCbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160370; c=relaxed/simple;
	bh=Qww6XzEAGfE8eYDJxPq5TXfbgVCHIcmqUWZo5kRQ5zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jseaqul14Jjq4v7Y0rf6yuoiQlKO1VCelIluJWck8+crcKDogv4HesyX/dzECEg7JuDAJGVadL7Wf9f+8w6VXhWzJdRdpune07Lsu1sIbKXagqLM7YarjXTeEB1q1nwBL+ioa2nXapE82EvRBfH+LNIdSRZuX+aUySzmjcpU/Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWABLeks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWABLeks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DA11F00893;
	Sat, 30 May 2026 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160368;
	bh=gx/3Z6tZxjd5RuZGLmM2ae9n6xQ2f6hRxw3CSgT8QpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWABLeksEXoj5DhNoEHnNk12jxiM7vax+a5aepuT1vlfmx5oJSdxFsT+n3ImW/7K6
	 /NssRtK8jMZdCtMovly98n6EkuZby7rXwIc3GQ83btltx0dv+yX5tHDS0hsAhFjwkd
	 FY0o0MQPn4KQix2x2+qauQ2GNs5/4NgBuE006PX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjit Waghmode <ranjit.waghmode@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 320/969] spi: zynqmp-gqspi: fix controller deregistration
Date: Sat, 30 May 2026 17:57:24 +0200
Message-ID: <20260530160309.240224043@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1202,7 +1202,7 @@ static int zynqmp_qspi_probe(struct plat
 	ctlr->dev.of_node = np;
 	ctlr->auto_runtime_pm = true;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 		goto clk_dis_all;
@@ -1243,6 +1243,8 @@ static int zynqmp_qspi_remove(struct pla
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(xqspi->ctlr);
+
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);


