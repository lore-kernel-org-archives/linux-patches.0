Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C8451CF6A;
	Wed, 30 Sep 2026 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792458; cv=none; b=ihDf9pS/r7Tf6VVV92bnOOIfXjW7iUkC6dD1yK8/nfMS/qy1j9J/OQBJpSaUWg02fByndt9qlWUZkiCbMbX7728yu4nSdwhwrQDp+X5TUMHcFSBirmfuIc8ylJatFBSOa0cP2KoIYSvTuZMUo8w86ppqJxlDkexujBHo8/M8+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792458; c=relaxed/simple;
	bh=xLpbgL6IJo9sM0A+oBuuZb3NGsnEgfrrf2mbc4dthpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7Rgpd4K2UpJ86h07gbspVUlm7KU8nNw0gwRNOaVgkjVXay1kT1sl8KioMHsN16GCeZeHW3xacuo5BcEZUDvYQQ6V7ZXJiHBVwfkku8cBTluU8j0kb7vryjTmrhS+RbiQYOTok0+TTC7I6w4W53LUUsMEf4Gh1x7qQuVDLJaefc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMWbs0IL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMWbs0IL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224481F000FF;
	Wed, 30 Sep 2026 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792457;
	bh=4UNrVpCGXa9Vf8nWUdk7/ZGSx+5B9LmxM8zSqakvnAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMWbs0ILigAyBdN3VSD8gS8BOC7doseDiDWcrixVss4e01KXrqHg3ulsqluaumizl
	 31yIgDYmSZcw0gr9/yy8lkwvpLji233nYlk4efFOzuBbsvsbvdR93H7VNooqVQpTiE
	 dWR3yYTd2K5pfPE0d6JwLqaAyzaiDXNY5Zp/IiGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 663/752] veth: manage XDP program pointers during channel resize
Date: Wed, 30 Sep 2026 17:28:53 +0200
Message-ID: <20260930152412.604541671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7104a370714346b667712913dc16abf14bbc97ed ]

veth_set_channels() tears down XDP resources for removed RX queues
without clearing rq->xdp_prog.  If the program is then detached or
replaced, those queues keep the old pointer after bpf_prog_put().
A later channel increase can re-enable NAPI and run the freed program.

  BUG: unable to handle page fault for address: ffffc90000256048
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: veth_xdp_rcv_skb (include/linux/filter.h:779
                         include/net/xdp.h:696 drivers/net/veth.c:820)
  Call Trace:
   veth_xdp_rcv (drivers/net/veth.c:941)
   veth_poll (drivers/net/veth.c:986)
   __napi_poll (net/core/dev.c:7787)
   net_rx_action (net/core/dev.c:7850 net/core/dev.c:8007)
   handle_softirqs (kernel/softirq.c:645)
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 4752eeb3d891 ("veth: implement support for set_channel ethtool op")
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260921231856.1798630-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 55c53895386aa..67fe853b245a7 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -955,6 +955,7 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
+		rcu_assign_pointer(rq->xdp_prog, priv->_xdp_prog);
 		napi_enable(&rq->xdp_napi);
 		rcu_assign_pointer(priv->rq[i].napi, &priv->rq[i].xdp_napi);
 	}
@@ -983,6 +984,7 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
 
 		rcu_assign_pointer(priv->rq[i].napi, NULL);
 		napi_disable(&rq->xdp_napi);
+		rcu_assign_pointer(rq->xdp_prog, NULL);
 		__netif_napi_del(&rq->xdp_napi);
 	}
 	synchronize_net();
-- 
2.53.0



