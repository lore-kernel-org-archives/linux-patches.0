Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DC934AAE0;
	Tue,  6 Jan 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719945; cv=none; b=m3VOrB7TuR5Nwnz2lAKoW9tBXhYA8yxsdrrAcmKtAGBKlx20ZIr2ppyRJaJt/Z4LCje+sxH77jepE0XztHGxsOBJB+QR+NBh+j3zZWrdBpxYFfE0OYUvpkFc9Oeg4AQxtv3b3DCBeaYIJGWKXjuluqf1+XzKYfQzz+um/MlYY4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719945; c=relaxed/simple;
	bh=5E7DTdy2Oh3cJXpIX+Fpqx0J0KJtnrzdOGADIfsauCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZcnvow4Sfz4Hh5O7lbrkAFqsNdncB4l8a572RRgMUyxqYTx1QFkecmw3QTKhStLXdNuBlUC37e66NxGVg1vFhEMdHBTIoDJ0RukV33vbRtlU3g2q1lZmjX8c2IXbPqQQU36u18HbE0WzZGMajQi8LFaC9dIwjZGVRzKY1lFPzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8rw2FIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8rw2FIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE91C116C6;
	Tue,  6 Jan 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719945;
	bh=5E7DTdy2Oh3cJXpIX+Fpqx0J0KJtnrzdOGADIfsauCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8rw2FISvtrLSEHV4HxlWX4b/jNfnvqrN+P0pNobnZwNJMMXn+28ezD4kbPUGma6j
	 te5E0x4FgwKXY8cjwNN9rPj4d9igPEmwRqdoHR1LuQS+LuTwmajOAkWzXFOtoouoV3
	 T6CyRqhOUf9olfVPelVDe3MrHKoposOjCp/Tj37c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/567] spi: cadence-quadspi: Fix clock disable on probe failure path
Date: Tue,  6 Jan 2026 17:57:50 +0100
Message-ID: <20260106170454.584972309@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 06e43b184d85..aca3681d32ea 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1959,7 +1959,9 @@ static int cqspi_probe(struct platform_device *pdev)
 probe_reset_failed:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
-	clk_disable_unprepare(cqspi->clk);
+
+	if (pm_runtime_get_sync(&pdev->dev) >= 0)
+		clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	return ret;
 }
-- 
2.51.0



