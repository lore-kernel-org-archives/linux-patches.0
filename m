Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC9228E0;
	Fri,  7 Aug 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116032; cv=none; b=X2bCn8MqMu74T41syUzaBUZN1K2p6g/kcvQaf/SCOO6oKjSrXIAbSACZPinN+8ZNPGHe45XlHsJQUOCPdgOQXgTVVHYO0AlU1uhz7tRrS/NoHAKeonFGjJPF3EJ8RPEAmOns92vmgLs8CAlQ9edIzDB3pKRvixtbXhgUztCVhqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116032; c=relaxed/simple;
	bh=EdW4yY4kL5RtgKlACMvVf/uiJvqW3vZPiO8Sy+n+jRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4KUX21qArmbxDQN8n3aSL1f7c1ONZsCQux+cqyeViJ9GzdsqQ+oajewrh5R94llaIq6NpGgJ29RAHh764vBDPAXj7orZXMcoWL+M4/DvJ+uQ/CJMl7aZLqLqrBy5txslQo6TX0ovpQ3sdlE6VVA6PwpRrCpFKYi6Syvo6K/Em4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpVn0hsD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpVn0hsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AFF1F000E9;
	Fri,  7 Aug 2026 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116031;
	bh=PglNhg4ZkLZwl9svU1CaNiSwN9X2PTfaFfBVruFrXE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpVn0hsDqmdAs0AWePrfb8yyr9oBkVrW172pps+pUQi8vViHcqKDu4GEGjwI+gAs+
	 XGZj30xf1KORDQ+nVvJT4rin5Nw3YOXqKAAfGKDtgbrv5bQVsxqKR+KM/jW8hUAVh+
	 eaBS7BkublB+4CcBTdU8CuIRI2NiUFLMXWrIFV6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.6 088/261] pinctrl: microchip-sgpio: add missing select REGMAP_MMIO
Date: Fri,  7 Aug 2026 16:37:25 +0200
Message-ID: <20260807143417.284682029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,6 +188,7 @@ config PINCTRL_EQUILIBRIUM
 	select GENERIC_PINCONF
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
+	select REGMAP_MMIO
 	help
 	  Equilibrium driver is a pinctrl and GPIO driver for Intel Lightning
 	  Mountain network processor SoC that supports both the GPIO and pin


