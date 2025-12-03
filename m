Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9DB352937;
	Wed,  3 Dec 2025 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778493; cv=none; b=koJZRDcYhEpPEaZCrBAUZuc12W0cSKHusGcwWyce0ro7s5nhGvsa7R5VFzuwSHdSWMcpkZwA7ID1B2+oCe+40oL1wqFE8jQO3T0L7/2f/UXRkjskxwyJAUFk9yaR1G8s2yLMZSpzolYMzUz5VwvkGFIdZBk5IrPPFwv5VR5TYkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778493; c=relaxed/simple;
	bh=Ba/nJO61IAF3vBgEcye/g/oS+PtwKOzn6vPMpizAkWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBV70Ld6tH6+AsC/4ojuV89a8/ooln/TovtxPapkpKEC57KYFMn2GUXLj7NoqZzjywp1aDuRm9tyP9cnBWS0Ut2Lt2eL6lGPSSoQY0Qj4CJi54Bhp2Qy2Pu3kCnM8Fq9DZS6MpaKEF3WEMP8OWqHxHdi1LssrpetMcSqW+5nPxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aS8EUwGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aS8EUwGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCDAC4CEF5;
	Wed,  3 Dec 2025 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778493;
	bh=Ba/nJO61IAF3vBgEcye/g/oS+PtwKOzn6vPMpizAkWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aS8EUwGyVEiVHk4LpK2TYLodZnuR4LQFfrsqKFvVHL4E5+U6oGy/ZHx2Z0LXb97nH
	 HZO9PExll2ds7HJmfSumjxEhgwZ58Db1RwW9NnX6SsimQy5zV5ZSKP5xTlGbXYP2WJ
	 mlAXcW9y8NwRYe3RjDXeO7TjtDVpNZsbmDeyh0vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.15 363/392] serial: amba-pl011: prefer dma_mapping_error() over explicit address checking
Date: Wed,  3 Dec 2025 16:28:33 +0100
Message-ID: <20251203152427.522865507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit eb4917f557d43c7a1c805dd73ffcdfddb2aba39a upstream.

Check for returned DMA addresses using specialized dma_mapping_error()
helper which is generally recommended for this purpose by
Documentation/core-api/dma-api.rst:

  "In some circumstances dma_map_single(), ...
will fail to create a mapping. A driver can check for these errors
by testing the returned DMA address with dma_mapping_error()."

Found via static analysis and this is similar to commit fa0308134d26
("ALSA: memalloc: prefer dma_mapping_error() over explicit address checking")

Fixes: 58ac1b379979 ("ARM: PL011: Fix DMA support")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Link: https://patch.msgid.link/20251027092053.87937-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -640,7 +640,7 @@ static int pl011_dma_tx_refill(struct ua
 	dmatx->len = count;
 	dmatx->dma = dma_map_single(dma_dev->dev, dmatx->buf, count,
 				    DMA_TO_DEVICE);
-	if (dmatx->dma == DMA_MAPPING_ERROR) {
+	if (dma_mapping_error(dma_dev->dev, dmatx->dma)) {
 		uap->dmatx.queued = false;
 		dev_dbg(uap->port.dev, "unable to map TX DMA\n");
 		return -EBUSY;


