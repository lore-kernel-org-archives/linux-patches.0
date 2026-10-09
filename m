Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519E94E4C5D;
	Fri,  9 Oct 2026 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557174; cv=none; b=VZd70Rahi4qjzQ02xfb2MZy033j2Z2wu9KPEcXbZhCGHJxGkzxOajY7WsStVO2rFx+nnr1PbO5+uS5d1SAVAlmWSat5gvS6VsJoxWPqsX6nhCCBv/s9cZIHhvoOT/k2uNQOy1ZJtvrRx1z1QgzmNlZ+jwysyqXj3Z5U91rwZi0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557174; c=relaxed/simple;
	bh=7MMuD3d/CrCH/fY2sInrI6aRrW/GCe1zLx5dAmzCaSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9BlwhBIt62jyltC1bxEJZcFGYPyDkcrUmriYJOPOTUy8lqxO06LiR8FkaT0nbPa1/hb+24KJecXapbuCvmQkfktW1Ljip+Sxexpj/8qF+MWV5Hqcz/fTimkTj1LrOnIX5uyd6XCRS/h6xOJtafp3Ml1RyeGZwmjt6ZTPQr1ecA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXTbsTzj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXTbsTzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776F91F000FF;
	Fri,  9 Oct 2026 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557173;
	bh=1QPAqWcu0/9Oc+g8hPcn8xBA0ii7RHrGedpr+z2Z95U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXTbsTzjJctawardr3TF495RctIi3CtgSdPFbpIr3axW/ILRHT6JM7aEK8ErBdjpx
	 YrzL+GkhlFBq80TZLp0yTgGv5Kve6J41ac/ZD+83tLH2XfNrZbN/d+wczJP/8Mn50Z
	 7XjYNl8mBvG94S/HFsF8MoFZjO9Gy9D0yCL7fd14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 307/428] mtd: spinand: Enable QE on all dies
Date: Fri,  9 Oct 2026 16:10:44 +0200
Message-ID: <20261009140952.862900136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

commit 63d6cace2c4a7f36c1cb44f1bb5e0f3ef19e5c7f upstream.

The QUAD ENABLE (QE) bit is stored in a per-die configuration
register on some SPI-NAND devices. When a device contains multiple
dies, updating the QE bit only on the currently selected die can
leave the remaining dies operating in non-quad mode.
 
Iterate over all targets and update the QE setting on each die
during initialization to ensure consistent quad I/O operation
across the entire device.

Tested on ISSI IS38SMW04G8B.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -281,8 +281,26 @@ static int spinand_init_cfg_cache(struct
 static int spinand_init_quad_enable(struct spinand_device *spinand,
 				    bool enable)
 {
-	return spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
-			       enable ? CFG_QUAD_ENABLE : 0);
+	struct nand_device *nand = spinand_to_nand(spinand);
+	unsigned int target;
+	int ret;
+
+	/*
+	 * QE is a per-die setting on some devices. Program each target
+	 * individually when enabling or disabling quad I/O mode.
+	 */
+	for (target = 0; target < nand->memorg.ntargets; target++) {
+		ret = spinand_select_target(spinand, target);
+		if (ret)
+			return ret;
+
+		ret = spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
+				      enable ? CFG_QUAD_ENABLE : 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int spinand_ecc_enable(struct spinand_device *spinand,


