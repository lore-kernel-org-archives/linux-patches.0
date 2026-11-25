Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622910;
	b=EYKp3jURYZuRiZI68vz+vrXA6Jozdvb1wCjegY5X2ursrBoP9OBZ5p6HtzZFVzfJDuPW
	 g2lNILfnoQHvDeqDoz8Fz+B1QUG15T0C7ZikQ8FFdWQB2JR8qB6Qfuei9OpbkB5AoXjcG
	 FQWB6b5xJH9jaLJmDvO36e/ar3dYtmri3FDwz1IcecPfwj7k0SEuZlK9rGCJ+K9IOMQNJ
	 4IEVFAjsHL2eATzlzJjbNydIMmCmtuabkqxOtNsRRVuSvpIwfc9TW6GHd3QkvE4JUmNbB
	 +I4fFRucsM7pWN2r2T4NndfvaI6OVSiXVBbWlSuYqNKdcy7LFFRlBTj/YHzazEAUZJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=boDTxHFUfmxZcfvEdRt6ZKFmt0NauU/WZBTtQJ7pS9U=;
	b=Fo2rS+pgBSG5cTICMIglfJw3O5Dr4K7vHYnW4CFnCUjp+zRsbvUIGvwHMYdXk+bSRTIn
	 U+KQFw0iZ2DQm+QETlVe93x7DX0+j4F2UgzNat2VbpK3stk81zFwp5sKemfbCWFwxCvEH
	 zBZxPihEWn93ygvhBdBB0U729sU1mQnDieB88ApszkNKo7ENjnDsq+SFgElETrt+vfojf
	 v6LXCj5o/sVBjl01A9Z/MvGPBH+nys0Q9vkqfSlzOhP1LJFmyGegK9AkYwymd9hw5P9yW
	 hkPp3KRu87pddc01+zis/gxMi+RtV7sbUiK4fvaIXt4c1FzVA8KdZ7M44nyUqf2hSaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJj4Z+FA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2C7606A31E;
	Wed, 25 Nov 2026 16:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJj4Z+FA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E891F000E0;
	Wed, 25 Nov 2026 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622909;
	bh=boDTxHFUfmxZcfvEdRt6ZKFmt0NauU/WZBTtQJ7pS9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJj4Z+FA4XkdzkOsiRZ7Ni4qgF4k3H8ok2Y1crOUEFJeIgbGvx+2Q8eOz56k2Thn7
	 AN2J5N9pxzK+ZFbnDO5vwBoss0ASDATNljuB+dbSM7KwnESPUVmIBvfHm9FNnY70ov
	 xOkQMAnEeaxLpDTraKCD9kO4x+dU5Dr5yURmtQoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 645/990] Bluetooth: 6lowpan: avoid concurrent peer_del() in bt_6lowpan_disconnect
Date: Wed, 25 Nov 2026 15:33:32 +0100
Message-ID: <20261125143837.199636127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit df5175dfcf4879f6bcdadee614ac089e5627b721 ]

bt_6lowpan_disconnect() looks up and accesses peer->chan, without
holding locks guaranteeing peer_del() cannot free the peer concurrently.

Take devices_lock to ensure peer can be dereferenced safely.

Fixes: 15f32cabf426 ("Bluetooth: 6lowpan: add missing l2cap_chan_lock()")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Kept this tree's existing lock/close/unlock sequence on the pinned channel instead of upstream's l2cap_chan_close_unlocked() helper, which is missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 64dffdc8125b3..9515b82cda688 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -913,18 +913,29 @@ static int bt_6lowpan_connect(bdaddr_t *addr, u8 dst_type)
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
 
-	l2cap_chan_lock(peer->chan);
-	l2cap_chan_close(peer->chan, ENOENT);
-	l2cap_chan_unlock(peer->chan);
+	l2cap_chan_lock(chan);
+	l2cap_chan_close(chan, ENOENT);
+	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return 0;
 }
-- 
2.53.0



