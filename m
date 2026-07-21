Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7FA46AA6A;
	Tue, 21 Jul 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647993; cv=none; b=FAh3MFgRC7tNnAoOrldwooMlB4NoBtDkLicNJoG8jRY+6mY94WPTlML0asCUNy8QNkC68FP8oQlLI/2rHQed/VTEjdvkGfYxtu+kLUJp68fe1yZc39gYz+FmpChWOHh6iQz+zEID9H7HNnZ14H0E+zlGhQWQk7hiLBCucj2fgN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647993; c=relaxed/simple;
	bh=BsEd65JaQqe6JoWwexoM+mNb2Bdua8nDVQ9AUIPm7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzolHFtP5zD6q3sgXx5d0PGUx24AqbLpI9uiNeTHlEFhEJSXWsznJpq1AfaaMYzYxoqJykpLXBWaGuHXD7eMdZu4DGYbUtXH3+VPrkRs/m2ROUu/VdiYVxtXVKenxqzEdYqOjhHasvw8L+x4gzG62GkQq9EKN0Oj5upwcGaAtHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ7c0GEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ7c0GEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E901F000E9;
	Tue, 21 Jul 2026 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647991;
	bh=ohqp0vvypcVtKDUo3j9tTZIaXPNJiCEE+emx+QcaHcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZ7c0GELVm5vrSXlGIyyT3CuDQ5zcz8zeN+zJXU40mgz92ogqDASXIVqDy8MMX8/f
	 nb+QtBrWhOn0k2cltsXsNsElnMv3P5lwXlXzu65khJIAEU6G/10xYABpEPxt/LXwKn
	 avnk31aALff0dgdd2KZDjwE8+9ezxJRV+6rT5eco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0031/2077] rxrpc: Fix the reception of a reply packet before data transmission
Date: Tue, 21 Jul 2026 16:55:04 +0200
Message-ID: <20260721152553.410730693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit a58e33405acd2584e730c1da72635f822ada6b49 upstream.

Fix rxrpc_receiving_reply() to handle the reception of an apparent reply
DATA packet before rxrpc has had a chance to send any request DATA packets
on a client call by checking to see if the call has been exposed yet by
sending the first packet.

Without this, rxrpc_rotate_tx_window() might oops.

Also fix rxrpc_rotate_tx_window() to handle the Tx queue being empty by
changing the do...while loop into a while loop, just in case a call is
abnormally terminated by an early reply before the last request packet is
transmitted.

Fixes: b341a0263b1b ("rxrpc: Implement progressive transmission queue struct")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-7-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -251,7 +251,7 @@ static bool rxrpc_rotate_tx_window(struc
 		tq = call->tx_queue;
 	}
 
-	do {
+	while (before_eq(seq, to)) {
 		unsigned int ix = seq - call->tx_qbase;
 
 		_debug("tq=%x seq=%x i=%d f=%x", tq->qbase, seq, ix, tq->bufs[ix]->flags);
@@ -321,8 +321,7 @@ static bool rxrpc_rotate_tx_window(struc
 				break;
 			}
 		}
-
-	} while (before_eq(seq, to));
+	}
 
 	if (trace)
 		trace_rxrpc_rack_update(call, summary);
@@ -397,6 +396,14 @@ static bool rxrpc_receiving_reply(struct
 		trace_rxrpc_timer_can(call, rxrpc_timer_trace_delayed_ack);
 	}
 
+	/* Deal with an apparent reply coming in before we've got the request
+	 * queued or transmitted.
+	 */
+	if (!test_bit(RXRPC_CALL_EXPOSED, &call->flags)) {
+		rxrpc_proto_abort(call, top, rxrpc_eproto_early_reply);
+		return false;
+	}
+
 	if (!test_bit(RXRPC_CALL_TX_LAST, &call->flags)) {
 		if (!rxrpc_rotate_tx_window(call, top, &summary)) {
 			rxrpc_proto_abort(call, top, rxrpc_eproto_early_reply);


