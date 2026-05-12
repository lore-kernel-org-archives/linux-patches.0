Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AA33EDE5B;
	Tue, 12 May 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608969; cv=none; b=ZevspLnB9g13OWSCXuCx7I+dmZU1QqGV7HJXeEHgRLOzul6nD3PXzhBKOKbcq6RmqaSLT1PErNjYrAPd3S63Xnr/N7foGDx81rT2CnMSkas+6JShHbhn6FCY0wu6rlgQcV4HaZWJaxpkTeQh7kl4Qa6sy8PcXzhMzbUr7Om9Tl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608969; c=relaxed/simple;
	bh=IGR/Av2sqiIEFJDeNWKYInbSXujWgQH/uEjD94dv0Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGXeN8snrJWEAsI09Nj0NY1yMfDR63pzn8j86EQsWXgWFZJq2hGjO1u1qEnoBF5OjOzGyNbBiFjHv8/lEb9zkIwo4XK+IC9Fbbzkjm7r8sIIaEsy5G1R/PPXQWIeWZvdiXjSP9F00fyODZrcKL7mdWk6bNkc5H2zQzTxsDxnOH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6iTSDIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6iTSDIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C56C2BCB0;
	Tue, 12 May 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608969;
	bh=IGR/Av2sqiIEFJDeNWKYInbSXujWgQH/uEjD94dv0Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6iTSDIYYNLaUDn9nUzZhHI1phCZ76Br0o4g5mpVYFTegYqS5WRbqao6ZPBYQmFlG
	 s8LbM8zu+FLD1A4tUgaolzxoRmkhov3tsr5gYCdGfN4UMyCuR+e8OVIeosYZI4YyU8
	 C8Yy55j5fFGWKfnQGs3g3xMNGBQpkLzfAqRrOKog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 015/307] spi: rockchip: fix controller deregistration
Date: Tue, 12 May 2026 19:36:50 +0200
Message-ID: <20260512173940.446752760@linuxfoundation.org>
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

commit 53e7a16070feb7d1d4d81a583eaac5e25048b9c3 upstream.

Make sure to deregister the controller before freeing underlying
resources like DMA channels during driver unbind.

Fixes: 64e36824b32b ("spi/rockchip: add driver for Rockchip RK3xxx SoCs integrated SPI")
Cc: stable@vger.kernel.org	# 3.17
Cc: addy ke <addy.ke@rock-chips.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rockchip.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -908,7 +908,7 @@ static int rockchip_spi_probe(struct pla
 		break;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register controller\n");
 		goto err_free_dma_rx;
@@ -936,6 +936,8 @@ static void rockchip_spi_remove(struct p
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


