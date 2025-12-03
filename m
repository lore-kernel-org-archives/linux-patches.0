Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A2D33A6FA;
	Wed,  3 Dec 2025 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777242; cv=none; b=rdLu9LNcnTZvXHvMAXPOQg8tJEU7KIeza3YYhaTJg5MCANYbN+WotDPg7HOfET2EXCIkLPilZLptaS+pwIdiFkhjY/0DaV6ggGrKuHtCy6AmEkwxnEZUnLpS2q1xxZmkCGeP/+RPqwrvQns3Fs+uE1AqgzAxEFcPIPkypZil990=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777242; c=relaxed/simple;
	bh=RaE+7kn5JAhyC3EQhoSqun6hktDBkzs5Ti2kNmFJC0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/JzAqYWRiNL5oRoDBEGV1dc0AhVJllMlKw2Rr2YFgweefAXSuQ65lwFZlGEoi2mfPBhd818yYY8BM9IJHp/uSL6+VC1NfkiopQXQ3gJXrKXDMz21YAQPTQNU9CNlqp3AHE1aXvPK6PjnzbxUjB+FSnp2NdVXsShtf7+NCEKZZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9AasVF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9AasVF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5931C4AF0B;
	Wed,  3 Dec 2025 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777240;
	bh=RaE+7kn5JAhyC3EQhoSqun6hktDBkzs5Ti2kNmFJC0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9AasVF/UcmL47jXDDj+gannct2C0Ba1Y0XT2E5VxtzrOMm9Q06m1KiuXUgiXNKH1
	 uqkIUvUg4LmwQ2RFWDNa3olRnWNJSa/YVsBWHW5u7BQiOAxm8GqadxQWo1QtwbTphN
	 i/QSRMHWTl+Pye8JNXTs0Xm1iTo6KWJdqWO0E8YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.17 108/146] serial: amba-pl011: prefer dma_mapping_error() over explicit address checking
Date: Wed,  3 Dec 2025 16:28:06 +0100
Message-ID: <20251203152350.418728539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/tty/serial/amba-pl011.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 22939841b1de..7f17d288c807 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -628,7 +628,7 @@ static int pl011_dma_tx_refill(struct uart_amba_port *uap)
 	dmatx->len = count;
 	dmatx->dma = dma_map_single(dma_dev->dev, dmatx->buf, count,
 				    DMA_TO_DEVICE);
-	if (dmatx->dma == DMA_MAPPING_ERROR) {
+	if (dma_mapping_error(dma_dev->dev, dmatx->dma)) {
 		uap->dmatx.queued = false;
 		dev_dbg(uap->port.dev, "unable to map TX DMA\n");
 		return -EBUSY;
-- 
2.52.0



