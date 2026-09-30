Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1475A514770;
	Wed, 30 Sep 2026 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786513; cv=none; b=ULbHqz+dW+PYnXGq9V4dAymRjPfcwH72R4fcZm//rYOaTm8j2aA3HdNO0WTIhVS/wcGZpRno5q5/4ddAvBBO1hai9VJmymTqRWZXOcoov6/V8+uJ40w4eSaS2jw33EMdh4rjEGd2FmM3jbJGtT0UBCix4YH7G5xiHtMBcThswp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786513; c=relaxed/simple;
	bh=IPx6rovRM4IRmx0BLKRp6/9cqPeXu9pDWhS7Mmbxjzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6SrponZHEOUSnapZez3iIudHj+4bRu6VPtfv0mMja7SEQMftv0/1oeuhHmsC3h6YJO6SDhRhGN7m7HWcJ3TRSjkY9yo03MCDH9Y8jahAZpD2mpcY9RAD546SON1I6QcZYXoQotO31c00E6K5OLkLvsBHMhKUlKbQ6dfCGkYioU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wu1qxhnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wu1qxhnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE31F00898;
	Wed, 30 Sep 2026 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786512;
	bh=xrPgETHIbEeBq51JhA6SShF7KDZW1aMQhXogyZ6ipTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wu1qxhnPmk/pFE1VEGag2CA5ZWDYMTBcbrqFlIJrO7FdrrWamT4ymL90+fNCXHSGn
	 U2Gw6V26VnspV8ly/iKYTdRP6gEUKGdXqID8bNP2+f9Mev6OrvH+U/V+1sQqhAbtYN
	 D+h+trUJRgWlmu7WKNhOJiglLAa1X6mfBBUa+p/4=
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
Subject: [PATCH 6.1 889/982] veth: manage XDP program pointers during channel resize
Date: Wed, 30 Sep 2026 17:27:05 +0200
Message-ID: <20260930152435.843789538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7e8c277a9255..2eef96cfd279a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1015,6 +1015,7 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
+		rcu_assign_pointer(rq->xdp_prog, priv->_xdp_prog);
 		napi_enable(&rq->xdp_napi);
 		rcu_assign_pointer(priv->rq[i].napi, &priv->rq[i].xdp_napi);
 	}
@@ -1043,6 +1044,7 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
 
 		rcu_assign_pointer(priv->rq[i].napi, NULL);
 		napi_disable(&rq->xdp_napi);
+		rcu_assign_pointer(rq->xdp_prog, NULL);
 		__netif_napi_del(&rq->xdp_napi);
 	}
 	synchronize_net();
-- 
2.53.0



