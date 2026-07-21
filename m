Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30713BED63;
	Tue, 21 Jul 2026 22:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671910; cv=none; b=j5rsjYdOxVyOfx2F1rP8QeXagAhUGgMseYAdc5QoWQe86dPOXlU0S5bJMhJsoxwO3JA39r/rYsV1O2mmxhxGvkHjMhBSYDS8S+CEuCToA9ruZX7B3dcH5f5Slqg0a5HuA/ccEqDlxFW4tFXwvBTBpO83ULanCugtfFdg3ZUe7Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671910; c=relaxed/simple;
	bh=dd7951R+yJBO/i40WMt5Ksigxk5t+39Nxa3h6yceQSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ity5zxZO+vLXITSlLCvhcJxqUUDrMdUPj9reD28IwtMXxVzobAGAnVfOTSDG7x4iCsVpD8CcrsCDmtR5q5Q746Bxo90XbVPIW2fNraJKqWvzE4swR14PImQothehLZqGP5h9jUriX2bfLIG/dZPF4tu53z8+3MMPHIYisaPsYz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvnkfeIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvnkfeIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A7C1F00A3A;
	Tue, 21 Jul 2026 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671909;
	bh=i/FT7VKgvjQJC5hxx5B3I+C4BuTjFIM+FjzmDcFhtLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvnkfeIk6DUF/OpuSFNglBPVoUqSVuAfVsyNpZ84gPAvGxf5qlnOskgFGGhJ6BY5g
	 JjSSzQi5XtjEgpj9foOMXyW2eVGT1NImG5+WOk9XpbgSyeHUiv7v2zWwTDxkwP3zjF
	 W/s5AxTlOLxCDb6djqdXd0WTzKhOYZvM6Rd3hmwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/843] PCI: mediatek: Fix possible truncation in mtk_pcie_parse_port()
Date: Tue, 21 Jul 2026 17:21:00 +0200
Message-ID: <20260721152415.594756207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 61bd2052bb05a8..32b58d8a32edce 100644
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



