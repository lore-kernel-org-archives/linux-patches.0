Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1DF33121F;
	Mon, 29 Dec 2025 16:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025222; cv=none; b=Iz9sXIHjgut2CS4Og4rDVRvTs4rXhp7HpCRxstGY6xM6l6bXwL1ip4bIZjkqrJ+rMch38AmIORROv8xQVrZ/KkQIkFJ9Rkei42aIEBxVgCt+hQGqMhbQnmhG2nrTHG6Qw93qsg5diaqdNCOTKy0Xc6LTSlpWQMtT/+M/JfhZ9uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025222; c=relaxed/simple;
	bh=C+/65wW2yECVlu+ig9TYZg0/ZB950/t2jMNUrXLZKsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxNIRiKv0ae9Sik8lN5cDFo6EmWIDgIOMg+7WXujQj2iJNYSsBXDjgFzqMemUzFrNkdmJZU9br/Tx1fMSS9i5TrJMUUhntHgdd6I+DZVIECtQBHFv9fWZ9pbzqzuupCG064qEV4KUyTa8Wtch87GnxmeNCsR0Bth/WOQiAAvk3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPEaQYit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPEaQYit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A87C4CEF7;
	Mon, 29 Dec 2025 16:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025222;
	bh=C+/65wW2yECVlu+ig9TYZg0/ZB950/t2jMNUrXLZKsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPEaQYitkVv+w2WbKeHNnLhtBnSgfp0x+K0I6GN5sEqNeiBjmVL7gyHaYA8uikd39
	 2EOJm33CZtIY5AbIMA50t+c4HErzrjYFgpjUIzEfPHJsMcQGlBeu/os3j4GmNkGknt
	 58cqkY6mh48bFKGC4DnNPoQUc1DohSlpYIzHTMWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anurag Dutta <a-dutta@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/430] spi: cadence-quadspi: Fix clock disable on probe failure path
Date: Mon, 29 Dec 2025 17:08:52 +0100
Message-ID: <20251229160729.149999672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index af6d050da1c8..3231bdaf9bd0 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2024,7 +2024,9 @@ static int cqspi_probe(struct platform_device *pdev)
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



