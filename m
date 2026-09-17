Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE14DDB2C;
	Thu, 17 Sep 2026 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670384; cv=none; b=uS7Obzxo1tHoJg0jKRWKn2ZP2JpKofDblDFElB7rgjV61Scv0CWS1zGswn5N/gzSgDpwSs6IMh8DCu5YTSv8urn4SDcHr76iN/qqULRn4PT8QlwbQMleHvvzMErPWiDf6xh7aZRUcQpOQ2ADlsVgs62190GvwZafFq8vRgJjTTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670384; c=relaxed/simple;
	bh=o0HwnSz+OB54opmNLKMb/GDa6bMIVQcQ4X1lEB8oEEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOx0sBzQHTvc+xMvrFJiNszcU/p2Kfx0V6oNUb3yOKa1VYiQjJ1BM8IfM/eMMY6nfe1BgFoYrhnkklpsDk1YLB5kqvYdI8oBOZjHVqyguEbS17aBl0KAX1We/Hc9bXPJjUXGM1FwsuzeKj7PzJ20Vv4t1ucY1uxe2RWqd3hzhZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjAvwbJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjAvwbJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2DC1F000FF;
	Thu, 17 Sep 2026 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670382;
	bh=WJQYeUGeujo092OCsOyL/7bdKbcDqXI5Z28AZoho5yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjAvwbJYxFNXPCuSTM2FZyL+mfFI1bzCKF29cNI5HAIR7v+brCSS9Hl2mPq0Q/glR
	 3GUT+OshXmLX2gaznVuc0P6fq65pAgUSFHdcyck5ykrLwB8A8rMb8I99+BXKfEZnt4
	 yeMkoJ+7SjpCfxuw+76subf8qpDadhF70IZbD93Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0647/1102] nvme-tcp: defer TLS inline send to io_work
Date: Thu, 17 Sep 2026 16:09:50 +0100
Message-ID: <20260917151556.394777319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 08acb54b063a33730eb1ae1e0f89bf36542bac9f ]

blk_mq holds set->srcu while queuing and running requests.  The kTLS
software send path takes ctx->tx_lock.  lockdep knows that tx_lock
nests under elevator_lock which then waits on srcu, so an inline
send from that path under TLS triggers circular locking.

Skip the inline send optimization for TLS queues so the send runs
from the workqueue instead.  The same workqueue already retries TLS
sends on write-space notifications.  Plain TCP keeps the inline path.

Fixes: be8e82caa685 ("nvme-tcp: enable TLS handshake upcall")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 8a6707a592930..1a1a11671826f 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -418,8 +418,13 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 	 * if we're the first on the send_list and we can try to send
 	 * directly, otherwise queue io_work. Also, only do that if we
 	 * are on the same cpu, so we don't introduce contention.
+	 *
+	 * TLS kTLS send takes ctx->tx_lock while blk_mq holds set->srcu.
+	 * lockdep reports circular locking via elevator_lock.  Defer TLS
+	 * sends to the io workqueue instead of inline from this path.
 	 */
 	if (queue->io_cpu == raw_smp_processor_id() &&
+	    !nvme_tcp_queue_tls(queue) &&
 	    empty && mutex_trylock(&queue->send_mutex)) {
 		nvme_tcp_send_all(queue);
 		mutex_unlock(&queue->send_mutex);
-- 
2.53.0



