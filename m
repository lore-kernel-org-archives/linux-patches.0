Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F6739FCE;
	Mon, 14 Oct 2024 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916628; cv=none; b=pbMkTf179pxNE+lYRPCUVDHQzu2FrTGV09u5hmIuBk9hjAxukNuZOw2PCkHNBNEemuKu+VqJO+marHfPBhh10/nbyHq54o3BObW6wh3Cbt5UE678nDlat18Z73/eEBK+3D4CHwtkom9hDjhdXN/RC1L98dZ4XNuC+4GYMxoDTpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916628; c=relaxed/simple;
	bh=H5Sz1fudZFYeJH7Sal1i3dSxbITNaq70yc9TbER05rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4cLozPbDmsi2ra+DN5pZvaqyXXy8vBfoQ50s08SZadmgHNJ3ppd9vccCYhMXJ1Bta9+RVzAbIxKKxns2QjPRk87jqtW3+a6UMR3lsZJwxTOKnYb/wBmsfjNHWdJPwloF//gcYUOX+cmOHP0YBYb+GDWcTr5RS225c9nD0NcqEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5sDSwtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5sDSwtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA87BC4CEC3;
	Mon, 14 Oct 2024 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916628;
	bh=H5Sz1fudZFYeJH7Sal1i3dSxbITNaq70yc9TbER05rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5sDSwtdk/21JZdMeMe8r27xdLDW+WgWGmBvEgnLZAvk0RcHem4hrQBSjnMrV+5ZL
	 bFf5XnSq6LJ4AAC8ZPF5JWEb67UgILAaQlHzzZee/Tki4XCx++RceaIlb015unCRop
	 G3HY4rXJlerCczbr22kCVJrRe84uTA5gmPKsQUms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mayank Rana <quic_mrana@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/213] bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone
Date: Mon, 14 Oct 2024 16:18:47 +0200
Message-ID: <20241014141043.813974688@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit c7d0b2db5bc5e8c0fdc67b3c8f463c3dfec92f77 ]

MHI endpoint stack accidentally started allocating memory for objects from
DMA zone since commit 62210a26cd4f ("bus: mhi: ep: Use slab allocator
where applicable"). But there is no real need to allocate memory from this
naturally limited DMA zone. This also causes the MHI endpoint stack to run
out of memory while doing high bandwidth transfers.

So let's switch over to normal memory.

Cc: <stable@vger.kernel.org> # 6.8
Fixes: 62210a26cd4f ("bus: mhi: ep: Use slab allocator where applicable")
Reviewed-by: Mayank Rana <quic_mrana@quicinc.com>
Link: https://lore.kernel.org/r/20240603164354.79035-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 2cb7e21ad3b74..c48f4d9f2c690 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -74,7 +74,7 @@ static int mhi_ep_send_completion_event(struct mhi_ep_cntrl *mhi_cntrl, struct m
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -93,7 +93,7 @@ int mhi_ep_send_state_change_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_stat
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -111,7 +111,7 @@ int mhi_ep_send_ee_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_ee_type exec_e
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -130,7 +130,7 @@ static int mhi_ep_send_cmd_comp_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_e
 	struct mhi_ring_element *event;
 	int ret;
 
-	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL | GFP_DMA);
+	event = kmem_cache_zalloc(mhi_cntrl->ev_ring_el_cache, GFP_KERNEL);
 	if (!event)
 		return -ENOMEM;
 
@@ -422,7 +422,7 @@ static int mhi_ep_read_channel(struct mhi_ep_cntrl *mhi_cntrl,
 		read_offset = mhi_chan->tre_size - mhi_chan->tre_bytes_left;
 		write_offset = len - buf_left;
 
-		buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL | GFP_DMA);
+		buf_addr = kmem_cache_zalloc(mhi_cntrl->tre_buf_cache, GFP_KERNEL);
 		if (!buf_addr)
 			return -ENOMEM;
 
@@ -1460,14 +1460,14 @@ int mhi_ep_register_controller(struct mhi_ep_cntrl *mhi_cntrl,
 
 	mhi_cntrl->ev_ring_el_cache = kmem_cache_create("mhi_ep_event_ring_el",
 							sizeof(struct mhi_ring_element), 0,
-							SLAB_CACHE_DMA, NULL);
+							0, NULL);
 	if (!mhi_cntrl->ev_ring_el_cache) {
 		ret = -ENOMEM;
 		goto err_free_cmd;
 	}
 
 	mhi_cntrl->tre_buf_cache = kmem_cache_create("mhi_ep_tre_buf", MHI_EP_DEFAULT_MTU, 0,
-						      SLAB_CACHE_DMA, NULL);
+						      0, NULL);
 	if (!mhi_cntrl->tre_buf_cache) {
 		ret = -ENOMEM;
 		goto err_destroy_ev_ring_el_cache;
-- 
2.43.0



