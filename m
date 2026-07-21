Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB73227BB5;
	Tue, 21 Jul 2026 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658025; cv=none; b=JHWb6eHlIZTxgSCb/B9jSz1cUeggQnYLGLEdmh89M2NlgLtbXqkEXbe+7Rk/ePXcyffGeVu6OeLOHhoyTCRkdiPdHBIdxhD8iHPKMf7bq4UWzumEST2OX1yiQbI5ZRCpmcQK6hEHT6wDrX4MlNZVEKXka7bnzZYhSZCRqI0pQ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658025; c=relaxed/simple;
	bh=wVD7L/nddYAgHzNilHKM9ZL/hGJTwzrAqxIH6YgWyU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmSIh/QjDVYIlxCTNApvv90TO7ZdwUjDV6SBwYmlxbDXQLoD0M2GiJ02DDBN6uy7t+gaBsmAlHdoGR4sR9p1PDcnO3KUU/1kTVcQtKHdYq/GCAe2BpRwF5RD/9FNJGyvhQpdCv5n+QQd4eEnjVf8DWripT49bVlV0Sjp9IbZKIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ob1W1Pan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ob1W1Pan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B368F1F000E9;
	Tue, 21 Jul 2026 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658024;
	bh=2qOk9T8oDjFwOi/r3vNFcuwTvDxqTZgnK1GfbZwx9Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ob1W1PanCA1IjJuuPaKcAJhFGWKQPzerf3nMrj4W/wg+nIOt1vZnHHFA5+t7N6xq7
	 ZQWYq/FD/h/3sVEfYv0OCLLcmLWL2IBA2L/rtNmKosW7RJvl3dlw3WFUtEzfORnVI7
	 QLuxVhnfspltyjuymFxl61g+D4ZZ58cIbZn/IYrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0988/1611] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:18:24 +0200
Message-ID: <20260721152537.615832118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Longjun Tang <tanglongjun@kylinos.cn>

[ Upstream commit 1eb8fc67ca41db71c90866ff76c990d85247daef ]

When busy-poll is active, napi_schedule_prep() returns false in
virtqueue_napi_schedule(), so virtqueue_disable_cb() is skipped.
The device may keep firing irqs until reaches virtqueue_napi_complete().
Under load (received == budget), it will lead to a large number
of spurious interrupts.

Fix it by disabling the callback at the virtnet_poll() entry.
This keeps the callback off while we poll and it is re-enabled by
virtqueue_napi_complete() when going idle.

Fixes: ceef438d613f ("virtio_net: remove custom busy_poll")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Longjun Tang <tanglongjun@kylinos.cn>
Link: https://patch.msgid.link/20260629024230.37325-1-lange_tang@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index dbdba0a42efe9d..d2fe26bfaccd0a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3128,6 +3128,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int xdp_xmit = 0;
 	bool napi_complete;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



