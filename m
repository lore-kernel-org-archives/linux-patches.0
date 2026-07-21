Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD5543B3D2;
	Tue, 21 Jul 2026 21:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670019; cv=none; b=qOvdN0KhDyMh0XHCxpW3KBOvzXZZDP0Y3H7j+43voBLE5OqoKa4IPRPkSwztsnFE0r7wGwPhic7Su9V+KvuQtR5FESLDYgfHO4ECcbdrSxcosdv7pHp9qTPe+fdfLe1IBWOeNIq71yaMROdX5VSyneQ6ILZMmdpj/lrWRepzv8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670019; c=relaxed/simple;
	bh=/UMhcjZu+vzTbof8UgFNtk9Y6c4f7BbNFQyoWvVkkJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF4pGRPOyD5WATwPfwxLzg/kYfnEXAs/PHL16hWdoN8HCSmeZS44G82l/Su/hskDtYtkItIDxK7p1ofmvV0qfVS7py7XeElFwxZvNsS+QX3qeUAEq7qqFFVOgK05BUnWhEWeCVKj0Hc7r1QpGsd5mHwMhL9n9hfZpNAm3dOmNKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEJIWUXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEJIWUXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B841F00A3A;
	Tue, 21 Jul 2026 21:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670018;
	bh=A+9Ndlx0yFcPXyUNwIHwD8UNKtja3mFzboYWRnn1oXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEJIWUXZ5jWmvi4vk+JfDfi6WqVtklZF2u/QGJKfFZfvG0UCSBRAxgy0USBMjR8ue
	 wEdzxVZKk/U7HXtnv13hntVd0VhkhG6yIj5JZ5jLkVOWyVxDEfAOew9mC/CP85za8b
	 8g3R1x69mrYH43MAAfBq0j5MXiT3US6+6jgKwlcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0774/1067] Bluetooth: SCO: fix sleeping under spinlock in sco_conn_ready
Date: Tue, 21 Jul 2026 17:22:55 +0200
Message-ID: <20260721152441.885242626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit b819db93d73f4593636299e229914052b89e3ef2 upstream.

sco_conn_ready calls sleeping functions under conn->lock spinlock.

The critical section can be reduced: conn->hcon is modified only with
hdev->lock held. It is guaranteed to be held in sco_conn_ready, so
conn->lock is not needed to guard it.

Move taking conn->lock after lock_sock(parent). This also follows the
lock ordering lock_sock() > conn->lock elsewhere in the file.

Fixes: 27c24fda62b60 ("Bluetooth: switch to lock_sock in SCO")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1328,26 +1328,24 @@ static void sco_conn_ready(struct sco_co
 		sk->sk_state_change(sk);
 		release_sock(sk);
 	} else {
-		sco_conn_lock(conn);
-
-		if (!conn->hcon) {
-			sco_conn_unlock(conn);
+		if (!conn->hcon)
 			return;
-		}
+
+		lockdep_assert_held(&conn->hcon->hdev->lock);
 
 		parent = sco_get_sock_listen(&conn->hcon->src);
-		if (!parent) {
-			sco_conn_unlock(conn);
+		if (!parent)
 			return;
-		}
 
 		lock_sock(parent);
 
+		sco_conn_lock(conn);
+
 		sk = sco_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_SCO, GFP_ATOMIC, 0);
 		if (!sk) {
-			release_sock(parent);
 			sco_conn_unlock(conn);
+			release_sock(parent);
 			return;
 		}
 
@@ -1367,9 +1365,9 @@ static void sco_conn_ready(struct sco_co
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		release_sock(parent);
-
 		sco_conn_unlock(conn);
+
+		release_sock(parent);
 	}
 }
 


