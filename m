Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854921A683A;
	Tue, 21 Jul 2026 20:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664033; cv=none; b=KWlc0OcIl2PID/zogwkMqar9jK0P5HYY4pJhy+oTxlEFKWhg+VcfMFhzKpx9FQZTE0RDLerGxgj9fiTnbY9oUgzI9pwJvtP3FKV39MPmSro/7SW6XANGnrVyjDLQ8aw87at7ZmCLaDzs+JCSv62iXFOoQ5qts/oF2EKxqLZZ3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664033; c=relaxed/simple;
	bh=coZUQtTz27AMCtX4htpDfYtQw1pBZTVOH0E7K0/68WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCBITIvpB0XBnBp8mvS3qTiNu1iA6JzesKRCTMkjNTrx2YGDrFMkOct1g4+UqcP/3LocEKJiN5UmUPxyKlHNmIvjuvjTXukDC36VY4pQ0DwyYTFjgoKZBaiI9IcQGQOTRlk9UZV2ibfT7JXc7pSIRDh12KYLgTXkJygSXS8+kVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5PbOAiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5PbOAiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5B71F000E9;
	Tue, 21 Jul 2026 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664032;
	bh=GSwx7oF8BtMXXXsGE02LzQ6RZbMtTbfp1UK7pB80v3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5PbOAiODcFXMi4PPcvgkhBliHP3F6BI5ekTTV2DAgjxUvzNBCcsTjVI+W+qmPOG/
	 rbBJd+70AvPwFZyYcIhbp5AyEmOxbh9tbKGOz4p1iQfyMQwZjxTVc41kJDyhMV6qtd
	 JUCwAPrqGzYGX4N8vO3VtPQ5VVLV29I08EesumY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1046/1276] net: wwan: t7xx: destroy DMA pool on CLDMA late init failure
Date: Tue, 21 Jul 2026 17:24:49 +0200
Message-ID: <20260721152509.395627952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 2bd6f26d4ce1e87de4d736b1e8896daf3acf1c0e upstream.

t7xx_cldma_late_init() creates md_ctrl->gpd_dmapool before
initializing the TX and RX rings. If any ring initialization
fails, the error path frees the already initialized rings but
leaves the DMA pool allocated.

Destroy md_ctrl->gpd_dmapool on the late-init failure path
to avoid leaking the DMA pool.

Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260621031714.3605022-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1066,6 +1066,9 @@ err_free_tx_ring:
 	while (i--)
 		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
 
+	dma_pool_destroy(md_ctrl->gpd_dmapool);
+	md_ctrl->gpd_dmapool = NULL;
+
 	return ret;
 }
 


