Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0073C0A1B;
	Tue, 12 May 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608268; cv=none; b=G0qAGPP6/P59aqSHOdjWy7RqNW1T5S7DSYVjhYhF61TDExpelcumIbvLNqwctDe8rq6hQKM8dz66QYHrxSFSgBlK8+kxg2d/HIMkmHXECaTJbJb0lCHhc8EsUMGnKxP367uhEScu5U33nM5DFbv3rV1C6/Uh/jJz+Fi2m5rgBHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608268; c=relaxed/simple;
	bh=Jhc2dBKn9rJ0k/+SlRpfplM6hHLElJwqbpqoeKZsg8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpSnsd7HuiHeVnw7XKAByyfToTFRYCJuzvi0Uq2UPhjC1JbqinLlYyl9A2JU0vyjxP0OMu/CQI/6pa/DmlA3i4joeytwZaW+9dMRLb/pfi9opyfRbPm1u+O7i028o6FTeWlpy5mTwEUIcR/RYzR9+teQY3G/ZErVNj0A0VzGD3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNARStp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNARStp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5411C2BCB0;
	Tue, 12 May 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608268;
	bh=Jhc2dBKn9rJ0k/+SlRpfplM6hHLElJwqbpqoeKZsg8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNARStp1P83wEDZMOxcw3R5ddAFPIhCgKVP7M+NJDvjIboBMQ/OvzJGBy7Z/Rw1s0
	 kgTuG6GPwg36YKl7lTcXLyv5UAhf5wKTBk7QKPnvh6frOTSwf5OYDWyvh1gFanbwLK
	 mXsUZoo6BnaC1KYbdKKs2zvw8j4te1GyyP7ntRbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	addy ke <addy.ke@rock-chips.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 014/270] spi: rockchip: fix controller deregistration
Date: Tue, 12 May 2026 19:36:55 +0200
Message-ID: <20260512173938.755921046@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -909,7 +909,7 @@ static int rockchip_spi_probe(struct pla
 		break;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register controller\n");
 		goto err_free_dma_rx;
@@ -937,6 +937,8 @@ static void rockchip_spi_remove(struct p
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


