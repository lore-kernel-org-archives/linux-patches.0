Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333A21D3DD;
	Mon, 23 Jun 2025 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714660; cv=none; b=Ac1puxFrlHAj0sCQbCrwDLjL0PXx9CQ0n88ewfuzS7Q1eiH80TO8FFnFnCjnbZ6HYVW2/ZUyZAeJEe7qZYfDhzJmbVLdEvIchLonKAf05KmubQFrm4+4Bk4rAP2V00N+jAeSDLHl46ChodoOrGeEbZ/lo0Y/vrjdWo5oqR53pM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714660; c=relaxed/simple;
	bh=yuBVMfJeUuR1E0jzINWMstl+qgNGbmk8+kXmp7i1/XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+McYGDTG3f/zmO/ok85O059pdc+p0dfJHxlQcb7EG4JdkBeS/5ZUHDmO1HnvXyIIwv/HXioW9C8p9hdr+EzmLGt8V+AmtVFpu+QvO1nsWkcYlSXRzZbzxhIbLt96sTy8QRheUpv1zzXDhBSZCr4De49hkY5/je+r1grYfEXf3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnJrymvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnJrymvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78286C4CEEA;
	Mon, 23 Jun 2025 21:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714659;
	bh=yuBVMfJeUuR1E0jzINWMstl+qgNGbmk8+kXmp7i1/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnJrymvu5FmTZ6CbmO/9F3diafnSFQuDxGqp1ENG94YkvfaXxXEgUcbOWBd1YPb2o
	 GNHygD4F3rQjIiFdGlSDnPUU3cH31Jl+wlCmmxEPqSE0q6576Ancfh9U7gQwpnW3uj
	 UMvnn7dAydo82jYtGhPKKZ6K9fBXZOatV8TupbiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 122/414] mtd: nand: sunxi: Add randomizer configuration before randomizer enable
Date: Mon, 23 Jun 2025 15:04:19 +0200
Message-ID: <20250623130645.120858974@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 4a5a99bc79cdc4be63933653682b0261a67a0c9f upstream.

In sunxi_nfc_hw_ecc_read_chunk(), the sunxi_nfc_randomizer_enable() is
called without the config of randomizer. A proper implementation can be
found in sunxi_nfc_hw_ecc_read_chunks_dma().

Add sunxi_nfc_randomizer_config() before the start of randomization.

Fixes: 4be4e03efc7f ("mtd: nand: sunxi: add randomizer support")
Cc: stable@vger.kernel.org # v4.6
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -817,6 +817,7 @@ static int sunxi_nfc_hw_ecc_read_chunk(s
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	writel(NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ECC_OP,
 	       nfc->regs + NFC_REG_CMD);


