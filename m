Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07AC3B71A0;
	Tue, 21 Jul 2026 21:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670486; cv=none; b=Wk9Uo7tY9fHIbNrvViyZ9yD7FnpEZQrPVkESFs0K+orSwYzBZ2MAB0xdhaFoh4elxIatAm6lQygKCGhuN6j+QXb0L9w+9v3zvqxRaSJZfXmhh43eq7LhPh/DYsA4iYCrsqqcpbhT0fMTUJTXhRzOVP14xs0yOf1y7RJcV2hF4wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670486; c=relaxed/simple;
	bh=fYN+DjVQ5WKoDEkuD4D+bZeRHRAiMgn/t8ZgdoeA40Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gebd4y8fw/gKFlKzL8/1febbzYrTvqaM/IzQE+zuWHsRiuQDQg88FEuLp4CVZpSPvOSjLzd7gqSCyv1YrgZfWL96QVU61PySONSuJk+s0ecxtT1vr+JZCjwbiXQN8247qkozlSE+kyjuVE1x/ygyYdMrj+/6tNp02l2nwrVN+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwkaJE+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwkaJE+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF001F00A3A;
	Tue, 21 Jul 2026 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670484;
	bh=dvvF1WfAStGwHfaRgcVdDmxNTk1fS5wZFp2B7j1373Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwkaJE+79IMOfGwh7g3e/HzlCwn1B+372+0xr8pCZGRGQz6HgsR2UYwgIZdqaiIfl
	 vi6xENtlKQau95AaAIqQLSzJrWBfdWtusP9xFo2VcJe1iEIwv5HJAl5pLlzqIa8t1q
	 ng7pTdagIk2d+Q4j75jw2jkjUp6qFZj36phX8N7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0933/1067] mtd: mchp23k256: use SPI match data for chip caps
Date: Tue, 21 Jul 2026 17:25:34 +0200
Message-ID: <20260721152445.403186882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit d322e40f4edf92bf0ca329e5aa4ae1c0316feb38 upstream.

The driver stores chip capacity information in both the OF match table
and the SPI id table. Probe currently uses of_device_get_match_data(),
so a non-OF SPI modalias match falls back to mchp23k256_caps even when
the SPI id table selected a different part.

Use spi_get_device_match_data() so SPI id-table driver_data is consumed
when OF match data is absent. This keeps the existing default fallback
while avoiding the wrong MTD geometry for id-table-only matches.

Fixes: 4379075a870b ("mtd: mchp23k256: Add support for mchp23lcv1024")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/mchp23k256.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/devices/mchp23k256.c
+++ b/drivers/mtd/devices/mchp23k256.c
@@ -188,7 +188,7 @@ static int mchp23k256_probe(struct spi_d
 
 	data = dev_get_platdata(&spi->dev);
 
-	flash->caps = of_device_get_match_data(&spi->dev);
+	flash->caps = spi_get_device_match_data(spi);
 	if (!flash->caps)
 		flash->caps = &mchp23k256_caps;
 


