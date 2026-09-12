Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B802EC09B;
	Sat, 12 Sep 2026 11:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212017; cv=none; b=UBge7u4BApMc5sdA8Xu/c+4s1UWtm3FIKlST96wompxN9UKSKgIZp8Gmj1pMgRteBsFgOPokI/v2E0cD8NjAKAWiyG9Tg60gQYh0V5ld75TJPO9GXojnjiPKwQa2zmyCKTWIpG/oH/GlaGCRWR5rlEXmhnhV598nqvwBXdlGCQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212017; c=relaxed/simple;
	bh=AdHpxXUVwqSTBcKk4AO8bLfRwCv9Dy86E1G/sZFqnGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObcdGaqYqh9szf72JjwHv05tgq7BrEmb4plxQ4C7IXLgJUfdNNvUK46FjEwckKgenutLadZ1uix2sEKq4HM3kNUoGGgW4F6q9d6nsCraktGgxnDjuDlbo0OMNPVCbPJsjqbAE1ycq1j/HrkA6inAd/Xf9YV5xX0XP36vTfqYjSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3SqmORR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3SqmORR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3011F000FF;
	Sat, 12 Sep 2026 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212015;
	bh=fHeUobzjx75jCz3DOv3KQC3ljEhuMfuw2VytVfRLgvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3SqmORRLNDJsASnu3xxvX4iu0I+icewmRI8z80KpheGllF6+4lDiGmmq5FGCsKeA
	 wfQ4eCxyELJuFq5Zvy6qh1bb+/agX9SBRa1HMkJFHkL85/ERp2wgUutJ6VyV/5oD7E
	 2pyfjGiqEQG1dpjcfkskA2yVSgnX1o8pkAx7Oo4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+483a6efbc4882c1201ee@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1350/1518] netdevsim: update queue NAPI association on queue reset
Date: Sat, 12 Sep 2026 08:58:39 +0200
Message-ID: <20260912065654.068427805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7a8e17bf46bdb..37260e488b9e8 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -576,6 +576,7 @@ static void nsim_del_napi(struct netdevsim *ns)
 	for (i = 0; i < dev->num_rx_queues; i++) {
 		struct nsim_rq *rq = ns->rq[i];
 
+		netif_queue_set_napi(dev, i, NETDEV_QUEUE_TYPE_RX, NULL);
 		napi_disable_locked(&rq->napi);
 		__netif_napi_del_locked(&rq->napi);
 	}
@@ -839,6 +840,7 @@ nsim_queue_start(struct net_device *dev, struct netdev_queue_config *qcfg,
 	}
 
 	ns->rq[idx] = qmem->rq;
+	netif_queue_set_napi(dev, idx, NETDEV_QUEUE_TYPE_RX, &ns->rq[idx]->napi);
 	napi_enable_locked(&ns->rq[idx]->napi);
 
 	return 0;
-- 
2.53.0



