Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3E15E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grRkzUOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B608BC433C8;
	Mon, 23 Oct 2023 11:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060567;
	bh=ysvA8v46okhoBfGKAUDmqz0fCJC8VKS8jB6nJPyDvqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grRkzUOr74DmkvG8Njf3ltt5muExnjxp6stJM6J3mw7LZwBACoAXr39/+GymiV+ug
	 Qa8Aws28KQJroxix/i9lI8wpU74E4GFlFGM7+ANVcah/Igp1/IMp3qs2yNzHBlhm2E
	 FVgIWqCa4b2ZNiAScG2vY5w9PB1QxzKNLAeaQ2zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 019/123] dmaengine: stm32-mdma: abort resume if no ongoing transfer
Date: Mon, 23 Oct 2023 12:56:17 +0200
Message-ID: <20231023104818.388764690@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1207,6 +1207,10 @@ static int stm32_mdma_resume(struct dma_
 	unsigned long flags;
 	u32 status, reg;
 
+	/* Transfer can be terminated */
+	if (!chan->desc || (stm32_mdma_read(dmadev, STM32_MDMA_CCR(chan->id)) & STM32_MDMA_CCR_EN))
+		return -EPERM;
+
 	hwdesc = chan->desc->node[chan->curr_hwdesc].hwdesc;
 
 	spin_lock_irqsave(&chan->vchan.lock, flags);


