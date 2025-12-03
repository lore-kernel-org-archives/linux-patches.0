Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE84308F1C;
	Wed,  3 Dec 2025 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776647; cv=none; b=rARK7UOLadYqqbzG2oMuGWOtnflDtBgM+cVMH4Ik4BUtAKA9ys9mTVe/ACg6hnDVg6Mbkco2+IPNQVsnkHxMdjJ1G4aqh3TUX11RCbDqJuY8GsFKXmDcrT01K14kot8Shmpbg/2Gz6JVEPn+pxhpDhW9RmE4DkQSihEkeWir2xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776647; c=relaxed/simple;
	bh=ofkhEjE7ewjU+pWUGQAJZKqTX2tXaQehQgGjUZf1G5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHxwrQ5UrhyTkkXwcwQiM1YsgXnAny3Kw9DxCCnrB8C+PsxdKSwAQLIdEwaMUeUQWYANA3zX0w7WXZnVCuy0Dh4cZsqvYG7sSg7qCriL1Mory27vO7k1FZZN27wIk4SEvbUimdl90VdSiPGvu8g5kWgoMLn459Gshusn2sLzOjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2luO5gMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2luO5gMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E034AC4CEF5;
	Wed,  3 Dec 2025 15:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776647;
	bh=ofkhEjE7ewjU+pWUGQAJZKqTX2tXaQehQgGjUZf1G5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2luO5gMs/vXEcM8r/hj1Yincw8v/NQo2J7PaRXyxqcDaLveoU21DnB+pdACJ6fJA6
	 /2INiRIGsI4cuW9y614w8wkSYTi4xJXyzCs+xGS7yUL5NapiGpWmqz3WLqHGXbD1Tf
	 i79Dt6VBuZZyQks31jiqX8yM8ktZl6H77//vSZL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 212/300] EDAC/altera: Handle OCRAM ECC enable after warm reset
Date: Wed,  3 Dec 2025 16:26:56 +0100
Message-ID: <20251203152408.476750650@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1147,10 +1147,22 @@ altr_check_ocram_deps_init(struct altr_e
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


