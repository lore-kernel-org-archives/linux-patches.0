Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05601552E7;
	Tue, 30 Jul 2024 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357812; cv=none; b=H22N8toLiD0QWndoVebTKWfFrd5i9VGbkuScSEx9cd477pThrL2WCCk9wFKW0UOLQVUyA+PU5XySGajAQnAppko+utMI/W2BW8BFxDP0E5m6IX/PFl8/4jIALT09epU7xIGpLc3SpjD96wuevCeEfpxRhanuTCBtdZAh07Xa5RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357812; c=relaxed/simple;
	bh=zmvU5tnUxy204EleOlGCEkI1rLhH0idM0ZozTBvnxb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9l/hnqtCsdBnQXwPaqpclaHONShtFp7sZGGXOSz1k3Bg1XwRSFjr4ZGI+SJk825GstjiRcXvab+BogblZcd/HkqWwrLyVZSiPksClzjJmdyt1npIAldfuqonSGmAslYzYvms/TlFPLSv4BPOpOAy1sTtzJ5XuzF8QSodjuPylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PF8uoWgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PF8uoWgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C09C4AF0E;
	Tue, 30 Jul 2024 16:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357812;
	bh=zmvU5tnUxy204EleOlGCEkI1rLhH0idM0ZozTBvnxb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PF8uoWgo9w6lvmjKOdykkHZOoFpyvIGg4kPXWCbVNvZrNEX3LpFtZymBUraJK4j8h
	 ibkfAcZGlrU4E/QY/HREARE3fM0tYB7kVciYq710FKS/YW3kznEBzch565Yc2Rdxdh
	 Pd+EJNLDT69W5VlwLC4VjrAVenSKDMv2E2oDTkFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 320/440] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:49:13 +0200
Message-ID: <20240730151628.317699778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 14cba6ace79627a57fb9058582b03f0ed3832390 upstream.

amd_rng_mod_init() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The return code is then returned as is but amd_rng_mod_init() is
a module_init() function that should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning it.

Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/amd-rng.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -142,8 +142,10 @@ static int __init amd_rng_mod_init(void)
 
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
-	if (err)
+	if (err) {
+		err = pcibios_err_to_errno(err);
 		goto put_dev;
+	}
 
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0) {


