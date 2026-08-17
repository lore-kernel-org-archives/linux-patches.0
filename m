Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891A3EC83A;
	Mon, 17 Aug 2026 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980162; cv=none; b=VienUMo+JwxOQ/QoxvVXDNdX1I2I7FdzuH78r8VmjjD+7dyS+ydXQ15NwzKMnMN//rYbTmaHQCpLTURnLm20wul+MJqhZU2ixPZdD+0p7q6M3ekb6ZFlUCxhOU9QFvlV+GQXdUdhtzQICkwYTGxKYOXdbdhMgcRns55KgfrUnuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980162; c=relaxed/simple;
	bh=A3KUNPd7wOdxHq07GyEFJo/veWtJ8M2In/DBofevjzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hk+Yeq3S/scdCS79ZafgOnu+YM3nBDvBxu1HX+laVXBzi5Hkp908w+HoCF62qSCdjSe84kyxv+y7MDUq1+mjHdOCgjtvVafkKAxcExhS05xchocNMmpPbByxJvTQBm6HkTsyCLvEhPm+mOxfKolq5bEoYTtP40dAhwM5fRHzvSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qzqkf8/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qzqkf8/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9921F000E9;
	Mon, 17 Aug 2026 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980161;
	bh=vQkzweJ3YuV/qOD0U1Az8azVT5Rz+ZMfboJ1+STUFp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qzqkf8/Ba4rhTs31M0C1UOH5dA+GOtXCGwjao9knSuiaX3j8tcJDjrYh/xTPEzV/Q
	 oxeeHQ4Ck7rT0PewHasWwsHRKySJPDX+IBdbkkuQqkvXVp3F8q72+/k0nG45FCuU91
	 jDgeyAL53V8IoEmqCLwgaDbxg5mlbcAyeikYRk7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Josua Mayer <josua@solid-run.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.1 476/609] ata: libahci_platform: Do not set mask_port_map when not needed
Date: Mon, 17 Aug 2026 15:32:52 +0200
Message-ID: <20260817132559.885094025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 2c202e6c4f4dd19d2e8c1dfac9df05170aa3934f upstream.

Commit 8c87215dd3a2 ("ata: libahci_platform: support non-consecutive
port numbers") modified ahci_platform_get_resources() to allow
identifying the ports of a controller that are defined as child nodes of
the controller node in order to support non-consecutive port numbers (as
defined by the platform device tree).

However, this commit also erroneously sets bit 0 of
hpriv->mask_port_map when the platform devices tree does not define port
child nodes, to match the fact that the temporary default number of
ports used in that case is 1 (which is also consistent with the fact
that only index 0 of hpriv->phys[] is initialized with the call to
ahci_platform_get_phy(). But doing so causes ahci_platform_init_host()
to initialize and probe only the first port, even if this function
determines that the controller has in fact multiple ports using the
capability register of the controller (through a call to
ahci_nr_ports()). This can be seen with the ahci_mvebu driver (Armada
385 SoC) with the second port declared as "dummy":

ahci-mvebu f10a8000.sata: masking port_map 0x3 -> 0x1
ahci-mvebu f10a8000.sata: AHCI vers 0001.0000, 32 command slots, 6 Gbps, platform mode
ahci-mvebu f10a8000.sata: 1/2 ports implemented (port mask 0x1)
ahci-mvebu f10a8000.sata: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs
scsi host0: ahci-mvebu
scsi host1: ahci-mvebu
ata1: SATA max UDMA/133 mmio [mem 0xf10a8000-0xf10a9fff] port 0x100 irq 40 lpm-pol 0
ata2: DUMMY

Fix this issue by removing setting bit 0 of hpriv->mask_port_map when
the platform device tree does not define port child nodes.

Reported-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Fixes: 8c87215dd3a2 ("ata: libahci_platform: support non-consecutive port numbers")
Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Josua Mayer <josua@solid-run.com>
Link: https://lore.kernel.org/r/20250207232915.1439174-1-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libahci_platform.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -659,8 +659,6 @@ struct ahci_host_priv *ahci_platform_get
 		 * If no sub-node was found, keep this for device tree
 		 * compatibility
 		 */
-		hpriv->mask_port_map |= BIT(0);
-
 		rc = ahci_platform_get_phy(hpriv, 0, dev, dev->of_node);
 		if (rc)
 			goto err_out;


