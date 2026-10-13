Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CBF3AE18C;
	Tue, 13 Oct 2026 11:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892552; cv=none; b=OxS4fPDFo004xlUHLOqokSTsPUGKvKwmO6WOKeubUMFj5YTHnvYFgPKYZqS+dxPQcW4iq7PsiR0fic/QEaR0CpZmqABGk5hNyfyZ5abSpTXPejLVKA7ZJ+DlTmEbmYIdOYGlOwI7RX6h8CBqr3GuTVOGNYh/VVcqegTn43kZWq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892552; c=relaxed/simple;
	bh=F4Ez+Sc1YCYvFvZDjC9tlF5i2tdORD+HPzBFOH3Eaic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tkr0/mndOiGnGZM2gosbazfaN69i+/XjNjQuL2+02vp7sowZODAJvjQnNqftrwnZX+ifekCYr2dQKgNxISNVQAi450pyfNvxtqBwGyx9pzprkEE8ISnqHNEMvT62DX485IoZWUeUqtmbECP7aF8PSwgo8nocf6ktJS4HDcVncOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfVprF68; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfVprF68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BA91F000FF;
	Tue, 13 Oct 2026 11:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892551;
	bh=V3Y4uP013iYM/v4anDdtEluF4iHkAR2jAAdfVBHQqro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfVprF682LP65aKeXjB1tqMk0NMRrhB8jt8rS0Rf58zN0Z1smJG9aiHbfqkiIW+kj
	 mlrfwCzQHFt7vHZ7IsqI4d7SimRjLCQd5pqt3Bns9wAvElisrjGS5eszLViuCJqRop
	 cvqMsUiihkwgHEGobpnAOmnZwDub1GX0KDLlEMa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 209/281] spi: spi-nxp-fspi: exit stop mode before waiting for DLL lock
Date: Tue, 13 Oct 2026 13:38:45 +0200
Message-ID: <20261013112900.234358702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 94b6df050433875f493fb8298b58d7b0dc32eb9c ]

For 8D-8D-8D (octal DTR) mode the FlexSPI samples read data using
MCR0[RXCLKSRC] = 3 (flash-memory-provided read strobe on the DQS pad),
which requires the DLL to be locked. Per the i.MX95 Reference Manual
(FlexSPI chapter, "DLL configuration for sampling"), when the serial
root clock is above 100 MHz the DLL is enabled (DLLxCR[DLLEN] = 1,
OVRDEN = 0) and software must then wait for STS2[xREFLOCK] and
STS2[xSLVLOCK] to be asserted before starting a read or write. This DLL
lock is relative to the serial root clock.

While the module is in stop mode (MCR0[MDIS] = 1) the AHB and serial
clocks are gated off internally, so the serial root clock the DLL locks
against is not running. nxp_fspi_dll_calibration() both programs DLLxCR
and then polls STS2 for lock. When it runs entirely in stop mode the
STS2 REF/SLV lock bits never assert (observed as "DLL lock failed" with
STS2 = 0).

The MCR0 bit fields (RXCLKSRC) and the serial root clock rate still have
to be reconfigured in stop mode, so keep entering stop mode around that.
Only move the exit from stop mode (clearing MCR0[MDIS]) ahead of the DLL
calibration/override step, so that the serial root clock is running when
the DLL is calibrated and STS2 can report lock.

Fixes: b4bde5cfff8e ("spi: spi-nxp-fspi: enter stop mode before reconfiguring MCR0 and DLL")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20260928-fspi-fix-v1-1-a0f9288cd5c8@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 4425132432ec8..e0c88e9f81833 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -898,10 +898,10 @@ static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	dev_dbg(f->dev, "Target device [CS:%x] selected\n", spi_get_chipselect(spi, 0));
 
 	/*
-	 * Per the FlexSPI reference manual (initialization sequence), MCR0 and
-	 * the DLL control registers should be configured while the module is in
-	 * stop mode (MCR0[MDIS] = 1). Enter stop mode before reconfiguring the
-	 * RX sample clock source and the DLL, then exit stop mode afterwards.
+	 * Per the FlexSPI reference manual (initialization sequence), MCR0
+	 * should be configured while the module is in stop mode (MCR0[MDIS] = 1).
+	 * Enter stop mode before reconfiguring the RX sample clock source, then
+	 * exit stop mode afterwards.
 	 */
 	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
 	fspi_writel(f, reg | FSPI_MCR0_MDIS, f->iobase + FSPI_MCR0);
@@ -936,6 +936,16 @@ static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	if (ret)
 		return ret;
 
+	/*
+	 * Exit stop mode before running the DLL calibration. The DLL
+	 * reference clock is derived from the module clock domain, which is
+	 * gated while MCR0[MDIS] = 1. Calibrating the DLL in stop mode leaves
+	 * the STS2 lock bits stuck at 0 (the DLL never runs), so clear MDIS
+	 * first and let the module and reference clock run.
+	 */
+	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
+	fspi_writel(f, reg & ~FSPI_MCR0_MDIS, f->iobase + FSPI_MCR0);
+
 	/*
 	 * If clock rate > 100MHz, then switch from DLL override mode to
 	 * DLL calibration mode.
@@ -945,10 +955,6 @@ static int nxp_fspi_select_mem(struct nxp_fspi *f, struct spi_device *spi,
 	else
 		nxp_fspi_dll_override(f);
 
-	/* Exit stop mode now that MCR0 and the DLL have been reconfigured. */
-	reg = fspi_readl(f, f->iobase + FSPI_MCR0);
-	fspi_writel(f, reg & ~FSPI_MCR0_MDIS, f->iobase + FSPI_MCR0);
-
 	f->pre_op_rate = op->max_freq;
 
 	f->selected = spi_get_chipselect(spi, 0);
-- 
2.53.0



