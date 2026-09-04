Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9401417BCA;
	Fri,  4 Sep 2026 05:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500251; cv=none; b=sCLIzFhe/6Ye0Z5at0UNJ30XG+vMSylpL9twx8euD2t3qXTUFcNZjDUiq5f61/N9VIlxvJiAW5s5cmRmLW8Z9xTbI06ZOQmk9+YA/25xZ157HSB6oywMJrByMH0dGwlFtuSMWSGxF8Lk9wlYCzX8XyPxIcR7t2m3La+kWbZ1QFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500251; c=relaxed/simple;
	bh=qdY9xRWxbjdiHWpGq4VXekgbod6XsvKjVWDqTe1IhJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaCkmlAotVz/y17hTqPCtqvf0e6ROxkdOM3iOEOzC5lpuoD4HCFKkAyVZjyMYQdiKpOBIeJEhUUrLWNFFfQ7mJTwPmRkj4AX7m16UfYLAVmXQBBXjI+wLq/0AKvjnp0CXGzTZlYOx3P7wRKdypcoer1JXOCIVMiuhz7n+k2Wbzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzIV8lxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzIV8lxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2041F00A3D;
	Fri,  4 Sep 2026 05:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500250;
	bh=zySWhr9K9WfrWJH1k3L5MYmivBbI/R0eg59YwNdx//Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzIV8lxtoC98px3jSU6ozRp8oWmOfSo557jifO63d9up/MyeZPYSW5rczuUOmkynV
	 ZloT3wad5u5RUCvfjX7RD5Rau8bLkmb8SyW9IWdxoLIaifMGAydtkpJRarECYFqeBU
	 iQza6JoMYkTuUp5e0noPs4RgCNlqfhjx10Ks1eP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 704/713] sticon/parisc: Detect default STI graphics card for console output
Date: Fri,  4 Sep 2026 07:01:12 +0200
Message-ID: <20260904045819.627701360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


