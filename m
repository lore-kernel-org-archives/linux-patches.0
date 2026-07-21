Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65452415F0E;
	Tue, 21 Jul 2026 19:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662674; cv=none; b=TFgZCzrTYVACcM682R/zv2gYOp4eSFbONs4Fd9MrlTViFR8S9ibyXH4vq/u8+RQmNIwkyYqBwdD/BJz89XMs6qkZYFf0oE1E2VK8jL0FnvyqzRtwnXBcfIMUfqcs51ajT25P2e16FY+SUsm/qwLvq7xj9PZT2Sb1ZGkovZJlpxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662674; c=relaxed/simple;
	bh=S0ONDjAJ0U06p3O6CCQs2uIqQSw0dHnrm+3VGwJfH5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoZO3sucDeYrbqq1yIqnZJN8374asfhKLvJr8YtJKjV7AVWWdK7e3Ks0g0gBiiIC1LRypGsHf77L1aEN//AlQ0V+fbja3b8vE09xnzLsNXJaWVo5nbOcEv70b5CZKNzQIDN3PFk6MYMUvH5IZNHXbG+KcBpr3fde8R5eYu7dlJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwXYmYg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwXYmYg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CCD1F000E9;
	Tue, 21 Jul 2026 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662671;
	bh=umRKk2KsiFU8Dw0eAZRdQ12l6RkDzEbJI/d5lhbtLsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwXYmYg4xKod2N1sX//m/kb9u+6lQXb8ravpS6AvKcUqBAqRYc7igDwYaqjGCPNfe
	 D6sArKCp2TI63Roqyg27vUHSAA7SOEuEIfBFkdawa9+xuzm2C4xrdML1hnhBOTROQV
	 axyDUCsmUFk77QyLAuH5R1gFoExdjYmwmv7s7Rag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0533/1276] PCI: mediatek: Fix possible truncation in mtk_pcie_parse_port()
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152458.051145828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit ab4a4043db1fcc4fd4c5745c5be8caf053502e29 ]

As reported by the W=1 warning below, content of the 'name' variable might
get truncated with the existing size of 10 bytes. Though it is not
practically possible to exceed the 10 bytes size, increase it to 20 to
silence the warning for a clean W=1 build:

  $ make W=1 drivers/pci/controller/pcie-mediatek.o
    CALL    scripts/checksyscalls.sh
    DESCEND objtool
    INSTALL libsubcmd_headers
    CC      drivers/pci/controller/pcie-mediatek.o
  drivers/pci/controller/pcie-mediatek.c: In function ‘mtk_pcie_parse_port’:
  drivers/pci/controller/pcie-mediatek.c:963:43: error: ‘%d’ directive output may be truncated writing between 1 and 10 bytes into a region of size 6 [-Werror=format-truncation=]
    963 |         snprintf(name, sizeof(name), "port%d", slot);
	|                                           ^~
  drivers/pci/controller/pcie-mediatek.c:963:38: note: directive argument in the range [0, 2147483647]
    963 |         snprintf(name, sizeof(name), "port%d", slot);
	|                                      ^~~~~~~~
  drivers/pci/controller/pcie-mediatek.c:963:9: note: ‘snprintf’ output between 6 and 15 bytes into a destination of size 10
    963 |         snprintf(name, sizeof(name), "port%d", slot);
	|         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/b835e360b42c5e0994f9301a34dbdf140a8d3ef5.1772493898.git.ryder.lee@mediatek.com
Stable-dep-of: ebc1d9906894 ("PCI: mediatek: Use actual physical address instead of virt_to_phys()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index f63a5c7a59e682..3ce6830d279f91 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -916,7 +916,7 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
 	struct mtk_pcie_port *port;
 	struct device *dev = pcie->dev;
 	struct platform_device *pdev = to_platform_device(dev);
-	char name[10];
+	char name[20];
 	int err;
 
 	port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
-- 
2.53.0



