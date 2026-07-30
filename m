Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46240860A;
	Thu, 30 Jul 2026 15:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426926; cv=none; b=sNJ127vQOK4Klq6JzWuTmzv2q2x8RpwVMkIrON3RnDWrM1rAaMEMmLLuQNlE4zl6EKODZHpylO+fa5Y5IOUBZQsG9ALzAdQb3fwGBn/mQ+Dptia2YO3s8V7q95D9mPd0f9dF9Fq0cnaPnxVzP637qeqkXKEXr8sHArcFaX8WmV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426926; c=relaxed/simple;
	bh=7Cpxhk+N1VHwYs61ffL7LxY+BbOuNhQ9g1G1FLXkVUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRn7YR778T+bJlQeEIahahVv4Xp3JicWXoCe8UYug0xuzgGuu+dYUpnyp7Vn4lS87hCp/MQrBpuFEH/QlAuNzJnkEO7mJZhbDwGjlPO0BmbPMbwmEXBMWij2yxNwDYiBtXF2V+yFnuqv9PuuSZYRDsuIIyycUXojW//chy81X5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4NW12IO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4NW12IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554671F000E9;
	Thu, 30 Jul 2026 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426924;
	bh=a61uQJ++84Aiuvm2ft1u0M4TJliibR052FV1AbBq7pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4NW12IOnbCYt0LxOhAhuD/rxAVbKqt/yPB1huPy+IqxwaG4UdoI0mVY939z+iLQU
	 t+VQHSL1GK01sb2c5i+vBNL6VWp3opDWYtrpidkoTZ43XmDtYBC4at475hDKiXkGo5
	 CTDU66NV1SOr4CvSn7UZPQim3FP2qUQb+6oddWe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 590/602] rxrpc: Fix locking issues with the peer record hash
Date: Thu, 30 Jul 2026 16:16:22 +0200
Message-ID: <20260730141448.452537378@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 71f5409176f4ffd460689eb5423a20332d00e342 upstream.

rxrpc_new_incoming_peer() can't use spin_lock_bh() whilst its caller has
interrupts disabled.

    WARNING: CPU: 0 PID: 1550 at kernel/softirq.c:369 __local_bh_enable_ip+0x46/0xd0
    ...
    Call Trace:
     rxrpc_alloc_incoming_call+0x1b0/0x400
     rxrpc_new_incoming_call+0x1dd/0x5e0
     rxrpc_input_packet+0x84a/0x920
     rxrpc_io_thread+0x40d/0xb40
     kthread+0x2ec/0x300
     ret_from_fork+0x24/0x40
     ret_from_fork_asm+0x1a/0x30
     </TASK>
    irq event stamp: 1811
    hardirqs last  enabled at (1809): _raw_spin_unlock_irq+0x24/0x50
    hardirqs last disabled at (1810): _raw_read_lock_irq+0x17/0x70
    softirqs last  enabled at (1182): handle_softirqs+0x3ee/0x430
    softirqs last disabled at (1811): rxrpc_new_incoming_peer+0x56/0x120

Fix this by using a plain spin_lock() instead.  IRQs are held, so softirqs
can't happen.

Fixes: a2ea9a907260 ("rxrpc: Use irq-disabling spinlocks between app and I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250218192250.296870-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/peer_object.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -314,10 +314,10 @@ void rxrpc_new_incoming_peer(struct rxrp
 	hash_key = rxrpc_peer_hash_key(local, &peer->srx);
 	rxrpc_init_peer(local, peer, hash_key);
 
-	spin_lock_bh(&rxnet->peer_hash_lock);
+	spin_lock(&rxnet->peer_hash_lock);
 	hash_add_rcu(rxnet->peer_hash, &peer->hash_link, hash_key);
 	list_add_tail(&peer->keepalive_link, &rxnet->peer_keepalive_new);
-	spin_unlock_bh(&rxnet->peer_hash_lock);
+	spin_unlock(&rxnet->peer_hash_lock);
 }
 
 /*


