Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E992E7367;
	Fri,  7 Aug 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115120; cv=none; b=qersOzZdrNexQzE7vYeRiYfLC+t/qZy28kBzSzk5bzKJLauQgJFnepQiecRXnAmjiGWyL5sQFGbkbm1NKiZuE6ZDTeSrEVK3hZHbU2CPvneAqm/l6E4mcNbub7UH7F7XKT58z29L2LAdSnkA5v3q7c2GRnJU/A2RQPhsvFm6eCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115120; c=relaxed/simple;
	bh=pPfjfdYV5nLxQ7faxadmqoNWnstJX6KLd3MjYZ+afeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQvNUYkhn6CdfAaxJlZPaGm3GPfzaGLF776UQF5Ig4G+H0KJq6lSPX5j0lNs5FELUIBjfoUZmTW5HsbVwlxaYS2znd2UstBTI5/KwP4QwVn5WPkEONKx0CejaRWxNfhAUK7TZ7VygMJzdVjLHk/8RpJuhiVg4fKAGem5cl7K5xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0evVKp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0evVKp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F921F000E9;
	Fri,  7 Aug 2026 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115118;
	bh=/4RR5aRzNOi2ddr9qKsWXpVcCa83bSvTPkauroJOC44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0evVKp+WOlmAFsY+oMXVTrvd1k0aneTbhPkeY04kX3qNM0Wu47TQIbcE+yM+XhK4
	 CJyjow0aUtrkoAb/E41RqUf4pLtD/rG6X9A04kiCrBb5IBhOJSlo3Vuztx0lDhWp0u
	 zJ2dNGOX4P8Zfebd9BMaaEfiZOdk85mVo2YNi7yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 164/396] pinctrl: microchip-sgpio: add missing select REGMAP_MMIO
Date: Fri,  7 Aug 2026 16:35:24 +0200
Message-ID: <20260807143427.840473527@linuxfoundation.org>
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
@@ -238,6 +238,7 @@ config PINCTRL_EQUILIBRIUM
 	select GENERIC_PINCONF
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
+	select REGMAP_MMIO
 	help
 	  Equilibrium driver is a pinctrl and GPIO driver for Intel Lightning
 	  Mountain network processor SoC that supports both the GPIO and pin


