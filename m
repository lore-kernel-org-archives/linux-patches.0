Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093F7385D85;
	Tue, 12 May 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607880; cv=none; b=n4T8DXA0bgTT3cEq5zIUsDfGdgAJ4rTtKCpOoOCrqTusKhoPBVF2Sv5YtQ5X0aD5CyQp+YVRXpK23m4vMzjAvV4sJ1mbmnUhauAz/I9n8cqHI+Eu0nd2JAm1eTM8DbCdaig2XC5xOJM/pMhg1tfqy5VvrVocuADgW2CImJ/RGAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607880; c=relaxed/simple;
	bh=U+rsNnYXQaiJJXLGwNBa7BZvoC9krXPzGteWRRYuPPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krGJLAKDF+kmKX4Pi98Mi6XNUrmCjhlEmsflqxNA80fvBuG7Lvg2ds898I578F32QWakNF7wQesMeRfzqEnZ6YqPNKHGf4GpPtX7MCyLP9j7a6i+hRU7QiXu0o2HaGyRRsISxd2LUJAwQRLEf2PJ47yOP82d6K/265iLpnzD+EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbQS4RjF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbQS4RjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95178C2BCC7;
	Tue, 12 May 2026 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607879;
	bh=U+rsNnYXQaiJJXLGwNBa7BZvoC9krXPzGteWRRYuPPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbQS4RjFsde+k8ZQHSWRcoGgDsxLbq1OHF4c5byMnhhp8kbly9e38SeqGkZ3cLHjF
	 HgXgEnS08E1pmYYU7Z+ie+xtSp9DH+/D0/4dMJD0V1DeQ1C13BjBIdnrz4Vg+DNw7A
	 rUwZ+sjaTq5rNUcdm2R9mbe9KP+xy+tQvhtQFq9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adithya K V <adithya.kv@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 072/206] spi: s3c64xx: fix NULL-deref on driver unbind
Date: Tue, 12 May 2026 19:38:44 +0200
Message-ID: <20260512173934.373918884@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 45daacbead8a009844bd5dba6cfa731332184d17 upstream.

A change moving DMA channel allocation from probe() back to
s3c64xx_spi_prepare_transfer() failed to remove the corresponding
deallocation from remove().

Drop the bogus DMA channel release from remove() to avoid triggering a
NULL-pointer dereference on driver unbind.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: f52b03c70744 ("spi: s3c64xx: requests spi-dma channel only during data transfer")
Cc: stable@vger.kernel.org	# 6.0
Cc: Adithya K V <adithya.kv@samsung.com>
Link: https://sashiko.dev/#/patchset/20260410081757.503099-1-johan%40kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410094925.518343-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-s3c64xx.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1404,11 +1404,6 @@ static void s3c64xx_spi_remove(struct pl
 
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
-	if (!is_polling(sdd)) {
-		dma_release_channel(sdd->rx_dma.ch);
-		dma_release_channel(sdd->tx_dma.ch);
-	}
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


