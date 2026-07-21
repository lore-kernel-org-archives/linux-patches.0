Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F23859EE;
	Tue, 21 Jul 2026 18:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657344; cv=none; b=OdG0tHcxyMTyCzBza2957ZjFkAk/Nw+mVNhvlkVFAMtJrMFBFco8lifCuv5BtAtNonkZMsEQyV0SoOCrNc/7pwZdygpHO8Pc2QEb+7aFFjIJVVhrWndW+sNhJIWZxIqN8cDwrOVJtSGBBxiDd42+A0VeOY/09BA5pmR0fFo3vlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657344; c=relaxed/simple;
	bh=8La4GVnqOQfWcdIsCC1Fpr2Wu98DjqJQySp0FXo99QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdBQKMXIqrPTrqbtSiyMooQSilF7WQqosaYHv91lBFFBprcXrgY53JbL4Ep1FdQ/yigZL1tWOwDYR8YAcXoeNIv9yDYj7llLRWKT0fYCujKDgrXZycotdHXmkLp649zc3tnfxNlyL/y211/glMVs7DP1Lk3COJbqiftSXyeK8B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxdIpP1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxdIpP1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155251F000E9;
	Tue, 21 Jul 2026 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657343;
	bh=h71EzUV18/600109sFylDeD9kVdnhhALlvflPKNEHtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxdIpP1v0Pxl7MPmX1jgIdotnwaHGqUWQbUcszslQeuEgObXKWHTMfDDI1zVQ/x7L
	 y7Bmrti94CJpANPQoeJoWvkTLvxy2aENP8UrK8pFIUrH5coWqPt+eE8SIo+2t05jSJ
	 ZZIeMPGvDkIXaJacJvVHvpsh9lH3QDd43p0EyGyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0728/1611] PCI: mediatek: Fix possible truncation in mtk_pcie_parse_port()
Date: Tue, 21 Jul 2026 17:14:04 +0200
Message-ID: <20260721152531.756535973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 83880840b8764c..cd4be8ec0d03a3 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -920,7 +920,7 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
 	struct mtk_pcie_port *port;
 	struct device *dev = pcie->dev;
 	struct platform_device *pdev = to_platform_device(dev);
-	char name[10];
+	char name[20];
 	int err;
 
 	port = devm_kzalloc(dev, sizeof(*port), GFP_KERNEL);
-- 
2.53.0



