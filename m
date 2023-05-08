Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE61C168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A380C433D2;
	Mon,  8 May 2023 10:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542711;
	bh=96xJQ/2uB8QceE5ijnDHeqsXxx2vhniFS4ziP/WEReg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKOnTNpXN/uItP4s6qHUC5oFNAUqydU4IUJtP38Rc6JDeB6LQ9HYjnkQ2zzEB00FI
	 cJbRpg1jJyK6AE0wT3ID+mBPwMn5ZOl19vB0l79KJ2aXSZ/OC+ELK9tCtYKYZ16HmI
	 jnodHQZTS7UVpbiBL45JCCu9Xg+6oFkgJ+4IkptI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 492/663] usb: mtu3: fix kernel panic at qmu transfer done irq handler
Date: Mon,  8 May 2023 11:45:18 +0200
Message-Id: <20230508094444.390483074@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit d28f4091ea7ec3510fd6a3c6d433234e7a2bef14 ]

When handle qmu transfer irq, it will unlock @mtu->lock before give back
request, if another thread handle disconnect event at the same time, and
try to disable ep, it may lock @mtu->lock and free qmu ring, then qmu
irq hanlder may get a NULL gpd, avoid the KE by checking gpd's value before
handling it.

e.g.
qmu done irq on cpu0                 thread running on cpu1

qmu_done_tx()
  handle gpd [0]
    mtu3_requ_complete()        mtu3_gadget_ep_disable()
      unlock @mtu->lock
        give back request         lock @mtu->lock
                                    mtu3_ep_disable()
                                      mtu3_gpd_ring_free()
                                   unlock @mtu->lock
      lock @mtu->lock
    get next gpd [1]

[1]: goto [0] to handle next gpd, and next gpd may be NULL.

Fixes: 48e0d3735aa5 ("usb: mtu3: supports new QMU format")
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20230417025203.18097-3-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_qmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/mtu3/mtu3_qmu.c b/drivers/usb/mtu3/mtu3_qmu.c
index 2ea3157ddb6e2..e65586147965d 100644
--- a/drivers/usb/mtu3/mtu3_qmu.c
+++ b/drivers/usb/mtu3/mtu3_qmu.c
@@ -210,6 +210,7 @@ static struct qmu_gpd *advance_enq_gpd(struct mtu3_gpd_ring *ring)
 	return ring->enqueue;
 }
 
+/* @dequeue may be NULL if ring is unallocated or freed */
 static struct qmu_gpd *advance_deq_gpd(struct mtu3_gpd_ring *ring)
 {
 	if (ring->dequeue < ring->end)
@@ -484,7 +485,7 @@ static void qmu_done_tx(struct mtu3 *mtu, u8 epnum)
 	dev_dbg(mtu->dev, "%s EP%d, last=%p, current=%p, enq=%p\n",
 		__func__, epnum, gpd, gpd_current, ring->enqueue);
 
-	while (gpd != gpd_current && !GET_GPD_HWO(gpd)) {
+	while (gpd && gpd != gpd_current && !GET_GPD_HWO(gpd)) {
 
 		mreq = next_request(mep);
 
@@ -523,7 +524,7 @@ static void qmu_done_rx(struct mtu3 *mtu, u8 epnum)
 	dev_dbg(mtu->dev, "%s EP%d, last=%p, current=%p, enq=%p\n",
 		__func__, epnum, gpd, gpd_current, ring->enqueue);
 
-	while (gpd != gpd_current && !GET_GPD_HWO(gpd)) {
+	while (gpd && gpd != gpd_current && !GET_GPD_HWO(gpd)) {
 
 		mreq = next_request(mep);
 
-- 
2.39.2



