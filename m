Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20F143C07E;
	Mon, 17 Aug 2026 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979894; cv=none; b=pEJ9LQV6Q1R9c0nFFqzdA/DiWSBioxtZPCCkJSuKpgzIbMBVDJCR+PdYUq8eWmZOk4//ZkagQSdxkijof/cIlRzI4tSxQzJfzdC+8nBzcC+fPvLR44OHV24N6/OaHZniKusc3c3NqzmfqM5kfXxG0Iv9ENr99SlaK/o54brX71g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979894; c=relaxed/simple;
	bh=DelwW3LL/ooF82udR8QR2beCDlqrUDNRabCubsIijPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4dPI6AbTPJx57oth1vmun7Z8fPxhIkxVIcA+7ZS1F85ershFC6jkjEVHQzkLPcPSUylVPqmHRnIgXYO2YpxYjPBcIPqj2QOkAnbnsjCFn9KAcpN+NwAwQBDfbtJUh1tk6h9ephnybem14REn6udNzqU9KmM+PegIjr/FU4Otzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rrm+b1vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rrm+b1vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D681F000E9;
	Mon, 17 Aug 2026 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979893;
	bh=NcTBJtnIFXT3Ax2SvxIbhTTB3i1u1Fre8REjveprymU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rrm+b1vzn13x+iKkSLUHkAID2BCzKuPsCA1MSnfB4oc+nkoLDGh1zmWGFDsqgp4YK
	 6LAgimK2oW9px/IxDNR17I5LhCnRuM1IdULGTWyIX4kD2ATmZ8ciaUbDfQ+c6NxFAv
	 HfwCMul/j963Girvu74kD1/FzHTPDvnevp/fBBPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.1 384/609] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Mon, 17 Aug 2026 15:31:20 +0200
Message-ID: <20260817132557.103785328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Benjamin Boortz <bennib@mailbox.org>

commit dad6e107b3cd9d20514e7799b7ad8674f81e3f30 upstream.

drivers/pinctrl/pinctrl-bm1880.c initialises its pinconf_ops with
.is_generic = true, but that field is only present when
CONFIG_GENERIC_PINCONF is enabled (guarded by #ifdef in pinconf.h).
The Kconfig entry for PINCTRL_BM1880 never selects GENERIC_PINCONF,
so any config that enables CONFIG_PINCTRL_BM1880=y without
CONFIG_GENERIC_PINCONF=y fails to compile:

  drivers/pinctrl/pinctrl-bm1880.c:1288:10: error: 'const struct pinconf_ops' has no member named 'is_generic'

Found by randconfig testing on arm64; tinyconfig reproducer below.
Add the missing select to fix the build.

Fixes: 49bd61ebce5f ("pinctrl: Add pinconf support for BM1880 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Boortz <bennib@mailbox.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -132,6 +132,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


