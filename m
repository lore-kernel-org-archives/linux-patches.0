Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CC643E4BA;
	Thu, 30 Jul 2026 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428046; cv=none; b=fusOZ9W6vsEWGBqsnb7B0pnluA6SDRGXRbktUO+86SG7V4V+CayIFdovJXWdS8eHSPhIl8PaP2mM7Yt3rG2L3wugc1d7tLF3xj4Ih8hkOsmfHgbrlMKEofi+5LzSfVVlhW12VPrlIW3mY2A7G5J5al4kpZ63dd52idN0lLU427Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428046; c=relaxed/simple;
	bh=3zCSdYkJ+gESntN34MMacJoh3qaZNkFWh32yoivG3Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7L3Ej4U9ikTquk7ElL04O2MgmbfTC+aZ7iywQda9P3oZ6aRRLzOkP8vWY2IlerydVMsRvntvkogkh14HXfI8hJKMW/TsFRxGuFgtXQLqK6mtf+U/JSApx7MOZNU/7TmLszQhPqkkFy9DWW7HDfEQWoDINzD9wmqkIH44Mo6TA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFogrlM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFogrlM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1FE1F000E9;
	Thu, 30 Jul 2026 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428045;
	bh=fZg2M1po+Chseeti9cvx9JSdOMX5MQfpr5ZcFawvgx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFogrlM24Q2Hfk9S+ZQNAnIA0IdcAPKq8EUv9SNSGlH17POda/Y1CFv9E9xTAtM4+
	 zxvLwjF+qJi769cYuZ9o+99uSU+NTX8ixWyUOD39N2DuFLwKafFryucMqwcbEWUfnP
	 yMI1s5Q/sJQOsGsZNfBB1ZabSPJ1J66mJ50kMluE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 385/484] rxrpc: Dont need barrier for ->tx_bottom and ->acks_hard_ack
Date: Thu, 30 Jul 2026 16:14:42 +0200
Message-ID: <20260730141431.840441829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6396b48ac0a77165f9c2c40ab03d6c8188c89739 ]

We don't need a barrier for the ->tx_bottom value (which indicates the
lowest sequence still in the transmission queue) and the ->acks_hard_ack
value (which tracks the DATA packets hard-ack'd by the latest ACK packet
received and thus indicates which DATA packets can now be discarded) as the
app thread doesn't use either value as a reference to memory to access.
Rather, the app thread merely uses these as a guide to how much space is
available in the transmission queue

Change the code to use READ/WRITE_ONCE() instead.

Also, change rxrpc_check_tx_space() to use the same value for tx_bottom
throughout.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20241204074710.990092-18-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e66f8f32f501 ("rxrpc: Fix socket notification race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/sendmsg.c |    8 +++++---
 net/rxrpc/txbuf.c   |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -93,9 +93,11 @@ no_wait:
  */
 static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
 {
+	rxrpc_seq_t tx_bottom = READ_ONCE(call->tx_bottom);
+
 	if (_tx_win)
-		*_tx_win = call->tx_bottom;
-	return call->tx_prepared - call->tx_bottom < 256;
+		*_tx_win = tx_bottom;
+	return call->tx_prepared - tx_bottom < 256;
 }
 
 /*
@@ -137,7 +139,7 @@ static int rxrpc_wait_for_tx_window_wait
 		rtt = 2;
 
 	timeout = rtt;
-	tx_start = smp_load_acquire(&call->acks_hard_ack);
+	tx_start = READ_ONCE(call->acks_hard_ack);
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -112,14 +112,14 @@ void rxrpc_shrink_call_tx_buffer(struct
 
 	while ((txb = list_first_entry_or_null(&call->tx_buffer,
 					       struct rxrpc_txbuf, call_link))) {
-		hard_ack = smp_load_acquire(&call->acks_hard_ack);
+		hard_ack = call->acks_hard_ack;
 		if (before(hard_ack, txb->seq))
 			break;
 
 		if (txb->seq != call->tx_bottom + 1)
 			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_out_of_step);
 		ASSERTCMP(txb->seq, ==, call->tx_bottom + 1);
-		smp_store_release(&call->tx_bottom, call->tx_bottom + 1);
+		WRITE_ONCE(call->tx_bottom, call->tx_bottom + 1);
 		list_del_rcu(&txb->call_link);
 
 		trace_rxrpc_txqueue(call, rxrpc_txqueue_dequeue);


