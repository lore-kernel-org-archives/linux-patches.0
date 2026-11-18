Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031831;
	b=K//jYFzDXIu7OYpzKxe7EaVSYYrNGhuL4RTjwJE1zldvgzzPcIvRP+VIR/ta/T4zJoqN
	 9DwR2cg8wp4zPiZPf3h7ZWlR/izqoHtjfogfeCbh6VgrPodr8+U/ftNTYvtFrQtIGD0xv
	 MSJ1sT1CSgfXN+UvAvjxTcEr1Rn2g18j+tAaNlNJ07AzVMXige7Bnv/zIFXoU7IlPtb6U
	 4IWKH/psjjKe6MxOI9WkUftR3H2megidtatzOllHq03UNJIipuTKIP8xGpaIMBwOWjNa9
	 G9tq8ogfUGv1KNUb29GkPoBwQU/935WNIUG4bVMSsfFU2IoJivhyCXoqwBlaQERasbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M4tUc1ExQ2oGo3Ai351+Dr6nU3xAmb0LfxY53aVX2fc=;
	b=R7bZg4j0nNlThWoN5EtHE66M3j8VSg5B2huA7dbDip3GAdv6ERdK0WSx83VusC2Apu1V
	 7VrSiLNaA38+kh4o+ppKh8l2pM6CxWy3m8/R1h7CEm9mAhN8X6HT0tW3sAIcXIOGx5zYi
	 yNlOLe122Tte11GXKcRq+HX+asqd42ZJ5EuMCcRMwU0+010VrlONC6tLWQDFwkCMD59AV
	 3LhW35rUHQ0lnDK7Mei46s2DNCiCYJMDytcxlGo+O19zc+fblmvdFfjONWlR9StI+UTPL
	 q6T5BsBLAq/2xuowxzf6oEXedJW8wbEhH3K6UY/s8Jufgb0CqE4sOJmoTZX5SOQYlGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T5AFdkr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF84C606A31C;
	Wed, 18 Nov 2026 19:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T5AFdkr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA81D1F000C4;
	Wed, 18 Nov 2026 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031831;
	bh=M4tUc1ExQ2oGo3Ai351+Dr6nU3xAmb0LfxY53aVX2fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5AFdkr8hARGVqFky3zmzCG+G1QXBhcu/bj8HYEzvMbBuwzuz7Z2P5tQj/CppJtoe
	 k77HVSi+KrkC1MIqmi42be1UDTUmoM441xsRZaDX+loxKOhzk5scaL+4daKMUQgIoM
	 44pM12yWQYpwVueNjmxNOUtSZVlv5a/KBXYN9qn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1145/1756] nvme-tcp: store and use the callers network namespace
Date: Wed, 18 Nov 2026 15:54:32 +0100
Message-ID: <20261118150055.625309148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 23d559d567d88..5a819d6b6abeb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -222,6 +222,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	struct net		*net;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -2033,7 +2034,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create_kern(current->nsproxy->net_ns,
+	ret = sock_create_kern(ctrl->net,
 			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
@@ -2780,6 +2781,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -3175,12 +3177,15 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
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



