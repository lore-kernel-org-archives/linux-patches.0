Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3332399D0C;
	Thu, 17 Sep 2026 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659396; cv=none; b=nV4cpIptg8b7k+/OCzyARcusYEhQc/3vHgE2p6zTisNfIyce1PZyE3iMJCIIdoZc/6h5Nr4aNw3UI+DSVwxEUz0UcCRZJ/X485A3tu3LgDwUImVsvsjsZipAblZ7SWNCimjQI9dzgNbiagCVAOCkEMvY9EAdZ6vePfNYLfH6aBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659396; c=relaxed/simple;
	bh=4R1k8Eo1COPLcv4QQF0hiZantxuhYdRTDmOa8wudiTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYJ9bSoDff4BjsizR5J/LtrYf9lCh2ymNo5nlGOP0Pv8rIm40DEp2H3yc99OEZAzFNy9myWWl77gnUaHJ7fIFm6YsbgGtriSdR86cJQi6+4z6CUNLVrQWO2ye9F+NOHVGaosM7zc8ZHeqMhztDj5phXphfEkOtj1kEI8T+mAMPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nL5HgcmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nL5HgcmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DE61F00893;
	Thu, 17 Sep 2026 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659386;
	bh=rQfR/qSMmWrdq1kwwB5a9+9ELB2BB8vOlW3X9plJedU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nL5HgcmR+yrFNVxzvMnvbM4T9aX7clIMUCs/M3LRlXHKIT6VkQ9gLaw0q6wHE2sx2
	 Zti1FVEutzknvo6HVXzYxkiGulpVqw+QpkPbHEnBbPeSw3gxdLhxjXAw6NdM9152pY
	 eTyNBxbfhZYKq5bE/hyI96eyEJMWiV/lxSlcytnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 238/733] nvme-tcp: defer TLS inline send to io_work
Date: Thu, 17 Sep 2026 16:09:06 +0100
Message-ID: <20260917151357.182202781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ddbb34a22f688..52efc6e4f7623 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -411,8 +411,13 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
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



