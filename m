Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889391D0BA8;
	Wed,  2 Oct 2024 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880123; cv=none; b=gXkls14A+Z44V/Ni2c+9a/jGODwyJqnzI1G4G5szra2xRx/2Gpo7DVK3p91uwRwpN7/R0ErPACfzTxbbTL+MBGDzkI988CIWw0qse+IFAgRnmaSclQ7uRGS/x/yClOgyZU1JhACyEG9hkdcMQIBkBYlYkQ4D+7Da6KjzKxOqE68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880123; c=relaxed/simple;
	bh=UZyjfefq6mHRpDx7xfBjYwIrDuEKN3CgF0St63LJnZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjdzxruHON8RQRrQoyR99AwP5GupSljVL3UMXQG9SdHMVbUo+HXINQByfM/F827zTZpfauQ/QAegcl5rbngcIKX2oRZFxW26MK4+8heQ3kiQZuXouktvlUl8fEFZoUXO2JwIHnXiiIXCng2U2kdKlZdNC/WEbj54yBEL43f+Tn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdwE8P/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdwE8P/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1DBC4CECE;
	Wed,  2 Oct 2024 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880123;
	bh=UZyjfefq6mHRpDx7xfBjYwIrDuEKN3CgF0St63LJnZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdwE8P/2pyuWCEIeI7hwFRAbea3C6IVWOlAby5LTgimhSKiaSgR8rMx9fTbZ7hWvK
	 w1J0qRLBSTbXJ2HZrtIRqyTIZvF/DLjVzddcCrtCbJJmtJNW+9mBnYHKQuAdNOlidr
	 5sh3jFlctTITk0WMOj41dR6HWE1eF1yOQbkrNqT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/538] spi: atmel-quadspi: Avoid overwriting delay register settings
Date: Wed,  2 Oct 2024 14:59:50 +0200
Message-ID: <20241002125806.283289301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

[ Upstream commit 329ca3eed4a9a161515a8714be6ba182321385c7 ]

Previously the MR and SCR registers were just set with the supposedly
required values, from cached register values (cached reg content
initialized to zero).

All parts fixed here did not consider the current register (cache)
content, which would make future support of cs_setup, cs_hold, and
cs_inactive impossible.

Setting SCBR in atmel_qspi_setup() erases a possible DLYBS setting from
atmel_qspi_set_cs_timing().  The DLYBS setting is applied by ORing over
the current setting, without resetting the bits first.  All writes to MR
did not consider possible settings of DLYCS and DLYBCT.

Signed-off-by: Alexander Dahl <ada@thorsis.com>
Fixes: f732646d0ccd ("spi: atmel-quadspi: Add support for configuring CS timing")
Link: https://patch.msgid.link/20240918082744.379610-2-ada@thorsis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index af0464999af1f..bf7999ac22c80 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -375,9 +375,9 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
 	 * If the QSPI controller is set in regular SPI mode, set it in
 	 * Serial Memory Mode (SMM).
 	 */
-	if (aq->mr != QSPI_MR_SMM) {
-		atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
-		aq->mr = QSPI_MR_SMM;
+	if (!(aq->mr & QSPI_MR_SMM)) {
+		aq->mr |= QSPI_MR_SMM;
+		atmel_qspi_write(aq->scr, aq, QSPI_MR);
 	}
 
 	/* Clear pending interrupts */
@@ -501,7 +501,8 @@ static int atmel_qspi_setup(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	aq->scr = QSPI_SCR_SCBR(scbr);
+	aq->scr &= ~QSPI_SCR_SCBR_MASK;
+	aq->scr |= QSPI_SCR_SCBR(scbr);
 	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
 
 	pm_runtime_mark_last_busy(ctrl->dev.parent);
@@ -534,6 +535,7 @@ static int atmel_qspi_set_cs_timing(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
+	aq->scr &= ~QSPI_SCR_DLYBS_MASK;
 	aq->scr |= QSPI_SCR_DLYBS(cs_setup);
 	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
 
@@ -549,8 +551,8 @@ static void atmel_qspi_init(struct atmel_qspi *aq)
 	atmel_qspi_write(QSPI_CR_SWRST, aq, QSPI_CR);
 
 	/* Set the QSPI controller by default in Serial Memory Mode */
-	atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
-	aq->mr = QSPI_MR_SMM;
+	aq->mr |= QSPI_MR_SMM;
+	atmel_qspi_write(aq->mr, aq, QSPI_MR);
 
 	/* Enable the QSPI controller */
 	atmel_qspi_write(QSPI_CR_QSPIEN, aq, QSPI_CR);
-- 
2.43.0



