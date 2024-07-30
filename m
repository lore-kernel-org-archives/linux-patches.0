Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C251A6192;
	Tue, 30 Jul 2024 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359036; cv=none; b=GJ9gNJOwn36FKEOrNhKJYh3Ls7d6/4O1azgKC5+K3n/zkG05FezLzs8t28xMddP0k+L8FGSJugvoFNo8vM0j2KYh/bQRzU4bd00ijjkX2P9SDNOxo0J0ntX+LthLZx5PucgCT/aWcOTfoHYcBdJfkz/HIcdaCm7B8YNWvil7lb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359036; c=relaxed/simple;
	bh=JZIgFAjle1PLMTlOpGfh1OTGk2dyDQCK/i1S79sxryw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWz9+CtHCeKdQJzX9fgq63/CPRvI1xgjOGU87r8tO+qEedszSP+azRu9L+WLRdDuHacwpMU6m8o0qr2wQHxzxhcoXRUGyQYLSJP9EQIB+pDhRgNWifNIjyVN1cuXUACfuvUk6+v+WQbGbMsn+/WukuJnG/T8yzEJGzbFKM09X0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOJ/8C48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOJ/8C48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517BDC32782;
	Tue, 30 Jul 2024 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359035;
	bh=JZIgFAjle1PLMTlOpGfh1OTGk2dyDQCK/i1S79sxryw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOJ/8C48bXz5B0f4icm3ib7YtdPcCFcrTfJsB5dT6JiGduw8J79thSKHZZ4GQjG61
	 OU44zm8+l0hx1N29erjupLfRFDml+BH6Lzj48PzwNgKAE6g+jmY4Qxlj0CIL/YnOir
	 TdMhZRQmWAFAlucuOvLY3TZI7EiIo4HnKYPocVrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 423/568] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:48:50 +0200
Message-ID: <20240730151656.400405647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -143,8 +143,10 @@ static int __init amd_rng_mod_init(void)
 
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
-	if (err)
+	if (err) {
+		err = pcibios_err_to_errno(err);
 		goto put_dev;
+	}
 
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0) {


