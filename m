Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33403EDE57;
	Tue, 21 Jul 2026 17:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653521; cv=none; b=TQG5+fVc6ecom+JlWoOrKIKBiVya2zgNQx+30W8xvQrGsMb1e0GrQfC7YN727aSayIP/xBztBJij/fWLgGzg0wGEGG/iYOM0HauFtODNtg6UVAuhlrVkJiGgWgqodY9W8r53I4oxp0QMZz2ilUVd+w5LU5bRE2X3WyHUDb5nxKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653521; c=relaxed/simple;
	bh=Q9SvBdnWzCKMMSLTLYzEUU6Nn2aDZ+YsAhFz1VnGRCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjlIGMslcGdByDaBqh/NjRAnLiqUMEgp08UdHFyMm1cd/jIGDhmcxq+fdobEBTu3z1QXn/xTaOkNu8WWvixPtDxycvtttRMoKq0ue0zU6bKcHLX3QspGXCLdt04lb9B6MhdoDTK+1q2i6UcwwsYGtdKieiWnq0TGHmvZXuLYS+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0VAXSqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0VAXSqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68961F00A3A;
	Tue, 21 Jul 2026 17:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653520;
	bh=wFnBoTD8vpLM470/PCUHeoetYieUlU3agRRGguQnH4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0VAXSqrUgG3I6d4p+C/SmWB7H6MXF1HEQZcanzYTACbAxy3epMojgazkMBcgQ/Zs
	 RnnNyFQJubmRcjxgA+HdVXgmOvx9DoKKEeo8vVrd2+lkwUmd8FIKfLSQUt/uYKpWVy
	 P2SslopYakE47kQ3pxwq6syEFHiAPAQ+oZD5F44Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1358/2077] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:17:11 +0200
Message-ID: <20260721152624.847242328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 26afa6341d1611..3e2a5876c6c8ce 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3011,6 +3011,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int xdp_xmit = 0;
 	bool napi_complete;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



