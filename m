Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C213FD4;
	Mon, 23 Jun 2025 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715284; cv=none; b=LMz6zp5fUqfkdc3AHjJXrBNFA9N93IJqDyfhPK+DtuLM8rrxhBDKKXkWY3AKhQafBHr4SD4kY5RnxaFDHKr31LUDft2dzX3MnBn54ChcKBvhPpAcp4lnGiypwXSISmjB057/R5ha0O6ar4Deb97zHavEvGyIzS4LE+5+tk2wAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715284; c=relaxed/simple;
	bh=u3eKzRRqEjmiLbqOzGsFDmKoQ058RwK3dfRhrMswoHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cU+NsyS56aBj8A1G8e+lpiivKczDoSaxEI1PYxU/JRBGv+2A4ijZ1JgpmEggnTmL/5nR/2KjMVjG8n2nLpw9nnybHJTF1Z1GTjfFt0gEEEEyiKS1a9juSywnuNVXUZ2TynWoaBggkA6yOVCfs7Ai06CBHS7eChvcugwA1FX2ZEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r79HXxzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r79HXxzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3863EC4CEEA;
	Mon, 23 Jun 2025 21:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715284;
	bh=u3eKzRRqEjmiLbqOzGsFDmKoQ058RwK3dfRhrMswoHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r79HXxzbcEMD03zTXyIRjWSsArlFy96Prtv9ieiolZUAyow9jYoCZ2RLEgMDDcgtQ
	 7BpI+otal0CPMKTNA+2me50tZzdoiUgX116rhWBnPGOWxkVweQ+N/MV2/x7XaN4Ig7
	 FeAZoWFjIzmiMEYdUMXXknEzVniT0ZEJnpUTg3ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 243/411] mtd: rawnand: sunxi: Add randomizer configuration in sunxi_nfc_hw_ecc_write_chunk
Date: Mon, 23 Jun 2025 15:06:27 +0200
Message-ID: <20250623130639.769076971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 44ed1f5ff73e9e115b6f5411744d5a22ea1c855b upstream.

The function sunxi_nfc_hw_ecc_write_chunk() calls the
sunxi_nfc_hw_ecc_write_chunk(), but does not call the configuration
function sunxi_nfc_randomizer_config(). Consequently, the randomization
might not conduct correctly, which will affect the lifespan of NAND flash.
A proper implementation can be found in sunxi_nfc_hw_ecc_write_page_dma().

Add the sunxi_nfc_randomizer_config() to config randomizer.

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
@@ -1061,6 +1061,7 @@ static int sunxi_nfc_hw_ecc_write_chunk(
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	sunxi_nfc_hw_ecc_set_prot_oob_bytes(nand, oob, 0, bbm, page);
 


