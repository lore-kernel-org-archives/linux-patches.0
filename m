Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490241E47AD;
	Tue, 12 Aug 2025 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026909; cv=none; b=AtpVMwa0jFTnpLaH3fgvEmk5B1bYhlQRrO1qG7d3JdlTXdBElHExj+AmapyD0uXA7h87BTUjB/C0+zQoipM38pNzoMIMXqAIJFsePx8zKJOQgQKF7K+P6+WsM2jARIJ+hvxjVFg0yct06dBl7lfLs6XQSK52IDtSO+ce+zclPk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026909; c=relaxed/simple;
	bh=3EUDPORZtE8PVCb+SpLjiiUjLBm4c8GBR0KuJ4nsqNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb4dNT6GR7ChN9IFWq2F6eDIxfKShgz8tompZDfikWJ7r7SBj36NOBfxUGDu5sY6DHJm3aQkZO1mUQr3ete0myuscXlNBLluEZouW4/jBh8U8H6epH+ztZgxXXMwBiM2OnbqE7qv1b59h6AqkVmTeixhr3kZE8tZYKaGOhVTGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xe42iBeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xe42iBeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86BCC4CEF0;
	Tue, 12 Aug 2025 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026909;
	bh=3EUDPORZtE8PVCb+SpLjiiUjLBm4c8GBR0KuJ4nsqNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xe42iBeYB0O60XAzOy9QVBLgBb1D90dlqRmXDDtMjB+JPEKyXeDzSMnegf0KW3pO9
	 V9FhIjPID/AS8/6UsCq23sLTAJK30ZaDDUdWvGQbsWYdwo8TRDtHqTwNPCif3IxcAA
	 jNOZylBPUMzo9WggBCjDfJ52CR0oY3nEedZEgyGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Le <quanglex97@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 442/480] net/packet: fix a race in packet_set_ring() and packet_notifier()
Date: Tue, 12 Aug 2025 19:50:50 +0200
Message-ID: <20250812174415.624318368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Le <quanglex97@gmail.com>

commit 01d3c8417b9c1b884a8a981a3b886da556512f36 upstream.

When packet_set_ring() releases po->bind_lock, another thread can
run packet_notifier() and process an NETDEV_UP event.

This race and the fix are both similar to that of commit 15fe076edea7
("net/packet: fix a race in packet_bind() and packet_notifier()").

There too the packet_notifier NETDEV_UP event managed to run while a
po->bind_lock critical section had to be temporarily released. And
the fix was similarly to temporarily set po->num to zero to keep
the socket unhooked until the lock is retaken.

The po->bind_lock in packet_set_ring and packet_notifier precede the
introduction of git history.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Quang Le <quanglex97@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250801175423.2970334-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4573,10 +4573,10 @@ static int packet_set_ring(struct sock *
 	spin_lock(&po->bind_lock);
 	was_running = packet_sock_flag(po, PACKET_SOCK_RUNNING);
 	num = po->num;
-	if (was_running) {
-		WRITE_ONCE(po->num, 0);
+	WRITE_ONCE(po->num, 0);
+	if (was_running)
 		__unregister_prot_hook(sk, false);
-	}
+
 	spin_unlock(&po->bind_lock);
 
 	synchronize_net();
@@ -4608,10 +4608,10 @@ static int packet_set_ring(struct sock *
 	mutex_unlock(&po->pg_vec_lock);
 
 	spin_lock(&po->bind_lock);
-	if (was_running) {
-		WRITE_ONCE(po->num, num);
+	WRITE_ONCE(po->num, num);
+	if (was_running)
 		register_prot_hook(sk);
-	}
+
 	spin_unlock(&po->bind_lock);
 	if (pg_vec && (po->tp_version > TPACKET_V2)) {
 		/* Because we don't support block-based V3 on tx-ring */


