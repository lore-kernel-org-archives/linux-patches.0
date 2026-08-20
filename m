Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE98361640;
	Thu, 20 Aug 2026 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238244; cv=none; b=fvHIa08d7tN/zdcS8pZuFXvHcs0iggy3TNh+4ajtTSH1zn2eR0xkYpb0fpax9Lae991EOWmjzSEsoQu24jh6JETu9egwnGjtR3ORyNvPaiBoIZwBh9D9nnxlLESI/S+a8PhZxKtI/owN3K4YjN4nmsFExFv0R2c2X2oMfeXagmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238244; c=relaxed/simple;
	bh=gNs6osjmuqnCHA6tqLISe96eQXELf6OGpAE+fxp3cLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6vruP1N8qMcCAi6YBrPllnBEBXmVt6sXVyHGUWOr/UavTlVcbOU446Up09Q4BqtEd8WEVz2tz97dk5Vo+57RCzPQvrQ1k9aOM/806YuY72a1NYSnPe4+qDgbA+H1vhM6Wgx/aPAUYGbNXY4fLBI7En7ORiRVZ4NFoLv3hGSrec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqh3JDeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqh3JDeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E161F000E9;
	Thu, 20 Aug 2026 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238243;
	bh=t/BfC5fWyZ9pfiZRuGPAO4Z0rYqvFmCHpVOADUhMyEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqh3JDeP3LOL7QswKLQDecqkinvW+N8bDh2oFIiBrDOeVjeBuKtkL3YGpQ6uUt5oZ
	 MfEN1esLx/69nzWbC8EwD/02gualZe3ZFLUKdfL8G/JtRWgIRDs+5XzIMWDRLdGOYO
	 2mwIuLB03490ilX7idu/IWrBvbFa1ZGnXNh2nWME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 080/228] mmc: sdhci: unmap the bounce buffer before device release
Date: Thu, 20 Aug 2026 16:53:42 +0200
Message-ID: <20260820145246.905334343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4247,6 +4255,14 @@ static void sdhci_allocate_bounce_buffer
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
 
 out:
 	/* Lie about this since we're bouncing */


