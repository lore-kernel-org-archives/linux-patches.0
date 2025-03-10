Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD5231A3F;
	Mon, 10 Mar 2025 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626668; cv=none; b=YJPkR3iyH/ZpRKIT5Ka/LcInmTle4ef9AtZr0hRq86v45vjT47P+GJS/I4tH5ku6RSqv6TEFQDx0qbJ+h+TpL6c0HyKtXnh2sqJh41VThMyD46S41W3ew+rB7b9lRv65atHMVobTxLiUljz404PNPxl+aA4Mep5u4oPfgUVjHfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626668; c=relaxed/simple;
	bh=LOBCCV+QYFsfpIgRWGW2S9oEzBYTcIu3qRvv3VFU8ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVuaWwgSboIiCv/YlYuR7sC25wu/Ch2xtb+bTx7HBJrf8f//v0t3SMF0rQ7jaAfRp05VHhj1b1xVnxFrSpEt4Oq6kdP3o1hCb/62kDDt6A/G95CzU9ppVjcUVlcaLyvSj4U6Xn7l5QvXX222oDxsD5Iw63orsAEaCCUuDCLgJsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJeYGhTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJeYGhTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD48C4CEE5;
	Mon, 10 Mar 2025 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626668;
	bh=LOBCCV+QYFsfpIgRWGW2S9oEzBYTcIu3qRvv3VFU8ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJeYGhTbE1sWFQf1uaQlVTUdSfrMFoz2W4mjEdcpsQLi5d3Ze2N4vTjfrxi3KgII/
	 bnHMqQcDf5MlUNWaR9y55qQQDsg5aF0sp7CrWhnUIV8IPVusdOOWzJ83QTvREQ4Afz
	 inPinVZzaA4ChCRx6lLV5lT9uXuPKfMiia5K/6Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan King <brendan.king@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.13 039/207] drm/imagination: only init job done fences once
Date: Mon, 10 Mar 2025 18:03:52 +0100
Message-ID: <20250310170449.326609765@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan King <Brendan.King@imgtec.com>

commit 68c3de7f707e8a70e0a6d8087cf0fe4a3d5dbfb0 upstream.

Ensure job done fences are only initialised once.

This fixes a memory manager not clean warning from drm_mm_takedown
on module unload.

Cc: stable@vger.kernel.org
Fixes: eaf01ee5ba28 ("drm/imagination: Implement job submission and scheduling")
Signed-off-by: Brendan King <brendan.king@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226-init-done-fences-once-v2-1-c1b2f556b329@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_queue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -313,8 +313,9 @@ pvr_queue_cccb_fence_init(struct dma_fen
 static void
 pvr_queue_job_fence_init(struct dma_fence *fence, struct pvr_queue *queue)
 {
-	pvr_queue_fence_init(fence, queue, &pvr_queue_job_fence_ops,
-			     &queue->job_fence_ctx);
+	if (!fence->ops)
+		pvr_queue_fence_init(fence, queue, &pvr_queue_job_fence_ops,
+				     &queue->job_fence_ctx);
 }
 
 /**


