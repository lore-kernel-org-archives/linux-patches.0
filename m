Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC947D93E;
	Thu, 20 Aug 2026 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244039; cv=none; b=tKfd7s6x0jvgVcnznzDXn7/Qfsb9Bgfs/TMApXwLHdQPYkulJjqDJOdz4hJGU8UNNv4j0y5WE5mxq/Q7RlXZn7cMYHHXj0GWQBgwbNo50z2lO0XoHOS+73bf7QKHzuMHx6iKjz+vBY7mekoqS033eC89NU0onNxjzEz9edoGJdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244039; c=relaxed/simple;
	bh=4vbH04918lfadkEUkqIAsRpmWt09MAyqNa7wfZ8L3AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gImp5XBkIvgqnKCzQfx6xdWK3dDGLIW7axmJLigweb3AcM4o4YMTyOk7mMiiKJBaYpaxy07+RI9U9mhIf/YUPF3f3sOigUO7srTJVUcIA1mKR/atzhW5RDZHNR9ezpSioZObRGfamwwQz65X6DslOPI/pj34y5UH5YZ2xknMmp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEuSeXy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEuSeXy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1638D1F000E9;
	Thu, 20 Aug 2026 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244037;
	bh=dEfpM1umlG9jozQVP52hxP4yav/DaSbNnVmdN/VIqM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEuSeXy/Wi0K8jult69DXSfNkTBdJTHHBlMJ2AbEn32t/DFmiIYQponcl7RkrFmAt
	 gtn5VN++nQov5gpkkRdHaS4x+oN2m9p3uMwSJECWN3HCv8xkSBK289g2sIh5OdG75s
	 FyRERTImmhSnunFR8NRy+Fd8Qqxid/mGw7b7jTH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 030/235] mmc: sdhci: unmap the bounce buffer before device release
Date: Thu, 20 Aug 2026 16:54:26 +0200
Message-ID: <20260820145217.349360517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4103,6 +4103,14 @@ void __sdhci_read_caps(struct sdhci_host
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
@@ -4153,6 +4161,14 @@ static void sdhci_allocate_bounce_buffer
 		/* Again fall back to max_segs == 1 */
 		return;
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


