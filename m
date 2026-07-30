Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B757443A89;
	Thu, 30 Jul 2026 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424910; cv=none; b=odbCVTw64oIzgTpVR1vdxjD6sDTJnS0Nz78hkAKP1MbyuR7BrnRdtmQeQ8icnzFCtcJCMxLZKbjLOOqZAxRextV6OBkYcfss+31l+u3mSWHUeDbpo1UgCOzrLoQAX8Yi4wZasXY6gmNG+Je003f/u+GoEsDPeElZRRDEVlEirb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424910; c=relaxed/simple;
	bh=KN8fU/k2FX9Sw8g0q4XDsp7M/08rp72NH/CwcTaAbL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLU1ILXv2tPmRwuBFi+oCIsicOGEIogWduEHyEFBdBij3bTTGw2s5pv0tyH4So4rk6uQcN9r4D3ZA1jkAlXAWMVDrhLS6l4Arj0VKBJerrS8IjhptWKBU127wCmiEAeeuzdLN5s3cBQ0pFvhi8qLrIFqO5BkzFjga0OjWnBxZdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7RJjNqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7RJjNqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E41F000E9;
	Thu, 30 Jul 2026 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424908;
	bh=vF68PUFwStxsnSFZFBy1Aw4q/wdsB/rBcQAmymCNRKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7RJjNqnTXZRYoL6vkVV2uUzbat0T0jw5yqaPdt3nNUNj8ppAv3E7xNzp5Uf93c46
	 snUs3v/pIrD2YD3OHa0k1KCw5nnnPw/FJUeeG+RRP68K5xQRywbJsdxKbQCtIe+0Aq
	 N0YIqcM1SbeiimAt8LFut4e6i93PDQN0txUSIQds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>
Subject: [PATCH 6.18 560/675] ovpn: fix peer refcount leak in TCP error paths
Date: Thu, 30 Jul 2026 16:14:50 +0200
Message-ID: <20260730141457.036643959@linuxfoundation.org>
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

From: Pavitra Jha <jhapavitra98@gmail.com>

commit 63bbe18fc03062f483c627838a566a707b62da79 upstream.

When either the TCP RX or TX error path calls ovpn_peer_hold() followed
by schedule_work(&peer->tcp.defer_del_work), and the work item is already
pending from the other path, schedule_work() returns false and the work
runs only once. Since ovpn_tcp_peer_del_work() calls ovpn_peer_put()
exactly once, the extra reference taken by the losing path is never
dropped, leaking the peer object.

The race window:

  CPU0 (strparser/RX error):       CPU1 (tcp_tx_work/TX error):
  ovpn_peer_hold()   <- refcnt+1   ovpn_peer_hold()   <- refcnt+2
  schedule_work()    <- queued      schedule_work()    <- NO-OP
                                    (work already pending)
  ovpn_tcp_peer_del_work runs:
    ovpn_peer_del()
    ovpn_peer_put()  <- refcnt+1
                                   <- peer never freed

Fix by checking the return value of schedule_work() in both paths and
calling ovpn_peer_put() to drop the extra reference if the work was
already pending. ovpn_peer_hold() is kept unconditional in the TX path
as it cannot fail at that point.

Fixes: a6a5e87b3ee4 ("ovpn: avoid sleep in atomic context in TCP RX error path")
Cc: stable@vger.kernel.org
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ovpn/tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index 433bd07a4f1b..0af14055c39a 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -151,7 +151,8 @@ static void ovpn_tcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	/* take reference for deferred peer deletion. should never fail */
 	if (WARN_ON(!ovpn_peer_hold(peer)))
 		goto err_nopeer;
-	schedule_work(&peer->tcp.defer_del_work);
+	if (!schedule_work(&peer->tcp.defer_del_work))
+		ovpn_peer_put(peer);
 	ovpn_dev_dstats_rx_dropped(peer->ovpn->dev);
 err_nopeer:
 	kfree_skb(skb);
@@ -283,7 +284,8 @@ static void ovpn_tcp_send_sock(struct ovpn_peer *peer, struct sock *sk)
 			 * stream therefore we abort the connection
 			 */
 			ovpn_peer_hold(peer);
-			schedule_work(&peer->tcp.defer_del_work);
+			if (!schedule_work(&peer->tcp.defer_del_work))
+				ovpn_peer_put(peer);
 
 			/* we bail out immediately and keep tx_in_progress set
 			 * to true. This way we prevent more TX attempts
-- 
2.55.0



