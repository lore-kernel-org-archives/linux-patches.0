Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8627C2E0;
	Mon, 23 Jun 2025 21:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714340; cv=none; b=tVHLdAu1aPynJ2bzOH+eqxyssCf+GWj+fd3T2I+kTb4GMQJp6Ym/nme9oSMIFa1Y48KtLPgn41xLS4vDxoyYkFwrLEFgrYngS5oZRKJaqkbRDq2Thc1raUSSIywlX5j+Yw4tz0Q/AJ2aLsc0Hgf13yMV8c1ubMAa6rvm09FcysU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714340; c=relaxed/simple;
	bh=XfNsirLXXdP9GBpp/QlMr23ztH8j/l7F6QbuyCRNmUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj+KW8OtVKiVGH67HK6KnjCEa6TGPFYNoG16szbRsPtB4owSpJUOQ79ko6KAUQhZ7V19VFICUrF54rBjZQsTWJgRXme4fu1c81T/3quygivI1s1htWEtoIj5TuAx2n6eOHPOu27zXNgu9Y5LMOSwIQTNIdzDJICGS57/wWf69aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2aA4Zm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2aA4Zm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F369C4CEEA;
	Mon, 23 Jun 2025 21:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714340;
	bh=XfNsirLXXdP9GBpp/QlMr23ztH8j/l7F6QbuyCRNmUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2aA4Zm1z2f2V8GEvcrKeidsmNXoU3jh0NvtnIzuq23OiXWDMA+NEqS9wMPCz+Gfx
	 TPQ181RcBIMOU17kqRGM2QC4r9iWusUdC5k6NQj86ayBvvlZqmauVa3O9SXOzdXElL
	 9inuxm/Mhx9nWzz++M4KgR8mjTtYoNngdN/6QflE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 200/355] mtd: nand: sunxi: Add randomizer configuration before randomizer enable
Date: Mon, 23 Jun 2025 15:06:41 +0200
Message-ID: <20250623130632.675992333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -818,6 +818,7 @@ static int sunxi_nfc_hw_ecc_read_chunk(s
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	writel(NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ECC_OP,
 	       nfc->regs + NFC_REG_CMD);


