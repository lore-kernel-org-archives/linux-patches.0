Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF3B4594E;
	Wed, 30 Sep 2026 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793165; cv=none; b=Rtq3TPJRPRuKB+LOLecfrepilMezbZP3DIKXP+fC1paA8+ArvYqz61Jxzr+lnahLa9HsMZ3Lwmvk0Z4hvBrWSyZk4MsoyiAQ8G3isHYw1lDFznhpzfdrv/KZUS9ftPWIeD6u+1xawWBYhyUPVQdySDcjJmcHtgnVSlWERJb1ygM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793165; c=relaxed/simple;
	bh=xQhpDRhuISC+B4KysjlDn6/0w8tm+o48cNsIr2AX56w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctjv7SBPuQXPsTWpna+w6k5QOd1rDRDhOKIe3GfvKSiqWTmq8J6GvPVVSUI16gnSNwCRAiEuUPdyEpxNIoGV7PZNe1Dto78LCnAuCpOAfF9F5gl/Vey00SveSYSmKJIDTvdLV6AEYbs4QIJxZXwDJFajqzSfHLaxeGBWoyyqNA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGlG9Eqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGlG9Eqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1FF1F000FF;
	Wed, 30 Sep 2026 18:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793164;
	bh=FmTgyDwG6ELquPLRSEm8GEplzwXgyolgl/Ic8zCS074=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGlG9EqdOJlvYerXVKr2G3c/6AQ2mTvoNJfxen5xZ9OUvscZrv6ZAgsKmhugLyUpS
	 XvvCohTXwgdzgw0RYuU96u2wHRQ59qZK1WiIxsQ2Jg1I7wIJzOMP86ug6l0Bur3jDi
	 Q/DvDQ/1gYDaKrNegbfMeHl70LD0Fu5OStsMOhII=
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
Subject: [PATCH 6.18 157/395] veth: manage XDP program pointers during channel resize
Date: Wed, 30 Sep 2026 17:26:59 +0200
Message-ID: <20260930152344.050958045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 56519b646cacd..fea031d491b34 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1053,6 +1053,7 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
+		rcu_assign_pointer(rq->xdp_prog, priv->_xdp_prog);
 		napi_enable(&rq->xdp_napi);
 		rcu_assign_pointer(priv->rq[i].napi, &priv->rq[i].xdp_napi);
 	}
@@ -1087,6 +1088,7 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
 
 		rcu_assign_pointer(priv->rq[i].napi, NULL);
 		napi_disable(&rq->xdp_napi);
+		rcu_assign_pointer(rq->xdp_prog, NULL);
 		__netif_napi_del(&rq->xdp_napi);
 	}
 	synchronize_net();
-- 
2.53.0



