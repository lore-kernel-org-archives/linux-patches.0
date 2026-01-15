Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67DB3BF31C;
	Thu, 15 Jan 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496759; cv=none; b=piOaMGIACEc483nzvp6vcLtsUqLKG521BXidGk8++CeLwbn1TskwHKV4akYZoXLGjF93jn1Hw1g4cJeBxX4JHStCSEKwEHK9pINTV3Nw4ABovgeCeU8kNVGeatiFqU3bndGaFHCxRT0+3ezB22mEeMwhTc8G6HlzV5eJF4rTo9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496759; c=relaxed/simple;
	bh=JtArep7jUM58TiSOVXof8PVKhCUKPEOjmOVjh35jmdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/cU5h7aSCvL/NEJkeBMtrMci+mcyeJHK1ph9koBkkuYigekSZbsmcggytAeoo90oSYt0E4Xc8qKUt0toxpbaV9m3HYWJLnH9BLQERWHFdie6H0LzWVB72IODuBUbx2oLcrPYIylUB1XoNyE1ej0Br+36R0dg05JtKG26dHtnNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0AM2VxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0AM2VxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52333C16AAE;
	Thu, 15 Jan 2026 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496759;
	bh=JtArep7jUM58TiSOVXof8PVKhCUKPEOjmOVjh35jmdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0AM2VxJbXBRVhEMIfsWuW6OTXy49EBFRFFZfLxEDgKSaNtwB+Aqueww+ndRLJXM1
	 6USH+3i60sukjne/sk9NOnNW/5ZFH6mEZHhUjp6INvJx55wHDw8PoQijLZQgew3Iij
	 mhCrXzJwli0t13Celo63eY7aCx1gREnkhofqTEEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/119] spi: mt65xx: Use IRQF_ONESHOT with threaded IRQ
Date: Thu, 15 Jan 2026 17:48:43 +0100
Message-ID: <20260115164155.849566108@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 8c04b77f87e6e321ae6acd28ce1de5553916153f ]

This driver is migrated to use threaded IRQ since commit 5972eb05ca32
("spi: spi-mt65xx: Use threaded interrupt for non-SPIMEM transfer"), and
we almost always want to disable the interrupt line to avoid excess
interrupts while the threaded handler is processing SPI transfer.
Use IRQF_ONESHOT for that purpose.

In practice, we see MediaTek devices show SPI transfer timeout errors
when communicating with ChromeOS EC in certain scenarios, and with
IRQF_ONESHOT, the issue goes away.

Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://patch.msgid.link/20251217101131.1975131-1-fshao@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index dfee244fc3173..5532ace0b1334 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1266,7 +1266,7 @@ static int mtk_spi_probe(struct platform_device *pdev)
 
 	ret = devm_request_threaded_irq(dev, irq, mtk_spi_interrupt,
 					mtk_spi_interrupt_thread,
-					IRQF_TRIGGER_NONE, dev_name(dev), host);
+					IRQF_ONESHOT, dev_name(dev), host);
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to register irq\n");
 
-- 
2.51.0



