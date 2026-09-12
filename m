Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209DD47AF69;
	Sat, 12 Sep 2026 16:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231674; cv=none; b=mbZ1GdRVpDf1zMEYHwnFun4R8c3uEJufT9B8w0swxrDQ5AOtEDxxixEY9hjcnS5lGOdZBJGfP0IeTKO40TlcXAXHiZvnEPzM276r1KO3MeBPsBEB6iMSNU+23HasyqeqRQjPOJ59RtCtG1hA4OSwOmLIsd3zmyGyCE4FXhslhW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231674; c=relaxed/simple;
	bh=mGQANhlgj9U3SzLf1gJEZ0jaU9YJb+o3Q2sWl+LZO7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJCl35a1os8LIDM2BlGBhadFb6Q9/q5NX1kLxcHzzcajYOV4qQRUh4Jk6LBoc6cuvk9FMT+R44/Q3tQNfZtV1FQobH4NkwQEMF5xJNQQKmPuGmnqbU1ylaYTHSw8Gh7jO07KPaLzTrxVjVn4cjQ6PoPem7vA812VPlL9wco2It8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYcvgVCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYcvgVCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1240D1F000FF;
	Sat, 12 Sep 2026 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231672;
	bh=nIVCzKV3fe0ZRRrTIUMur3U2/i4vg53RsdST0CI2Qa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYcvgVCbI5AYlsNfKmz6Z36+0AW29W2JU1I3Exu9RW/3ELMMuDOYP2/nVd+J2vxgI
	 Txzke8xCfvkwYZ6ed2GMwYoDYD0fm6P7ZOCogF1A+1jo271o2d3x/uK1LcWIBGl48c
	 +TPhHXeje+C494fat0k+hUVb4ENi8ykP2WLndTtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1046/1191] pppox: drain queued packets on channel handoff
Date: Sat, 12 Sep 2026 09:02:54 +0200
Message-ID: <20260912065611.669832186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 92c1bf630abf0af646562398eaa36f80b5ff677d ]

PPPIOCGCHAN both returns the channel index and marks a PPPOX socket as
bound to generic PPP, despite its getter semantic. Packets received
before that transition are queued on sk_receive_queue, but a bound
socket is no longer readable. Such packets therefore remain queued until
the socket is destroyed.

After marking a socket bound, wait for receive paths that observed the
old state to finish queueing packets, and then drain the queue into
generic PPP.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Link: https://patch.msgid.link/20260811035314.302878-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppox.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ppp/pppox.c b/drivers/net/ppp/pppox.c
index 08364f10a43fa..61b3453469dce 100644
--- a/drivers/net/ppp/pppox.c
+++ b/drivers/net/ppp/pppox.c
@@ -74,7 +74,9 @@ int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case PPPIOCGCHAN: {
+		struct sk_buff *skb;
 		int index;
+
 		rc = -ENOTCONN;
 		if (!(sk->sk_state & PPPOX_CONNECTED))
 			break;
@@ -85,7 +87,22 @@ int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			break;
 
 		rc = 0;
+		/* PPPIOCGCHAN historically marks the userspace handoff to
+		 * generic PPP; pppd then attaches the returned channel to
+		 * /dev/ppp.
+		 */
 		sk->sk_state |= PPPOX_BOUND;
+		/* Let lockless receive paths finish queueing against the old
+		 * state.
+		 */
+		synchronize_net();
+		/* Drain packets queued before the handoff because a bound
+		 * socket is no longer readable.
+		 */
+		while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
+			skb_orphan(skb);
+			ppp_input(&po->chan, skb);
+		}
 		break;
 	}
 	default:
-- 
2.53.0



