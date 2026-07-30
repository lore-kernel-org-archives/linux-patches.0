Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B4E432E94;
	Thu, 30 Jul 2026 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423587; cv=none; b=YOEKQSNJMYLZ7mbW5kWW1+9nUCCt0ZpWJ2dx6Vrsdnjpw6WFR0hFA/Rf5sadfJOMv5unfdZBF/p0UCVbCR7hLfN2DK8W4/7DYWlxw0hL0cmwTa3TRUNlNm+GdU77wAFaNGZnwgKSKRqERg6eE8Ev+sQOccu580KgTEHQXCrtkqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423587; c=relaxed/simple;
	bh=iKPxPYzsxid/AHym+Le1akN38zeuiO8pgThCcTV21Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8sccCI4+t5BRQnrRM4WOxr/kmEeEKSw7HFBuYvNIN6BwlXXyZ7z9wbvnD5uIOJHpYKg43RzweF/rNyF2lWUXhmMCMf1zzYYs2MdT0RzZoRXjY0K/9ICH7FU2fG+LYxTM7y8eZOFH8IwpJtxytSPRxVQ/HZLLa+kBN7gsP6IJQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0gc2Dl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0gc2Dl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C5F1F000E9;
	Thu, 30 Jul 2026 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423586;
	bh=IJoCkVZa/VX+p54ZHG7fsctYQHqq0rLX25VRxmpamqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0gc2Dl1fZflSfGQmMCm/yLwhA6kD1y7lGugR2kYzICeiL0DKzS4zuG3RNUy9No/K
	 7MYdgDCTUnFNRxVhcSjB3nc2mH5qWlpTFeu5+yP5ZMlpCYp13DYoHIdeSuMHnSwCs4
	 E9JXeQjTnSqbUOvXJ+jByT3DGEJx726qCuOhn1lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/675] ppp: defer channel free to an RCU grace period to fix pppol2tp RX UAF
Date: Thu, 30 Jul 2026 16:07:06 +0200
Message-ID: <20260730141447.170454827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit ec4215683e47424c9c4762fd3c60f552a3119142 ]

pppol2tp_recv() runs in the L2TP UDP-encap softirq RX path:

 l2tp_udp_encap_recv() -> l2tp_recv_common() -> pppol2tp_recv()
   -> ppp_input(&po->chan)

It runs under rcu_read_lock() holding only an l2tp_session reference and
takes NO reference on the internal PPP channel (struct channel,
chan->ppp) that ppp_input() dereferences.

The pppox socket is SOCK_RCU_FREE, so 'po' and the embedded ppp_channel
are RCU-safe.  But the internal struct channel is a separate allocation
that ppp_release_channel() frees with a plain kfree():

 close(data socket) -> pppol2tp_release() -> pppox_unbind_sock()
   -> ppp_unregister_channel() -> ppp_release_channel() -> kfree(pch)

For a channel that is bound (PPPIOCGCHAN) but not attached to a ppp unit
(no PPPIOCCONNECT, pch->ppp == NULL) and not bridged, teardown skips
both ppp_disconnect_channel()'s synchronize_net() and
ppp_unbridge_channels()'s synchronize_rcu(), so the kfree() has no grace
period.  rcu_read_lock() in pppol2tp_recv() does not protect against a
plain kfree(), so an in-flight ppp_input() on one CPU can dereference
the channel just freed by close() on another CPU.

The bug is reachable by an unprivileged user.

Defer the channel free to an RCU callback via call_rcu() so the grace
period fences any in-flight ppp_input(). The disconnect and unbridge
teardown paths already fence with synchronize_net()/synchronize_rcu();
call_rcu() does the same here without stalling the close() path.

Fixes: ee40fb2e1eb5 ("l2tp: protect sock pointer of struct pppol2tp_session with RCU")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Qingfang Deng <qingfang.deng@linux.dev>
Link: https://patch.msgid.link/E793FCF2-58DE-4387-A983-C7B4BC3158BD@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 507d216256c0dd..72e98286fba2fe 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -185,6 +185,7 @@ struct channel {
 	struct list_head clist;		/* link in list of channels per unit */
 	spinlock_t	upl;		/* protects `ppp' and 'bridge' */
 	struct channel __rcu *bridge;	/* "bridged" ppp channel */
+	struct rcu_head rcu;		/* for RCU-deferred free of the channel */
 #ifdef CONFIG_PPP_MULTILINK
 	u8		avail;		/* flag used in multilink stuff */
 	u8		had_frag;	/* >= 1 fragments have been sent */
@@ -3570,6 +3571,18 @@ ppp_disconnect_channel(struct channel *pch)
 	return err;
 }
 
+/* Purge after the grace period: a late ppp_input() may still queue an
+ * skb on pch->file.rq before the last RCU reader drains.
+ */
+static void ppp_release_channel_free(struct rcu_head *rcu)
+{
+	struct channel *pch = container_of(rcu, struct channel, rcu);
+
+	skb_queue_purge(&pch->file.xq);
+	skb_queue_purge(&pch->file.rq);
+	kfree(pch);
+}
+
 /*
  * Free up the resources used by a ppp channel.
  */
@@ -3585,9 +3598,7 @@ static void ppp_destroy_channel(struct channel *pch)
 		pr_err("ppp: destroying undead channel %p !\n", pch);
 		return;
 	}
-	skb_queue_purge(&pch->file.xq);
-	skb_queue_purge(&pch->file.rq);
-	kfree(pch);
+	call_rcu(&pch->rcu, ppp_release_channel_free);
 }
 
 static void __exit ppp_cleanup(void)
@@ -3600,6 +3611,7 @@ static void __exit ppp_cleanup(void)
 	device_destroy(&ppp_class, MKDEV(PPP_MAJOR, 0));
 	class_unregister(&ppp_class);
 	unregister_pernet_device(&ppp_net_ops);
+	rcu_barrier(); /* wait for RCU callbacks before module unload */
 }
 
 /*
-- 
2.53.0



