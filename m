Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97951D31A0;
	Tue,  8 Oct 2024 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392261; cv=none; b=mH8lPtZe3Ic9/IQw3wzvuc99oQEqPHXbiD1wr2P4FaD7fyyP6PJbNb6cPiFUAUYrxcISV8hQoiI+jWKjo3aiL0fQCF/S2lx2Etg7HZLfq1NWB5Xhvye/cAXl25p2otiyePKeNL3gXpRw894DSBUq0I7VHCHsu+vGafnlueLa7Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392261; c=relaxed/simple;
	bh=Q7ouEzaA9DaUG7YRlfoE7oVTlijI5/83MHdX5tkbxN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBIAKRjoaE0GB+GNLjYBB2V5AHHp/ywNNDQLh46frabVHiatqzhoxmXsjzwFxy8XnxUmfyrpbwWHDImx0UTYf/Z7b7BYPx7BwJU/v7FfhArJv7kkp4CUo6k/zTMBP3G9d7hBho32n04+TQhS20/KWsetNlHofihAG7/4/wxHN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B826uZDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B826uZDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275CFC4CEC7;
	Tue,  8 Oct 2024 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392261;
	bh=Q7ouEzaA9DaUG7YRlfoE7oVTlijI5/83MHdX5tkbxN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B826uZDt0nlc6EvUzrBXC+r67N51dd78qu6PfE14kS2R+CsnoruyOJmVHMlJMXwph
	 Vq+5UL+2iA/6TaWvjtcYEXIREY5YM/sk2l8NYJSlf16iSRoyjRrwtSA9sOFBgljIlc
	 pSUkZyfiyoi/s2M/ga3WAvXpQtgVnfDs3DsD8mZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 363/558] spi: bcm63xx: Fix missing pm_runtime_disable()
Date: Tue,  8 Oct 2024 14:06:33 +0200
Message-ID: <20241008115716.582119268@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 265697288ec2160ca84707565d6641d46f69b0ff upstream.

The pm_runtime_disable() is missing in the remove function, fix it
by using devm_pm_runtime_enable(), so the pm_runtime_disable() in
the probe error path can also be removed.

Fixes: 2d13f2ff6073 ("spi: bcm63xx-spi: fix pm_runtime")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -584,13 +584,15 @@ static int bcm63xx_spi_probe(struct plat
 
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		goto out_clk_disable;
 
 	/* register and we are done */
 	ret = devm_spi_register_controller(dev, host);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
-		goto out_pm_disable;
+		goto out_clk_disable;
 	}
 
 	dev_info(dev, "at %pr (irq %d, FIFOs size %d)\n",
@@ -598,8 +600,6 @@ static int bcm63xx_spi_probe(struct plat
 
 	return 0;
 
-out_pm_disable:
-	pm_runtime_disable(&pdev->dev);
 out_clk_disable:
 	clk_disable_unprepare(clk);
 out_err:


