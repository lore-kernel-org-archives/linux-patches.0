Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AF8314D34;
	Mon, 17 Aug 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977331; cv=none; b=fSY96asafhQswHlkbbjdLlljMR9wlRuuOhSF/fsrgT2AatyrdO2ALkzZj41tW32sjLMdkqJ07Nr6Nfi+iKlHmp59p7xu8ydv3sXXJrZx5E6GauP30L2zulVHTlDEH5NXsTwEwJ5ghPSYriGJcl/qonHLvDWhTIslvinIEHLnxpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977331; c=relaxed/simple;
	bh=aftZ4e7+SWXLB93cWV4yjAl2sfgBxbsbuiJrBBaZx24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtIRELSaWgCJzKQvRpm8UMUDQGy7NeF3/T02kOXOU7rtRC+h0AkXIMgru7QqngKO4gz9MX7XZYASQ6X+Lom5tIznLhPjVPt5fQnf8URibmdF1DJXWFEf24Ic57HU+tGUIHPMlM+DBdYHcc2qqehnOtnm6PzbyXmldsbFPBiIlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/kkp7iS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/kkp7iS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771C41F000E9;
	Mon, 17 Aug 2026 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977330;
	bh=hLuacJ/i+FdW3eqW5c6DBhZiqZqe4MUr0mBC96U1vDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/kkp7iSDFLg6l0B66usJ1lLQzzZ48uJ7yvYb/93N0xqEJtLq7ttXoNFs9i1PEMXH
	 K+RfTTnbuex8Sl9L9wyi22w/OQ+wwoSSq0+WGCLvooaGkgZOsKqCQ52MBolnibF4Lm
	 ab6WZFp7qQImFPP4YO8rovecO1m1Fw3UXnAs24AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 5.15 292/456] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Mon, 17 Aug 2026 15:31:22 +0200
Message-ID: <20260817132551.294180266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,6 +116,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


