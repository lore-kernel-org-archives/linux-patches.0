Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AD0378838;
	Fri,  4 Sep 2026 06:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501819; cv=none; b=Lj0VyaJKOuLxLBxCCrhejZ9AdHb9Q5yLgv/9JdIGDGUfaYWzl5eetCgtoJsIPOyfNVtoK/9nLkxQy8jCNQfJ3dIejoka9JfQoEPBB2HnOzE8LwDwb2lAOsz3dNjaR0pbd89xKMngG8Pe9CIlFv8rYYs5qah09wWiDDuDiNUik90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501819; c=relaxed/simple;
	bh=XIkqfLP8qLMAWF7ta87nB00QX1JnYUtLzLiO9g3S1vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW8agU+ixGGVWj6b2ZouMaRl58gdJ6JzTxsMvyBESMyF3ydzJ6+iYke9qCeXa0076Fp6io5HbbeQkjplLfhG6PP0kFjcs5X5mIiM/I5FLi/WMttcsb62Hy7F87F+A/f5jXNQpNna1ASub3no8xGHYNehfBhE6+EW+97veWn4OKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAvDf7yk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAvDf7yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EA81F00A3D;
	Fri,  4 Sep 2026 06:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501817;
	bh=aCMTgwg/Gkm9ffII7BkcNaaNDWKNkNfEGFIOaOO/fdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAvDf7yka3qbEyxl9GByq9mdRgtePBapww68WH2/SiAIGmtgWFqpR7U450sdl8OOy
	 YnZnup/C5rRvlpLDrUANAatlVzFvtpzRxaHPk+Qu9H7+bHq/UrA9mMverL8kiJEoUJ
	 +8HUQrByr/nNsK/ts1LwOCgeqEAnmMie0zaDLhPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 544/552] sticon/parisc: Detect default STI graphics card for console output
Date: Fri,  4 Sep 2026 07:01:41 +0200
Message-ID: <20260904045802.938472472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit de508ece1d37cdbbbfa52f074954310f9b066b13 upstream.

If a machine has multiple graphic cards, detect the graphic card which is used
to display firmware messages and use that one as the default graphic card for
sticon and fbcon.

On parisc machines the default graphic card used for BCH (boot console
handler, aka BIOS menu) is stored in the stable storage (equivalent to CMOS
storage on x86) or in the console path in page zero. Extract that path and
store it as default STI path for later comparism. Take care that the graphic
card can be a GSC or a PCI card which use different path strings.

Increase max string size for default_sti_path to 32 chars as the
print_pa_hwpath() function formats a hardware path using unbounded sprintf
calls for up to 6 bus converter components and 1 module component (e.g.,
255/255/...), which can produce a string up to 28 bytes long.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/sticore.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/video/sticore.c
+++ b/drivers/video/sticore.c
@@ -325,7 +325,7 @@ static void sti_rom_copy(unsigned long b
 
 
 
-static char default_sti_path[21] __read_mostly;
+static char default_sti_path[32] __read_mostly;
 
 #ifndef MODULE
 static int __init sti_setup(char *str)
@@ -1148,6 +1148,26 @@ static void sti_init_roms(void)
 	pr_info("STI GSC/PCI core graphics driver "
 			STI_DRIVERVERSION "\n");
 
+	/*
+	 * Find default console by hardware path which is either stored in
+	 * console entry in stable storage or alternatively from console path
+	 * in PAGE0 used by BCH and PDC.
+	 */
+	if (!default_sti_path[0]) {
+		struct pdc_module_path conspath;
+		struct device *dev = NULL;
+
+		if (pdc_stable_read(0x60, &conspath, sizeof(conspath)) == PDC_OK)
+			dev = hwpath_to_device(&conspath.path);
+		if (!dev)
+			dev = hwpath_to_device(&PAGE0->mem_cons.dp.path);
+		if (dev && dev_is_pci(dev))
+			print_pci_hwpath(to_pci_dev(dev), default_sti_path);
+		else if (dev && !dev_is_pci(dev))
+			print_pa_hwpath(to_parisc_device(dev), default_sti_path);
+		pr_debug("default graphic card: %s\n", default_sti_path);
+	}
+
 	/* Register drivers for native & PCI cards */
 	register_parisc_driver(&pa_sti_driver);
 	WARN_ON(pci_register_driver(&pci_sti_driver));


