Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04F43D34BC;
	Thu, 15 Jan 2026 18:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500015; cv=none; b=B1rlCbmTv04/v/FKj3+ZAWqDge+InktUnnnQGYHNPNPWzUxH/KZuh4Wy6fpdQLT5NDDrxwiNlN4t6iTvB6Gxkm/U1q/9LfZ+wAUo1IW5o1v8PlyogV9hOCrfV6uxev8M0njrqkZ9qdrbi2nR25abadl17AFLmX06boMPyUkNiKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500015; c=relaxed/simple;
	bh=CEQHEHS+kp72/UPYFyw60ULHNiZoob+585H0eN6g2ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWkA6hfpBR0bca2DVBbsKadWq7QMr287LvX0Bs6aNbHMW9HVVAsgH9M0t1QCBB1QRzS1cH3/dV4D6wev2GPgF/Klr8/gfTpYCQOXQoFtxsF/iRQ5G3lsJxVS7WHz0bZpp4FgA8a+cKb/+YCfntNoBNsBB7h4Qnp9cLQcF8edCi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLGbUw6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLGbUw6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F73C116D0;
	Thu, 15 Jan 2026 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500014;
	bh=CEQHEHS+kp72/UPYFyw60ULHNiZoob+585H0eN6g2ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLGbUw6wvDn+1aSb9BQwPj2IXJdYNqUEYnCzbhbxgaxqyT4B9Bjk07hEPMvlrHrk3
	 kwfUaPn0/2CpObCw+OmRJcBcxXF5aqBJeYPv2VLwXOsqkV5qD04KGFxOU06NBBB2GS
	 JQoUmJCKAAi19+6lwt8WuKgD5ZquP1TAyBuUKgUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 411/451] net: 3com: 3c59x: fix possible null dereference in vortex_probe1()
Date: Thu, 15 Jan 2026 17:50:12 +0100
Message-ID: <20260115164245.808061978@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -1471,7 +1471,7 @@ static int vortex_probe1(struct device *
 		return 0;
 
 free_ring:
-	dma_free_coherent(&pdev->dev,
+	dma_free_coherent(gendev,
 		sizeof(struct boom_rx_desc) * RX_RING_SIZE +
 		sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 		vp->rx_ring, vp->rx_ring_dma);


