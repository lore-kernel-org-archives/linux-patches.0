Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54A8837;
	Mon, 28 Oct 2024 06:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097918; cv=none; b=ppG8mpPnL5oci5lJ+1flgbJAuzfd45fSSB8lZDwGXkoBYwiHRUfDpZUsrqmbXtkXo47Y0ohqHBiQYUccj1izyS5Pek1d4ccUdi3ZS4sbe4Jwa//o1WF+QyL8rrwlXLlLTcDNqHwXG8nmDZrFr3wX0Swndzzwm6JHkmBqEBhByso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097918; c=relaxed/simple;
	bh=10vVpccgc8w4hYxxY/ZUYtVGbENYqDkIb4mLZHzXt3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6PLxR67q31BPceVTfRTzVL1H5tpOKhpS9q1TdoF3pOi4HxdW3g6O3IYP8k/deCsMlnN6nBPq4DcgwEoG7lMSc8E1c3GBc4TNPfkzkFfwBJSEn/DZl27MWKNnyejGKAtJ1EkzeLotlUZfLj1TAJvU5R7yVrTGOM6NMnNpGhFIso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+PJElIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+PJElIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0990C4CEC3;
	Mon, 28 Oct 2024 06:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097918;
	bh=10vVpccgc8w4hYxxY/ZUYtVGbENYqDkIb4mLZHzXt3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+PJElIsi/aYPpXbo62oaDyLBWoA8poxT7Wgb3HW9K6iI/ahSR6aOLdTdcl6YP8fl
	 X23hmWKMoZw0lX157HUfEpEsmaWyxC0lA7BMZ54Uww08AEexaxJ37lSJIoqHmLm9KV
	 FS+VPa3JQCA7/l6RSaT8OJ8VpsiUuycHbxikqdgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 205/208] RDMA/bnxt_re: Avoid creating fence MR for newer adapters
Date: Mon, 28 Oct 2024 07:26:25 +0100
Message-ID: <20241028062311.693421524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

commit 282fd66e2ef6e5d72b8fcd77efb2b282d2569464 upstream.

Limit the usage of fence MR to adapters older than Gen P5 products.

Fixes: 1801d87b3598 ("RDMA/bnxt_re: Support new 5760X P7 devices")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -400,6 +400,10 @@ static void bnxt_re_create_fence_wqe(str
 	struct bnxt_re_fence_data *fence = &pd->fence;
 	struct ib_mr *ib_mr = &fence->mr->ib_mr;
 	struct bnxt_qplib_swqe *wqe = &fence->bind_wqe;
+	struct bnxt_re_dev *rdev = pd->rdev;
+
+	if (bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
+		return;
 
 	memset(wqe, 0, sizeof(*wqe));
 	wqe->type = BNXT_QPLIB_SWQE_TYPE_BIND_MW;
@@ -454,6 +458,9 @@ static void bnxt_re_destroy_fence_mr(str
 	struct device *dev = &rdev->en_dev->pdev->dev;
 	struct bnxt_re_mr *mr = fence->mr;
 
+	if (bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
+		return;
+
 	if (fence->mw) {
 		bnxt_re_dealloc_mw(fence->mw);
 		fence->mw = NULL;
@@ -485,6 +492,9 @@ static int bnxt_re_create_fence_mr(struc
 	struct ib_mw *mw;
 	int rc;
 
+	if (bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
+		return 0;
+
 	dma_addr = dma_map_single(dev, fence->va, BNXT_RE_FENCE_BYTES,
 				  DMA_BIDIRECTIONAL);
 	rc = dma_mapping_error(dev, dma_addr);


