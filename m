Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022070;
	b=Ryu71iufftvh3mIdSBtifePYSWA0MWoK1ij8JVN5O4oPiwE5kx33N9jIYyTQ1z36yp9H
	 6qEH162NgH+jOGWpHddFPXK+4NmUItvrt/tGM3KACZfFNrnKX+piWAqrAXeoHhYLR6Usp
	 ckMxfuGe11L5tqV3YXt7lmWTJ+jF+M40MQhG9E73xc8cFbKwS0IKY3vi0cSNUeTfaUEma
	 XPDlxVyjHa0plt+PCFhb26imc6qvrp2SLEGSwpION09EJGbc5hGtL6tdhbRyoGMzIbtjh
	 wIEEi0yAHZ49ElnW4ZC7WyBBW8A3hyIdQogHhEUrvl0rpKAPtEQyBwGZNaMwR+YibrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0aj49Ga0dFnsz4IHQwMlAWUpICcVFJBHqVsjHoMV+Ns=;
	b=ZqmwXcwRI0558oizn9qP69uXcAHg1dPOIWmFq3w17YMyUc93oNI+RvWPzvvzYb4tUgkg
	 TODLd5xg8kNL4AKwvRvBsrB4cwLrS5o0NEam3PxJNwIXB3dtmWfRwAxZ/d25nAQKOITBi
	 wyeR8XW8YiNNEdLT9wb8Gv44TBvgUpse6S087taY/PJUkglf7ilcXtbPImddYzMQMx+TW
	 Cfx3v4ZXCkPcv518jsdml/FrKjhhhx4CNodx3aN+rQy7xJo0uzFsgFfQCzXFrOQq9iJtu
	 LOZl3yhADHK/CcOY/kamiSH0u2tGpv27PQilVxSx/57ErXgr3ufY76XcuSCFNh+QFuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYSWBpqX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C60C606A325;
	Wed, 18 Nov 2026 17:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYSWBpqX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917B41F000C4;
	Wed, 18 Nov 2026 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022070;
	bh=0aj49Ga0dFnsz4IHQwMlAWUpICcVFJBHqVsjHoMV+Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYSWBpqX7Uni71wyqV093/VgTbz0yQXEBndpLPNvkXgCkpxldbF/8Pf4xwVbvz4kV
	 D52k64ybuztMX9mujwcH6FBQpECpmCDe1miVDg1I+awsvpcTBUGY0WjqqRvs6BXTLB
	 zWA7f2StUOSIqKkUn2a8STLw6JY8WlnM9uLcKMCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2530/2651] nvme-rdma: fix NULL metadata_sgl dereference with T10-PI
Date: Wed, 18 Nov 2026 16:02:50 +0100
Message-ID: <20261118150415.707089742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>

[ Upstream commit 557114b52c1d73f45c603337ac3465bba6667e34 ]

Since commit 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation
and startup") the I/O tag set is allocated before the I/O queues.
nvme_rdma_init_request() only sets req->metadata_sgl if
queue->pi_support is set, but pi_support is only set later by
nvme_rdma_alloc_queue(), so every I/O request is left with a NULL
metadata_sgl.

With an RDMA device that supports integrity and a namespace formatted
with protection information, nvme_rdma_dma_map_req() then dereferences
the NULL pointer on the first integrity I/O, already during the
namespace scan when there is more than one I/O queue.

Queues that a later reconnect adds for the first time have the same
problem.

Check queue_idx and the controller's max_integrity_segments instead,
which is what nvme_rdma_alloc_queue() derives pi_support from.

Fixes: 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation and startup")
Signed-off-by: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ff7b9e3796140..32189fdfc0f51 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -313,7 +313,7 @@ static int nvme_rdma_init_request(struct blk_mq_tag_set *set,
 		return -ENOMEM;
 
 	/* metadata nvme_rdma_sgl struct is located after command's data SGL */
-	if (queue->pi_support)
+	if (queue_idx && ctrl->ctrl.max_integrity_segments)
 		req->metadata_sgl = (void *)nvme_req(rq) +
 			sizeof(struct nvme_rdma_request) +
 			NVME_RDMA_DATA_SGL_SIZE;
-- 
2.53.0



