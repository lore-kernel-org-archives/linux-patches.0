Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE983274FDC;
	Sat, 30 May 2026 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164919; cv=none; b=uPjZB5Gc16myA3A9T3WocCHjJFMHokqxSdEsc01z0O2RrUT8C8C4kYWHjqjI1v73HLHEmq7cSMvHh8CZkt8jirhW8/ahGNH91ah7DYGnIMAHqp6vNewjgu06Ua3n05y9klW0k86frLR5q1kNVrK3DAa2/EzmoOny4D3aCSrprGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164919; c=relaxed/simple;
	bh=OFNqE33IrSHpwkjTJZeI28w+5b1nobviMnEAY2o0wD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSI2dcw6Gvp0ipyoyCyEMEaDZfXJAW6Bu7LnNfTav7DjZJ6AjMVbWvzraA97kJ2ZlC2D0qMpbxioYevBKO940RKw3hrfuWW22Ez1tW2TcdHIIlhM4clK5vzaZqxlppplQhzxfJTu1/gTtXZxrTBrJouZP0uh1hH4RFL5xjFPMA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1+nUNI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1+nUNI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2A11F00893;
	Sat, 30 May 2026 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164918;
	bh=9/oOi+bjgIwHOQj9H2xaAAOwMvwIhF2BLySS4mHYm4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1+nUNI7YpioZHFc2ryR8fk65agsD0RCbu9Hx5itDnQFuTYbjQkZIlWr28wmvvFEy
	 oD8Pmt9KBz/RM+szf27vkFSoQ0xpEHpnOko7ZtVEg3Rp5Kw/EdVbSO5A+QfyGQPx5o
	 5MpTI+2zSCiKonvQe2mq4guGFeTqwJhpF8/QkDX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lanqing Liu <lanqing.liu@unisoc.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 698/776] spi: sprd: fix error pointer deref after DMA setup failure
Date: Sat, 30 May 2026 18:06:52 +0200
Message-ID: <20260530160257.867983279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3d67fffb74267772d461c02c67f1eff893ad547d upstream.

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to check the dma.enabled flag before trying to release the DMA
channels also on late probe errors to avoid dereferencing an error
pointer (or attempting to release a channel a second time).

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: 386119bc7be9 ("spi: sprd: spi: sprd: Add DMA mode support")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=10
Cc: stable@vger.kernel.org	# 5.1
Cc: Lanqing Liu <lanqing.liu@unisoc.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074733.915029-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sprd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -995,7 +995,8 @@ err_rpm_put:
 disable_clk:
 	clk_disable_unprepare(ss->clk);
 release_dma:
-	sprd_spi_dma_release(ss);
+	if (ss->dma.enable)
+		sprd_spi_dma_release(ss);
 free_controller:
 	spi_controller_put(sctlr);
 


