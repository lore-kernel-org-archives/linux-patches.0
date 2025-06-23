Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03731230BC2;
	Mon, 23 Jun 2025 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686082; cv=none; b=AmRTtLRtWNY2jkPDw2a5ysG4u0U9EwG8CbZXG991paNmAQVUu11FSBraYdGudEXf9P3106A6CuQwwVTOsMwcEVN2GD49k0wAfAoymXoFafR0EUrhF/eDwO8R4ZoSkgb7U9Fjt7gHVJxt58SpFotwdqbakP6xeYiH3RFnNQdC0/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686082; c=relaxed/simple;
	bh=qdvBTb528ZwcGbgKvyeNOIU5S7DdDc85PSeIh2FAhFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APO+A3ly9jF/Vp8eyH9SqKcO7oITSeuLA0t64j7ke0ZKJMgKS5Qtz+Qem73W2aOUm27TSPGmzi78skgppNJQB76b9EFgsbSR5rjTYyvtK4GP/Uu+WSC7dhkIcBFqxW5h5/9KkjwYHRkBwwJb7kimNll1ifXq/XBfyH0YMS5JVi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAxOWXcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAxOWXcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D230C4CEEA;
	Mon, 23 Jun 2025 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686081;
	bh=qdvBTb528ZwcGbgKvyeNOIU5S7DdDc85PSeIh2FAhFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAxOWXcqLE1uMbW2eOMEzG4WwR8+ABZLCDAKX7b+m+iI2agLYnsSfnniW7EKlbf0U
	 IMn1s/OejqtgwL4mvi5lKL5++ZjZ2NZieph8A4UAsPYeNEl4XKSW/XxrO+ncunCvwn
	 8/XLOgIU9TG9FBtQm+CbjK/NFKfUvT+s39yaW7zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 123/222] mtd: rawnand: sunxi: Add randomizer configuration in sunxi_nfc_hw_ecc_write_chunk
Date: Mon, 23 Jun 2025 15:07:38 +0200
Message-ID: <20250623130615.797856330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


