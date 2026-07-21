Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE4E39733E;
	Tue, 21 Jul 2026 22:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674528; cv=none; b=FbWRDSqpV8Tl8nnGJlnTQG5WuvchrvpaUIRb07DZVwBtybGM6XE3yKRnJRJqfW8crsxfkTj6KgZ9dQwbl9ThWVGFLmFZ7Wx1FkFz5hro2XfczmXs74Ibsm9rfEqNO4H7YQRJgunqEOqZYbh/cH/k2NWsHzSTagNa5C1gE1HK2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674528; c=relaxed/simple;
	bh=9/N8lr/MuLvvhNRWqlgOn9x4a00Fy1N8NdAEy7okbkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ0rR/vwvrI00xzxp+I2lKC3SaTnP1R5zHfiJpDnwuockm0kfFzqv3c50bhZT6sCaPlXg6h83m1NArhPoduufYKH6gaEvR8hPYSWUE7rqn5OireMCVmwAIJhNtzWH573gIITTQHLmqIJIC0FteSpjwXr24SqApiP9c8ZxcCivBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzR/L2yC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzR/L2yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE27C1F000E9;
	Tue, 21 Jul 2026 22:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674527;
	bh=i/wHOqO7dYRvdTaBshaicr8JAAGHB+dvETNdc08s/VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzR/L2yCqyWKbw7UXwnqORzixmyCJPLLkfpLXGgqdRi2aCwWJDCdzfWDT87ub0xt2
	 dFo89fvDWk78JvHT5c9BVRg+CjOOQb5kIrUxdXWSAhFF34AUkc3AlW8VtyQujHeN7M
	 39/8bj4PQv49k2294gzSxvYz6e3ccop4nq9Se2wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 574/699] mtd: rawnand: fsl_ifc: return errors for failed page reads
Date: Tue, 21 Jul 2026 17:25:33 +0200
Message-ID: <20260721152408.657311858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit f9a13e05a327080c3a1c8165adf9e678fb68fef2 upstream.

fsl_ifc_run_command() logs controller timeout and other non-OPC
completion states in ctrl->nand_stat. fsl_ifc_read_page() then only
increments the ECC failure counter for non-OPC status and still returns
max_bitflips, which can be zero.

Return -ETIMEDOUT when the command did not complete at all and -EIO for
other non-OPC read completions so the NAND core does not treat a failed
page read as a clean page.

Fixes: 82771882d960 ("NAND Machine support for Integrated Flash Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsl_ifc_nand.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -683,8 +683,15 @@ static int fsl_ifc_read_page(struct nand
 		return check_erased_page(chip, buf);
 	}
 
-	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC)
+	if (!ctrl->nand_stat) {
 		mtd->ecc_stats.failed++;
+		return -ETIMEDOUT;
+	}
+
+	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC) {
+		mtd->ecc_stats.failed++;
+		return -EIO;
+	}
 
 	return nctrl->max_bitflips;
 }


