Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3903F23B1;
	Mon, 17 Aug 2026 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978255; cv=none; b=u2WNLPRiT/VyGkpbRWtW1VO98TzG1/CFJhbq1uPZcbZcYqnAuI869U0IXt7byCcB9uE7zjes+4JinZeA2Z1XLt6HYB0zgUtnhjwSK4BzYTZvlCA7+IjZFf3JIUXZaYUh/f9gAjK3ex2xiyAbKCqyTihhraSccCaZVDQYNwJoptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978255; c=relaxed/simple;
	bh=Ys8hdl+TgFTil4TD/OsE+T3H32ND5LN8bJL5teQDyPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvN25FWjNBi9DU9CF9PZD4E6yB6dn8lxYnbr1P5FRtIuH+hJ6eWjqNpuhNlngvP27KdRv7H2rKIpMAlq9NWabKQwc+EZUxp02HNHAqRDu5hTiLnk02odvNRvADWCVV+iSQXWUabkUfUQ05NMisLg81LdwhIYz+68t09PNj6/INY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0sQa4dW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0sQa4dW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6E51F000E9;
	Mon, 17 Aug 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978254;
	bh=tPh+3JADGZKYV5NtTwNoQmsk6/lZosYntUYA2SCpr+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0sQa4dW3N7PR1gSEgxKJwySCEMw9nQeDxU1ED6w0qJyuYL4n62zWdgVo36L0njYB
	 o6uGNzWzbFryAGBXCX6f0yPrXidURBNY1hsF+ppLn7d1e67JmVfXRernr/334iEmYc
	 J92h+1hxHDRTnli4o97sr0/nAKK4HPNc1/txiu1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 154/181] vsock/virtio: read virtqueues under worker locks
Date: Mon, 17 Aug 2026 15:34:08 +0200
Message-ID: <20260817132541.752249058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit ebac8f6b1ef0e9278afe204b8692a7479988dace upstream.

Commit bd50c5dc182b ("vsock/virtio: add support for device
suspend/resume") made the *_run flags transition from false to true when
restore installs replacement virtqueues.  The RX, TX and event workers
read their virtqueue before locking and checking the corresponding flag,
so a worker delayed across freeze and restore can observe the replacement
queue's running state while retaining a pointer to the deleted queue.

Read each virtqueue under its mutex after checking the run flag, keeping
the pointer and state in the same queue generation.

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/r/20260727035804.1860862-1-bestswngs@gmail.com
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/e79f68ad9284c983364fc3ac46904b6d9ef50231.1785352330.git.bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -343,12 +343,13 @@ static void virtio_transport_tx_work(str
 	struct virtqueue *vq;
 	bool added = false;
 
-	vq = vsock->vqs[VSOCK_VQ_TX];
 	mutex_lock(&vsock->tx_lock);
 
 	if (!vsock->tx_run)
 		goto out;
 
+	vq = vsock->vqs[VSOCK_VQ_TX];
+
 	do {
 		struct sk_buff *skb;
 		unsigned int len;
@@ -448,13 +449,13 @@ static void virtio_transport_event_work(
 		container_of(work, struct virtio_vsock, event_work);
 	struct virtqueue *vq;
 
-	vq = vsock->vqs[VSOCK_VQ_EVENT];
-
 	mutex_lock(&vsock->event_lock);
 
 	if (!vsock->event_run)
 		goto out;
 
+	vq = vsock->vqs[VSOCK_VQ_EVENT];
+
 	do {
 		struct virtio_vsock_event *event;
 		unsigned int len;
@@ -614,13 +615,13 @@ static void virtio_transport_rx_work(str
 		container_of(work, struct virtio_vsock, rx_work);
 	struct virtqueue *vq;
 
-	vq = vsock->vqs[VSOCK_VQ_RX];
-
 	mutex_lock(&vsock->rx_lock);
 
 	if (!vsock->rx_run)
 		goto out;
 
+	vq = vsock->vqs[VSOCK_VQ_RX];
+
 	do {
 		virtqueue_disable_cb(vq);
 		for (;;) {


