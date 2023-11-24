Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28CD381D8;
	Fri, 24 Nov 2023 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYDxY5tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C9AC433C7;
	Fri, 24 Nov 2023 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848728;
	bh=OXydAH++5OobtdWzhsL0ClS5Lbw6VkZz+DzsQMwnUwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYDxY5tzNWUkKVfYgBkjLT9GAp7YXN6Ue4FlFEIUWsCfmTCNbV79l1VxWTzgk1Vmy
	 /TS2GPz3ht3oNOj55Mq34HSSEsQzes2ySA7aNSPgbP+6M6ZhPdYn1O2exq9c5z2D8l
	 1LsuREqrhR3lejn/uG4blT3feytSOAmmFtJdIsLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4.19 58/97] PCI: keystone: Dont discard .probe() callback
Date: Fri, 24 Nov 2023 17:50:31 +0000
Message-ID: <20231124171936.314663676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 7994db905c0fd692cf04c527585f08a91b560144 upstream.

The __init annotation makes the ks_pcie_probe() function disappear after
booting completes. However a device can also be bound later. In that case,
we try to call ks_pcie_probe(), but the backing memory is likely already
overwritten.

The right thing to do is do always have the probe callback available.  Note
that the (wrong) __refdata annotation prevented this issue to be noticed by
modpost.

Fixes: 0c4ffcfe1fbc ("PCI: keystone: Add TI Keystone PCIe driver")
Link: https://lore.kernel.org/r/20231001170254.2506508-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-keystone.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -385,7 +385,7 @@ static int ks_pcie_remove(struct platfor
 	return 0;
 }
 
-static int __init ks_pcie_probe(struct platform_device *pdev)
+static int ks_pcie_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct dw_pcie *pci;
@@ -452,7 +452,7 @@ fail_clk:
 	return ret;
 }
 
-static struct platform_driver ks_pcie_driver __refdata = {
+static struct platform_driver ks_pcie_driver = {
 	.probe  = ks_pcie_probe,
 	.remove = ks_pcie_remove,
 	.driver = {


