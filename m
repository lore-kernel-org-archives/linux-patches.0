Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3660321AD;
	Fri, 24 Nov 2023 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElS+ts0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16755C433C8;
	Fri, 24 Nov 2023 18:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852137;
	bh=nNm40wXuZGih/nr+rH2Bii3KcRqkF1kRk1fSAmRJjv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElS+ts0v70FebVeTCDn3HAEA3RWvqdjyn7mV95m8iyOjR2x9iWXHlBgNyIA9hd1Dp
	 WUaFtIsoCWTtajizb82TSxSL/dYEOtXTS+BeD/ECukYvk60yeo6rtQ5W3FdCFGyBhT
	 W4QCqeqtmwdbxuio57PDwogUoEdhiJC3/qnGG2i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 217/372] PCI: kirin: Dont discard .remove() callback
Date: Fri, 24 Nov 2023 17:50:04 +0000
Message-ID: <20231124172017.710115484@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 3064ef2e88c1629c1e67a77d7bc20020b35846f2 upstream.

With CONFIG_PCIE_KIRIN=y and kirin_pcie_remove() marked with __exit, the
function is discarded from the driver. In this case a bound device can
still get unbound, e.g via sysfs. Then no cleanup code is run resulting in
resource leaks or worse.

The right thing to do is do always have the remove callback available.
This fixes the following warning by modpost:

  drivers/pci/controller/dwc/pcie-kirin: section mismatch in reference: kirin_pcie_driver+0x8 (section: .data) -> kirin_pcie_remove (section: .exit.text)

(with ARCH=x86_64 W=1 allmodconfig).

Fixes: 000f60db784b ("PCI: kirin: Add support for a PHY layer")
Link: https://lore.kernel.org/r/20231001170254.2506508-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-kirin.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-kirin.c
+++ b/drivers/pci/controller/dwc/pcie-kirin.c
@@ -742,7 +742,7 @@ err:
 	return ret;
 }
 
-static int __exit kirin_pcie_remove(struct platform_device *pdev)
+static int kirin_pcie_remove(struct platform_device *pdev)
 {
 	struct kirin_pcie *kirin_pcie = platform_get_drvdata(pdev);
 
@@ -819,7 +819,7 @@ static int kirin_pcie_probe(struct platf
 
 static struct platform_driver kirin_pcie_driver = {
 	.probe			= kirin_pcie_probe,
-	.remove	        	= __exit_p(kirin_pcie_remove),
+	.remove	        	= kirin_pcie_remove,
 	.driver			= {
 		.name			= "kirin-pcie",
 		.of_match_table		= kirin_pcie_match,


