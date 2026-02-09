Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA823D291;
	Mon,  9 Feb 2026 14:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647675; cv=none; b=etC9aOqP+JyTkbOrqir2kGYI48Zo52PPXkBSJ43ELn986Tl75W1y/4wdTkb/fb0NgocdHNcCHus/atQ/6ZrK3QBmiYNanfkSdoO21yuEuKEhlVUxjqdKP4VsXO4y278C+9W/cCSv0p5r0CV7NgI9huSp6tp4C70Bp3ctbLr23j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647675; c=relaxed/simple;
	bh=BkoxUA2/Nyk4ESAGRNuCqWdBUVoXRNVa6sN44R1LIs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBXefdStFQ2aqEIyGzwiMJVO+nXfbovayR1x2gVWDvo5Ft3WUUQCYEiIlxIfROOc0JACu69fZims28n0+zOFuszTwf/gXVF7vEaSznBk0Cu4i3+PGB80SvALIfyxRU5XSQ1KSXbn0fwYP9Bto3JQMPSy6UfSAiFItMTPwkJvQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxELFWsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxELFWsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5396C116C6;
	Mon,  9 Feb 2026 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647675;
	bh=BkoxUA2/Nyk4ESAGRNuCqWdBUVoXRNVa6sN44R1LIs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxELFWsaZzouBHDhZpGt2NWgZM1eUgEKMHcGMzj84pz7fTQ9V4ViZK0ib3wE5Y6Hp
	 GGp/YHxW5EWxcDj7OJFt5gpOtBrJ4AcR3qMt3jx1HhQ+vKzE7VklFZPCdf3v5A9bXA
	 cWdcKbeGEzmIE1FjSntENImKb2IyT6CAAw58Phds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/175] spi: tegra: Fix a memory leak in tegra_slink_probe()
Date: Mon,  9 Feb 2026 15:24:04 +0100
Message-ID: <20260209142326.632140054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 41d9a6795b95d6ea28439ac1e9ce8c95bbca20fc ]

In tegra_slink_probe(), when platform_get_irq() fails, it directly
returns from the function with an error code, which causes a memory leak.

Replace it with a goto label to ensure proper cleanup.

Fixes: eb9913b511f1 ("spi: tegra: Fix missing IRQ check in tegra_slink_probe()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260202-slink-v1-1-eac50433a6f9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra20-slink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index fe452d03c1ee4..709669610840b 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1086,8 +1086,10 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	reset_control_deassert(tspi->rst);
 
 	spi_irq = platform_get_irq(pdev, 0);
-	if (spi_irq < 0)
-		return spi_irq;
+	if (spi_irq < 0) {
+		ret = spi_irq;
+		goto exit_pm_put;
+	}
 	tspi->irq = spi_irq;
 	ret = request_threaded_irq(tspi->irq, tegra_slink_isr,
 				   tegra_slink_isr_thread, IRQF_ONESHOT,
-- 
2.51.0



