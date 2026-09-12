Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AC92F7F19;
	Sat, 12 Sep 2026 09:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204751; cv=none; b=RLWuRpud6odji6L+uuTAMVtRXeeH69sInABvPkjoXu4m5TmOCgH5jRh7BWV3ouMmgC0VX+I47tJQ5MoE6lEKGYr2RT6PvSPVFSpnkWEV1ZcmHeTpwMLMD88OcBS7TmskjlsOg4swUg3fstOhIZ0lE43//1f0Fcq2b7XPulNR5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204751; c=relaxed/simple;
	bh=Rc/o7F/0UKZQ60d+I8jVJsf8IzDtaP0sHjean+ZDsYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXI/VK5sAr+1vZsxNcz+T5eQ75uvVBdUIqJJFgnWvCem3lnegSXPvA6hWh+awJCe5AZzyIYHZcsoMZSemDAzlG2P1gUeNFOWIlN+36KssLQ6jbU8mWguc2WAtcBi9x+kJ+riuYBE2jog+W4D3FEd3Br6a1eA31v6HYvzLlj+OuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eynWuSeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eynWuSeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384251F000FF;
	Sat, 12 Sep 2026 09:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204750;
	bh=fpluV+lMi+myIT/utUHLrn7wr7E1BmokAjEmkD2D6rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eynWuSeuku++nERKDoZNWUIISqdRz6M5inByiOyG0txT9pXCrApzA3hwDUueYa4gz
	 j0Vz0y/oa4OrbR0Vm7GJN60zJYtHZoJdZHyAdI1GqrlRVTLA9TJ9SXnpBWDVny3Trz
	 RcXtE0ovRVUUUxSIS7r05yh1iM1NmHAXc0P6F1rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+483a6efbc4882c1201ee@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1676/1815] netdevsim: update queue NAPI association on queue reset
Date: Sat, 12 Sep 2026 08:57:06 +0200
Message-ID: <20260912065728.332629861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 07e98a4d5e9c292eae97c9cc5ab0937384e48492 ]

In netdevsim, receive queues (struct nsim_rq) embed their own struct
napi_struct. When queue reset is performed (e.g. via queue_reset
debugfs), nsim_queue_start() swaps in a newly allocated struct nsim_rq,
and nsim_queue_mem_free() later deletes and frees the old one.

However, nsim_queue_start() failed to update the queue-to-NAPI mapping
via netif_queue_set_napi(). As a result, dev->_rx[idx].napi continued to
point to the old NAPI struct. After the old queue was freed, a subsequent
queue dump via Netlink (NETDEV_CMD_QUEUE_GET) triggered a KASAN
slab-use-after-free read in nla_put_napi_id() when accessing
rxq->napi->napi_id.

Fix this by calling netif_queue_set_napi() in nsim_queue_start() to
associate the new NAPI with the RX queue, and clear the association
with netif_queue_set_napi(..., NULL) in nsim_del_napi() during teardown.

Fixes: 5bc8e8dbef27 ("netdevsim: add queue management API support")
Reported-by: syzbot+483a6efbc4882c1201ee@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a82c3d4.f7a79266.2f965f.0024.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260817082511.2300402-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 4e9d7e10b527e..b4a99f3ceac60 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -529,6 +529,7 @@ static void nsim_del_napi(struct netdevsim *ns)
 	for (i = 0; i < dev->num_rx_queues; i++) {
 		struct nsim_rq *rq = ns->rq[i];
 
+		netif_queue_set_napi(dev, i, NETDEV_QUEUE_TYPE_RX, NULL);
 		napi_disable_locked(&rq->napi);
 		__netif_napi_del_locked(&rq->napi);
 	}
@@ -826,6 +827,7 @@ nsim_queue_start(struct net_device *dev, struct netdev_queue_config *qcfg,
 	}
 
 	ns->rq[idx] = qmem->rq;
+	netif_queue_set_napi(dev, idx, NETDEV_QUEUE_TYPE_RX, &ns->rq[idx]->napi);
 	napi_enable_locked(&ns->rq[idx]->napi);
 
 	return 0;
-- 
2.53.0



