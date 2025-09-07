Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F29315D54;
	Sun,  7 Sep 2025 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277343; cv=none; b=jL+l1+BOg1D0XaPSHd5BAySztP1cepjvRoio+5wCJtpthUfwXL7CoD4vt7pukoCBSLTXA/NexFuH34NMIrDyA3+tE36Ch60Mujk3F41W4uEQqRxPA2qMIxIIN4Y2dsHntYQ+gtdyKWEr8LP7OCTUsXl7bBIq7ulbEKjrj3BBAk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277343; c=relaxed/simple;
	bh=gp5GQWy4jD2+fgtHFH3N/NfXeAZWLRNMVWbN05r+1+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAoHBY6vwU6B2JlywXFLRuhVyE5FMqPFhxsRB/yv8t0LO6pR4DAckXdMWV4r5egfzOQsOzWepvxxb8taLOl9oQGUufG8q/ZMsnkRJj9s5ZnIS6eFIt7GBJeKClDBDge8yDVLuj9EzYwPJsjZ2rnMrHsq6lK7BtoBJ6v60ZrmfAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA5iC9rW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA5iC9rW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6A3C4CEF0;
	Sun,  7 Sep 2025 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277343;
	bh=gp5GQWy4jD2+fgtHFH3N/NfXeAZWLRNMVWbN05r+1+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VA5iC9rWuQdkqirhwN4R8ohcvVogPIRSxh0um7v62P9WvRtrACc2+JPJgzprWHWwO
	 tKwBMW8OVooMEtLEvev928XhLrn4wbxNpHamWRXedxePkMC9HRj/WMvE/ARXNQco7t
	 pv3ycw5mAFyphRsrlg+SiRGpsgQ5GcHzST3aXQBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	Ciprian Marian Costea <ciprianmarian.costea@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/175] spi: spi-fsl-lpspi: Clear status register after disabling the module
Date: Sun,  7 Sep 2025 21:59:15 +0200
Message-ID: <20250907195618.643224870@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit dedf9c93dece441e9a0a4836458bc93677008ddd ]

Clear the error flags after disabling the module to avoid the case when
a flag is set again between flag clear and module disable. And use
SR_CLEAR_MASK to replace hardcoded value for improved readability.

Although fsl_lpspi_reset() was only introduced in commit a15dc3d657fa
("spi: lpspi: Fix CLK pin becomes low before one transfer"), the
original driver only reset SR in the interrupt handler, making it
vulnerable to the same issue. Therefore the fixes commit is set at the
introduction of the driver.

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: Ciprian Marian Costea <ciprianmarian.costea@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-4-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 2843b559e9413..5e96913fd9466 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -83,6 +83,8 @@
 #define TCR_RXMSK	BIT(19)
 #define TCR_TXMSK	BIT(18)
 
+#define SR_CLEAR_MASK	GENMASK(13, 8)
+
 struct fsl_lpspi_devtype_data {
 	u8 prescale_max;
 };
@@ -532,14 +534,13 @@ static int fsl_lpspi_reset(struct fsl_lpspi_data *fsl_lpspi)
 		fsl_lpspi_intctrl(fsl_lpspi, 0);
 	}
 
-	/* W1C for all flags in SR */
-	temp = 0x3F << 8;
-	writel(temp, fsl_lpspi->base + IMX7ULP_SR);
-
 	/* Clear FIFO and disable module */
 	temp = CR_RRF | CR_RTF;
 	writel(temp, fsl_lpspi->base + IMX7ULP_CR);
 
+	/* W1C for all flags in SR */
+	writel(SR_CLEAR_MASK, fsl_lpspi->base + IMX7ULP_SR);
+
 	return 0;
 }
 
-- 
2.51.0



