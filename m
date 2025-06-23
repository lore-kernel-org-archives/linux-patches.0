Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF64226D16;
	Mon, 23 Jun 2025 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717006; cv=none; b=GPohmYFJrDkex+qXPwizfvj7wD/J1ibUsF9bGgn06Ffzh7U7cFEvRkJM+sH1aBMTyP7P0dqTW9jCRvBR7hf/OPWR9YBncMgH6STckwoSLN3l6FDnd7deldawTaH1v+ArBXVhnMBJjA3WmEbY2tnza7yOm966Fso7Tqg/aGW7gWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717006; c=relaxed/simple;
	bh=6VlYEcICRamv/xiRV3EQHshopDB4vX9OwoNcA/Imyss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7wDn+zxQ9hTfcLw5qQI7nelpZqQm2d41xPcbvDzRYxGOLo4glNAFAwGhYq5OLpgWufcnXQZd/U6ofsiLi6k/klpCqKGtCaeJSTmIcfCsftf+ixg3RdbViDgZygL7AiF4oR+65gip5xvPU5TK5+dmNBmynZWXZqjdAvtVym0AdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkYp/xu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkYp/xu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7AC4CEED;
	Mon, 23 Jun 2025 22:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717006;
	bh=6VlYEcICRamv/xiRV3EQHshopDB4vX9OwoNcA/Imyss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkYp/xu8wLPAtXfQeZg7qu55XFm1N76XSmuZw9oAZR0/wD8ewB7+ObVqmSc2u+Z8F
	 ohDyFJYgjZg9pAA41F4FiH520uKFP3pH7y+HKxbHBYLHhIGFvEeA206/gXhGHifX8D
	 DPDSG8yZ03X9s80uneOBprz7Eyf3ODXhn6Ytu/0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 353/508] mtd: rawnand: sunxi: Add randomizer configuration in sunxi_nfc_hw_ecc_write_chunk
Date: Mon, 23 Jun 2025 15:06:38 +0200
Message-ID: <20250623130654.041317759@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


