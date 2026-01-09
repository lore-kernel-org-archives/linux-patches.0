Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D65D33372B;
	Fri,  9 Jan 2026 12:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962293; cv=none; b=X+oUKp/OQBPBh6Is/6D3WmUzFkauiq+QU4TDP6YPZMBQw3Nx+E6ZQGJ12IkySRnXU9lEjVXUn1Hbfp4X/gDWz2GtWjc91E+Wk/Eg9jwJ1rYuCf2+v3LkNu1hvpfmwSots1A8afEEd4gQcxpx5wS5P1k5hCP6ZuncIvPTx5RTmT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962293; c=relaxed/simple;
	bh=KfBgSy8xn0t5oTjREp5iffICLxXYv1ZNkvtrNiKIP2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NasiQ/CuND544pu664lIXoXobr0ZgMnrqNSKMQJERdHMPz8s1VtmWy7XWQAaU6YImtLzPS0ecWPRpYTZ2RWIc/4uH4D/BLQiQtrvJlXQ4U1C38CCHSqNWo2RhKckl9rIkOyDL0yERLYb11g6QDvbp/0pIc6GpX8XPIb7WHNXwD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ+GIbvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ+GIbvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDB7C4CEF1;
	Fri,  9 Jan 2026 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962293;
	bh=KfBgSy8xn0t5oTjREp5iffICLxXYv1ZNkvtrNiKIP2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ+GIbvz7E1oW23zT+gz1vhdBldut+kB4QA1DLtdTAhsj/FFgzbZn7H82iu5g5zwo
	 m5WJgZeIJ9ZTD2Yz33MRetXKnGNqwwjflvniWs6RxNSr/oxKwrcpGH1GTXCiest9oX
	 FAIImQG1j6oYNFt6Mdem5VHuazaK2NeqUGFE8oy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 281/634] spi: cadence-quadspi: Fix clock disable on probe failure path
Date: Fri,  9 Jan 2026 12:39:19 +0100
Message-ID: <20260109112128.106626826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Anurag Dutta <a-dutta@ti.com>

[ Upstream commit 1889dd2081975ce1f6275b06cdebaa8d154847a9 ]

When cqspi_request_mmap_dma() returns -EPROBE_DEFER after runtime PM
is enabled, the error path calls clk_disable_unprepare() on an already
disabled clock, causing an imbalance.

Use pm_runtime_get_sync() to increment the usage counter and resume the
device. This prevents runtime_suspend() from being invoked and causing
a double clock disable.

Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
Signed-off-by: Anurag Dutta <a-dutta@ti.com>
Tested-by: Nishanth Menon <nm@ti.com>
Link: https://patch.msgid.link/20251212072312.2711806-3-a-dutta@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index cb094ac3f211..5b0ce13521f2 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1838,7 +1838,9 @@ static int cqspi_probe(struct platform_device *pdev)
 probe_reset_failed:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
-	clk_disable_unprepare(cqspi->clk);
+
+	if (pm_runtime_get_sync(&pdev->dev) >= 0)
+		clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	pm_runtime_put_sync(dev);
 probe_pm_failed:
-- 
2.51.0



