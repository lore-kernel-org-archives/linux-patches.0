Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8148E14288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1ebgt0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07BBC433C7;
	Mon, 16 Oct 2023 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467788;
	bh=USCZpY/g7MesCQZRiLMLYRWjSLxeK56VyOmHPaaHwng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1ebgt0eF/F7YO5Bzi+lWsNf0asXOKz23QBu84Pccllcud3msFXdTFi2SIjKFze+q
	 WT7XClHfgpyXXlMz4c/w7XJRFwVnLw7iH9IFW1wpALqq8v3TgnJxpNAmUGItdBibQ/
	 +D7olLdt4k/dMCmgbL2bvcsb3Yr6F5OOEC115xEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.5 094/191] dmaengine: stm32-mdma: abort resume if no ongoing transfer
Date: Mon, 16 Oct 2023 10:41:19 +0200
Message-ID: <20231016084017.588155772@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit 81337b9a72dc58a5fa0ae8a042e8cb59f9bdec4a upstream.

chan->desc can be null, if transfer is terminated when resume is called,
leading to a NULL pointer when retrieving the hwdesc.
To avoid this case, check that chan->desc is not null and channel is
disabled (transfer previously paused or terminated).

Fixes: a4ffb13c8946 ("dmaengine: Add STM32 MDMA driver")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231004163531.2864160-1-amelie.delaunay@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/stm32-mdma.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/stm32-mdma.c
+++ b/drivers/dma/stm32-mdma.c
@@ -1237,6 +1237,10 @@ static int stm32_mdma_resume(struct dma_
 	unsigned long flags;
 	u32 status, reg;
 
+	/* Transfer can be terminated */
+	if (!chan->desc || (stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id)) & STM32_MDMA_CCR_EN))
+		return -EPERM;
+
 	hwdesc = chan->desc->node[chan->curr_hwdesc].hwdesc;
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);


