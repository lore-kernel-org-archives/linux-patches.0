Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C537B3FD;
	Thu, 17 Sep 2026 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665612; cv=none; b=c27y1gcxcryfijxPfzmiAanr7QfKZZrlmNDFHfUMxvkRIFNheEM0AOGOKQHoShoBgqCt8DBkSvpdJWU7xvLWmYyHR83OFJvYc18SI82cS1K8OpKN0TZwR4oN5zIL6fu1QuKeLIO7s1WTd5CEKsu8/dTls5mQUTiyL1IXcaHMD9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665612; c=relaxed/simple;
	bh=tLoUmS04AIBL5dUtIgNuGcsQ9JVQyj84WPWCBe+Ilx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMrjrvjhQK4t4iUbOh+bgFS7WZtpPK3cSXp+pA3/Bqz9xuv7zmsVNKJnAI7BtAR1OrMDw3KTd5J39ZqTZijcIycmjhLm236mSifJXll+KAxrS5/Jl8518Kqe8BNDdWeHELcxKtOqSkkAQ0SJGHnSqIi1FWXq0XtPAihiN7W1w6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1mABxHs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1mABxHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8301F000FF;
	Thu, 17 Sep 2026 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665611;
	bh=PkH0tc2BjIfSnBUOXvZvgaLgzk3gKpwfYhA3Y+HXbtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1mABxHsyXiXjj2b5eZpx1Hut0Ya6gsd9/7qmhVSpJD6m+hniAjI7vbVsqcP9jiwQ
	 dZbqFT0dUmZhAiQ8Hsxw9x2sasqPNHHhFj/06J0cHzXQft6rbZGNslRbNeEbhByet4
	 2MgorNc21E6Kd/6B0RYWQmbpytZA7Rn1JTLlVg6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0761/1250] nvme-tcp: defer TLS inline send to io_work
Date: Thu, 17 Sep 2026 16:09:16 +0100
Message-ID: <20260917151612.504372675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 8aaec6096d6de..86e064d058d35 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -417,8 +417,13 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
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



