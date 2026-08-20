Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7037F730;
	Thu, 20 Aug 2026 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238864; cv=none; b=RjvR692h4yzL6cQrXBhpzXQix9bEeceF8qBQYTp63V51MUx6+hIStpqAzDZ/32EgU9rdcmRXRLIHJXx/uCnSE6SbPsoEjzJ9emFIM0yEVqC4iposozYsDyJUbZTNPJIG2WiEK7VUx2VMF1GHyeHkhDgS1Y3j6q0SIu8l1tGBU9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238864; c=relaxed/simple;
	bh=2GHNOgz5w0IsUI1X+Yr/Yd4JFOSBbsFSWgmhnxJP7mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvjE8pq9ZoT8F3Bk0+/iM0W430jQYg0IyG6hDXFyYMWQoAxhUa0KlWBD8cuGoMiHV1rTG4BbEJqjETs8FyfSIZTmPl6VnVr+VxKVZ5U0aopyRJbWgZNpNbkh9T82+Hb5o+an4p3A4wPF14DfLwVidn8CLvZ4YLWTyCJWXkHktxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HE81hNab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HE81hNab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428B81F00ACA;
	Thu, 20 Aug 2026 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238863;
	bh=pTCG78ZjZ7sH4WJ9ExFyvt0MpZhydx19Gt5WgEcsUHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HE81hNabQgFAjPTgdsIZc5nIdTHwQp/wtnOTo38qnkzHnEhIKV4jb06d7eNGv+Uuv
	 I2TXmNIbtNkG4JadjBhYMLKxrN4Eoq7ppJWPEUovOVJOO2GezsY/STqgXt9QnXouQQ
	 NtBaoSve8V3+qIMadxVeGXSU+Z9V672kCJNvzOc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 066/217] mmc: sdhci: unmap the bounce buffer before device release
Date: Thu, 20 Aug 2026 16:53:54 +0200
Message-ID: <20260820145239.608192833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 9e9f561269dff35e6f84ed21776ec37fd6360b03 upstream.

sdhci_allocate_bounce_buffer() allocates its buffer with devm_kmalloc()
but maps it with dma_map_single(). The buffer is therefore released by
devres without the streaming DMA mapping being unmapped.

Register a managed action after dma_map_single() succeeds so the mapping
is removed before devres releases the buffer. The action is registered
only for buffers allocated and mapped by the SDHCI core, leaving buffers
provided by host drivers under their existing ownership.

Fixes: bd9b902798ab ("mmc: sdhci: Implement an SDHCI-specific bounce buffer")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -4187,6 +4187,14 @@ void __sdhci_read_caps(struct sdhci_host
 }
 EXPORT_SYMBOL_GPL(__sdhci_read_caps);
 
+static void sdhci_unmap_bounce_buffer(void *data)
+{
+	struct sdhci_host *host = data;
+
+	dma_unmap_single(mmc_dev(host->mmc), host->bounce_addr,
+			 host->bounce_buffer_size, DMA_BIDIRECTIONAL);
+}
+
 static void sdhci_allocate_bounce_buffer(struct sdhci_host *host)
 {
 	struct mmc_host *mmc = host->mmc;
@@ -4241,6 +4249,14 @@ static void sdhci_allocate_bounce_buffer
 	}
 
 	host->bounce_buffer_size = bounce_size;
+	ret = devm_add_action_or_reset(mmc_dev(mmc),
+				       sdhci_unmap_bounce_buffer, host);
+	if (ret) {
+		devm_kfree(mmc_dev(mmc), host->bounce_buffer);
+		host->bounce_buffer = NULL;
+		host->bounce_buffer_size = 0;
+		return;
+	}
 
 	/* Lie about this since we're bouncing */
 	mmc->max_segs = max_blocks;


