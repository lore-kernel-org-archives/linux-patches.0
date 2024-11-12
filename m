Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BA220DD62;
	Tue, 12 Nov 2024 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407675; cv=none; b=gfnM4ugnYYKEDTOhcU0U5y4XgZkYXVq8SR8iAgw/HAwpOy7zUHeMYYvqMsEwi81Va2S1TirInPx3lPCjjVRJhlVzkKGbnlR5bKhPNwlnIBKVoTZfHkKLpL3Ex+gvNbl9wyQnFs8oeL8xvbY8A/VxhgGd/l2UtEOx3bs22Xydjo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407675; c=relaxed/simple;
	bh=ytp7kXlpAtqB9urT6gy4YaIy74UXy/ZM6dsuviAjRwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxOBjxHh1aj/L/gketJ5ynjceVNU6Jc2OuFWvXioWk2Pi5EpF3lJVBgAJv8kQFZ6FQl/p5UeSZYg4Wtp2ol1UvuZvMafEWXr36JbSkI/+3vai1VEe2PcgEqz3phnq0J2HYIiadCcQ1U1hhGAg39JR7dYR6hiCnhIioSAuV6NSLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEfHcUz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEfHcUz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3EFC4CED4;
	Tue, 12 Nov 2024 10:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407675;
	bh=ytp7kXlpAtqB9urT6gy4YaIy74UXy/ZM6dsuviAjRwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEfHcUz0CyimjX0QDYdz1jylXkSVOYdnKVvfJE0YEcC4kh8Yz68CF4aUOAKCjCy2B
	 4kfly06LtXZHcTlfNuVJfFMh/feJBxsC3d1tyG6SlkU1S0qwTC2rlBQoeQ7ysyZ6mu
	 co1OwsaAbaN/KtmtxA0i04SKaBJ7ietRpfeoZjA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	linux-afs@lists.infradead.org,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/119] rxrpc: Fix missing locking causing hanging calls
Date: Tue, 12 Nov 2024 11:20:56 +0100
Message-ID: <20241112101850.552175902@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3322fb93a260b..ed36f5f577a9d 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -283,6 +283,7 @@
 	EM(rxrpc_call_see_input,		"SEE input   ") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
 	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
+	EM(rxrpc_call_see_waiting_call,		"SEE q-conn  ") \
 	E_(rxrpc_call_see_zap,			"SEE zap     ")
 
 #define rxrpc_txqueue_traces \
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 1d95f8bc769fa..a0231b64fb6ef 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -507,6 +507,7 @@ void rxrpc_connect_client_calls(struct rxrpc_local *local)
 
 		spin_lock(&local->client_call_lock);
 		list_move_tail(&call->wait_link, &bundle->waiting_calls);
+		rxrpc_see_call(call, rxrpc_call_see_waiting_call);
 		spin_unlock(&local->client_call_lock);
 
 		if (rxrpc_bundle_has_space(bundle))
@@ -577,7 +578,10 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
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



