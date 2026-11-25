Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625041;
	b=3WM+KhjXAr8XkDS15pFXvMhECTRdUuaTuqAchjI4kEVNbJLoZt9bXTL9xHvbeKlINIfn
	 l09F4Pw4QcQkWIKEbD4OawlvQQiv21U1r5sYCfI5o2dYUjNWuNTvceH8n8T0hN7Rw0W1d
	 zezB3hgbFMwXTch7vAE10gkGXSyqMjgeAJQe29w2X7rUcnzu1X7wtypV2eg7cOt47tk0G
	 xWlrh0dZtqPI3euZ15jxltItFpBQQemY38tgQ0M2dT/KcBmuXVffwD+iRgeyyAKp6QvBd
	 0kS83QCGLcABGL/BoSCvmlzNbCacCIz0ZFu+GogUWKw9Wj2St58+x/L9jyHeLucv3SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lC+c3e2wE52t9uRnCdBs+L3zA3JWJUfidPNbWa4hT88=;
	b=ZXV5ciLYob4+/xwW6J/oXcjXbqXbkTD4Ztucx5fJ+WvRgfpvVzpkMzdZsZ7kKsILBq7s
	 XGHNh8+7+YciDbrupqTT+FlwgKZs65uENBahZIfY+MAcoeDK2GWxb9jwr1uiqFv0VvfTj
	 IIWVliPtP7+jV+amVbRaf4WdTANkpIwzx3p002oNmgJBr1KuBxelTKmpob4VrpYUD8d0G
	 7jkfhTLx9ta9difN3gCmxhJWPegIOeCceKOONLXnRNlTP2r4wT3I7ocIKYvFSU441trGE
	 mgVjxGd90YG2tcyK+DezJmnhT5NGVc8IRmwv0bYD1mq/xBj330QY3ycq0HWSHCIhZ+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUYR4Aib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B278606A321;
	Wed, 25 Nov 2026 16:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUYR4Aib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E318D1F000C4;
	Wed, 25 Nov 2026 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625040;
	bh=lC+c3e2wE52t9uRnCdBs+L3zA3JWJUfidPNbWa4hT88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUYR4AibTVcD9Nstsk6PuWdQnJrIFuebVC3KLjzyc1cn0SrlW/jcXPrypQPD2LNxw
	 r/FMfwOSZQQfjjIWIyxwaTrZe3SsFCz6Q4ZcSV4Hnx4CLwAPu2MCpD3xovMWre+9vM
	 X2cLJnaY0YtHFOGRKIgt4iBeIzmOWTxHpjihDhSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/816] nvme-tcp: fix use-after-free in nvme_tcp_free_ctrl()
Date: Wed, 25 Nov 2026 15:32:15 +0100
Message-ID: <20261125143858.161093698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced nvme_tcp_init_queue()/nvme_tcp_exit_queue() and kzalloc_objs() with the branch's open-coded mutex_init()/mutex_destroy() loops and kcalloc(), using the new nr_allocated_queues bound. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4d9cd0e34b7b8..5c051f5644cc8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -225,6 +225,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	unsigned int		nr_allocated_queues;
 	struct net		*net;
 };
 
@@ -2782,8 +2783,6 @@ static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
-	/* the same count used to size and initialize the queue array */
-	unsigned int nr_queues = NVME_TCP_OPT_NR_QUEUES(nctrl->opts);
 	unsigned int i;
 
 	if (list_empty(&ctrl->list))
@@ -2796,7 +2795,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
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



