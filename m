Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945B13955EA;
	Tue, 12 May 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608556; cv=none; b=ohwnW8erZe6PYCJ8/ONE7AAlVu/Rb1RLYNocxjwOSD9DKeT53HePyDPGNoK8NOzX5CzeF1SaTd0LTumitTGUwUNyZ+UjQYshB+0KHC0YVFMMESfxjwT1A8ecPxr3gqAqPfMN2GfbP5vxqVpL9EiWCaHCxwBd8q0b071CKkPux4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608556; c=relaxed/simple;
	bh=OOnYEchHNIjfK28UJX8Sgt5iDafGO5cTZY3N6n/G7NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfZDHrRRCxDXQEo0V0n9vc7G6EfjUXCSrvHLDpGwfNEP8sznNyu2+5gLhsdZeFEYQn1HCAt7bXca0pCrNTe9rfEFAMVZcLUxlT+LsAahRmTOXEevgzWEaj0JCYfR4WstohG9i6mIYHSKcxeTkyeryAkVszqU0ITgxxqG1syFYGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hY0MDj+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hY0MDj+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2201FC2BCF5;
	Tue, 12 May 2026 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608556;
	bh=OOnYEchHNIjfK28UJX8Sgt5iDafGO5cTZY3N6n/G7NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hY0MDj+SOoFpkQ3qqa5GrkFmn6vI0woU4qQ9D8VFfzSOCFjIgpAIdle8NCr0BRZpj
	 2yiwwsJKBDs6QpeOviAmtIzQHvAbZ+4KeEtOHwCxVf+ujQtsb/HC5wYF38YwQ5aBSQ
	 gz8cpA72fuICHBe5/mnxwpMgUee0ElnRVAV3BZ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adithya K V <adithya.kv@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 083/270] spi: s3c64xx: fix NULL-deref on driver unbind
Date: Tue, 12 May 2026 19:38:04 +0200
Message-ID: <20260512173940.206247114@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1402,11 +1402,6 @@ static void s3c64xx_spi_remove(struct pl
 
 	writel(0, sdd->regs + S3C64XX_SPI_INT_EN);
 
-	if (!is_polling(sdd)) {
-		dma_release_channel(sdd->rx_dma.ch);
-		dma_release_channel(sdd->tx_dma.ch);
-	}
-
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


