Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015058;
	b=aKLnIWRRfd8uiYOst5OBmB1y1UB56mCD6qgzlVh6o/kQxCf7ch3uVyAFVR4f1xzGNqgq
	 Q96qo5iwPRekiCEwhUqb6Z1moYCWJCn37OzL9s1qK2oQcwZnelKQk1KEsx3tqGEVxNzwd
	 NWb/AkEKK62N85QzONVLwbW10Vy4tq4+U94SmPyx82244CQpzD7tRMiwpFfGM5Vp6I7ES
	 yO7M4PaumMCxInJFRj9w/v3t5fG9zeVWCRBANYdUP3OuOFpry+n4v4Tk2umdSfo5mXlk6
	 R3WCGU75L/5R7HjggnUTHuNsamZ+7TDbYJ0OnVoCiep5U4WAevxMKmlUJ79HuqamD2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UxiBr0vNJ+eslZtKIOiSyh7NI3V0KhTvdwZmmMa424M=;
	b=G/yGEZ868ejYbk6bvJ97jop+EQeAv3kPAxZr5U6rdMCqE/4AUYeL+xsyX/K9MRsPXM4o
	 Ho6HrGp0fWqL+4/gdwY/NhmxfWUbgKopobkLWf15PWfWWXNp/VuKcmXJ63EDVTO0xfl6p
	 OjdSjkuHpdvcdPlb3P9xL/FSZJDfWspXYeW8AosY+E5PA3RMaoPm+9chqTTHqSH56qI9i
	 rKybLLjmHtk9/rZdiJu1njSpdYRGe4YMUT+HJMg/FERAlSKXioYdmtWC6j6vq9arrepKH
	 dB1F6tsIwZPZSF2FIBUauWfrR/V0a3bH7DKuXWe3+MoXYDIlGUzuT2DgCjhdkRnp1Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWofsyZw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07D360A2600;
	Wed, 18 Nov 2026 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWofsyZw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517401F000C5;
	Wed, 18 Nov 2026 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015057;
	bh=UxiBr0vNJ+eslZtKIOiSyh7NI3V0KhTvdwZmmMa424M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWofsyZwTSP9hLFSihX0NH/r4ce+3CqKRZ50JijEjQzW420YmZ5qECbxUe6S7+wzw
	 tn6NQRcNlDChcdsqzLcyGkgRKOR/Syj3fMsBopq9wXvqteuwsT4ajyOIpt4yQTEf8c
	 nzVdkTYwfCL3g2dwr44DYqpPL/MupkJzoGTNdbnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0038/2651] nvme-tcp: fix use-after-free in nvme_tcp_free_ctrl()
Date: Wed, 18 Nov 2026 15:21:18 +0100
Message-ID: <20261118150249.341986400@linuxfoundation.org>
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
[ sashal: adapted to a tree without the netns/init_queue refactor, so the fix edits the mutex_init/mutex_destroy queue loops instead of nvme_tcp_init_queue()/exit_queue() and has no net member context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 50297ce8bdde6..edb41cb3a7a15 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -191,6 +191,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	unsigned int		nr_allocated_queues;
 };
 
 static struct workqueue_struct *nvme_tcp_wq;
@@ -2791,8 +2792,6 @@ static void nvme_tcp_stop_ctrl(struct nvme_ctrl *ctrl)
 static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
-	/* the same count used to size and initialize the queue array */
-	unsigned int nr_queues = NVME_TCP_OPT_NR_QUEUES(nctrl->opts);
 	unsigned int i;
 
 	if (list_empty_careful(&ctrl->list))
@@ -2804,7 +2803,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
-	for (i = 0; i < nr_queues; i++)
+	for (i = 0; i < ctrl->nr_allocated_queues; i++)
 		mutex_destroy(&ctrl->queues[i].queue_lock);
 	kfree(ctrl->queues);
 	kfree(ctrl);
@@ -3198,7 +3197,8 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		goto out_free_ctrl;
 	}
 
-	ctrl->queues = kzalloc_objs(*ctrl->queues, ctrl->ctrl.queue_count);
+	ctrl->nr_allocated_queues = ctrl->ctrl.queue_count;
+	ctrl->queues = kzalloc_objs(*ctrl->queues, ctrl->nr_allocated_queues);
 	if (!ctrl->queues) {
 		ret = -ENOMEM;
 		goto out_free_ctrl;
@@ -3209,7 +3209,7 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 	 * they outlive the per-queue connect/disconnect cycles so that
 	 * sysfs readers can never race their destruction.
 	 */
-	for (i = 0; i < ctrl->ctrl.queue_count; i++)
+	for (i = 0; i < ctrl->nr_allocated_queues; i++)
 		mutex_init(&ctrl->queues[i].queue_lock);
 
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_tcp_ctrl_ops, 0);
-- 
2.53.0



