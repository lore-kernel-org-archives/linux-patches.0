Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E884F190072;
	Mon, 10 Mar 2025 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628556; cv=none; b=sqwUTvXNnFf4QnqeCNjO7fsWKrKEBYbOxHVxuKQB9R8VnLJkSdSi3XNXsmViWcEmXotgeEd6pw/T8xxRlM+MLPwKTgYTEFzHCzYCyREK32kD7icomFNc0YEAGJLlvZBJfUqN/vJh4+cmOhfYWyQ3O5zm9dFsQg/bCnEIrjxYQr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628556; c=relaxed/simple;
	bh=3rO+BPXSerIEIbCGIRQfp96vT6lFM2mJGK0frUR9l3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLDaxHiK3YtxEtxG+Znmbl1hM6M5+wJbljpSANr8L4dMsb2POP3Jnb6AtuQ0a/CHDVv5eqxMcfcvoVNu5cbu39CM84eRywDnfCSodRfZJ+K9/7YaDO+hpSxxKQpUq4UWRuc0rWi1N1O63s4B6bfCPQ3Mwv7UiKghUSgeN3DCp0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqxt2Sja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqxt2Sja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0989AC4CEE5;
	Mon, 10 Mar 2025 17:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628555;
	bh=3rO+BPXSerIEIbCGIRQfp96vT6lFM2mJGK0frUR9l3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqxt2SjaqfL1NMlVAHWN8LWAAYKLyJAyHcJxghJERdi3WAyGp/rcxXM+9vxkR8AAP
	 YSTFJ7ix7h6mKgXtCFXklUNZ/16UEKt11UkblJGI+jEkuydfClwF+asQ/hcKtE0TkD
	 mxO6AkVMJQ76yfAyqPCcruC9cCbQNkc58xhqsqmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Schlatterbeck <rsc@runtux.com>,
	Mark Brown <broonie@kernel.org>,
	Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 6.1 099/109] spi-mxs: Fix chipselect glitch
Date: Mon, 10 Mar 2025 18:07:23 +0100
Message-ID: <20250310170431.498610313@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Schlatterbeck <rsc@runtux.com>

commit 269e31aecdd0b70f53a05def79480f15cbcc0fd6 upstream.

There was a change in the mxs-dma engine that uses a new custom flag.
The change was not applied to the mxs spi driver.
This results in chipselect being deasserted too early.
This fixes the chipselect problem by using the new flag in the mxs-spi
driver.

Fixes: ceeeb99cd821 ("dmaengine: mxs: rename custom flag")
Signed-off-by: Ralf Schlatterbeck <rsc@runtux.com>
Link: https://msgid.link/r/20240202115330.wxkbfmvd76sy3a6a@runtux.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mxs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -39,6 +39,7 @@
 #include <linux/spi/spi.h>
 #include <linux/spi/mxs-spi.h>
 #include <trace/events/spi.h>
+#include <linux/dma/mxs-dma.h>
 
 #define DRIVER_NAME		"mxs-spi"
 
@@ -252,7 +253,7 @@ static int mxs_spi_txrx_dma(struct mxs_s
 		desc = dmaengine_prep_slave_sg(ssp->dmach,
 				&dma_xfer[sg_count].sg, 1,
 				(flags & TXRX_WRITE) ? DMA_MEM_TO_DEV : DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+				DMA_PREP_INTERRUPT | MXS_DMA_CTRL_WAIT4END);
 
 		if (!desc) {
 			dev_err(ssp->dev,


