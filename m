Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E878C2690EC;
	Mon,  9 Feb 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648592; cv=none; b=ugVeGAev4manV7+b0KXLjANQvIAqqST0LnH179uC5YGrJkOLcHKmcFIhxB+132NLWIecYaw5P6+ICIrncEY3jRtI8UopBW/EkzIZjhl0A21ADdSYrNJnTn7LX8YCrHgpf+b2gKGXv606GOZtkYXOIQu4KZZy4ww6ascJY8xDOI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648592; c=relaxed/simple;
	bh=53d4BxtSoFayeJxTW7xUyBZdBEXVZi3GsJMDwMWqAZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zn6rRp+Ts1g83h5xXO0NRIMnyw6fwIUNXUTbiOYdCGrdfSh+vuqEkIR6u9U5ti/1kll3XfMZDRF03yti0pEiq6k49DJjvpQESyfm8+KwjSRb3tclLooyyU7VnK8CKkiNm2fYeMcTvvkyAy+I/CaqCD+EZruAlBwh2awPzT19ESU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmEwBT2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmEwBT2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DB2C116C6;
	Mon,  9 Feb 2026 14:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648591;
	bh=53d4BxtSoFayeJxTW7xUyBZdBEXVZi3GsJMDwMWqAZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmEwBT2Z2cFA1eVWkhV7lw6uUwEzDd5x7xHgAdUUg/EJ63Qn1LSSxppJ+NaOvtDfv
	 H+y4D2pxRgRxuD6/om5+49CdZpeCSGC6hILKRA0onYxMGy13byrTkpzL6p74Q8dD+F
	 jKYQ3QqhJzth9N9V5mLknbcjJ8kYC7XHeI7UsBYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 84/86] spi: tegra: Fix a memory leak in tegra_slink_probe()
Date: Mon,  9 Feb 2026 15:24:47 +0100
Message-ID: <20260209142307.809111778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f5cd365c913a8..f450409156c64 100644
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



