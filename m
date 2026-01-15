Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2EC396B75;
	Thu, 15 Jan 2026 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495992; cv=none; b=FR+rEZOIaof1Qk/kGt8jP2nLDQxzZ46zv5UXg4sLcCnuL1gNUxNb1FIoVBP4NqRHJzjTm5CLtQ2ZMG+RqlxZsum1Gj64WUQCLY8fyRR9RxvCYcYQ64ZZ2ek1p4lvZwSWQRYi0pSCB9uZFN8uNmQjm7gohjP92z9FAfAitW7/MII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495992; c=relaxed/simple;
	bh=fljk6v1rlmjEHwgb6Ms8rOD2KPdoYn80mH/WIf+8FDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVB2nOvCgokhKJSZZ+atad63KPlhDkxD/YmmYfcnHpm1T/76V8WyVvWahfvE+Ydm3ncAHurbUFDSGw1bQjvb6SwTmkGoeHO/DqUkrZCBGD9oQ0d+dTBkjZclamZa7Dc6A4fpiIBZZxYLRGGr2OXNU/rK8bIk67QGqr1IVb83Fpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQm4JTbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQm4JTbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A70C116D0;
	Thu, 15 Jan 2026 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495992;
	bh=fljk6v1rlmjEHwgb6Ms8rOD2KPdoYn80mH/WIf+8FDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQm4JTbpqy6uJscIPx8RlcYPxai6mtqp444lyiXZuwMRTMUJp1iEyKGJ96Ez7kMTZ
	 +IlFLeY31Uy5tyI2Zgv7LUL4GygAY2sBhRDTrGbOF6IHe7nuaER2FJVcX9nJemFvUn
	 VaDDlBcms8nu94gg5SMAsKGQA5gipZl/FI4WSHEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 008/181] net: 3com: 3c59x: fix possible null dereference in vortex_probe1()
Date: Thu, 15 Jan 2026 17:45:45 +0100
Message-ID: <20260115164202.617538287@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit a4e305ed60f7c41bbf9aabc16dd75267194e0de3 upstream.

pdev can be null and free_ring: can be called in 1297 with a null
pdev.

Fixes: 55c82617c3e8 ("3c59x: convert to generic DMA API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260106094731.25819-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/3com/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1473,7 +1473,7 @@ static int vortex_probe1(struct device *
 		return 0;
 
 free_ring:
-	dma_free_coherent(&pdev->dev,
+	dma_free_coherent(gendev,
 		sizeof(struct boom_rx_desc) * RX_RING_SIZE +
 		sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 		vp->rx_ring, vp->rx_ring_dma);


