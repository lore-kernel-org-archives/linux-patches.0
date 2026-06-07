Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925452D3A69;
	Sun,  7 Jun 2026 10:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828537; cv=none; b=GvcGM4A3A47aEcvbzEQSj6+XTK/t32ZQdbYeoC/22XM34rCLDLdWDg0SCsB/y7KhUW9B8xF8UXx/vKckJ/ebceMArj0P8YgwoStw5YQb/J76h7XHg0LxZBgWNsS3TwkhmmiedaQ7HABEHbvkfSjwjWs5Z9zyXk3pyQE2DU5UCEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828537; c=relaxed/simple;
	bh=ykX1TT8wdY6kop1e1oydICvZOZk+Q3FmMstz6mZyh6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENNedNH9i6W6I35stW6uO+aRkzvEvYdM0Aqo5Jho0vPDZoXL0amM/Nmg063jPUMnCPbEC3YNQwa2960IIOhHrghlOaTK5DCL4zW6Wm6CkWQcJhQzVpz2VcMJJsmLYoPqlGuxkQZ/cVnyukaWSwFNrpLKBmB/jPShocOOzJaW3yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh+IewrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh+IewrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF501F00893;
	Sun,  7 Jun 2026 10:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828536;
	bh=0R53gYc2buAC0Tbn+tYjgU6MdsU8agYftCPw1v0ZFy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hh+IewrPD+a8ZQxYvzeE6PT6dZF6KgClk4v9w2b0qow4F9NmEpz8zAKV4OeIIxdwY
	 DGNh5MTmyyfVbVBBH5iVdwiKo+r30Q4/MXA0pML0WzteH+fY3s/VCf67F8k9oZkao/
	 fIZD85Cy++ENyY8wCYjCKAQb8bIEe48XR925CVKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 146/307] Bluetooth: ISO: fix UAF in iso_recv_frame
Date: Sun,  7 Jun 2026 11:59:03 +0200
Message-ID: <20260607095733.093033022@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 47f23a259517abbdb8032c057a1e8a6bf3734878 upstream.

iso_recv_frame reads conn->sk under iso_conn_lock but releases the lock
before using sk, with no reference held. A concurrent iso_sock_kill()
can free sk in that window, causing use-after-free on sk->sk_state and
sock_queue_rcv_skb().

Fix by replacing the bare pointer read with iso_sock_hold(conn), which
calls sock_hold() while the spinlock is held, atomically elevating the
refcount before the lock drops. Add a drop_put label so sock_put() is
called on all exit paths where the hold succeeded.

Fixes: ccf74f2390d60a2f9a75ef496d2564abb478f46a ("Bluetooth: Add BTPROTO_ISO socket type")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -553,7 +553,7 @@ static void iso_recv_frame(struct iso_co
 	struct sock *sk;
 
 	iso_conn_lock(conn);
-	sk = conn->sk;
+	sk = iso_sock_hold(conn);
 	iso_conn_unlock(conn);
 
 	if (!sk)
@@ -562,11 +562,15 @@ static void iso_recv_frame(struct iso_co
 	BT_DBG("sk %p len %d", sk, skb->len);
 
 	if (sk->sk_state != BT_CONNECTED)
-		goto drop;
+		goto drop_put;
 
-	if (!sock_queue_rcv_skb(sk, skb))
+	if (!sock_queue_rcv_skb(sk, skb)) {
+		sock_put(sk);
 		return;
+	}
 
+drop_put:
+	sock_put(sk);
 drop:
 	kfree_skb(skb);
 }


