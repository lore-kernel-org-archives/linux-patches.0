Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31E3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RepqmVy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC76C433C8;
	Wed, 15 Nov 2023 19:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077867;
	bh=6FpuizoJz+eMk7vQJcRKs4AJlmxzh7dBxMa7jcDN/80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RepqmVy3cswBMKbTZnFAuzxHA7kpbxY/19TjtJ0EuOpNKyLIHeIcUYbb4d0j33p7f
	 Y2NnM2/hdi1gAnR9FepUNqedoDBDva1NoL2FNTW+K+sG1F2rwlWdimm6DLilZ5/5n5
	 5+LFPMA1v9R8RXFKsF2ShSI2zLMkZgePchBfBgBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 544/603] rxrpc: Fix two connection reaping bugs
Date: Wed, 15 Nov 2023 14:18:09 -0500
Message-ID: <20231115191649.428634820@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit 61e4a86600029e6e8d468d1fad6b6c749bebed19 ]

Fix two connection reaping bugs:

 (1) rxrpc_connection_expiry is in units of seconds, so
     rxrpc_disconnect_call() needs to multiply it by HZ when adding it to
     jiffies.

 (2) rxrpc_client_conn_reap_timeout() should set RXRPC_CLIENT_REAP_TIMER if
     local->kill_all_client_conns is clear, not if it is set (in which case
     we don't need the timer).  Without this, old client connections don't
     get cleaned up until the local endpoint is cleaned up.

Fixes: 5040011d073d ("rxrpc: Make the local endpoint hold a ref on a connected call")
Fixes: 0d6bf319bc5a ("rxrpc: Move the client conn cache management to the I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/783911.1698364174@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_object.c  | 2 +-
 net/rxrpc/local_object.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index ac85d4644a3c3..df8a271948a1c 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -212,7 +212,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 		conn->idle_timestamp = jiffies;
 		if (atomic_dec_and_test(&conn->active))
 			rxrpc_set_service_reap_timer(conn->rxnet,
-						     jiffies + rxrpc_connection_expiry);
+						     jiffies + rxrpc_connection_expiry * HZ);
 	}
 
 	rxrpc_put_call(call, rxrpc_call_put_io_thread);
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 7d910aee4f8cb..c553a30e9c838 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -87,7 +87,7 @@ static void rxrpc_client_conn_reap_timeout(struct timer_list *timer)
 	struct rxrpc_local *local =
 		container_of(timer, struct rxrpc_local, client_conn_reap_timer);
 
-	if (local->kill_all_client_conns &&
+	if (!local->kill_all_client_conns &&
 	    test_and_set_bit(RXRPC_CLIENT_CONN_REAP_TIMER, &local->client_conn_flags))
 		rxrpc_wake_up_io_thread(local);
 }
-- 
2.42.0



