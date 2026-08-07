Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545443F888A;
	Fri,  7 Aug 2026 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116604; cv=none; b=u7Hh4NQxxtEWLi8HNroVfzkETVnsGA6K1sJd4ooFi+T2xZU6dMICHpfPRxKz9DlGEBmceqtHNfKBDVDpXcbUPFXk2Wkr4moSe/V4TfmFruPho38Apc6RKBhCOGFzk0WsIM5PnembveUL+WCc7PCDfTlkJugNWRmtm/Eyl3nErYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116604; c=relaxed/simple;
	bh=iMpEmEqVefV8B7KBITpCMsV/M7MazKGFWCUMJoW0ct8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9CeumnGihMlX3KbDbmuHk7lh40yzYjjsnpeCh9ojNu3bKOFMZ04lcTonP1uHkzJ/SOCeNCaEfB9mTtDaxoQROqCuuRAobrrGIgbtaFN4gcmH0Ludb+AD3MnvPcr95uYmkViNj5o/KjU6BVrQerEVIiU3e+xwhudj1X+JOSUnrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dkywc/+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dkywc/+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00681F00A3A;
	Fri,  7 Aug 2026 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116603;
	bh=umJ9VxLB7vvqpzBDobS+1O1L0IECyCQkH3Ri+d8FOFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dkywc/+AYTxYnN4r0DihWG9koDRpt59Q685V6QvkITVTwuRMHG2FDhS4sPNlrZRK1
	 hB6CXTfX9BhAmcqczr5JAQHeWN2Mon5HuLxlkHTTpe0iNrPJrHOGWe2zHVKOL4SHxL
	 HGDVr3QmYp8ADaR3K4WIzqpa0JJ6/z79ASC5oQRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 019/438] ata: sata_mv: accept 1 or 2 resources in platform probe
Date: Fri,  7 Aug 2026 16:33:35 +0200
Message-ID: <20260807143428.420582846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ef19a9cf037957fe3a35df8355c76ff0a63a0436 ]

Board files in arch/arm/plat-orion, arch/arm/mach-dove,
arch/arm/mach-mv78xx0 and arch/arm/mach-orion5x still register the
"sata_mv" device with two resources (IORESOURCE_MEM plus IORESOURCE_IRQ).
Those devices are rejected with -EINVAL, so SATA no longer probes on
legacy Marvell Orion/Kirkwood-style boards.

Accept both 1 resource (DT, IRQ fetched via platform_get_irq()) and 2
resources (legacy, IRQ supplied as a second resource) so both probing
paths work.

Fixes: b3b2bec9646e ("ata: sata_mv: Fixes expected number of resources now IRQs are gone")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index ffb396f61731f..1d8ca95fb7328 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4026,7 +4026,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	/*
 	 * Simple resource validation ..
 	 */
-	if (unlikely(pdev->num_resources != 1)) {
+	if (unlikely(pdev->num_resources != 1 && pdev->num_resources != 2)) {
 		dev_err(&pdev->dev, "invalid number of resources\n");
 		return -EINVAL;
 	}
-- 
2.53.0



