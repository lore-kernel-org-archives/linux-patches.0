Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398503557F3;
	Fri,  7 Aug 2026 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116595; cv=none; b=W37TykCf1hiGyM3xTOPAKs62KJ57bSvKkxl+vz/12U+t33HooQfBJ2Z62HaMK/7rBxkCyx/B9rsOOjB3t8ZmdA1EnyANePLqyzHsy1fmT/oHZTLMqyQR2cgxnZpDf7BrEGcitHBaUjNlsf2POAdVxnLUL6/BkSI7NbgeIjl8T+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116595; c=relaxed/simple;
	bh=YtLzj/2oHStZ91vCLeVrX1Z1NXEPQKRdLg50W59ikkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj/FgyQXXLw2z09jXejmiiAUwH67uSk+dzORxlCmMb82ehM+wSfhyoXdnEFQC0/+1lArZVWLlSKY64lfE1jWFnMm5G6Ug5en+TV30KQuXBWJioQ4NPmE7ETAlhVQhrprCqjekz8GvnfhqffAaCW9bOk7dwa5pTADbbSlmMzrf9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFhTgH2J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFhTgH2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0EE1F000E9;
	Fri,  7 Aug 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116594;
	bh=+vGzV3q82ucC1UvYrup/TJV2pnkiLqIxhgVSIEROWPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFhTgH2Jhp9lqIPIHlWU64h71xEvYsl24Ee2ssm88i+ROPZ3M7zon49d+CCxK/aB5
	 m+MVMtO4zQH+RTQr6j92r5Q/aj3IdCnqkQRDKSGSyqvCqUsZiEBf7iJpTOxFr8LhZ0
	 Fu6vnvJNqUj+W8RAp0bWuwDywXZEPhsUrqputbE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 7.1 008/438] dmaengine: switchtec-dma: fix FIELD_GET misuse when programming SE threshold
Date: Fri,  7 Aug 2026 16:33:24 +0200
Message-ID: <20260807143428.189272176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 9d12eb98582fec2578d17e025b13740dcfb57d8e ]

FIELD_GET(SE_THRESH_MASK, thresh) extracts bits [31:23] from thresh and
right-shifts them, which is the inverse of the intended operation. Since
thresh is derived from se_buf_len / 2 (at most 255), bits [31:23] are
always zero, so the SE threshold is never actually programmed into the
register.

Use FIELD_PREP() instead to correctly left-shift thresh into bits [31:23]
of the valid_en_se register, consistent with the FIELD_PREP usage for
the perf tuner config just above.

Fixes: 30eba9df76ad ("dmaengine: switchtec-dma: Implement hardware initialization and cleanup")
Signed-off-by: David Carlier <devnexen@gmail.com>
Review-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260317083252.13224-1-devnexen@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/switchtec_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/switchtec_dma.c b/drivers/dma/switchtec_dma.c
index 3ef9286406159..71d9868ce613e 100644
--- a/drivers/dma/switchtec_dma.c
+++ b/drivers/dma/switchtec_dma.c
@@ -1099,7 +1099,7 @@ static int switchtec_dma_chan_init(struct switchtec_dma_dev *swdma_dev,
 	dev_dbg(&pdev->dev, "Channel %d: SE buffer count %d\n", i, se_buf_len);
 
 	thresh = se_buf_len / 2;
-	valid_en_se |= FIELD_GET(SE_THRESH_MASK, thresh);
+	valid_en_se |= FIELD_PREP(SE_THRESH_MASK, thresh);
 	writel(valid_en_se, &swdma_chan->mmio_chan_fw->valid_en_se);
 
 	/* request irqs */
-- 
2.53.0



