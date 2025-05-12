Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68617296FD5;
	Mon, 12 May 2025 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071770; cv=none; b=FtxzjfngjJMGLwkLPxJ4ShiV+ZBrGSB/BeMzvfcMj0y+i4Ouzv+ggLY5muB8fud17rIq205qRl3idvkHxAspFRdQP7RkIjMYsPz1EeL08suUaJe+JP1WH8Tyr951CQUgDC8Ktl+wfO7JCgWNS4K4gSqUCfAJzhHlJtUrspb333E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071770; c=relaxed/simple;
	bh=p3rZV13C7LKzdsdc8ZfMDjWOOSXDZ4rYcMCaHE8LFQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+PNEQSVi+Oz/d8KIMf+GUwjJK4C8uP5CCTDbTVdAyh3SxFZ2B0ETvmwrTkYsbP7taLjWF368N23bKLwueTX9Izak5RUsk4TOAkBj8vqW9lHNb0ty/VwC/4Mp8VByz+ZbQLLinbDdRn9exPiKLvCJmNaXni+/pDD47euM1M0oqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEbJws+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEbJws+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8469AC4CEE7;
	Mon, 12 May 2025 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071769;
	bh=p3rZV13C7LKzdsdc8ZfMDjWOOSXDZ4rYcMCaHE8LFQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEbJws+RXAtjSw70L/MyourqAbx0mPIhL1t+ypRUsOcjUHIvRDsRAd47NYKac+YOI
	 eGIugaFyv2xZUyoQxGj59IGYjKq9ejV534QQRtbJ0hh1K4S96VQdIY6cFf15jol9VA
	 kmv1V68SlP0KMwF3DtN0roeeEL4az/zCFxf8E+JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 020/197] virtio-net: dont re-enable refill work too early when NAPI is disabled
Date: Mon, 12 May 2025 19:37:50 +0200
Message-ID: <20250512172045.168061492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1e20324b23f0afba27997434fb978f1e4a1dbcb6 ]

Commit 4bc12818b363 ("virtio-net: disable delayed refill when pausing rx")
fixed a deadlock between reconfig paths and refill work trying to disable
the same NAPI instance. The refill work can't run in parallel with reconfig
because trying to double-disable a NAPI instance causes a stall under the
instance lock, which the reconfig path needs to re-enable the NAPI and
therefore unblock the stalled thread.

There are two cases where we re-enable refill too early. One is in the
virtnet_set_queues() handler. We call it when installing XDP:

   virtnet_rx_pause_all(vi);
   ...
   virtnet_napi_tx_disable(..);
   ...
   virtnet_set_queues(..);
   ...
   virtnet_rx_resume_all(..);

We want the work to be disabled until we call virtnet_rx_resume_all(),
but virtnet_set_queues() kicks it before NAPIs were re-enabled.

The other case is a more trivial case of mis-ordering in
__virtnet_rx_resume() found by code inspection.

Taking the spin lock in virtnet_set_queues() (requested during review)
may be unnecessary as we are under rtnl_lock and so are all paths writing
to ->refill_enabled.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Bui Quang Minh <minhquangbui99@gmail.com>
Fixes: 4bc12818b363 ("virtio-net: disable delayed refill when pausing rx")
Fixes: 413f0271f396 ("net: protect NAPI enablement with netdev_lock()")
Link: https://patch.msgid.link/20250430163758.3029367-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3e4896d9537ee..2c3c6e8e3f35b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3359,12 +3359,15 @@ static void __virtnet_rx_resume(struct virtnet_info *vi,
 				bool refill)
 {
 	bool running = netif_running(vi->dev);
+	bool schedule_refill = false;
 
 	if (refill && !try_fill_recv(vi, rq, GFP_KERNEL))
-		schedule_delayed_work(&vi->refill, 0);
-
+		schedule_refill = true;
 	if (running)
 		virtnet_napi_enable(rq);
+
+	if (schedule_refill)
+		schedule_delayed_work(&vi->refill, 0);
 }
 
 static void virtnet_rx_resume_all(struct virtnet_info *vi)
@@ -3699,8 +3702,10 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 succ:
 	vi->curr_queue_pairs = queue_pairs;
 	/* virtnet_open() will refill when device is going to up. */
-	if (dev->flags & IFF_UP)
+	spin_lock_bh(&vi->refill_lock);
+	if (dev->flags & IFF_UP && vi->refill_enabled)
 		schedule_delayed_work(&vi->refill, 0);
+	spin_unlock_bh(&vi->refill_lock);
 
 	return 0;
 }
-- 
2.39.5



