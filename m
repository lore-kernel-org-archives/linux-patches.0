Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8715D2B9CA;
	Tue, 23 Jan 2024 00:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968184; cv=none; b=KlrLRbb6CVlkii0k9eLUTJEqSMvQbdXfhdEwwklKRoboSXaq7GUXq1TbEBMpWUOGOqJGQfngUySRrZxZ8Ca7wEhVI+C9EYG8xYBXjHWa29Z2gdYL4/pZn2p9i/ZbP01bVEteeza/G1ME0XG9nfB4fTKqELsC9ngXlQZbgOR5wJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968184; c=relaxed/simple;
	bh=4+iXcYXCK0DOqXDt5cdF6rFaLewDb4HepE+SWLl/sI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNVAqEC+ActAM5rVFANjPBd8ye9AB6411TyG6N5CYGa/m6UXR+DtaCvA1heVYibpjL+880fgg6Fx8hllGzulKtKKAvSjLwbYdys9AFre+jwCRmyaqMP2IgRnOFPDE4wEG2xY+IrDQ81o9HhvWuv8VfDhAWwZq7Zw9VMaywZTw3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOxPpJX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOxPpJX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC51CC433F1;
	Tue, 23 Jan 2024 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968184;
	bh=4+iXcYXCK0DOqXDt5cdF6rFaLewDb4HepE+SWLl/sI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOxPpJX10S6KcbUYJoYQ23r7WeyVdohYEC6Mh0tqnXTuC14u/uRrdHNRl72myZahg
	 RhZrVOWjNnbqR/Q2ja97jc+wE0oMlW0F5ack6/vG5rLDm7Oi5zTHGu2rEaUGA9QMo7
	 KLx2IwuP2BPs1C4OxR6HBNwLVSFKwaIEXBn8T3/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Ronald Monthero <debug.penguin32@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/148] mtd: rawnand: Increment IFC_TIMEOUT_MSECS for nand controller response
Date: Mon, 22 Jan 2024 15:56:33 -0800
Message-ID: <20240122235713.915330439@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 70bf8e1552a5..bdb97460257c 100644
--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -34,7 +34,7 @@
 
 #define ERR_BYTE		0xFF /* Value returned for read
 					bytes when read failed	*/
-#define IFC_TIMEOUT_MSECS	500  /* Maximum number of mSecs to wait
+#define IFC_TIMEOUT_MSECS	1000 /* Maximum timeout to wait
 					for IFC NAND Machine	*/
 
 struct fsl_ifc_ctrl;
-- 
2.43.0



