Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806C3B0AC6;
	Tue, 21 Jul 2026 20:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666801; cv=none; b=OONLwgU/BVPtAxfHjR6Asjdu0UudgzFS85Bpk4Hec6wHM/MOD7G6wCGSVWeJ+usoCr3PvAWqFX43Ym1cuXeoFrbgWKGWuHhV2adz8hnV4JFfIAE2VkLO3DQOE256zog3NCCo/A+N+wfcGfJkTkw3NoKLUz7fSQjp86TNaVA1l2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666801; c=relaxed/simple;
	bh=jfIdykMe1g21nIRJ9jRtP2BYbCdMPGkuYNJNyyjWhV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6bpUDAKvVJ6FptJGaFCCcybrlXZys5wweurS2DOWqyrj2sRcMr+jyqswdGw2Cp19vRD0LyBI/eA8W2LmkwuOrQVHjbil4xcFsqLXGOMjplh4ZvklSXjlgrKHqGU0KYAsgCo9jy/CbRxsa/itwlfPT0RH+MfZvDn6dbl9yIna8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I653e2AV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I653e2AV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEC01F000E9;
	Tue, 21 Jul 2026 20:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666800;
	bh=bK8ZhIdV7p6lEoESlZoiGgsvCkiiDSuN9bqQzgZRXRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I653e2AVCwwWaKfRNRGy1WFXvfSX5EZlH7gGGN/2Vlqwy08iuE6p3ypIXtSeOSFaL
	 V7Atc9rpN/60Z5BGqzK8x2jFkTv2POFjHRTE6vGgzHISdemy6WfWZ0LYR45fIauAUj
	 GSMciNKLMnvkDwlKw73laAzUs6SSOr2KoDQUbBGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Longjun Tang <tanglongjun@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0819/1266] virtio_net: disable cb when NAPI is busy-polled
Date: Tue, 21 Jul 2026 17:20:56 +0200
Message-ID: <20260721152500.187305363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8be173b76abe5b..fe0e647808cd7e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2228,6 +2228,9 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 	unsigned int received;
 	unsigned int xdp_xmit = 0;
 
+	if (budget)
+		virtqueue_disable_cb(rq->vq);
+
 	virtnet_poll_cleantx(rq, budget);
 
 	received = virtnet_receive(rq, budget, &xdp_xmit);
-- 
2.53.0



