Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF13217F37;
	Tue, 12 Nov 2024 10:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408160; cv=none; b=bgXsiSdlyaT3oHraBEsns2qkniNE4k1BzI+JScMuHQYk90fW6+psXAS93hUFrTETelXIkcHqqdx+2HJmQ+TVwpVfoXR7xR4La7uPbY1va5J9lOa0dyoBsYcfdyYWzYoHTMIlCCk/K2jJjXk7U8c0eFvT9qQxgGiktozTpl9kYHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408160; c=relaxed/simple;
	bh=83zoGHe9k2GoQs6HoPfeFi3VxNEb/S9YKo8n5sOz+/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wu3y4c5I7MifCy57KyWEerFV1+ooWKjIa9l5dyAfK3YeZ0Mjrb2qzx2IgUTfG7uei+Loj4FzBbvgv7G1OOt3k6OPtdWuQp7hDfg0p57pbXoAZ80rxM/4/0lu214SvY4q83AV1cAaxB05ylJzclPGrnNuHP3ZFv6e6TZx9ZuaqAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAMIgjts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAMIgjts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1123FC4CECD;
	Tue, 12 Nov 2024 10:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408160;
	bh=83zoGHe9k2GoQs6HoPfeFi3VxNEb/S9YKo8n5sOz+/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAMIgjtspeFIvGlc25jiOtFCfc278vBqZC8f0Gva3ewrVArzV6OXIQy6oTM9QopdF
	 /bdhv/UijhUvAdrE+tDrvf0akucDj0Jv8SNA9hnq/V+/QiQJVimWZiVvskfaJlIFkO
	 adGlrNUrhEFxv4iVJnDUuk9kDcplzAYyIsPoqFcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 061/184] rxrpc: Fix missing locking causing hanging calls
Date: Tue, 12 Nov 2024 11:20:19 +0100
Message-ID: <20241112101903.201992378@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

[ Upstream commit fc9de52de38f656399d2ce40f7349a6b5f86e787 ]

If a call gets aborted (e.g. because kafs saw a signal) between it being
queued for connection and the I/O thread picking up the call, the abort
will be prioritised over the connection and it will be removed from
local->new_client_calls by rxrpc_disconnect_client_call() without a lock
being held.  This may cause other calls on the list to disappear if a race
occurs.

Fix this by taking the client_call_lock when removing a call from whatever
list its ->wait_link happens to be on.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Fixes: 9d35d880e0e4 ("rxrpc: Move client call connection to the I/O thread")
Link: https://patch.msgid.link/726660.1730898202@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h | 1 +
 net/rxrpc/conn_client.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a1b126a6b0d72..cc22596c7250c 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -287,6 +287,7 @@
 	EM(rxrpc_call_see_input,		"SEE input   ") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
+	EM(rxrpc_call_see_waiting_call,		"SEE q-conn  ") \
 	E_(rxrpc_call_see_zap,			"SEE zap     ")
 
 #define rxrpc_txqueue_traces \
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index d25bf1cf36700..bb11e8289d6dc 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -516,6 +516,7 @@ void rxrpc_connect_client_calls(struct rxrpc_local *local)
 
 		spin_lock(&local->client_call_lock);
 		list_move_tail(&call->wait_link, &bundle->waiting_calls);
+		rxrpc_see_call(call, rxrpc_call_see_waiting_call);
 		spin_unlock(&local->client_call_lock);
 
 		if (rxrpc_bundle_has_space(bundle))
@@ -586,7 +587,10 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 		_debug("call is waiting");
 		ASSERTCMP(call->call_id, ==, 0);
 		ASSERT(!test_bit(RXRPC_CALL_EXPOSED, &call->flags));
+		/* May still be on ->new_client_calls. */
+		spin_lock(&local->client_call_lock);
 		list_del_init(&call->wait_link);
+		spin_unlock(&local->client_call_lock);
 		return;
 	}
 
-- 
2.43.0



