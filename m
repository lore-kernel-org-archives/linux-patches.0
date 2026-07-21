Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE4B44AB6A;
	Tue, 21 Jul 2026 22:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674013; cv=none; b=oSJWloVFsYvqO/5FofWiD7Xu0CayYkPrQzmTCk+xXZ2y8E2Edjh/0Zp4PNfRkGwpVPbQ+gS7+lxF1O8GgvfhbAIS8csWdIyZ31OlWXIqTjxjJrvKSnHsPiFvRYJyhlRs9Z4rSiqvNEtuB7AY8okhkuM0mhVeDENO5rCRP9YBTAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674013; c=relaxed/simple;
	bh=qLe2OgztIoOGqjkQiThP29HBI1/8PexV5Db6WlsXdok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQaN72hVt8Ppdc1QTAe/8MBHII16TdQydazSqn69O/k3xVsx/6KDn0p83wWcSBqyrQAkIQFUs2Lz9YX8qqyknyXPabv8RvB7B+g37kTLEfzVeE9X/Cw13N9FvnWBGOEaHRVMowOC/E7V91mTVjuyKwmfzmixY1zJkxJY/a9OJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ep6RTU32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ep6RTU32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE41F000E9;
	Tue, 21 Jul 2026 22:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674011;
	bh=GO9OvOlGl08BupNcMC2tALZuVucgmdatJAS6VchuJ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ep6RTU32av47YwqGzLYzKGAbmlW9LsGu8QFFG9yyh3aJ7geRf2SI0Avo3qwUYOfG6
	 wckHkv9C1BJBRIIAefcHTYGJ0y11xk4EC8+u/KxkiAEmo3Y+1ZvXE9y39i4rRhpp7G
	 /FNA0p2KlkPxQLz9CjK2f93erPb0xTtBg7ADjUU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/699] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:22:19 +0200
Message-ID: <20260721152404.263629166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fe7b28a595f163..aa61bf852e2e0e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1555,6 +1555,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



