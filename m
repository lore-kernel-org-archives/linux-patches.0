Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845135EE6;
	Fri, 24 Nov 2023 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVdGfKdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70A4C433C9;
	Fri, 24 Nov 2023 19:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853481;
	bh=h/VmC1g4m3/VFNttySL853g8a/oyhQLXdrvQjDOqHlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVdGfKdFjj9jDchz9ayCa8F8bI+3xE90a/Lk6dN/x8oE8SfX1kCUtOvaMA7aOuw/9
	 /g9rtDVLsSlr27XZFa5ZYm/atDFMlfRl1uliXEiiPSLbFIUsQnTyIABNevgLnN83Sa
	 go8j970vNipYao9FwmKXXCx8EaQuWS9+dBzfYkUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.15 205/297] PCI: keystone: Dont discard .remove() callback
Date: Fri, 24 Nov 2023 17:54:07 +0000
Message-ID: <20231124172007.384298510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 200bddbb3f5202bbce96444fdc416305de14f547 upstream.

With CONFIG_PCIE_KEYSTONE=y and ks_pcie_remove() marked with __exit, the
function is discarded from the driver. In this case a bound device can
still get unbound, e.g via sysfs. Then no cleanup code is run resulting in
resource leaks or worse.

The right thing to do is do always have the remove callback available.
Note that this driver cannot be compiled as a module, so ks_pcie_remove()
was always discarded before this change and modpost couldn't warn about
this issue. Furthermore the __ref annotation also prevents a warning.

Fixes: 0c4ffcfe1fbc ("PCI: keystone: Add TI Keystone PCIe driver")
Link: https://lore.kernel.org/r/20231001170254.2506508-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1284,7 +1284,7 @@ err_link:
 	return ret;
 }
 
-static int __exit ks_pcie_remove(struct platform_device *pdev)
+static int ks_pcie_remove(struct platform_device *pdev)
 {
 	struct keystone_pcie *ks_pcie = platform_get_drvdata(pdev);
 	struct device_link **link = ks_pcie->link;
@@ -1302,7 +1302,7 @@ static int __exit ks_pcie_remove(struct
 
 static struct platform_driver ks_pcie_driver __refdata = {
 	.probe  = ks_pcie_probe,
-	.remove = __exit_p(ks_pcie_remove),
+	.remove = ks_pcie_remove,
 	.driver = {
 		.name	= "keystone-pcie",
 		.of_match_table = of_match_ptr(ks_pcie_of_match),


