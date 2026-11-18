Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020227;
	b=JvMXzDQZnS8EJEeueUBVkDRO4D0onDpG7IeLeUhmWrsvITd/D92q9g1aH02pFMSLe3MD
	 wEJOSEuxvd7e5O1NJ6mnM7m4RMTWwowRfiqRPT9CMuF5kBpJwU2APKkW/U6h1rAC4Olrw
	 Qp67FC4W0xG9clSTaK0j2BgMnQ12hq6x9OFcPNGM1G8tmiGzZGo7pjkJWuGbwwhTmqoQq
	 heLllmjuBX2N+EMI1IjFSYtRVR5HhwChfVuDDinfdLlHXA3h54nvcot+pf76JRniBU+ya
	 w2ixGtZeSYS2F3UTqLf9IaKQeX8p00hFDaxcWt9bWjgPh3eCRPD8Ojm1AHsrN1YuE6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=If/WqM6j+XAwPd6R7Im+CBFbCAVKdhatXuUow98iIzw=;
	b=CB/I3LfI4ujY0nfqq9M8p1lVyeFpYnC9eeFmvhLh99WPU783FvF46xFMEO1c3sJ1qjU0
	 +ezrlvqtekEro6KXLTUGsEs43R7yIb+R4BEm5TVjutKxsjKKX7EFw64jteXu/jqXFFoFZ
	 0Mp03esYoHVwoU8EFmvgI/BZzvNkxjH+Ksc+gauhhxSGCkm8mKuPKsWoQ4hDY9zjmlt+3
	 Ya2k2GXWHACg+SNEtsDvWTouaNwsicGcS/Jy6WBRl0Xqd9VopUWSdY8lz6iDJU1pt3/qV
	 QkvJMgyv9cak3UdrwczD1byFXeu80hDXNP3bSWRDTX2wVhQjeqyTNTfXYA2VLc5Sq9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi7oxMBN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED91606A325;
	Wed, 18 Nov 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi7oxMBN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF221F000C6;
	Wed, 18 Nov 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020227;
	bh=If/WqM6j+XAwPd6R7Im+CBFbCAVKdhatXuUow98iIzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi7oxMBNWjOfN0Ovv8PhGnBAsYKsfzETXHbCnHBfvccyTVCciaGtEnTVmnRObZL7Q
	 l8r0BlgbCFHTvrbN6B8aZdlEJI/6xW/fEQPOlkSgh3IJel69gib81RF95wnWbSGfTM
	 JaLopAOzUHlfmzfVl2KQLMdroUebcerjrVw+nBFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1874/2651] Bluetooth: 6lowpan: avoid concurrent peer_del() in bt_6lowpan_disconnect
Date: Wed, 18 Nov 2026 15:51:54 +0100
Message-ID: <20261118150354.415926324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit df5175dfcf4879f6bcdadee614ac089e5627b721 ]

bt_6lowpan_disconnect() looks up and accesses peer->chan, without
holding locks guaranteeing peer_del() cannot free the peer concurrently.

Take devices_lock to ensure peer can be dereferenced safely.

Fixes: 15f32cabf426 ("Bluetooth: 6lowpan: add missing l2cap_chan_lock()")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 50402bd4e1b07..500211793528f 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -912,16 +912,27 @@ static int bt_6lowpan_connect(bdaddr_t *addr, u8 dst_type)
 static int bt_6lowpan_disconnect(struct l2cap_conn *conn, u8 dst_type)
 {
 	struct lowpan_peer *peer;
+	struct l2cap_chan *chan;
 
 	BT_DBG("conn %p dst type %u", conn, dst_type);
 
+	spin_lock(&devices_lock);
+
 	peer = lookup_peer(conn);
-	if (!peer)
+	if (!peer) {
+		spin_unlock(&devices_lock);
 		return -ENOENT;
+	}
+
+	chan = peer->chan;
+	l2cap_chan_hold(chan);
+
+	spin_unlock(&devices_lock);
 
-	BT_DBG("peer %p chan %p", peer, peer->chan);
+	BT_DBG("peer %p chan %p", peer, chan);
 
-	l2cap_chan_close_unlocked(peer->chan, ENOENT);
+	l2cap_chan_close_unlocked(chan, ENOENT);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
-- 
2.53.0



