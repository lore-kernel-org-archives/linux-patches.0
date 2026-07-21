Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8C344212D;
	Tue, 21 Jul 2026 22:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672114; cv=none; b=LtB3YItTUOaXgx8/ZBlgxMwleQ9T7vS6iJn7abU9tVYrHEWhShojN9vpvv2ihzl40YnQAhIm3eCXSqxn3ZM4kHn7b6a/6DW/5yaeAL/WLWrHONvnq5M1MkJSnqz+HPy488QFS5Jj7pe11kMZ00J31mYDZMct0oeOvbphCmvmVXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672114; c=relaxed/simple;
	bh=kRn5Uj8zyY3K9r9O7WLvaPKDViFHq3ccA+7CCNg9heE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtPNKTf7yVlkCXr6ZjmJM5tBJv/ANgm/cyktlpHiFF4iGVr5UZOjCbWuf2MxxBM+GDuHPMyPch9J7E0trxr67fIczh11dF4nC9CU9RlVMgmUU0tzREtYe9ujTe9rS/XPJx0JEn5Givl/dVpuMg0g1vpOTgSUd2mAGWhz2c/fBqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRr/uwps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRr/uwps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F761F000E9;
	Tue, 21 Jul 2026 22:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672113;
	bh=JBEvqIcaiAcWfFPVOmlnNhhvOX7iD+fGxZ9LGWIznys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRr/uwpsIShEkTkkX+82S/nLqDZRtmsmMarvUWuxXIeGxWIrGzhXwRKSjp3+n6v33
	 Ulhovw2Vm1h+ymd998/v5RNWnZ+IUpJbXSq+cSTrkGPrjyk4oKzU295nFqPXTG4t3U
	 dawPmK+vO7jePrk9XgdN/60kGDwo5M/AlrHmdo1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 503/843] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:22:18 +0200
Message-ID: <20260721152417.346862382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 78996989c60cea..535ea3ad3a8cd1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1612,6 +1612,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



