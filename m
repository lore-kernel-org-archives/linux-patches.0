Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503493932EE;
	Fri,  7 Aug 2026 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114068; cv=none; b=eA/tVA/x9/ePOP7V0cdwxWCRHFdguIv3hDhJ+3y2PJ4JkmGPcC+0WPRKE+svmedjSANTsWtvQeeJr00Fkg92ZY2eUXNOIbMm92E/GQICJvR7ncVOf/KtkxZQ+ohneJ7KUNd/ktg4w0sufi22A+Su8NCUDv/60edaO9V2XYmOEsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114068; c=relaxed/simple;
	bh=fStasIdaXAt0v5pAGw2Km1RsP2B82XQ+QjLD5r7KbK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjzjcaaCSoACGkNk00K2Cj1f6F0H+BU81gfomTqJFuBeh2V6iVjguFLEnTiS2E4NuQp4ecAHTtxSCOyiGQgzaMfpkMBuXzrVrFqXvYTIUXG09VMk6DROPmjvM0uXr5J5/gGFBOSzVVj0WBcOqlQEMJScnVlg5CEFoECIBjdJTRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCrNTGqm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCrNTGqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660741F00A3D;
	Fri,  7 Aug 2026 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114062;
	bh=HVHGM7J8nF38p/qIuSWQ+6hJwTcei7cifsdXyFfWjyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCrNTGqmQOHsma5mYIVYEivPxvQ2WxUjowZJ8JtUpny+iIhxsl1/48V1can50mG9y
	 MfBJNMoRlWU3mGTClIjGhglAh93HCFw/aIo3zN/UAeotuZw6XGJP+fxGTdZ/QjvFkp
	 izlX1hwfhhDy4adlrSRk+4t427kaWwqdHV3SOhjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.12 132/337] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Fri,  7 Aug 2026 16:35:35 +0200
Message-ID: <20260807143421.395101313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


