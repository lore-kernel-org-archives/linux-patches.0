Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF10B471D0B;
	Thu, 20 Aug 2026 17:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247899; cv=none; b=gDaqtQPUVZUUJUby4PD4An/9/az73TkeUAS/ksGODP8m/OneUggqnT7wFUAi5Y9EpKTkz/g0mkrDVGjD/WybBRn+UU9HzLbSn694xbB9YLbM/WBZHEFV8ARv0ZSe3x0uLRaPyY20vukSoELPgE0YPqfukPSHg2gNRss8bkE0Ey8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247899; c=relaxed/simple;
	bh=9rdOVEVEoWcFnzSGQTcKLnoSVyFGErVDIKY2soY3J5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8qlAgG4wlWp5HQm7NFLSGz4NySUF6fGJ3TGJhlEEUeZg+yrivISGXEcxFuZgnEUnYT96NWjJXc13k8AtIr5/S9MMy/+7Nog7Eon0QrwTBLg69QMR0DSy5rzFY6rl1UUx0mqNnKytfWgRSpvr21WoMBYzXw3JwiiyKSqgNbK27w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIPa07N+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIPa07N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0313B1F00A3A;
	Thu, 20 Aug 2026 17:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247897;
	bh=JhM44tB4xrtFm17k1ehXwcvzwfqU8K4+aFqoo5Eaqfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIPa07N+L0m5MBAnLQwYKTAK1KntU9hnaxxHdnDvBIfPUmeeHiXGaRFRLUqSCib/Q
	 prnk6p+ecwWWseKoYN99Wpgqsj5E90SWc+SnZm6IbuN4SIHLiMyWxuQYJcQLz3VNOk
	 mk8Mn9eAlE7IdU0QD3lSqx0FYNZwpsQLSOYMud+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 040/303] mmc: sdhci: unmap the bounce buffer before device release
Date: Thu, 20 Aug 2026 16:52:56 +0200
Message-ID: <20260820145254.387244798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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
@@ -4178,6 +4178,14 @@ void __sdhci_read_caps(struct sdhci_host
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
@@ -4232,6 +4240,14 @@ static void sdhci_allocate_bounce_buffer
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


