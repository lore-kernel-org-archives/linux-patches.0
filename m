Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AAA481DD;
	Wed,  5 Mar 2025 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197260; cv=none; b=Mo8ZFFZ/7tXSRrACCvceQ/8uUtOIYvuqlAjOtFeXrZ+o44sD2Y/3g/rYqLu3UCNpIgKUnpYr1Cbrv7JSHBjHZSK4M+pZSh3xZKvCx7fP4e/WnrI/CyXIwa4YATN1fJLTtU5Aa/Qq6JH6xhtr1mBjqfy/YUKpnjAQ3NE+9Hu5z1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197260; c=relaxed/simple;
	bh=wpCcKskK2Eg5uIpRf6fgqYVdTBTQFzMECqSMkXVzarY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqcqvyQ7M02/d9AZE3mk5bTMrW9wFhk02CsKa6X63q9A2Amc56wTvgq0cXZbN0nrFZul2KnQFkSGbE/VNvSFsfbjmiNsvdK8vyvBhDsvrWO4JGmGqifzI5lAA0x4T2cpnTIPz2qkq84b/Ro/RJRv7T0AIIMMOh0BuL41BtGc6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkzTS/dW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkzTS/dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A43CC4CED1;
	Wed,  5 Mar 2025 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197259;
	bh=wpCcKskK2Eg5uIpRf6fgqYVdTBTQFzMECqSMkXVzarY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkzTS/dWUl09FcWtcULg5jdJgn5mtYfBzSaGwsIgM+PXI+id1KmUhIEQmI+mfldYG
	 8vOtsxLf8OopH2abEvpgRI6Cbl9E1WXhINNHxYTuYTlOljSmRyk6GNrdbw1Hj/6vP6
	 borhcVb0CA+MgaubVwmkFUzIoT0ihXoq4Bc542BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 094/176] spi: atmel-quadspi: Avoid overwriting delay register settings
Date: Wed,  5 Mar 2025 18:47:43 +0100
Message-ID: <20250305174509.237426779@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

commit 329ca3eed4a9a161515a8714be6ba182321385c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/atmel-quadspi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -388,9 +388,9 @@ static int atmel_qspi_set_cfg(struct atm
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
@@ -545,7 +545,8 @@ static int atmel_qspi_setup(struct spi_d
 	if (ret < 0)
 		return ret;
 
-	aq->scr = QSPI_SCR_SCBR(scbr);
+	aq->scr &= ~QSPI_SCR_SCBR_MASK;
+	aq->scr |= QSPI_SCR_SCBR(scbr);
 	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
 
 	pm_runtime_mark_last_busy(ctrl->dev.parent);
@@ -578,6 +579,7 @@ static int atmel_qspi_set_cs_timing(stru
 	if (ret < 0)
 		return ret;
 
+	aq->scr &= ~QSPI_SCR_DLYBS_MASK;
 	aq->scr |= QSPI_SCR_DLYBS(cs_setup);
 	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
 
@@ -593,8 +595,8 @@ static void atmel_qspi_init(struct atmel
 	atmel_qspi_write(QSPI_CR_SWRST, aq, QSPI_CR);
 
 	/* Set the QSPI controller by default in Serial Memory Mode */
-	atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
-	aq->mr = QSPI_MR_SMM;
+	aq->mr |= QSPI_MR_SMM;
+	atmel_qspi_write(aq->mr, aq, QSPI_MR);
 
 	/* Enable the QSPI controller */
 	atmel_qspi_write(QSPI_CR_QSPIEN, aq, QSPI_CR);


