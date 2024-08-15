Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5429C1494C5;
	Thu, 15 Aug 2024 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729881; cv=none; b=CMmI2XqBqa+vlJZ7LvPmLoQ7g3zwthsJ/Lhz7CV86BmOJSOHhBErRWgBfYbKhqwj3h1NNAvqU/hvvOZglZVnm6IzWW6zcy4yy/GEYwb1FprUL6/R8fcO9SFl5UlHGLZskQ8yZ+9lE8bDCxEkjeuAXiT43j68snvLaLouSdIMsg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729881; c=relaxed/simple;
	bh=kdctphV77bio/zuUcNYh43DOYTQOBflUCcrdkJMvCzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WNGOiaa4/4nSBa84IDH4dzLlkXjU+fxNnTZV8+guaA8ZFyjSeAKE2rG9+Mox+gNCvfjGDQ2Uh/sW6qMhot5lSQPTgRM00V6E2Y28axzW64v9Sm6/JfgIN+dq72smx/69ARsP8KGAlNQbTQU9F1Rn8cUFHO/MmfMwJHDRGLy3YFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAZEqoGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAZEqoGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E71C4AF0C;
	Thu, 15 Aug 2024 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729881;
	bh=kdctphV77bio/zuUcNYh43DOYTQOBflUCcrdkJMvCzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAZEqoGkO06YCNpgHT99y1MdQX5eAF5iNEaUNNt8/YsNyRb/gGDwbYUMc1oZG94ix
	 wwtlrrom2WmL5ksGuteE8MWQP4ODBpVxo9yTnZe1uo7eyG6Yzd4NziMeXpgdyI+zRE
	 IymUfgYbAv4Zva0ewDkH/JoSPa6iWq30l5O/shFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 205/484] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:21:03 +0200
Message-ID: <20240815131949.331547013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


