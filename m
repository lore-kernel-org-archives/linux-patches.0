Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668DF1A76A1;
	Tue, 30 Jul 2024 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360224; cv=none; b=kv0NRuwbPkWQd4k7uOsNjozWdJxd4Lood2wad9ruJLRiI8sSM2czX6mJRoHoVQlHb9K8jcImryhR73Iuj4B2tX06AEmsiixifezDnQZyuUibr5S7Bhwia9MjP7rOll8rQHwbhxGfAZD5w/kZqmdTcpav9OEKTgLRzdriWLCiTyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360224; c=relaxed/simple;
	bh=eafieAQvpRzMF+MNzRbcjzzoQL3xJhOdWx+oKvAbpn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQmWinrKo6ZnacXrg/7XwPzaA66QG2MDVvBl6foQwsBRvTnjO0UO8hHKTadaqniyB9qF8eHt9NWfwK1D9qzzqWKmqE7m7yZwWmPbL7gTGtjWskt7c6rPNq4+fUeQ3HSAtmcweILzYD12ZI8ckmdh0Q0RQJtjKck+ImiqLaxl2rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3immezD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3immezD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B22C32782;
	Tue, 30 Jul 2024 17:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360224;
	bh=eafieAQvpRzMF+MNzRbcjzzoQL3xJhOdWx+oKvAbpn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3immezD+KLjLh0imrvyU9S4NEyfAZdLtUQ6AA5K55++knIoavyzeO/3za2b0VI8H
	 okdcYXM+WjAB6eY0nR388iBCnIjE44b69Dm4q0K/IIOZgt3ZUHL7MlCyz0NZdmUcWi
	 tsZ+7VFNE9y07dVGUTP1u/u5bQApM7k915eIdE5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.10 635/809] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:48:31 +0200
Message-ID: <20240730151749.924647604@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


