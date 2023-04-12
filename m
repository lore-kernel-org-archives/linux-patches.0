Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639A42F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B03C433D2;
	Wed, 12 Apr 2023 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289418;
	bh=v2l6FyqJs0CT+7YwnPNBkgEa65om6F4b14Az2PuqUSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On1HQGTjvWefWu01YNs3sFHyAR8wOV/Ea+y5t43TVFlHWu8ejjnVbpd4abMpnD1F+
	 HnKwYgWi4npuXq1DVtEqcWADvwkKzj4JJDZtFaN2JsyHgzxItHWp7dwc3YBbIm8V2B
	 pugOP0B8xPzeYx3gGeqq8/mGXmy8yfdpW39C8gh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.2 061/173] Revert "usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS"
Date: Wed, 12 Apr 2023 10:33:07 +0200
Message-Id: <20230412082840.562843769@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 8e77d3d59d7b5da13deda1d832c51b8bbdbe2037 upstream.

This reverts commit 4c2604a9a6899bab195edbee35fc8d64ce1444aa.

Asynch probe caused regression in a setup with both Renesas and Intel xHC
controllers. Devices connected to the Renesas disconnected shortly after
boot. With Asynch probe the busnumbers got interleaved.

xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 2
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4

Reason why this commit causes regression is still unknown, but revert it
while debugging the issue.

Fixes: 4c2604a9a689 ("usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/linux-usb/20230307132120.5897c5af@deangelis.fenrir.org.uk
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230330143056.1390020-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index fb988e4ea924..6db07ca419c3 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -771,12 +771,11 @@ static struct pci_driver xhci_pci_driver = {
 	/* suspend and resume implemented later */
 
 	.shutdown = 	usb_hcd_pci_shutdown,
-	.driver = {
 #ifdef CONFIG_PM
-		.pm = &usb_hcd_pci_pm_ops,
-#endif
-		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	.driver = {
+		.pm = &usb_hcd_pci_pm_ops
 	},
+#endif
 };
 
 static int __init xhci_pci_init(void)
-- 
2.40.0



