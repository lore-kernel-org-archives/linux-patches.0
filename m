Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D030C143;
	Thu, 30 Jul 2026 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426620; cv=none; b=URa4kwkoKKyxoHjeBj5FgEL19bfFXXGInCoyPrCAdIMENrlkcEYBLunEE/1pnacFkXWcj7Q4WdQRnYcy41Is48lM983rCiube6FOfbb+4YJo9PmQdPfbHbgCmewso5X9RhYj0OwC1UiGqVKn2sCCy+eh/Yg9NGRSSQxG0K+7BzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426620; c=relaxed/simple;
	bh=0rpNUkXqQZMXpJ9cXakQDWNvQasF/ZoIbB0OJgDOhZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsI+n6YKdKTHRC1FrVVK2C4vx5+7+4eJ8zLCHyHGoXIDOTaweaZ8JoFYStRzowKWVCwNUsem5Byrj66yhZQ/20sVhr1BHe0NRoiZ0Z6jeG/kpJYXjKRvpUiaIXhHdiA0qjfFHxoN1FZC6kjiHpuAOdbvbfweCxu+BSGyJmcOaxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnU9Uz27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnU9Uz27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514F51F000E9;
	Thu, 30 Jul 2026 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426618;
	bh=k8qUQMZGQPEHQlXd2fYytPA8iVNzrFKUVlFImDHLENE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnU9Uz27A9WFO+F3nknxrMLqWEvdQM6Eu9z20XE+1yN+wh5JJOsvV7FEGPosV4L4W
	 lmYagCTjn4M5TcViiNznXucLZsJk5hF/cqX1wf5vEwK0Yr96Mu/m+tobxdQp9QpmbW
	 DSaQEQ6kelKOFSgl4GLZEbZoYGXxTIWM9QBcdFi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 484/602] rxrpc: Dont need barrier for ->tx_bottom and ->acks_hard_ack
Date: Thu, 30 Jul 2026 16:14:36 +0200
Message-ID: <20260730141446.137299871@linuxfoundation.org>
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
@@ -216,14 +216,14 @@ void rxrpc_shrink_call_tx_buffer(struct
 
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


