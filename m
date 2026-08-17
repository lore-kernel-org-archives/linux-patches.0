Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD84440A2E;
	Mon, 17 Aug 2026 14:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976168; cv=none; b=I6DeWENxFNVDEUc+apro2fSX8W8hHJJrERYwr4OcRAhCygibAM51meyNQHu3a/nd2xE3o9cl6AX5kVqzNwGOscuYBEfaGeBPRIIoR49g2oO1fRBut1+8G1S3w6GKVqoM1RUWvNzjEc2wuY5CB9SDEMAjABkaGKB1J41eeJbtmks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976168; c=relaxed/simple;
	bh=BBwMBgaya2/0Wi2DVvMLYmzLPV2uN6hCl3CUtF6Jkjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1svj4/72LwOUcGnAjUrCkhPSb9gpjpDd2eycr7tZjQK6hqkAhJpbiH5VlBEypRGixFxgbRxyDnWAU1jWk/gPfbyD2aFndB+hvje5b6bG7vbjCh945yDQ4iPugf6JjMWX6GWPf00NIQY1e3+eVV4w2SLz2OYbH/bKBmQHbJxgAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2Euurbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2Euurbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3331F000E9;
	Mon, 17 Aug 2026 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976167;
	bh=BUagERdaYjCjLVdxElHh3O1bd0Wlj5oH06th7aV3Tes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2Euurbh6QaEJ6FGybme5xOMayV6dPe5Uo+e/w+cmYGCJrZcK55E6JPaJTdDMcZ2p
	 Krk3ucNRBH+u6yYzixWl3cRTUj9HspX2lcwa7eW9Gp3oVnhe9DGXRMzN5UXEm0tCHg
	 wE+JzX+OZNTRj7c2rDotcdBQyzW//HC5JogNjtSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 5.10 241/389] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Mon, 17 Aug 2026 15:31:20 +0200
Message-ID: <20260817132548.689196805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -115,6 +115,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


