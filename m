Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2914D2E762C;
	Mon, 17 Aug 2026 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979889; cv=none; b=pKQ+85U4emHCtk1Lq0xeAanwx0EB4FKWOdgNLdTckOyQngtj0PkiDnm0wfEYGeJPzgIL1Hd9DEY6/IUx4bw2tEjBr74QFfC8OVSvrTgSGcxZ/7Q0wGlov0SJJRMJ6pZXL2tyNxCktJAjnuTsvn0xY2GZv9zflZUmu8UQSprJWyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979889; c=relaxed/simple;
	bh=obje4y7f9IOSoJVNqRsrYCozg4jwWM9PTIWPebNQidw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkSTXQbCcMQ+q93OKcpLBNVJuAYxWbElgCaoiRPJrqVCLp0tiVHgfv88CVwvsziPWM2rD0qEw6aTUVTBIjq0AF3oiztu6MluaZ5atLQiM4k9ClnrMjWbf4d6m4pltOBdnz6eNSd8egE/mn3Eyzeu8lyss3dXbVHJNHUjuI6+Tr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mnsfy30E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mnsfy30E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8324E1F000E9;
	Mon, 17 Aug 2026 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979888;
	bh=ZUls6QG1Uounwq7dtk7i9+YvTXWXSih9bpbtZ7ufHvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mnsfy30EUAq/mFZrN6ZOfraYxyltP6oU/oHsN0fga7SKZl3v7fkSDKpRSeTUy9aCL
	 jz9QTL5bVukgmvijGkh7mwNXiiyLrfV9aFnGavOrg2BHfKf2EwlXFimkvytf+N+Abg
	 udeNCT0yASaZG9RhRq2d6m9chETfyScrYgNVkXmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.1 382/609] pinctrl: microchip-sgpio: add missing select REGMAP_MMIO
Date: Mon, 17 Aug 2026 15:31:18 +0200
Message-ID: <20260817132557.044022222@linuxfoundation.org>
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
@@ -315,6 +315,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
 	select OF_GPIO
+	select REGMAP_MMIO
 	help
 	  Support for the serial GPIO interface used on Microsemi and
 	  Microchip SoCs. By using a serial interface, the SIO


