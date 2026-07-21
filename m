Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C6F3A4F4B;
	Tue, 21 Jul 2026 19:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663161; cv=none; b=Ui90FN0CuoU/vN1+vWm+QmBdPsnvB1jloNtwbdPWMAxhyCGNM+4YAdLSV0a57IKEd7dIIGNN+s0XigpDkYCVBIuoO4TNo7y1BzbcegG+OKxTCt/t9KoDI0Kao+lHhvCXuQ6GwQ2r924injHM1jeJrtBuZeSqv508NPXBw7g7Fqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663161; c=relaxed/simple;
	bh=MAOrAtydZknupOooxKYrFcRCpZcLRooCRzQbBf+epsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPJ2RnTy3wXr4vPx0ONcTly/NZqN993Qe8FgzqYoFK0k1nQyN8tF0GXY+neq8bsUgO/NPiaUa8sfA6za2pV6xZpyETW36qRUGXTs1RWLTFN/QjgXHg9k9pmUp1Cj/EeFT0FXsUvp50rBoodpYrdtm1AsdnZ//AtK/Kf4SIgV5ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEe9hYTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEe9hYTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68481F000E9;
	Tue, 21 Jul 2026 19:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663160;
	bh=unSI6ub3KbMdWEkzHnG7rGLZP2pE04SYquqpnpg+2cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEe9hYTJuYuthOwN9QXA2B2JJD+m3NCviCWh/xkaJtB9ILEJHdp3S5WGZtynpUpJN
	 lsV8jJrSfKy4BB9j6OR98SK6KdU31FZyGEY5o8bu+YGvePZA1/jnCdw63C9dZwdp27
	 PcyvEZcCuakOJ12RMuMt0jezS60oxdFHny5g6pn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0718/1276] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:19:21 +0200
Message-ID: <20260721152502.159274066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f57491866aebf..0e8fa0f81e84be 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2886,6 +2886,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int xdp_xmit = 0;
 	bool napi_complete;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



