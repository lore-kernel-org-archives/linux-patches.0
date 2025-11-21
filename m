Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949012DEA7E;
	Fri, 21 Nov 2025 13:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731445; cv=none; b=rfAm9ExX5ZiWTSFDM4WuXk0l8UuI4/F7bPyMHRql11qOJ6GkroKx6pNI7X0UoPSgVasJxo4X3EX2yjh2mCVJoXNt3jHOLvrvPHzX4OEzHtLsR5wf1ZPgLGFYkaQTilPHXgjEgzul5KKwS+R/a7mFWJiLL/M8XA/koM9wAcQmpj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731445; c=relaxed/simple;
	bh=Oh0vZkTrVBAMewCQ1NTgIVdL1tqUHZt83Md9a5kUJyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ0MPDDcIokUJr7fE2+XfRTlnDqe6K9XaxldW4Cfm9r9DDX73VbbsQbHlOJfSWwRyCzE0S4sCC+41qYJoqqoJA6QgJ4xyWv8FBudSLfUqS6wlBQcXQtEd4bkI34UFMm1EdMFnwJiLm5DhjYtCAHp1DnL32udYyW0ffJNC5CupEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TU/pxXeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TU/pxXeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB53C4CEF1;
	Fri, 21 Nov 2025 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731445;
	bh=Oh0vZkTrVBAMewCQ1NTgIVdL1tqUHZt83Md9a5kUJyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TU/pxXeHm+OrKUWJe32YlXzh5b47vmJDI57Epq2N43lXNupiSnd/FhN4XPtmH7AR7
	 SiunIjKGChP1QQtxOvg4MdgcskPOy3wvNy9CnEwPJG7Ss6XX4otoaSeDvVfJOEjIiA
	 /ZCqdLxbrovlEiMQANyelzoP2D6WRH9BDKl+X0Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.17 210/247] EDAC/altera: Handle OCRAM ECC enable after warm reset
Date: Fri, 21 Nov 2025 14:12:37 +0100
Message-ID: <20251121130202.265452913@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>

commit fd3ecda38fe0cb713d167b5477d25f6b350f0514 upstream.

The OCRAM ECC is always enabled either by the BootROM or by the Secure Device
Manager (SDM) during a power-on reset on SoCFPGA.

However, during a warm reset, the OCRAM content is retained to preserve data,
while the control and status registers are reset to their default values. As
a result, ECC must be explicitly re-enabled after a warm reset.

Fixes: 17e47dc6db4f ("EDAC/altera: Add Stratix10 OCRAM ECC support")
Signed-off-by: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251111080801.1279401-1-niravkumarlaxmidas.rabara@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1184,10 +1184,22 @@ altr_check_ocram_deps_init(struct altr_e
 	if (ret)
 		return ret;
 
-	/* Verify OCRAM has been initialized */
+	/*
+	 * Verify that OCRAM has been initialized.
+	 * During a warm reset, OCRAM contents are retained, but the control
+	 * and status registers are reset to their default values. Therefore,
+	 * ECC must be explicitly re-enabled in the control register.
+	 * Error condition: if INITCOMPLETEA is clear and ECC_EN is already set.
+	 */
 	if (!ecc_test_bits(ALTR_A10_ECC_INITCOMPLETEA,
-			   (base + ALTR_A10_ECC_INITSTAT_OFST)))
-		return -ENODEV;
+			   (base + ALTR_A10_ECC_INITSTAT_OFST))) {
+		if (!ecc_test_bits(ALTR_A10_ECC_EN,
+				   (base + ALTR_A10_ECC_CTRL_OFST)))
+			ecc_set_bits(ALTR_A10_ECC_EN,
+				     (base + ALTR_A10_ECC_CTRL_OFST));
+		else
+			return -ENODEV;
+	}
 
 	/* Enable IRQ on Single Bit Error */
 	writel(ALTR_A10_ECC_SERRINTEN, (base + ALTR_A10_ECC_ERRINTENS_OFST));


