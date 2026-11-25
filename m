Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622462;
	b=iyxq85qB3dJeJM9oxJ7btr9N7x8fT1Ecgl7eBeQYWTMxzrg2vKppkrYt2MeLCtm63iGH
	 ie7EEuCd4Uyp/W7fCyod5Rx5BV9v+XQ1jYzQlZnYslUi1jO+4q777jq3ub+Maq3tvQjG6
	 ffFCX4SaKyQ8priLPMDdPlIv+7rS+gGQktZQXq7vKtP8mmz2lD27glELM09+0w2DZpqbS
	 2rQFCWK8y7GlDWqGJOqJTHTwHtqLieQVb2JJkAuEFUHpyCWshU2SJbgGIoRUFnJ0XlZW/
	 pY7pqdh1Xc1lc96bEonESREfFbL86CCf5lhhP3VynfBOdyIbw/xeR2E6MH3CMJR7xvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w2QOZUKshoyh/FkuMrueQzNJsLFuo+F9jeR286ZhYWo=;
	b=Ba5VfsI/9RObz3+Bsmnijexq3jlA+hKd9L6CiEF2w0kTYxPXoj9U27DbdEO731+XrRLx
	 y5Aq3ESV4We2ZDdMUzYllQBWHgnqJYD70jgOJT+XrZebTryIpEGqGRfkobbD+mWy8vsuY
	 7Nu9+mGEhG0zlHsUZBivkxdi6RxlHIdfR22osuoGbulvSdkQAXTJmUzbMscdPEzy6cvjF
	 sC/HwdIzET6siM7ayjYciD8jwy4fs2qeROVl1Wt/m2klmd2pJJt1S3lHbCs+S8MIIvJ5N
	 H5KZFBcvaXRNTxuOxbNJeKHMfef3OnpINAhbjbjW9OmLeE4AzFrnfndBhH72/gb68DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3xUta1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07B9606A33A;
	Wed, 25 Nov 2026 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G3xUta1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581411F000D4;
	Wed, 25 Nov 2026 16:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622462;
	bh=w2QOZUKshoyh/FkuMrueQzNJsLFuo+F9jeR286ZhYWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3xUta1u7EaBhOzv0ONHwWb5rGKAMSrep76mwAwEaG0joC7H7KKKjMc6Swc4Thtpu
	 XzSjE9Ux4TizrDhHsy5U3n4hqX8wV7dink7wYHLI7M9HVXa6+FSEm/gZ2ASvmN15GM
	 FU6n0nTE4ya4629dbhOL41M2d5jAvEe1AVf1WHh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/990] nvme-tcp: fix use-after-free in nvme_tcp_free_ctrl()
Date: Wed, 25 Nov 2026 15:31:08 +0100
Message-ID: <20261125143833.834079297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>

[ Upstream commit b1d1f6b1ee03285690f12c2ebf23616416e6d881 ]

nvme_tcp_free_ctrl() reads ctrl->ctrl.opts to know how many queue
mutexes to destroy. When creating the controller fails,
nvmf_create_ctrl() frees opts as soon as nvme_tcp_create_ctrl()
returns, but a concurrent open of the character device can hold the
last reference to the controller. With CONFIG_DEBUG_KOBJECT_RELEASE,
which delays the release, every failed connect reads freed memory:

  BUG: KASAN: slab-use-after-free in nvme_tcp_free_ctrl+0x38b/0x430
  Read of size 4 at addr ffff888005b93740 by task kworker/2:1/51

Keep the size of the queue array in the controller and use it instead.

Fixes: 2eeeaa9c1ff0 ("nvme-tcp: Validate the queue state under the queue lock in the address attribute")
Cc: stable@vger.kernel.org
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: Replaced upstream's nvme_tcp_exit_queue(), nvme_tcp_init_queue() and kzalloc_objs() with this tree's mutex_destroy(), mutex_init() and kcalloc(), keeping the nr_allocated_queues loop bounds. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index d97ef58b834a3..e25cc8e55cf40 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -224,6 +224,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	unsigned int		nr_allocated_queues;
 	struct net		*net;
 };
 
@@ -2781,8 +2782,6 @@ static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
-	/* the same count used to size and initialize the queue array */
-	unsigned int nr_queues = NVME_TCP_OPT_NR_QUEUES(nctrl->opts);
 	unsigned int i;
 
 	if (list_empty(&ctrl->list))
@@ -2795,7 +2794,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
 	put_net(ctrl->net);
-	for (i = 0; i < nr_queues; i++)
+	for (i = 0; i < ctrl->nr_allocated_queues; i++)
 		mutex_destroy(&ctrl->queues[i].queue_lock);
 	kfree(ctrl->queues);
 	kfree(ctrl);
@@ -3186,7 +3185,8 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		goto out_free_ctrl;
 	}
 
-	ctrl->queues = kcalloc(ctrl->ctrl.queue_count, sizeof(*ctrl->queues),
+	ctrl->nr_allocated_queues = ctrl->ctrl.queue_count;
+	ctrl->queues = kcalloc(ctrl->nr_allocated_queues, sizeof(*ctrl->queues),
 				GFP_KERNEL);
 	if (!ctrl->queues) {
 		ret = -ENOMEM;
@@ -3198,7 +3198,7 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 	 * they outlive the per-queue connect/disconnect cycles so that
 	 * sysfs readers can never race their destruction.
 	 */
-	for (i = 0; i < ctrl->ctrl.queue_count; i++)
+	for (i = 0; i < ctrl->nr_allocated_queues; i++)
 		mutex_init(&ctrl->queues[i].queue_lock);
 
 	ctrl->net = get_net(current->nsproxy->net_ns);
-- 
2.53.0



