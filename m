Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D46A169AD2;
	Tue, 16 Jun 2026 18:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634941; cv=none; b=uRc8eKWbTVDkBib4GfksX9NHdEvTFS2UIqav//0xm+uIgMzHbly50jzMbr0fUurR+fhc+7O75eq8W0YpgHzNpYJ60wZt3YE436Dph0VveBvUl6UMpMzmw2NvaFWeOI/OlwJi4kTaYCTzvoRf7vRAUN46Z32lFWGItGYCW/xHj10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634941; c=relaxed/simple;
	bh=gg2YkY/VgueBvaaEY4XCEd24Q8WHh3QuwgJeta00f4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chM0rSHzGC5l/Qq53glXSO5IELNYSs8tC+Uat5KHnSd8VDEUTw8dem5wvUYbLmVEQvnGW1/kGkM30/vhF+wMyiyQnhEYqXhcuCJt9xf5utcXIPpJS/iWZ8bxV7jXDS5JVhhD2dLVjI42Aufqr4hZM3CTI3G+4FoUJSfLQdshlC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQJ8597t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQJ8597t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1755B1F000E9;
	Tue, 16 Jun 2026 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634940;
	bh=0AVdeZZPlG4Hrz2w4N1G8udxL5nvQxL/Gyvwpt1In8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQJ8597tAGGUFzEA4QnYc3VGQvavBMj/rYwxbOfWGLb+WJSUgY5BclV78I/ZhaJBf
	 x/wa4B9QtWbD1Ccvodsb07P8e6gQao7DEhRRS24+jPKA385ub/M6yUzh1zGmON5Hhw
	 HxP3Vqe+xIxC5nS3+3yFliUbDucF9b8+5Cvu9CyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/411] spi: qup: fix error pointer deref after DMA setup failure
Date: Tue, 16 Jun 2026 20:29:57 +0530
Message-ID: <20260616145120.404059649@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit a7e8f3efd50a165ba0189f6dc57f7e51a7d149db ]

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to the clear the DMA channel pointers on setup failure to
avoid dereferencing an error pointer (or attempting to release a channel
a second time) on later probe errors or driver unbind.

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: 612762e82ae6 ("spi: qup: Add DMA capabilities")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=4
Cc: stable@vger.kernel.org	# 4.1
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074334.914735-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -969,8 +969,11 @@ static int spi_qup_init_dma(struct spi_c
 
 err:
 	dma_release_channel(host->dma_tx);
+	host->dma_tx = NULL;
 err_tx:
 	dma_release_channel(host->dma_rx);
+	host->dma_rx = NULL;
+
 	return ret;
 }
 


