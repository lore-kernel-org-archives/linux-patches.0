Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A07482;
	Mon, 23 Jun 2025 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713704; cv=none; b=sPyOwPnjRtfhqdiePH/dyzm5AGOzHpf7TTCJ/7DtW4CpnyrAwMAFJf1NrmFHq1dyuEX09KN+Tfv3XvcQgBTH5ViZfXyg6WDeAJRyXNM71MDC/S5o0cqYXYipRiiUA+wffYEeb/m84f9idxPG22TVS3oSpE9br2KYhIi9Sl/AtzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713704; c=relaxed/simple;
	bh=dEGsmv5WZmUdNTTZLKSjx2hOysYoAq/vqJRwp5Fg4gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF4AAy6cRxGQNq191Zk5XObDWRmvk5vIl9L1NZU21k6lac7VfSd8mp+jRN0L9WSV/cKYT7wyUdwVdUN1uC8FAnie/D7qCpRB8u6EKwq6YCGxXKdnFwk6m+Y3hRAlSbHO6Cz1tm8FAqNmHnUeKKGn5IADha/mp2OUBQIng0IIG68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9hiBU/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9hiBU/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51590C4CEEA;
	Mon, 23 Jun 2025 21:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713704;
	bh=dEGsmv5WZmUdNTTZLKSjx2hOysYoAq/vqJRwp5Fg4gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9hiBU/Ut5JqRg8lubbIi1ms03Hx8iEBwQze+viIez36bQxZhZhMo/goCybbWjJ/Q
	 20QfiqVZ8SgNAmUdndVVALjZo1vAyZduC3FKTxJECio+OwOXF/+zyQQvbk8MH4ckMT
	 IXW8yRMGrsustqcaPrBpBqSMXjy/kBaWSoUgFESk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 085/290] mtd: rawnand: sunxi: Add randomizer configuration in sunxi_nfc_hw_ecc_write_chunk
Date: Mon, 23 Jun 2025 15:05:46 +0200
Message-ID: <20250623130629.541787391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1049,6 +1049,7 @@ static int sunxi_nfc_hw_ecc_write_chunk(
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	sunxi_nfc_hw_ecc_set_prot_oob_bytes(nand, oob, 0, bbm, page);
 


