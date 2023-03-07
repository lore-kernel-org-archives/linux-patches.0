Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC7FBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108C9C433EF;
	Tue,  7 Mar 2023 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211810;
	bh=+UFbwSapYubz/zOvph1T4DXXzplLGsq9iFOXSpN8Uzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6/qFmU4+u5AF1N58Wsx6NVCuvyjiEcKCKJpD2mP0LLkcqq1oDAqiw0EfQEfCpfui
	 9HR3Tq7DZL/QNho6E1zUVJDrfMOlUoQeHOx6rddJLY9skmB/6gsYARuH2w30ofnE3v
	 k5S0FoVK/Q6Lp2jdYJd1/5Ho+9Rwd742Gdhm1/Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.2 0984/1001] bus: mhi: ep: Move chan->lock to the start of processing queued ch ring
Date: Tue,  7 Mar 2023 18:02:36 +0100
Message-Id: <20230307170104.936230309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 8d6a1fea53864cd9545741f48f4ae4df804db557 upstream.

There is a good chance that while the channel ring gets processed, the STOP
or RESET command for the channel might be received from the MHI host. In
those cases, the entire channel ring processing needs to be protected by
chan->lock to prevent the race where the corresponding channel ring might
be reset.

While at it, let's also add a sanity check to make sure that the ring is
started before processing it. Because, if the STOP/RESET command gets
processed while mhi_ep_ch_ring_worker() waited for chan->lock, the ring
would've been reset.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: 03c0bb8ec983 ("bus: mhi: ep: Add support for processing channel rings")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221228161704.255268-6-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/main.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -723,24 +723,37 @@ static void mhi_ep_ch_ring_worker(struct
 		list_del(&itr->node);
 		ring = itr->ring;
 
+		chan = &mhi_cntrl->mhi_chan[ring->ch_id];
+		mutex_lock(&chan->lock);
+
+		/*
+		 * The ring could've stopped while we waited to grab the (chan->lock), so do
+		 * a sanity check before going further.
+		 */
+		if (!ring->started) {
+			mutex_unlock(&chan->lock);
+			kfree(itr);
+			continue;
+		}
+
 		/* Update the write offset for the ring */
 		ret = mhi_ep_update_wr_offset(ring);
 		if (ret) {
 			dev_err(dev, "Error updating write offset for ring\n");
+			mutex_unlock(&chan->lock);
 			kfree(itr);
 			continue;
 		}
 
 		/* Sanity check to make sure there are elements in the ring */
 		if (ring->rd_offset == ring->wr_offset) {
+			mutex_unlock(&chan->lock);
 			kfree(itr);
 			continue;
 		}
 
 		el = &ring->ring_cache[ring->rd_offset];
-		chan = &mhi_cntrl->mhi_chan[ring->ch_id];
 
-		mutex_lock(&chan->lock);
 		dev_dbg(dev, "Processing the ring for channel (%u)\n", ring->ch_id);
 		ret = mhi_ep_process_ch_ring(ring, el);
 		if (ret) {


