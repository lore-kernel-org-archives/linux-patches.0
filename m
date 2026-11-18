Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056161;
	b=CD38w36eqppP99DIBvCwAljNzGgURTAZbq/jGoIuz92thnXIJn3/dSx85Od54oBKLvck
	 2Vm9kekbPnlzxi+0d78SOB7RyYAysVTvUTnZBK1GZT0VeufhOjWexDFnSCglNhp2jXSLt
	 fRezBtsum5yPpfc7JWNahsqYegMeRvG34l/nY++jv+P1JTVGApJ1xTLLOs9nFkQkp6qYr
	 YxMiXR3KwXmQ8xPINYBvLspoUzXb178a61CFLXEKitGVpLhNiq3zpy24vNdjkWjsW8D86
	 wCkxLKXpmycs8T+q00l/at4tfg5lGUTpGCurcnzftDx9deialV+USqabPNZevV4hqlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9avarBokTjW7J2L55JbIFh641/YeULYP59A9w+bt4c=;
	b=rxnYEZCeKPQux+N5TTB1P1OQe5uhYaPDDvZcxO/HLiafsIBlmctiPJZTBYeATzsCDqtf
	 5pbrgPT3Jh3/jh1zWdMdncSRLhOapUHhtenl8gLjcQ/ExHIPGl1rOc9JRJzEXBGP/e2+I
	 ++4ZjQPxrL+1kxU4FCB3v5UqVpGImtYLtQQIjXTVAEhECX4IKjwVvaZII9dgnC8vfNLzf
	 ObVzrrVrdIKumoYuKsYF3RI9cQmeCWzKfrpWTWOuMm9GRjJHvHGBJh5BKURrUzG3ui0TB
	 BVZlUPrXQ+YHxiwiNVNuC8vf8gvl7qXoI75EoxGgKXPp7ajRGGIJX/TCXz/+homKHXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnnSuVG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F62606A31C;
	Thu, 19 Nov 2026 02:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnnSuVG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535281F000C6;
	Thu, 19 Nov 2026 02:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056160;
	bh=+9avarBokTjW7J2L55JbIFh641/YeULYP59A9w+bt4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnnSuVG3CaHJPYjOcYTM1Kl3s2s1t8umE+3XnA69e56wgrbIK88sJkka26/oZHnrr
	 ecT/Kapnd0Fsgt+c0YP32W05BP3jJgFNq2YsCeAZy2PrQpjBCuf8WON2k+zC66YgNo
	 RWzrSfpV9iQvtgGWhFUhXRf5w5fY2J7fTsIIm9rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1888/2214] nvme-tcp: store and use the callers network namespace
Date: Wed, 18 Nov 2026 15:59:24 +0100
Message-ID: <20261118150126.743313375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Surabhi Gogte <sgogte@purestorage.com>

[ Upstream commit 87a1ac965502858f9207153a92c3aef8ecf6d4ae ]

nvme_tcp_alloc_queue() creates each socket using
current->nsproxy->net_ns, which is correct for the initial connect that
runs in userspace context. However, the reconnect and error recovery
paths run from a workqueue where current netns is a kernel thread in
init_net, so sockets created during reconnect end up in a different
namespace than the one the controller was originally connected from.

Fix this by capturing the caller's network namespace at controller
allocation time. Use ctrl->net for all socket creation so that every
queue, on initial connect, reset, or reconnect, is created in the same
namespace.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Surabhi Gogte <sgogte@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 5106092a8a299..6a5d21d3e14f7 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -168,6 +168,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	struct net		*net;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -1504,7 +1505,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create_kern(current->nsproxy->net_ns,
+	ret = sock_create_kern(ctrl->net,
 			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
@@ -2295,6 +2296,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -2700,12 +2702,15 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
 		goto out_free_ctrl;
 	}
 
+	ctrl->net = get_net(current->nsproxy->net_ns);
+
 	ret = nvme_init_ctrl(&ctrl->ctrl, dev, &nvme_tcp_ctrl_ops, 0);
 	if (ret)
 		goto out_kfree_queues;
 
 	return ctrl;
 out_kfree_queues:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 out_free_ctrl:
 	kfree(ctrl);
-- 
2.53.0



