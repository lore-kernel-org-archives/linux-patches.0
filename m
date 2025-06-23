Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963F248895;
	Mon, 23 Jun 2025 13:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684653; cv=none; b=TmGB67f/5WZrKf9KlP13OnMOkpBKIg/OBDHHJp45rHBdViSesc9cMuG9f++aq1C0AJ2blw1hdDNfChRpWFgI8aL+5ytvf6o0QGoLDNR61vGFep/CfXD7ibtT3aTx67+khcalyoHpEPyLZaYSy0eWKxw1xPLnpH8IZ6DmC8JANPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684653; c=relaxed/simple;
	bh=GDWuN9zw6Tdr9Zg6/6rr9PIeMcKW+s4OeycTmj0OeAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ag3JFwim16eaeXdk4Nf94Nv1HQ+jSeQwbyZmsAxnnFBpeQ3+UEs7Q1iohCfoA6fylGku5pq1alw4KFAogfNJhMlARG9tF4muvim8juC1GOnxEXSAO3ae/nH2FKALhsR4phIVg4nBqPaqzxpUsb6yneybw2+1IGw3WmUy9ypX4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCwyr25u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCwyr25u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E119DC4CEF5;
	Mon, 23 Jun 2025 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684653;
	bh=GDWuN9zw6Tdr9Zg6/6rr9PIeMcKW+s4OeycTmj0OeAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCwyr25u0KuaNouVxCaNergSZ2cw+t9GMEgqrwYtPulJhB+wT9pO1ZAFS0NuWwWN9
	 IcDLvHfvgRotXVtUgCxK9mYxXnxU1c0dYwHuyVuEhNhl+xmTuyRr1XmrBE4WbgoLPG
	 Az4xCFxffPebItXyxo3UdJfMmuN3cYuLccQfPT0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.15 148/592] mtd: nand: sunxi: Add randomizer configuration before randomizer enable
Date: Mon, 23 Jun 2025 15:01:46 +0200
Message-ID: <20250623130703.801130397@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


