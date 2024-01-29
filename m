Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C76015956D;
	Mon, 29 Jan 2024 17:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548394; cv=none; b=se1vkX2NNz6DAsIKOflHiyYzH09btedDcPUUFnHJXTnwe4ZuxDObqXr8UTJ+jtrNdVr+PEILbfzEfm3zly9NMadNg99/LqNKhOScb4styEq2tQNqythpR4/7TJLM3z0q3ALlZJigs1SiskmBPS+IHvGC/dtOpwGmD8sjexBFJ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548394; c=relaxed/simple;
	bh=c+ceS5WwQfohiufiToqDdokE5xUCX94L4hTIEQDXXY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxiqN9NnEm0htsGFO8DK1w+6QqmS97ea5VfB385ZqgQMIZEJXfl+PvKFBlRfv8tSNIpF3rX/zrvTS08oO1LDssrZNi5/Alc+necFKoAdOXmuDk4oFT8/v0q58uYPaHiLdrsLQiV6fmYPE8UrDv/l3MFIIGycpvPXjF/SLE0gSWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7/p72Qr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7/p72Qr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14649C433F1;
	Mon, 29 Jan 2024 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548394;
	bh=c+ceS5WwQfohiufiToqDdokE5xUCX94L4hTIEQDXXY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7/p72QrCtjrXpoEajC5ei7HE+WiLMtvIMvKN9YCKjIJDldJlfU/3s+BxzfzgDNEl
	 Nn5IAnLH4izrBo7GApMZxWU32qZpIQhKijuqbR5uiSTn66dGnQuA507KkKeVAzWtRr
	 vb30iqyQmewM0QwF2bk7Zg/034RpAcoax7/4ljm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/185] bus: mhi: ep: Do not allocate event ring element on stack
Date: Mon, 29 Jan 2024 09:05:45 -0800
Message-ID: <20240129170003.245087417@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 987fdb5a43a66764808371b54e6047834170d565 ]

It is possible that the host controller driver would use DMA framework to
write the event ring element. So avoid allocating event ring element on the
stack as DMA cannot work on vmalloc memory.

Cc: stable@vger.kernel.org
Fixes: 961aeb689224 ("bus: mhi: ep: Add support for sending events to the host")
Link: https://lore.kernel.org/r/20230901073502.69385-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 68 ++++++++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index edd153dda40c..34e0ba6f52d0 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -71,45 +71,77 @@ static int mhi_ep_send_event(struct mhi_ep_cntrl *mhi_cntrl, u32 ring_idx,
 static int mhi_ep_send_completion_event(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_ring *ring,
 					struct mhi_ring_element *tre, u32 len, enum mhi_ev_ccs code)
 {
-	struct mhi_ring_element event = {};
+	struct mhi_ring_element *event;
+	int ret;
+
+	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
 
-	event.ptr = cpu_to_le64(ring->rbase + ring->rd_offset * sizeof(*tre));
-	event.dword[0] = MHI_TRE_EV_DWORD0(code, len);
-	event.dword[1] = MHI_TRE_EV_DWORD1(ring->ch_id, MHI_PKT_TYPE_TX_EVENT);
+	event->ptr = cpu_to_le64(ring->rbase + ring->rd_offset * sizeof(*tre));
+	event->dword[0] = MHI_TRE_EV_DWORD0(code, len);
+	event->dword[1] = MHI_TRE_EV_DWORD1(ring->ch_id, MHI_PKT_TYPE_TX_EVENT);
 
-	return mhi_ep_send_event(mhi_cntrl, ring->er_index, &event, MHI_TRE_DATA_GET_BEI(tre));
+	ret = mhi_ep_send_event(mhi_cntrl, ring->er_index, event, MHI_TRE_DATA_GET_BEI(tre));
+	kfree(event);
+
+	return ret;
 }
 
 int mhi_ep_send_state_change_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_state state)
 {
-	struct mhi_ring_element event = {};
+	struct mhi_ring_element *event;
+	int ret;
+
+	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
 
-	event.dword[0] = MHI_SC_EV_DWORD0(state);
-	event.dword[1] = MHI_SC_EV_DWORD1(MHI_PKT_TYPE_STATE_CHANGE_EVENT);
+	event->dword[0] = MHI_SC_EV_DWORD0(state);
+	event->dword[1] = MHI_SC_EV_DWORD1(MHI_PKT_TYPE_STATE_CHANGE_EVENT);
 
-	return mhi_ep_send_event(mhi_cntrl, 0, &event, 0);
+	ret = mhi_ep_send_event(mhi_cntrl, 0, event, 0);
+	kfree(event);
+
+	return ret;
 }
 
 int mhi_ep_send_ee_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_ee_type exec_env)
 {
-	struct mhi_ring_element event = {};
+	struct mhi_ring_element *event;
+	int ret;
+
+	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
 
-	event.dword[0] = MHI_EE_EV_DWORD0(exec_env);
-	event.dword[1] = MHI_SC_EV_DWORD1(MHI_PKT_TYPE_EE_EVENT);
+	event->dword[0] = MHI_EE_EV_DWORD0(exec_env);
+	event->dword[1] = MHI_SC_EV_DWORD1(MHI_PKT_TYPE_EE_EVENT);
 
-	return mhi_ep_send_event(mhi_cntrl, 0, &event, 0);
+	ret = mhi_ep_send_event(mhi_cntrl, 0, event, 0);
+	kfree(event);
+
+	return ret;
 }
 
 static int mhi_ep_send_cmd_comp_event(struct mhi_ep_cntrl *mhi_cntrl, enum mhi_ev_ccs code)
 {
 	struct mhi_ep_ring *ring = &mhi_cntrl->mhi_cmd->ring;
-	struct mhi_ring_element event = {};
+	struct mhi_ring_element *event;
+	int ret;
+
+	event = kzalloc(sizeof(struct mhi_ring_element), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
 
-	event.ptr = cpu_to_le64(ring->rbase + ring->rd_offset * sizeof(struct mhi_ring_element));
-	event.dword[0] = MHI_CC_EV_DWORD0(code);
-	event.dword[1] = MHI_CC_EV_DWORD1(MHI_PKT_TYPE_CMD_COMPLETION_EVENT);
+	event->ptr = cpu_to_le64(ring->rbase + ring->rd_offset * sizeof(struct mhi_ring_element));
+	event->dword[0] = MHI_CC_EV_DWORD0(code);
+	event->dword[1] = MHI_CC_EV_DWORD1(MHI_PKT_TYPE_CMD_COMPLETION_EVENT);
 
-	return mhi_ep_send_event(mhi_cntrl, 0, &event, 0);
+	ret = mhi_ep_send_event(mhi_cntrl, 0, event, 0);
+	kfree(event);
+
+	return ret;
 }
 
 static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_element *el)
-- 
2.43.0



