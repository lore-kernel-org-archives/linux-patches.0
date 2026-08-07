Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EA834BA24;
	Fri,  7 Aug 2026 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115128; cv=none; b=HY5HsRnsGlbHFL2dCenVdFjd2ztAnrobH1mOmX4R9jC+7Or9KMjZQJLDbxLid71PX3hVafMV2U3GsNCrq94yrPwckJKzmgGVmHpEGEK5jbE265WTT0KgUuaYSm3qYhlwVpUlRy7ZDbKt3AU8WF6+inMb5ibIjsNG2HXE+99XHnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115128; c=relaxed/simple;
	bh=qmRWMSVSuCMNHviQ7A/q4xIkTxMNx9keHLaGjgi7aL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8Sd/XZaNuxwwdhSiUTqHRbnD0f2lrBaxcTtJtmNu3hTo7hgic+4JsPnE643PyLAdOOXwP3pNnwR+7creL5mOAFkg9OTprCFshf68Btf0sv3lhYKNPcTXk7g05JQNeHgfynaO108IgSC0a9wx6rT1srxJzxUx2C36owvl66booE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6Z0h6Wq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6Z0h6Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37A01F000E9;
	Fri,  7 Aug 2026 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115127;
	bh=KqvG86vmD2Vgp8U0KmkoouQXKTxwU+s90cEXpIMiohQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6Z0h6WqW4CWa1wlK02a0P6FcVHvhfGYqz9baj0laNrttwA7tEbE0FMXKpBy9kUvb
	 Kmsbu70nuEgWVbdeqVZJAELOTOVyVCZnQAUkI1e35caoNzHxQkppWJOUFpi3Rmv0T5
	 g45UWHksuXMbRJq0jDDt3MJ8DP6B4nYv0hyHLYcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 167/396] pinctrl: bm1880: add missing select GENERIC_PINCONF
Date: Fri,  7 Aug 2026 16:35:27 +0200
Message-ID: <20260807143427.904727416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -162,6 +162,7 @@ config PINCTRL_BM1880
 	depends on OF && (ARCH_BITMAIN || COMPILE_TEST)
 	default ARCH_BITMAIN
 	select PINMUX
+	select GENERIC_PINCONF
 	help
 	  Pinctrl driver for Bitmain BM1880 SoC.
 


