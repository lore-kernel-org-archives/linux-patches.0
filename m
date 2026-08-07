Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1438F4756A6;
	Fri,  7 Aug 2026 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117124; cv=none; b=OLMbJ0sI34KqccayOHeGzJE8DY33346JXgfKJnc2djhDDcCWDL8PM40yXhbbFGtp6KEm5oG+BR9boq6Au/qqeDLAjrTw3LOL+c5mfXG3ZqR7xXfdxGhozaYd6uEUq4C3K5DpS7SJIIuLGuOemcEdu/9cc0h6cKA55iMPU0lx4js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117124; c=relaxed/simple;
	bh=zc1XmNOGGH38pFGjMwzmDf8mDA1Goky9s+azsp3E3JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp/SfsbMFAINEUNVMzZN32KOAjQo2LkxnKsme3AlG8AaLUr61Y9MdBaxW6WNlVYvVb1injX2wu7IV+cn0q7RUqoXigwdwuJW2XkdDWrMuIDTMdieloE3E8r66bLm3xi4rEpNd10Nu4WEoBVHiuBUPegQ1TNc7u/q3FpWN9L4nLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvxijDAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvxijDAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692351F000E9;
	Fri,  7 Aug 2026 15:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117123;
	bh=gfm09VcUtZ44VlpRYAuUKg1uDNiWfbVq/1bpvipU3Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvxijDAVcmbLI9KsubQs0VS7Vs7LJXCDLVw1ZioY8wb8G4NFTubP9Bpr5Bnf9jwXj
	 a/cxgZ40LmbWHSwI2VyOlYscbeeLDptFS7XdL4LGWNv/R582k7BRMFCD2fhsciLs0W
	 rdvYbrsehfyLWKQsKma5DUwvBEOCTci1jMsXgvLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Boortz <bennib@mailbox.org>,
	Andy Shevchenko <andy@kernel.org>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.1 206/438] pinctrl: microchip-sgpio: add missing select REGMAP_MMIO
Date: Fri,  7 Aug 2026 16:36:42 +0200
Message-ID: <20260807143432.410473921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -416,6 +416,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	select GENERIC_PINCONF
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
+	select REGMAP_MMIO
 	help
 	  Support for the serial GPIO interface used on Microsemi and
 	  Microchip SoCs. By using a serial interface, the SIO


