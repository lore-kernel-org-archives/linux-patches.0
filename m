Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67098157052;
	Mon, 29 Jan 2024 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548050; cv=none; b=XCuFGrhGet4TjiFvjoyglWeCGMeQxRoIkCjHEKkEjIqpgzoQT66X8VJdNioxGUWaYfU+YlQhb5id08t9aOAslSYjJQxWqnnFFkLU2PKue76patJJWSMTnPZbmRtW9HeNHssgtitVoX1NIW/Mje6p7iTtdtPXlzCRqFyu91qRBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548050; c=relaxed/simple;
	bh=RDdTbajtQ7EgfgvGuYq4mrrd2mOmbERjn+8MRNIJ/7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdrJtKqwywwe8Ft5bM2j2ypukXXhQEfC+GSf16jq9ZD7tHt4noKAR8kumg7p7lexE33X96jl6l7EITcHUjAjq9AFPWR2f9L6p4U09XCoMqjf14VGHTqr+dRL5n3jNoqPy0qZRf9A+X9zBcbMo8JTc0qnMmpDaCbcXIEX/UXrr+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srAPt7Jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srAPt7Jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1C6C43390;
	Mon, 29 Jan 2024 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548049;
	bh=RDdTbajtQ7EgfgvGuYq4mrrd2mOmbERjn+8MRNIJ/7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srAPt7Jdxr4txxEXau+PokuHuVD2MHsZp9I44FJWNj9y1LYQLO/S1tivIOIHvKumF
	 odaYal0moTdtP8F/UupznugoAeycPRIOmEkuCgxn8M99kBcrvhTaxmYARWT+YPfHYF
	 WKGtCFqt3/mVxMCRAlPDp3QbG4MfItOVu+Xokv8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 051/346] dmaengine: fsl-edma: fix eDMAv4 channel allocation issue
Date: Mon, 29 Jan 2024 09:01:22 -0800
Message-ID: <20240129170017.891119801@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit dc51b4442dd94ab12c146c1897bbdb40e16d5636 ]

The eDMAv4 channel mux has a limitation where certain requests must use
even channels, while others must use odd numbers.

Add two flags (ARGS_EVEN_CH and ARGS_ODD_CH) to reflect this limitation.
The device tree source (dts) files need to be updated accordingly.

This issue was identified by the following commit:
commit a725990557e7 ("arm64: dts: imx93: Fix the dmas entries order")

Reverting channel orders triggered this problem.

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231114154824.3617255-2-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 238a69bd0d6f..75cae7ccae27 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -24,6 +24,8 @@
 #define ARGS_RX                         BIT(0)
 #define ARGS_REMOTE                     BIT(1)
 #define ARGS_MULTI_FIFO                 BIT(2)
+#define ARGS_EVEN_CH                    BIT(3)
+#define ARGS_ODD_CH                     BIT(4)
 
 static void fsl_edma_synchronize(struct dma_chan *chan)
 {
@@ -157,6 +159,12 @@ static struct dma_chan *fsl_edma3_xlate(struct of_phandle_args *dma_spec,
 		fsl_chan->is_remote = dma_spec->args[2] & ARGS_REMOTE;
 		fsl_chan->is_multi_fifo = dma_spec->args[2] & ARGS_MULTI_FIFO;
 
+		if ((dma_spec->args[2] & ARGS_EVEN_CH) && (i & 0x1))
+			continue;
+
+		if ((dma_spec->args[2] & ARGS_ODD_CH) && !(i & 0x1))
+			continue;
+
 		if (!b_chmux && i == dma_spec->args[0]) {
 			chan = dma_get_slave_channel(chan);
 			chan->device->privatecnt++;
-- 
2.43.0



