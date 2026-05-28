Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970323438AE;
	Thu, 28 May 2026 20:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999489; cv=none; b=fah0IuLP3j9WPiq+w/QAXfl9Ocyw6BAHSmp2gyZK5SqVK8n8tXZNBY2ZwMLvOzfH7S0VyvqBGLEjyWbZHHFyNiKXaoFc5r2WWyNxF19GnOd1+lm+3dVxu4M0eH0QZYt9aQXNK7uub0olzaf2B+4pOQbCN2ZiEy6llJfSWL0Rz8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999489; c=relaxed/simple;
	bh=3cWcwTV9A5WNz2kn/WvPk4HMvgkRG62HzXmsx/FPA3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxMX85ZGkBi1X7ncrVWqPApWOgUnBzopRDOjqF9maBArli949YkHp1UPIo9HCawOVkPCnBUs3frsZmnWBWfhmZNrFl2SN6j3jBEjJGJFKc3nFBkbHhNIZnbvIWWhzpvQsXcIhYiX2rY3yUB+7iXs1AEJrJE6/tkWHC13cyiobM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrRIE5J4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrRIE5J4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D4B1F000E9;
	Thu, 28 May 2026 20:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999486;
	bh=xsTO5bH/r9ojWT42HwyU03Y3O9a8vaJPW7vawQswXAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrRIE5J4xP+jLeXgrKQ43h9lLu1j61ivrwRM17umEuxIBZIM/ov7fdUIWkXoEgpnq
	 n+yARwSeQjSmnx3weIzg6lxTJgScfv6nFRRJKqUl3wWrhTRBIoRqmq722MJUZdcKRY
	 XEGay6suVepj/E9ZlgFu3iS/+QJ2Vio5mzAhUqEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minh Nguyen <minhnguyen.080505@gmail.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 085/377] vsock/vmci: fix UAF when peer resets connection during handshake
Date: Thu, 28 May 2026 21:45:23 +0200
Message-ID: <20260528194640.832818834@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Minh Nguyen <minhnguyen.080505@gmail.com>

commit 99e22ddf4edb63dc8382bc028af928056d3450cf upstream.

vmci_transport_recv_connecting_server() returned err = 0 for a peer
RST in its default switch arm:

	err = pkt->type == VMCI_TRANSPORT_PACKET_TYPE_RST ? 0 : -EINVAL;

That made vmci_transport_recv_listen() skip vsock_remove_pending(),
leaving the pending socket on the listener's pending_links with
sk_state = TCP_CLOSE while destroy: still dropped the explicit
reference taken before schedule_delayed_work().

One second later vsock_pending_work() observed is_pending=true and
performed full cleanup: vsock_remove_pending() then the two trailing
sock_put(sk) calls -- the first reached refcount 0 and __sk_freed
the socket, and the second wrote into the freed object:

  BUG: KASAN: slab-use-after-free in refcount_warn_saturate
  Write of size 4 at addr ffff88800b1cac80 by task kworker
  Workqueue: events vsock_pending_work

Treat peer RST like any other unexpected packet type (err = -EINVAL).
All destroy: arms now return err < 0, so vmci_transport_recv_listen()
removes pending from pending_links synchronously and
vsock_pending_work() takes the is_pending=false / !rejected branch,
dropping only its own work reference.  This also closes the
multi-packet race Sashiko reported on v2: pending is removed from
the list before any subsequent packet can find it.

The pre-existing sk_acceptq_removed() gap on the err < 0 path of
vmci_transport_recv_listen() that Sashiko also noted is not
introduced or changed by this patch.

Tested on lts-6.12.79 with KASAN: 52/100 unpatched -> 0/100 patched.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Cc: stable@vger.kernel.org
Signed-off-by: Minh Nguyen <minhnguyen.080505@gmail.com>
Acked-by: Bryan Tan <bryan-bt.tan@broadcom.com>
Link: https://patch.msgid.link/20260519102310.237181-1-minhnguyen.080505@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/vmci_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1156,7 +1156,7 @@ vmci_transport_recv_connecting_server(st
 		/* Close and cleanup the connection. */
 		vmci_transport_send_reset(pending, pkt);
 		skerr = EPROTO;
-		err = pkt->type == VMCI_TRANSPORT_PACKET_TYPE_RST ? 0 : -EINVAL;
+		err = -EINVAL;
 		goto destroy;
 	}
 


