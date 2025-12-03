Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF88326CE39;
	Wed,  3 Dec 2025 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779948; cv=none; b=oTj+Y4xELRf+EXaLS1ksQwyV7dedvtyc3Gp0t9qmeTC8qpExtp+IyEeBirlaoKDIg8K7GObxaRXOjQ+xYPv9zk/MfpxlDrYz+/qJyPF24LitpbcoAsczEmo0GmgzahSaElkI+4kEb90EEcZ2ISv+93W27cKfdM7yyiu+XE/yJ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779948; c=relaxed/simple;
	bh=FXz3J7H0G2zE/IASUgA75ePYpckdV5KWfg09LEqDBZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTmVwLxbQRWWtgk4h0GlNijJ8tCoyqTl4iI+5hhP6A2+zH6koC4XSqoXUpkGBUFlZ2fEVQ35ShZNtoDGCusjHnLpVg5gZYC4XCGo8TyQpKrfuebmCsU9mmhrkIlpS7nsBosT2haBR8frCoBFL6vP1IV4wpS9v+KY4ExeEraqZag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyahnBnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyahnBnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA81C4CEF5;
	Wed,  3 Dec 2025 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779948;
	bh=FXz3J7H0G2zE/IASUgA75ePYpckdV5KWfg09LEqDBZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyahnBnO5g31C7KshdRVhbOIB9xJTsHWffPZk9oeK7VHmqOt0FP/hWwr/y+rVLBWA
	 bR0zoSva1GCAbIq67iGGpKZysnsQhGuzcv4j1H1pwMphMq6CFou/5rh8bzCEKbxEF2
	 rIZstMJbWOqoMXobGWoexzVzSjRlmXUIPL9Ie7G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.1 410/568] EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection
Date: Wed,  3 Dec 2025 16:26:52 +0100
Message-ID: <20251203152455.703602307@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>

commit 281326be67252ac5794d1383f67526606b1d6b13 upstream.

The current single-bit error injection mechanism flips bits directly in ECC RAM
by performing write and read operations. When the ECC RAM is actively used by
the Ethernet or USB controller, this approach sometimes trigger a false
double-bit error.

Switch both Ethernet and USB EDAC devices to use the INTTEST register
(altr_edac_a10_device_inject_fops) for single-bit error injection, similar to
the existing double-bit error injection method.

Fixes: 064acbd4f4ab ("EDAC, altera: Add Stratix10 peripheral support")
Signed-off-by: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251111081333.1279635-1-niravkumarlaxmidas.rabara@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1379,7 +1379,7 @@ static const struct edac_device_prv_data
 	.ue_set_mask = ALTR_A10_ECC_TDERRA,
 	.set_err_ofst = ALTR_A10_ECC_INTTEST_OFST,
 	.ecc_irq_handler = altr_edac_a10_ecc_irq,
-	.inject_fops = &altr_edac_a10_device_inject2_fops,
+	.inject_fops = &altr_edac_a10_device_inject_fops,
 };
 
 #endif	/* CONFIG_EDAC_ALTERA_ETHERNET */
@@ -1469,7 +1469,7 @@ static const struct edac_device_prv_data
 	.ue_set_mask = ALTR_A10_ECC_TDERRA,
 	.set_err_ofst = ALTR_A10_ECC_INTTEST_OFST,
 	.ecc_irq_handler = altr_edac_a10_ecc_irq,
-	.inject_fops = &altr_edac_a10_device_inject2_fops,
+	.inject_fops = &altr_edac_a10_device_inject_fops,
 };
 
 #endif	/* CONFIG_EDAC_ALTERA_USB */


