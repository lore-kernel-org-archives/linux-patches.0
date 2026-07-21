Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB323446C7;
	Tue, 21 Jul 2026 21:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669427; cv=none; b=nTXvZ0hnFkZRqOJ2NV3eRn1rt2QEF/7sxJs356vHawqYK2naraThNKygilnxizq9m9rtlveAF7ukJnGCCttL6OTwqDbNLVyLjhNJWSqCgHb75YkC8b5FUVENk962JLrNy2uSEyBKRUiDU06VRtOPWS0NC8I+L1OU03pQWKm1Vkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669427; c=relaxed/simple;
	bh=F1zTNMepap6QWefEzdcFgSRqpxgNYPuyy+kFl2fUavA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZwQGZ7JZ1XZp4gGmiAu2drWwkuDtzbu+tBTHjvOFiyepujv76oqXUb6Bqj5sf9DDtg4n1OFtmPcFhFv4Da60/9XcRG6x6YDpJjGMkPYP9dorPzW/R4hgxejuk/Kdv/Y/SM1d4wv+ikdueP9gL6qEr/VIKu0DQf1ncIz8PJ+VBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMW8s3sr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMW8s3sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9671F000E9;
	Tue, 21 Jul 2026 21:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669425;
	bh=hLQec4G96FpL4kxCeHmSYMcr6A3sBqvKxW+eG022jsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMW8s3srO8URcRnqz/4RzdmVo+/V4lBZeN/PVK+gUgvtZcdqNAlR3EC1DJ8HmD43D
	 RQRGbXNdm79TmUP+PtTFOJQH6tMBdBNoUCwlBNeCJ+YJ0ue3z61I/eGwY3t75+rLA5
	 p7xA2ihSA/lUUYkKeHjPrsKsBVyNTbrBuQ3jCTdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0549/1067] PCI: mediatek: Fix possible truncation in mtk_pcie_parse_port()
Date: Tue, 21 Jul 2026 17:19:10 +0200
Message-ID: <20260721152436.892480861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e3a8461b5ce01..c8c87e8afa6cc7 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -924,7 +924,7 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
 	struct mtk_pcie_port *port;
 	struct device *dev = pcie->dev;
 	struct platform_device *pdev = to_platform_device(dev);
-	char name[10];
+	char name[20];
 	int err;
 
 	port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
-- 
2.53.0



