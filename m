Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E730131E54;
	Tue, 23 Jan 2024 00:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969104; cv=none; b=KAj8Q5IEyKIWRblLEWsB6pPDessEIEyPIAaHmTls80Xq9h6E+oLS1TQ7GEAjo6/fba8kwr24kYPfwgESxdetYVOjYBOGjvWWAr4ZrcSn+mHx3Zs4PJJYRGMWusUqAjYmUWxDsQ8aMwBlNIuyk24LEvHy83S2TtzoJ68fGMCY9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969104; c=relaxed/simple;
	bh=kwhf1y11i+hlYim/GgvoejXusBqa2/21xXNQ0xStOnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klKMM+MQwOcKfCbLARevGQN9TS6fpDAk5JceC51W0rGy3yrkJ3/zfSEVhFcXjUslD+ImBpO7mc6EdS2/idMtlbUfdWo+1bgWV7cqdOy5aylA+irO/fDj4XDy0AHYdyS0+lbsF65LIyb15+Mzna8WK63Wp54n9R2rcbTAujSJ4fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBaFGpTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBaFGpTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A86C433F1;
	Tue, 23 Jan 2024 00:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969104;
	bh=kwhf1y11i+hlYim/GgvoejXusBqa2/21xXNQ0xStOnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBaFGpTzw/0GeSW0xlEgFgiusLUc7vrT0Nm82mql3du261Cb6jBrX679Hs4rwJYo4
	 uLG5qT5yWhZX9c0ckKfbs/HY07R8KuQ5M/XoI074KCo52eu3JCXYKIB3+DIthWdpWn
	 H1RGTO6DIMfN3n8kNfts0/IHJ0e7ZgvX2hHIkTVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ronald Monthero <debug.penguin32@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/641] mtd: rawnand: Increment IFC_TIMEOUT_MSECS for nand controller response
Date: Mon, 22 Jan 2024 15:48:47 -0800
Message-ID: <20240122235818.827672697@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 20bb1e0cb5eb..f0e2318ce088 100644
--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -21,7 +21,7 @@
 
 #define ERR_BYTE		0xFF /* Value returned for read
 					bytes when read failed	*/
-#define IFC_TIMEOUT_MSECS	500  /* Maximum number of mSecs to wait
+#define IFC_TIMEOUT_MSECS	1000 /* Maximum timeout to wait
 					for IFC NAND Machine	*/
 
 struct fsl_ifc_ctrl;
-- 
2.43.0



