Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061593;
	b=sCGpdh8TOzSVPwgfk9tJLiXKZMk8nPHPAso7pNp3kxd9WjBNKEecokBqP/tv1DgV77sG
	 GZDgLBc2rVTaH/nZzu2cXKhNXroUvzbpgi6z2N1uosN1fcUCKsXt19UkwoZvP9b271Nv7
	 DjH3IssrRglN4Lt7TA0pAQYob0y0u8xNHsitJxhicIO1lGFs4aVsXhfn7ARwm8WJPWtV8
	 ZLSOQISvbr/DpBB1KhJFh7mN5dUj6DjY8UxIh7SftX8G5Vv5Kuon8kaxc3kQRfrmlXAle
	 k5zgbeW32mlONqotJ5WCzmBSAk2mmfiFIAbhQG4K7BCvu6SYedCRSD4sJHp0oYujzLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQAYT/n4B701GEr/p6c37XZacFqtMad4R+uP9YcnoJ8=;
	b=l6wgrnZ2s0DK6Ng+D9kTVijGEm3dTYO1ALNhOStBLllXqDqjiNlv+AjptWhUm+mqnCn4
	 UMFcgubwu36qJTTofbuP/TbPKkX1nDpdlPN2oJy41hpHFmt9xlSLouSAyBRkTVI7zVp1s
	 6y9ntIP2qVXBf2BehZk04cFIOA+3idlCK1Nnwu/JNryVXYFumhh1CVgwJa1RA6FcoXt8e
	 XHlIcY+gv1qilIjgEWK++r9p/1jwrUnLv+Wo+50rcYb0Up2HlpHt0XYwu2z6ZDSKz05A8
	 TSdTOM03kg/W8JclnxXO9QIf+ysm85r/8Jjb+4MCfqXlxlSvgZ+3DqFJXPrsKdldNXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vh8I7jgR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A734606A332;
	Thu, 19 Nov 2026 04:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vh8I7jgR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E46F1F000C4;
	Thu, 19 Nov 2026 04:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061592;
	bh=hQAYT/n4B701GEr/p6c37XZacFqtMad4R+uP9YcnoJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vh8I7jgR4mokRV/JT3VdE5B7fS9HpcFl3qWB6nVE75P6kX5zhRelp4drUgF+pb9bd
	 /7uKINz8vESQd4Xjkb9YnqLKCmv1SVhrWzFGtG+wE5UCo7or2zk5LvmB/usS7PMnoK
	 J0+jwgNciL68XVN+/2NgmbAzLzjkUOB5Qr22A44I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surabhi Gogte <sgogte@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1609/1848] nvme-tcp: store and use the callers network namespace
Date: Wed, 18 Nov 2026 16:00:47 +0100
Message-ID: <20261118150026.898952660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e9776ad102d0e..f87ae42ec9e4c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -168,6 +168,7 @@ struct nvme_tcp_ctrl {
 	struct delayed_work	connect_work;
 	struct nvme_tcp_request async_req;
 	u32			io_queues[HCTX_MAX_TYPES];
+	struct net		*net;
 };
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
@@ -1503,7 +1504,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 		queue->cmnd_capsule_len = sizeof(struct nvme_command) +
 						NVME_TCP_ADMIN_CCSZ;
 
-	ret = sock_create_kern(current->nsproxy->net_ns,
+	ret = sock_create_kern(ctrl->net,
 			ctrl->addr.ss_family, SOCK_STREAM,
 			IPPROTO_TCP, &queue->sock);
 	if (ret) {
@@ -2281,6 +2282,7 @@ static void nvme_tcp_free_ctrl(struct nvme_ctrl *nctrl)
 
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
+	put_net(ctrl->net);
 	kfree(ctrl->queues);
 	kfree(ctrl);
 }
@@ -2676,12 +2678,15 @@ static struct nvme_tcp_ctrl *nvme_tcp_alloc_ctrl(struct device *dev,
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



