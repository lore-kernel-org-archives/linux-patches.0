Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049660;
	b=TIzOHwG5SengaY0ZPkzKFOIDiGdcwi3eC8kq3AXnzNp5gYgs51yPfBO09Whl7WcCZ6BR
	 UJtsAzeVhOJDaN0uMF3wtuMWAYm0l20sdsbaPef2jUvzbfnnrJD+rUamTBPNcNydUXA2D
	 PI0yC+IGYHswlekZ7LDDHFRC4X39gyyxbPDJOiGvbJyrfbuvwWM8MbepuyC874G7DavQG
	 uJtSCYpSOVR3XTD01g4kYxVUOBo8lUKNdWBJAg7KBQP2Uu1nchXUZnpzmUld07ehPFuS4
	 q45A8DBzkV8383X230KipJw7h7h3/+DN8hn3WzOk/Y4V83dNBqU/wQCbF6UAoco9rzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ldEUTj2A36JwCzzAu9uRVC64x5lDosEopPIIqCvVAzU=;
	b=RF7OyjYgCqUaQbLIT0Wy8Dq5k/6KHccs3XDRMhrsunD36HR5bZnfoLBNT1EQbBPnghH6
	 YmRcsb3Ef4eOFhVPtFy2iH6WhoHK2Quwy4GAIdizC3b2+I4wWnXkp75BhXQmDAOjszvOr
	 dMdpt6bP/jjDaOQbsEfknBTtTa+7NMYyuTkON9Gletz9wOXQRzhSbf8Ce3Iec7DVW+1pd
	 3ElXFZFM6pXGAPHw3rTVnGo1Wo4HiY3SBiXqqpIotdw3MQfLSY6nzH3Her2BVH4WXKO34
	 1H2Jq0pkc1hYYhJpooG/0Oc4LmRyfkKMXEzSG6bPMYHxmccG+VFVall8X87jT7hxgQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nG+CR8gK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9937606A320;
	Thu, 19 Nov 2026 00:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nG+CR8gK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D151F000C4;
	Thu, 19 Nov 2026 00:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049660;
	bh=ldEUTj2A36JwCzzAu9uRVC64x5lDosEopPIIqCvVAzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nG+CR8gKXJmx7o9YCy7LlXUPgt0r4Dmq2E+uaHN/+DVh71fuEUgD/uOgkprBOgeDy
	 4aFOYwMMb/aZuzuycdfoEiNeJC0FSrR+HiFcqaNK6w9mrLt2LmEeiRpJ3vq0gSm1ms
	 orl+HSdhgECeTPlTWekY/iDSVpHfEC1qDkUwim9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2431/2857] nvme-tcp: store and use the callers network namespace
Date: Wed, 18 Nov 2026 15:57:45 +0100
Message-ID: <20261118150329.098994292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13a66bb3b7892..31c2ffb6d011c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -170,6 +170,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	struct net		*net;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -1621,7 +1622,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid)
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create_kern(current->nsproxy->net_ns,
+	ret = sock_create_kern(ctrl->net,
 			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
@@ -2361,6 +2362,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -2787,12 +2789,15 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
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



