Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F74E3806D9;
	Thu, 30 Jul 2026 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425473; cv=none; b=YMVa50FAeQbKxytvg5oI+ZJHQjzmG5Det8t7td0nO5AwjaYC0xfW9hVLqxkz7e9SyNDAJeH87cZMMWe7yRjD7vm1uGEP4d0ETlHLRU7iXrP71MrWRu6RX5HIPjClDnU3gpxkHWUjnqUF++1dKsj7APlEBLXK26yc9RB1HzxGApk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425473; c=relaxed/simple;
	bh=pk8rQ4HtsKYmbIlnyU1pnV0oWQUnk0zHDg5q4zbzJgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e47lD+jIoKDwJK+VrKRz481bPRuCaFe48d9lERnIwJpdoXUBZjLGz5LEC6m3rjFWB1WusLrUc5ddp85OPv/IMyGcJkOBB4MK4mD/w5vaI94KkrvdmQCB4XmlqaLYsmYwEHydl26q2riexsRz0wy3xavuTa18aA3h0Wg3VFAmeLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ims4QnPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ims4QnPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890D61F000E9;
	Thu, 30 Jul 2026 15:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425472;
	bh=poEgmPHlnZJaaH0bYSkjMQ1p/4Q3RdPoZDbLuF9sU/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ims4QnPpxol7uPLOOdvlDzr3eqSCLGiv+GYObnpf9MnmjATUZ3KuybX9yIhZLE4Et
	 8/llT4cysT4W6ZWtl6EVEy2uOwBzBTQCukfRRf8tOaodyGMY6LkLjkz8V3AGX20Kcj
	 cryWKQy3PNhxMTOy/Jiui8vjPS+zutaAuDDdIxfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/602] ppp: defer channel free to an RCU grace period to fix pppol2tp RX UAF
Date: Thu, 30 Jul 2026 16:07:52 +0200
Message-ID: <20260730141437.678520338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c70994c6a265e3..9f787adef3eb38 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -192,6 +192,7 @@ struct channel {
 	struct list_head clist;		/* link in list of channels per unit */
 	rwlock_t	upl;		/* protects `ppp' and 'bridge' */
 	struct channel __rcu *bridge;	/* "bridged" ppp channel */
+	struct rcu_head rcu;		/* for RCU-deferred free of the channel */
 #ifdef CONFIG_PPP_MULTILINK
 	u8		avail;		/* flag used in multilink stuff */
 	u8		had_frag;	/* >= 1 fragments have been sent */
@@ -3555,6 +3556,18 @@ ppp_disconnect_channel(struct channel *pch)
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
@@ -3570,9 +3583,7 @@ static void ppp_destroy_channel(struct channel *pch)
 		pr_err("ppp: destroying undead channel %p !\n", pch);
 		return;
 	}
-	skb_queue_purge(&pch->file.xq);
-	skb_queue_purge(&pch->file.rq);
-	kfree(pch);
+	call_rcu(&pch->rcu, ppp_release_channel_free);
 }
 
 static void __exit ppp_cleanup(void)
@@ -3585,6 +3596,7 @@ static void __exit ppp_cleanup(void)
 	device_destroy(&ppp_class, MKDEV(PPP_MAJOR, 0));
 	class_unregister(&ppp_class);
 	unregister_pernet_device(&ppp_net_ops);
+	rcu_barrier(); /* wait for RCU callbacks before module unload */
 }
 
 /*
-- 
2.53.0



