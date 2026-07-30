Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B115A4519AE;
	Thu, 30 Jul 2026 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428329; cv=none; b=Xrmdpj+e15GpRK0wwGrR+SDtasDtQobZ5TmiXELl1uMOgyFo5FgLVJQuR2jjP8h9TCfgH5QXblLM9ylICrFpz5vadN6WL11aq0gFaHWe+QYYM3ISz9s2B/BOd6T/eNNQmgLTtpe/RI0xLUlZqVMFXw1IVrJm7B+jqm6p+VbPmB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428329; c=relaxed/simple;
	bh=7V2anpIml8sW8CA6RfZGi65mx5hA0/JNzezFF4KOoe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mShu9WpHnIe7+J5WwEItMq8O4yIf+zFjjagTTKtFJwzGwAyhk373V1Vi2roOr+lwrTDE3Xb61uM1kAxiD2c/p9WvpAq/JHpAPSjmqMv8ezLMlQzm7UaobAA8bmwAdcKVOAUMe6eu5m/wQa7oAeiS3jQDpWcwzDEFPpuX25ezgjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIf7HbZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIf7HbZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B751F000E9;
	Thu, 30 Jul 2026 16:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428328;
	bh=i9ZOucY8THq5hfWbaQg3n1dIywGWMZzwTcrCyPWX8FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIf7HbZn6cPemAgu9Yw6Q9/SzanTVZjj9VZ/x+8ExgSqsQNmPYl3GPseImDO1E7oH
	 o3vSEVm0j/P6oJizhTXS+CZdBcMn8xhtODvgM/ARkDbIs66gqgQBecd+GhREcsVECi
	 x1Al6V/ytlNCRTvJsdN5DOCzvMnbzbrxBhq0O1kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 483/484] rxrpc: Disable IRQ, not BH, to take the lock for ->attend_link
Date: Thu, 30 Jul 2026 16:16:20 +0200
Message-ID: <20260730141433.985740031@linuxfoundation.org>
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

commit d920270a6dbf756384b125ce39c17666a7c0c9f4 upstream.

Use spin_lock_irq(), not spin_lock_bh() to take the lock when accessing the
->attend_link() to stop a delay in the I/O thread due to an interrupt being
taken in the app thread whilst that holds the lock and vice versa.

Fixes: a2ea9a907260 ("rxrpc: Use irq-disabling spinlocks between app and I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/2870146.1734037095@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/io_thread.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -423,9 +423,9 @@ int rxrpc_io_thread(void *data)
 						struct rxrpc_connection,
 						attend_link);
 		if (conn) {
-			spin_lock_bh(&local->lock);
+			spin_lock_irq(&local->lock);
 			list_del_init(&conn->attend_link);
-			spin_unlock_bh(&local->lock);
+			spin_unlock_irq(&local->lock);
 
 			rxrpc_input_conn_event(conn, NULL);
 			rxrpc_put_connection(conn, rxrpc_conn_put_poke);
@@ -440,9 +440,9 @@ int rxrpc_io_thread(void *data)
 		if ((call = list_first_entry_or_null(&local->call_attend_q,
 						     struct rxrpc_call,
 						     attend_link))) {
-			spin_lock_bh(&local->lock);
+			spin_lock_irq(&local->lock);
 			list_del_init(&call->attend_link);
-			spin_unlock_bh(&local->lock);
+			spin_unlock_irq(&local->lock);
 
 			trace_rxrpc_call_poked(call);
 			rxrpc_input_call_event(call, NULL);


