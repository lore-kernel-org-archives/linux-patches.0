Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316CD35209C;
	Tue, 26 Aug 2025 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219217; cv=none; b=WzFSgVYpx4GsflxOiMIMAwv+JqgbdpNiiDa7dYMAFgWSPDLdYmnGsdSm1+oDLV8v4IWcOqIxMeQIW8DZU+nQPZ1ceNJO9jxCXJaa/ko/pHHXcKIX3EcNEWikOmuubfXktRmiqOXpDW/i14Rn5Lsx8Mud0ihmAZfSQb+aiCkUqXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219217; c=relaxed/simple;
	bh=1nuTbwMsNolkP9/tstjpY82W3o26eBNtsA66I+pPX3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU5Z+570TX0/s6snndV6NW2unilhNMs1Zu/0tHs6CdeBQIDjCyq0nld3esqggMoMUW64Pn3LrjCLiR2CZ/lUFSio7s4fRi+Ia4fMflsGYjgkZL+L0G2+TZiXqxyf+3ZJo0wWMhdKd39+tX5mO8B+8dedrX7d7T3DqFAUdD0DU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJHFdOzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJHFdOzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C5C113CF;
	Tue, 26 Aug 2025 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219217;
	bh=1nuTbwMsNolkP9/tstjpY82W3o26eBNtsA66I+pPX3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJHFdOzx5lrHMVnGzFQgN0oHizRm+53y+TshjcJzm/3TLOungpZ8Ga9GxVGromEg/
	 zvZOyiXmOvvhuXSdM/zPc9pq1TBgDnH+cZZPRaaagUS0+n94HUCBr+kmo3/UGBbKB9
	 Z0MO0RFZ+IPaRsWJlx+ogE9G+2ciUT58RUP6ECkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 298/403] mtd: rawnand: fsmc: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:10:24 +0200
Message-ID: <20250826110915.048233659@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 6c4dab38431fee3d39a841d66ba6f2890b31b005 upstream.

The DMA map functions can fail and should be tested for errors.

Fixes: 4774fb0a48aa ("mtd: nand/fsmc: Add DMA support")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20250702065806.20983-2-fourier.thomas%40gmail.com
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -492,6 +492,8 @@ static int dma_xfer(struct fsmc_nand_dat
 
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
+	if (dma_mapping_error(dma_dev->dev, dma_addr))
+		return -EINVAL;
 
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;


