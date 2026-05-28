Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2EE26B973;
	Thu, 28 May 2026 19:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998356; cv=none; b=nevSXP5Te7pV81j0Zs+ppR8XXyk4L8qiFCJlAufi5weQurfUIsgo4BXr5I3a/oHhr7dofXojZJ58gGwILpiItzyH2E1NIp/Gdtkqbdg0wGul6mpaaoN773JW/2qxhvwXK8cBe5b79E0IpgMFKhqJT8nQpxEUqlSM2n1kKqNkNRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998356; c=relaxed/simple;
	bh=cywKm4uAPY4hk+eJSXhH/192AISTivzB2mBWPhl8ikM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJ2pOTnUlOGFKBQBs++WB2pnLpNYKuFjp+MkJmABjPDn8jwYy1j1AIEgFj45LmBMCmHBWJ+K2pXQGwl9oP62vbOv4RpVKIaYGKDKbrsBeQf2gGOMh4264XLtVJDYQyFSaXoesnrucp7hehPEpVLuJFCBNoV2cPpCXGKlwrwHavE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WN/KFHXE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WN/KFHXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A821F00A3A;
	Thu, 28 May 2026 19:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998355;
	bh=CBI0GZPdg/c1jFbPVJBUlH02IOxxeRsX2ajJ+YtHpTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WN/KFHXEGqv4D5vMo6b1EcwXx1vIJFyszlb8AXVrHx+AU7gldCOomWtlpd36pqbFt
	 aZsu/b6SZu0prrcOrz1T6gPBtacFzKn1XiVHrM7VAnQ4oKceKmZgHwD18IdztqWIvP
	 DwGZXpz/CmCa9AD+NhtdqzR45xgOLlZp2Rpyunok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lanqing Liu <lanqing.liu@unisoc.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 117/461] spi: sprd: fix error pointer deref after DMA setup failure
Date: Thu, 28 May 2026 21:44:06 +0200
Message-ID: <20260528194650.361384031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
@@ -991,7 +991,8 @@ err_rpm_put:
 disable_clk:
 	clk_disable_unprepare(ss->clk);
 release_dma:
-	sprd_spi_dma_release(ss);
+	if (ss->dma.enable)
+		sprd_spi_dma_release(ss);
 free_controller:
 	spi_controller_put(sctlr);
 


