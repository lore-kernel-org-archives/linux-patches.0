Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CBB1C5793;
	Tue,  8 Oct 2024 13:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392941; cv=none; b=Ag7m2kCoqDNtz+ZsMiMfQ32ufbtW3ABWKDcV/Dk2Nhjo48+Zb4psvYsBkyRbK0Gf+qUW67FwCrwyfd++LzGo/EmDOGgvamODzPLCkLhkCZyEJVKx9aEUMvVv4TJz8OlNoVTZNkjWO/OHz4882FU64fX+M6r94O7BBlZX+jp1urY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392941; c=relaxed/simple;
	bh=6miNhDiMYLQvwqMXPqOucrJrnkKSzdPMoQzl/AlHDK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUFmzj6rUCoGsagpgR9W7IkcpLuWfaKSEh4NX8hOuNAhuaS7Li21MnoZh206yYdwztneQZkhlbyCe7YxlpR/fXrx6xRqTYgKktlOX8LrpvAo5AB2W1UfCYuvA+SkhUK15mmFl8+prTwsyjpWfnns7XDUNdEvIq/DbOpGkAn5zTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0UwmV9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0UwmV9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8973C4CEC7;
	Tue,  8 Oct 2024 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392941;
	bh=6miNhDiMYLQvwqMXPqOucrJrnkKSzdPMoQzl/AlHDK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0UwmV9spAxGlL3Bqb2Vz1BY315AL0blXTKLeWuTXXiBFM1DkQABhXq36CdVeN009
	 awKGarfCpf/eCEg9nWhk/C7b22AUNlyPnyy0upTv9/zneCRjSBC1/DxpTOf884h1L+
	 GVKGD3cBIxLgPjRpNEzKH0az2ZldZqUYtmIAndUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	yuxuanzhe@outlook.com,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 552/558] rxrpc: Fix a race between socket set up and I/O thread creation
Date: Tue,  8 Oct 2024 14:09:42 +0200
Message-ID: <20241008115723.956439301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit bc212465326e8587325f520a052346f0b57360e6 upstream.

In rxrpc_open_socket(), it sets up the socket and then sets up the I/O
thread that will handle it.  This is a problem, however, as there's a gap
between the two phases in which a packet may come into rxrpc_encap_rcv()
from the UDP packet but we oops when trying to wake the not-yet created I/O
thread.

As a quick fix, just make rxrpc_encap_rcv() discard the packet if there's
no I/O thread yet.

A better, but more intrusive fix would perhaps be to rearrange things such
that the socket creation is done by the I/O thread.

Fixes: a275da62e8c1 ("rxrpc: Create a per-local endpoint receive queue and I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: yuxuanzhe@outlook.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241001132702.3122709-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/ar-internal.h  |    2 +-
 net/rxrpc/io_thread.c    |   10 ++++++++--
 net/rxrpc/local_object.c |    2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1058,7 +1058,7 @@ bool rxrpc_direct_abort(struct sk_buff *
 int rxrpc_io_thread(void *data);
 static inline void rxrpc_wake_up_io_thread(struct rxrpc_local *local)
 {
-	wake_up_process(local->io_thread);
+	wake_up_process(READ_ONCE(local->io_thread));
 }
 
 static inline bool rxrpc_protocol_error(struct sk_buff *skb, enum rxrpc_abort_reason why)
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -27,11 +27,17 @@ int rxrpc_encap_rcv(struct sock *udp_sk,
 {
 	struct sk_buff_head *rx_queue;
 	struct rxrpc_local *local = rcu_dereference_sk_user_data(udp_sk);
+	struct task_struct *io_thread;
 
 	if (unlikely(!local)) {
 		kfree_skb(skb);
 		return 0;
 	}
+	io_thread = READ_ONCE(local->io_thread);
+	if (!io_thread) {
+		kfree_skb(skb);
+		return 0;
+	}
 	if (skb->tstamp == 0)
 		skb->tstamp = ktime_get_real();
 
@@ -47,7 +53,7 @@ int rxrpc_encap_rcv(struct sock *udp_sk,
 #endif
 
 	skb_queue_tail(rx_queue, skb);
-	rxrpc_wake_up_io_thread(local);
+	wake_up_process(io_thread);
 	return 0;
 }
 
@@ -565,7 +571,7 @@ int rxrpc_io_thread(void *data)
 	__set_current_state(TASK_RUNNING);
 	rxrpc_see_local(local, rxrpc_local_stop);
 	rxrpc_destroy_local(local);
-	local->io_thread = NULL;
+	WRITE_ONCE(local->io_thread, NULL);
 	rxrpc_see_local(local, rxrpc_local_stopped);
 	return 0;
 }
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -232,7 +232,7 @@ static int rxrpc_open_socket(struct rxrp
 	}
 
 	wait_for_completion(&local->io_thread_ready);
-	local->io_thread = io_thread;
+	WRITE_ONCE(local->io_thread, io_thread);
 	_leave(" = 0");
 	return 0;
 


