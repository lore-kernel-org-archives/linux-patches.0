Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623208;
	b=0g2k/bDR/cvLUmI67W2FXGAssVOG1VANc4GGYGWZz4ufjRmbUjo8GSA3qpbcfZM1BE3/
	 jagBElgtsgxx82WY0YxltE3VoORghfNF87jeX+4gOd8i1rxjkaEhds3layTS+Rekq0VF1
	 xjdkdWExaOWxeeQg9niHJJ/Wdz+y7wXI5fFlqrznQbwbrcRMmkNrrRnpALMyP1CKYoyaG
	 3hGbmOA0KcQ28adMYli8CENCC9xLtlZYkmrZhmqUmNzjuUlla3HD+p+oGTGuUMUdc4bjD
	 ljoRCybL/4GpVi2dLgeo7iTC5g8jZQOjL0drtlOX4baD15jq8lGFMpD2ZpeCoBXA4bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lhWavKsXyOL/pcjcAeGv8kr4MDKulFj4K67JxLPGLq0=;
	b=EE1Gubr4TbnaStk2ymW4U0ldUL2Dm0DPsYu+QywlBQY1s4P+El3C5DUNa+zGWQz9W51K
	 xYmwz6UIyu2+5MidHtAbT5KjS8kCQ1wrmmYGDnL7MWJ6JkXQbz+vIq3qFqp0ltTapxDq3
	 NZpq5N98ggqvzgYMpHj+oLJsAwf4eLgJo9Zeai0fdC16hJFr7bJyFYeRyVfPRnbWiRCJf
	 7cF6ukpRbhtajAxGQypnMm41U/XyO1xDqnM6Ic+2SHk6TWaO0NWJb/62VXMU3i6Qqa1Ln
	 RjDN/AD2pRQu2I8U7AqkdF1IR/u791/dHZownpZVfgnYe/YBtok/4tWCMGUZkd4Gv9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GINctd4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FE2606A321;
	Wed, 25 Nov 2026 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GINctd4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E911F000CA;
	Wed, 25 Nov 2026 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623208;
	bh=lhWavKsXyOL/pcjcAeGv8kr4MDKulFj4K67JxLPGLq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GINctd4lXWg0lmin9xPiB2TXHIGNM5Ze89V3dKNJ/WND8d7nSRceol69R2OLfvqdO
	 ewZuS5Jb24KaRr8G8mgfGetvsG/vYWoyRS3sOfwQ5EDhrbLo2obqw5ScHTExM8e0aH
	 Z3KygA7tMA3uns33LoWxJVq9QGuQd9Hvd52pUr7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 740/990] Bluetooth: L2CAP: Keep recvmsg from resuming a closed channel
Date: Wed, 25 Nov 2026 15:35:07 +0100
Message-ID: <20261125143839.399039686@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 1f2ac56137c51be0601e18a163d817e02a15913f upstream.

Reading buffered ERTM data after ACL link loss can clear local busy and
send a supervisory frame after l2cap_conn_del() has destroyed the HCI
channel, which oopses on a NULL pointer in hci_send_acl(). The socket still
owns its L2CAP channel, so its lifetime does not protect the underlying HCI
channel.

Require BT_CONNECTED before clearing local busy in recvmsg. The socket lock
already held here serializes this check and send with teardown, which
closes the socket before the HCI channel is destroyed. Continue to allow
buffered data to be read after disconnection.

AI assistance was used.

Fixes: 61aa4f5b9f43 ("Bluetooth: Use the transmit state machine for busy state changes")
Cc: stable@vger.kernel.org # needs adjustments for 5.15
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1289,7 +1289,8 @@ static int l2cap_sock_recvmsg(struct soc
 	 * available.  This avoids resending large numbers of
 	 * frames.
 	 */
-	if (test_bit(CONN_LOCAL_BUSY, &pi->chan->conn_state) &&
+	if (sk->sk_state == BT_CONNECTED &&
+	    test_bit(CONN_LOCAL_BUSY, &pi->chan->conn_state) &&
 	    atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf >> 1)
 		l2cap_chan_busy(pi->chan, 0);
 


