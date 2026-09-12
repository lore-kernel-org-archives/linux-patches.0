Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA931F9A6;
	Sat, 12 Sep 2026 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221230; cv=none; b=Ov8hLtSLhdhhfNYE3jVhzr6VvC2Em1uDyNGizYKbXPZomNmOh0Bw/afva8a4EGn5IvLKRzg338AKDMpAZhzQo7rTqXiXC7YUWooTh0RWzzjx7UWYQp4DIPrp/GP0axmxHWJYiuFVDQoHejY2jCTdp9KbwUSY8hg+SxyWc0oHatY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221230; c=relaxed/simple;
	bh=j8C6zsb2h9tIflckmGq6TcOpI5lcYE+shrmrsmlcRXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZ4Z7ZNxlDxttg83b19tov+zyF5RsZicmHb+gZB+KDxQRyITilDtiN9ZCdT76x2h0FCnqfmrkCO1CalQWy0U8SKPw7NKWamils3t7F9Hko2P+QzieiBnHwSgw6Dp9zhh2iEc2+/ktpBNioTA2H35JvNV+oZ3pGjQOdemnRnSs0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4loILVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4loILVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ACB1F00893;
	Sat, 12 Sep 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221226;
	bh=ZN6vbqyLZkZCcp6fXGgl7COVQfvJZlbVETOQI9Z4QJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4loILVveZJO3CmHIPzZG/lbkvX9EJkrJ2h6Mk9awMMreXXkkQOQYT0b6gmS4VVr4
	 o2c45Fj6y7hqcqMpsvsIdUoBFf1QcQOgw74m1ZBZ7MejQLNDgpt2YlIBrFskP+9d2J
	 kjUfccy+MchdJ5DYl9K/qo0BE+YJbYqcFV4JbMZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0302/1424] sticon/parisc: Detect default STI graphics card for console output
Date: Sat, 12 Sep 2026 08:45:34 +0200
Message-ID: <20260912065614.048942588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -1143,6 +1143,26 @@ static void sti_init_roms(void)
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


