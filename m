Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD19A351FDD;
	Fri, 21 Nov 2025 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733492; cv=none; b=jBh2f1Z+StWS8MoGXhQwCJLv60zugw1gUtJCcLa/+mGe6hEyeYr+v95gHXAJaX1lLQoL3QxLH/gAmBqmI30ZpXq0WcWFgb16ZAOz//9s+d1SmufhX45ymHqpdbuAAzkdovHcrKDt7Ns6P5yIazJmbwC3saAVV0MSHCMyl0Gc+mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733492; c=relaxed/simple;
	bh=/RzdJITi7Y0NGuGOclJ3zJ32KARFycjx1512NhLW81A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJuqHBeeiDNWkr2cGDyUq9JyJsb+cUhNl5HGfWaRpJg4WgZAIzd+RT4g2gMZ7QcpdA1BK5QKD5jmI5tkrBryrtqRWjb3PomSp+8/DSmu32+KBHI4YJNsihJ4M2KC5wUquvuOZRFm6qpkHji+Nta8piRJj5nI0Jj8A4pS+NeDYsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJQJ0JGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJQJ0JGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED34C4CEF1;
	Fri, 21 Nov 2025 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733492;
	bh=/RzdJITi7Y0NGuGOclJ3zJ32KARFycjx1512NhLW81A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJQJ0JGTix/jfihyfyDjL+S7TpkE4VFdZZHpafz8p0vpQcRiMpa+IKpCd8DAtiIVU
	 TreF6Ze+pOl0Mklkeu4Z1uLOulY22pBSDUI7HQjv60NDefEjGsahGJFJJZmeG3Dxsa
	 Z6xPC0qmDPYN64UKX/R8jDEIVid2VapcgSEqHnTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.6 485/529] EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection
Date: Fri, 21 Nov 2025 14:13:04 +0100
Message-ID: <20251121130248.264388845@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


