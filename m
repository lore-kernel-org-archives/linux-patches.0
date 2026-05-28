Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF5F2F9D85;
	Thu, 28 May 2026 20:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001257; cv=none; b=DHxw51mgoy3vzRW5kLTuHgxa5a7dU5sc73LzqS5+qId5yCCIHXNBQyLlQxw+ZzWGZltRaUNkPD6aCwMovYUkfT8tsbOApEGGinVTS4neIfX62H9RV4KkeU5NyxhnwEUqiyN+IbTB2I73Sd61/CcwVjfRzs0FMLB3acIIgoB0rRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001257; c=relaxed/simple;
	bh=w8bj23SSJXLlMajD/g6TqpdFSLKif4xJxPH3DRFbj1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8ouBJbeUUKcdb0CvTyWO57zxwMzukM5aluruMYqwSQCluaoNASPfFwcfA2ZCSY3zbYdRokWFm3PMhzjFgPquMEF2AZ5PwJ/n+8E4POoJePienn4lhdv3NG61kmng7inNr4Cpp/iCPJSUHuhFrd1ldCghX1YQhjG6PSxdSV0G3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flwJcDP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flwJcDP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E911F000E9;
	Thu, 28 May 2026 20:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001256;
	bh=rnlthpMlU797uSokMGtDgELRK25t+Ptz2r7R5G+klPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flwJcDP0hunHUKSGOjdhTlC3MVzT1So8nKsuWFDALWi5uqP/qwtfsgj1IP47d55Bc
	 U33MysRiIEkdCR+ttxNCM/8i36B9/qaGLMdfvEldiFSvmyytXnwAeHQxc6+mYN4mVQ
	 faI8D7kVmht5S3/0/aYPCydUkQYXa92JybWQE+QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 062/186] spi: qup: fix error pointer deref after DMA setup failure
Date: Thu, 28 May 2026 21:49:02 +0200
Message-ID: <20260528194930.639014723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit a7e8f3efd50a165ba0189f6dc57f7e51a7d149db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -967,8 +967,11 @@ static int spi_qup_init_dma(struct spi_c
 
 err:
 	dma_release_channel(host->dma_tx);
+	host->dma_tx = NULL;
 err_tx:
 	dma_release_channel(host->dma_rx);
+	host->dma_rx = NULL;
+
 	return ret;
 }
 


