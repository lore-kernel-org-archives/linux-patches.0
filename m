Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F091C1F1538;
	Tue, 26 Aug 2025 12:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212954; cv=none; b=JV72frEmEUFMjZRQX3fpyCetp1tKPyong9Bn0Xe8Nrgq7mWKYjQ2qtBDTsKRERXG8MH2k9jJlyM/rsfdCbWmlDQPPXHMnqD5YDMp4lHwTzOi2aTXpFnBCUKJenSRGBKBUolqEBaNBGGPE3i5or5Z8x7QFwofd9OUhgekNaBoZAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212954; c=relaxed/simple;
	bh=XVh05h5ECCrzW8YhMPt9MRY/GCynD+MEtckNA4DDCoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tz0mqWYHNTZvf0QmtGsfV5n8tbF0W3OAshWQTiYC5bnOahqqF8zo9qf0CNF2wU6Tyl0k/vege3jwz4OkYtYwN/32XImf8XFK0pfLSsW/IRC9cOJuqxDdAxyDz71Vo6pkax6Ap8tmDhQnQLoSsfmJ/jAg9An2S3e+fEwOCnTokQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seid9e9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seid9e9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAB8C4CEF1;
	Tue, 26 Aug 2025 12:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212953;
	bh=XVh05h5ECCrzW8YhMPt9MRY/GCynD+MEtckNA4DDCoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seid9e9aAnUfTB4BJHQIry+dExNRxTdUP7QCxrx7DWDJxVas3thJk07u0Bj1HyCz7
	 kbd4aFlqmb7+jtnkECvjwIEn7O8RMcO+b6eWFmyokknqOlt44byH46NfDosKmAkDUV
	 RKmvKt4+r4wNUUF6qj7yxYxu/EmkxzWVNTxNDrEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/587] (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer
Date: Tue, 26 Aug 2025 13:05:15 +0200
Message-ID: <20250826110957.168319013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 760b9b4f6de9a33ca56a05f950cabe82138d25bd ]

If the device configuration fails (if `dma_dev->device_config()`),
`sg_dma_address(&sg)` is not initialized and the jump to `err_dma_prep`
leads to calling `dma_unmap_single()` on `sg_dma_address(&sg)`.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250610142918.169540-2-fourier.thomas@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
index 4a25b6b48615..f1e353fc6594 100644
--- a/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
+++ b/arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
@@ -240,10 +240,8 @@ static int mpc512x_lpbfifo_kick(void)
 	dma_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 
 	/* Make DMA channel work with LPB FIFO data register */
-	if (dma_dev->device_config(lpbfifo.chan, &dma_conf)) {
-		ret = -EINVAL;
-		goto err_dma_prep;
-	}
+	if (dma_dev->device_config(lpbfifo.chan, &dma_conf))
+		return -EINVAL;
 
 	sg_init_table(&sg, 1);
 
-- 
2.39.5



