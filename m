Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24B4BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641B7C433EF;
	Tue,  7 Mar 2023 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209585;
	bh=d2vq+OpyWVYC6vMQK9HpWdLkXJXkpAFUzASnP3LFqcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgWWKjDwpirT2oPCDeZnW9BV22/x1t+u9EobqNlNz+/gZ6dAFj9dz+fdaoICnQFf6
	 g8b26KGDYAkhLZNyAgBXF8f/o82mM73dauG1ydpd2y/4B2xjW5/t3eGWhM8d93kNQu
	 YE5TAO82oblShTcpWvntE3qtgdWOQ00Wpcaff344=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0267/1001] rxrpc: Fix overwaking on call poking
Date: Tue,  7 Mar 2023 17:50:39 +0100
Message-Id: <20230307170033.311899660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit a33395ab85b9b9cff83948a03a1d6d96347935d8 ]

If an rxrpc call is given a poke, it will get woken up unconditionally,
even if there's already a poke pending (for which there will have been a
wake) or if the call refcount has gone to 0.

Fix this by only waking the call if it is still referenced and if it
doesn't already have a poke pending.

Fixes: 15f661dc95da ("rxrpc: Implement a mechanism to send an event notification to a call")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_object.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f3c9f0201c156..7ce562f6dc8d5 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -54,12 +54,14 @@ void rxrpc_poke_call(struct rxrpc_call *call, enum rxrpc_call_poke_trace what)
 		spin_lock_bh(&local->lock);
 		busy = !list_empty(&call->attend_link);
 		trace_rxrpc_poke_call(call, busy, what);
+		if (!busy && !rxrpc_try_get_call(call, rxrpc_call_get_poke))
+			busy = true;
 		if (!busy) {
-			rxrpc_get_call(call, rxrpc_call_get_poke);
 			list_add_tail(&call->attend_link, &local->call_attend_q);
 		}
 		spin_unlock_bh(&local->lock);
-		rxrpc_wake_up_io_thread(local);
+		if (!busy)
+			rxrpc_wake_up_io_thread(local);
 	}
 }
 
-- 
2.39.2



