Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949DD41DDF3;
	Fri,  7 Aug 2026 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114183; cv=none; b=REPtowX9whUN4fnu+A2EOzpXG6Pzekju1laYFKnVm9pPlrA1wuPw0dq2oVkCLYn0y8VnkoiSudfx2vMdKPR7UsZ92jQAVaolsw2m6l11iH1kIC8cd4FV8QP6AfkfgweLVZRLi79v/Zat1CPmCMudgkjdoJT55a6oCoumIMZ+79A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114183; c=relaxed/simple;
	bh=HjnWWhqwPcbLGADqsGWWlj+j+TbW4+6T4eqsdE+ju64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIcDD5FkK9MiJw9YYmRCqf3g30Y2shWTM5uyzP1lSJ07qtA+JouiGsJV8rmR5dBkkGxhaOzv0+SrxUcSXA053vBm4pD3AI7w8Cii7m0GqtRY9O3RW68/RkyoLlxcDhJCdmoDRbbxvZezRzTa8Vh/+injCuI9l6dHRS8Ch9fYMdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6amuhfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6amuhfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7921F000E9;
	Fri,  7 Aug 2026 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114181;
	bh=gBiFFLjbZA+Nvq1OMYe+3tx15Kif9CHFf+rMkt5DYz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6amuhfknkDNRe/rpnCUiFvzBvcFaRsI/bZkH76Dj8uCOnp6/Mi5HIg0x1rt0YVxC
	 3k8SW+N8N2F40Y0+eMH1ialzDBWsxkrGi7b6GTXyyjDzeUMF6AqE+bdKvcIAu2UDh8
	 p2RCSn5alFJ3yySyZIigGtFV/00JvJNkSYu2hIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.12 129/337] pinctrl: microchip-sgpio: add missing select REGMAP_MMIO
Date: Fri,  7 Aug 2026 16:35:32 +0200
Message-ID: <20260807143421.330302978@linuxfoundation.org>
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

commit 25cb6e9a13123d1039cdc75b446ac52e1ebdc26d upstream.

The driver calls ocelot_regmap_from_resource() via <linux/mfd/ocelot.h>,
which internally uses devm_regmap_init_mmio() and requires REGMAP_MMIO.
The Kconfig entry does not select REGMAP_MMIO, causing a build failure
when no other driver in the config happens to pull in REGMAP_MMIO:

  include/linux/mfd/ocelot.h:34:24: error: implicit declaration of function 'devm_regmap_init_mmio'

Found by randconfig testing on arm64; tinyconfig reproducer below.

Fixes: 2afbbab45c26 ("pinctrl: microchip-sgpio: update to support regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Boortz <bennib@mailbox.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -213,6 +213,7 @@ config PINCTRL_EQUILIBRIUM
 	select GENERIC_PINCONF
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
+	select REGMAP_MMIO
 	help
 	  Equilibrium driver is a pinctrl and GPIO driver for Intel Lightning
 	  Mountain network processor SoC that supports both the GPIO and pin


