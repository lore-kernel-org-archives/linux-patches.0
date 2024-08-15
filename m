Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C4863D5;
	Thu, 15 Aug 2024 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732445; cv=none; b=jnOGFOMeG7Uchl/cn7t9390QAlxyGfSuXbwCp6nQ4s/InotUx57k0fBASdlX6vCnDTMMPCyQw47aMwreB4KxgZ5ISoQSRIsnYZyydJsD49m7U/5h6ERUmNJIe/H6gPSWGtqAKtziosC5RQ+QPhIO9rzpRMC6p1uODvZ41b8Y7u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732445; c=relaxed/simple;
	bh=PjGMRq7+1RF8dKlZFbZyYtDQer8NAjXBPPAkfJZDlSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RHVYK8TJl/d167COM61WaGW07p+Ih0DxnbhyHwsVXbuEw3mqPGLog/ND+4EWYivimz/hXVWOZWGmQunhkSQURjL/uZEVU+VfjaEQZ/09ZNfEk5mNf8RCyV7eee7kACgkU7TDpg6A2Oa31Qlh6snq//XF+gro7KEfJDV1hZCZVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMfJDCfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMfJDCfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA28C4AF0D;
	Thu, 15 Aug 2024 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732444;
	bh=PjGMRq7+1RF8dKlZFbZyYtDQer8NAjXBPPAkfJZDlSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMfJDCfK+m+3jTIPEbiBC8K7TtAHfzo20UGOxo+aVBJYofqhGakQcv3N5otM7gCdA
	 9eXoDgmGiB1s/AJmxYpYGOvhJ9t4Ugjmw9JXJFLoKCFppyjJWh//tUqkXYfXKiNCaA
	 0ghBmXVSp6a5ULgJYW8mOEQAClqHvfXAjN8MP9/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 151/352] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:23:37 +0200
Message-ID: <20240815131925.102077545@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -142,8 +142,10 @@ static int __init mod_init(void)
 
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
-	if (err)
+	if (err) {
+		err = pcibios_err_to_errno(err);
 		goto put_dev;
+	}
 
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0) {


