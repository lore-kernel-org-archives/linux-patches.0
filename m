Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C0B33DEF9;
	Wed, 30 Sep 2026 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792193; cv=none; b=nK+oSymtCdM4C0wLtFZ6lJx31dL+j3rFyGsHe6MPT0nFeXRD+HlSanEH/zza+UJd3xxxds8QFfroHjItTso0OYh9QLaY1/dv9DZ9l/rqOXLrw3DVpw54Ok9QPAg07OMYokwEsBBBmUndWa0v72X+eOFUx4v6oP8WdT71CWwYDBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792193; c=relaxed/simple;
	bh=fZnNPdueWSVRb6qmSvORHSGhSxZ7c9YHLvyI2iemqN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDtIRrRnZv5ff7Aj47dSNodXF4/gUGHQ2iajljenL3+l3qMLRCmj7fcvMsSA4E5Zb4UAM52EtFpmLr4WQqidUDjBiFYaQ4gmBTp8V/GkYQiFk9wwFC/eofy1w+tA4uHfLXEOX1RfJ1VqOatZ9hzaTNSTHfKWDPabiQb6Qpqav8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PF23FUqA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PF23FUqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414FC1F00898;
	Wed, 30 Sep 2026 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792191;
	bh=Rzf1G/j+Wdu6wRiBRBkevIpCK9c80caBBleb27WwI2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PF23FUqAJKCyhHyBYRCenV9bnIiHEJfF4wBpc0Ea1haBFPa+3DGAg67AqrDYxYRpW
	 YiA1HEa1IBGAS0AENAsnAkNe7LeiuWLr948IdOLJG2kdT297ThmkMLkjDz2slesBx/
	 qtYMdJSdmv//3fCLDyzNh0LSmMbZV4f1N3zddBFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 569/752] watchdog: sp5100_tco: Fix pci_dev reference leak in sp5100_tco_init()
Date: Wed, 30 Sep 2026 17:27:19 +0200
Message-ID: <20260930152410.547793198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 88f113634028ca90a857031837d8061d1a9e1a7b upstream.

sp5100_tco_init() stores the PCI device matched by for_each_pci_dev()
in the global sp5100_tco_pci and keeps its reference for the lifetime
of the driver, but neither sp5100_tco_exit() nor the error paths of
sp5100_tco_init() call pci_dev_put(), leaking the reference on driver
registration failure and on every module load/unload cycle.

Drop the reference when the platform driver or device registration
fails and when the module is unloaded.

Fixes: 15e28bf13008 ("watchdog: Add support for sp5100 chipset TCO")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916170511.2086199-1-vulab@iscas.ac.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sp5100_tco.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -587,8 +587,10 @@ static int __init sp5100_tco_init(void)
 	pr_info("SP5100/SB800 TCO WatchDog Timer Driver\n");
 
 	err = platform_driver_register(&sp5100_tco_driver);
-	if (err)
+	if (err) {
+		pci_dev_put(sp5100_tco_pci);
 		return err;
+	}
 
 	sp5100_tco_platform_device =
 		platform_device_register_simple(TCO_DRIVER_NAME, -1, NULL, 0);
@@ -601,6 +603,7 @@ static int __init sp5100_tco_init(void)
 
 unreg_platform_driver:
 	platform_driver_unregister(&sp5100_tco_driver);
+	pci_dev_put(sp5100_tco_pci);
 	return err;
 }
 
@@ -608,6 +611,7 @@ static void __exit sp5100_tco_exit(void)
 {
 	platform_device_unregister(sp5100_tco_platform_device);
 	platform_driver_unregister(&sp5100_tco_driver);
+	pci_dev_put(sp5100_tco_pci);
 }
 
 module_init(sp5100_tco_init);


