Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D9C2E0;
	Mon, 23 Jun 2025 21:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714323; cv=none; b=jD3mScUKQeE2+Ej9YyoSeUbIWX781vvUY9XNoGLqRo969uodotABzgWKYy7cOZTSzZbrU6dJtmntIphLPnK4up6Rl4GCnO+grBoIMde4D2w6WMgEeyg/GjzyHP41VK+X+CWbLavJcZQuQjCl0B3KJ7WOtVHAa7wM1dujL/Vv+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714323; c=relaxed/simple;
	bh=nF+fcyq9WU773IWa0Awgs21XXQqMij/bkFq9Vbwad1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihDX33g/qrq0+0WrWvlS2ljDinYreEn2W7rMnMkGLijDbhC/ZwpdzxYV+wSfi0YfjckAPUDiBi85hWhzrLpIiybsKTpf8QBIrz/BuhE9pMU0KKm/i7tPkJbWK0TsVdHuGsILZd67vN4IKAYZ44IqZ1lkjJaYj8Z5HS+4IlMinpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfk4jhn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfk4jhn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB2FC4CEEA;
	Mon, 23 Jun 2025 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714323;
	bh=nF+fcyq9WU773IWa0Awgs21XXQqMij/bkFq9Vbwad1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfk4jhn878lhjPR4s0SwL9f1oMTsOqSeMeJRAAOjF5BNiIMiKaDRa5uLcRrscu0Fh
	 70UGAkp89N16ZBoEoEL6S8eE52AFtWa7FEwy9y1jxrMoIuv6rlrvMMKItWU/Nd0935
	 6/1M6Hcmw3eTKh9/f6Dvdnt7OKZt+aP9rY7E+sug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 199/355] mtd: rawnand: sunxi: Add randomizer configuration in sunxi_nfc_hw_ecc_write_chunk
Date: Mon, 23 Jun 2025 15:06:40 +0200
Message-ID: <20250623130632.647567560@linuxfoundation.org>
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
@@ -1045,6 +1045,7 @@ static int sunxi_nfc_hw_ecc_write_chunk(
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	sunxi_nfc_hw_ecc_set_prot_oob_bytes(nand, oob, 0, bbm, page);
 


