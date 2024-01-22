Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F500374;
	Tue, 23 Jan 2024 01:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972152; cv=none; b=fClLBRCxmQd1h3e8wdXrbPylrIM4kxzYJNxXFvKczROp8rEoo7DOmKfHFFXw6n95qyat19JYdjzEtHVBdHngGaQGoBUwDh6/45qV2sRwvfwDSs4x7TC5pFcDx3DUwl4sL9310R1U4nizlxY8WU5ifofQ6NbKrNprStAYf7QuDVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972152; c=relaxed/simple;
	bh=AZx4UE4Wq/X1S038gc6JZWjabIWdTrAX8A3Looq4D7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KErGQ59DIvLpDNmjF18IwClz1di9M0IZDN4IplJLl2BBXmb/2oEmZIeBx2CFMDHkroMV9ihFnfUocYzzoSAzxAPzbn35vR+EbkzQeDAm/DK/ZJV7n2+/buzU++mocHVJszAA3HKsM7YB+6FPPpuewqJ1dYRLzcOr1JiFMburij0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJWylD1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJWylD1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF256C43390;
	Tue, 23 Jan 2024 01:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972152;
	bh=AZx4UE4Wq/X1S038gc6JZWjabIWdTrAX8A3Looq4D7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJWylD1Qdi/xFbln/x0a1zpsrrtG982aB5NbueFf4V7ht9afG/TChPEjjz6uDjz6S
	 jAX1b9DhavJ2hZilEy5kDmLOVqexWlSwYwgiex7Za/fYfJzV2jd4OVwJJP+GNVwdfo
	 uWrVHLDcNpcYWuhf5yt01wylQdRCefdoqrgvx4zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ronald Monthero <debug.penguin32@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/374] mtd: rawnand: Increment IFC_TIMEOUT_MSECS for nand controller response
Date: Mon, 22 Jan 2024 15:55:35 -0800
Message-ID: <20240122235747.370600012@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ronald Monthero <debug.penguin32@gmail.com>

[ Upstream commit 923fb6238cb3ac529aa2bf13b3b1e53762186a8b ]

Under heavy load it is likely that the controller is done
with its own task but the thread unlocking the wait is not
scheduled in time. Increasing IFC_TIMEOUT_MSECS allows the
controller to respond within allowable timeslice of 1 sec.

fsl,ifc-nand 7e800000.nand: Controller is not responding

[<804b2047>] (nand_get_device) from [<804b5335>] (nand_write_oob+0x1b/0x4a)
[<804b5335>] (nand_write_oob) from [<804a3585>] (mtd_write+0x41/0x5c)
[<804a3585>] (mtd_write) from [<804c1d47>] (ubi_io_write+0x17f/0x22c)
[<804c1d47>] (ubi_io_write) from [<804c047b>] (ubi_eba_write_leb+0x5b/0x1d0)

Fixes: 82771882d960 ("NAND Machine support for Integrated Flash Controller")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ronald Monthero <debug.penguin32@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231118083156.776887-1-debug.penguin32@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsl_ifc_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/fsl_ifc_nand.c b/drivers/mtd/nand/raw/fsl_ifc_nand.c
index 02d500176838..bea1a7d3edd7 100644
--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -20,7 +20,7 @@
 
 #define ERR_BYTE		0xFF /* Value returned for read
 					bytes when read failed	*/
-#define IFC_TIMEOUT_MSECS	500  /* Maximum number of mSecs to wait
+#define IFC_TIMEOUT_MSECS	1000 /* Maximum timeout to wait
 					for IFC NAND Machine	*/
 
 struct fsl_ifc_ctrl;
-- 
2.43.0



