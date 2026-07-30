Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2633344470B;
	Thu, 30 Jul 2026 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426923; cv=none; b=cS4/89COj2Rj/mwkAzeeWGUsEbcKZ3dUJQGxUzk/+jKfUjtzy0Np44cdPXNXcFAuLb+Lqc+Mm/m0+WZitLw7T6dREI+v3RnRVK1W0vZhwn/Vwpkjebq2/E2RU1v0tF893TRcspmxsTDOufSIUVvlKOVOemEE8fkGWyX7hbHJMjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426923; c=relaxed/simple;
	bh=g6CDJPxxwacoWXhKxKk7aKndXSxYX2yFyTNmrzmHV0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HD0NP6sxeW00sUbWpNZfkDrcxvdbhW6YxgDhCA/NlXIYjPuLNUN8O53j2KQfJV7QQIJEHRP9vS1b3mw3J0BUGm0927/TBPSAMFGZc4P3QoiaLq+JocRU6cZA5I7Q+fpXIc5eshx9GtpBX2BY24wdc0cXsLikGoyJMahwtD4aDUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO4pKWQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO4pKWQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829931F00A3A;
	Thu, 30 Jul 2026 15:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426922;
	bh=cIIHh5xcrKz0t9YezBdvTd75XG5JjELCMRNCcyNlG2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XO4pKWQSOxh4f5NACUCWhMDe0+HZolD8A8SudCnY7pPC1sNSX9R356VtkI5bCUHvF
	 3w/eswQOt0xqXU7EBX7Dkvmc0Dr5IXxSAVkwDy22KyNXxpKhVjOvCXVYC+NJ5eJr7g
	 wv9lirny22rP5D+U5L0f8jWltzDReX5AeEwtPnQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 589/602] rxrpc: Disable IRQ, not BH, to take the lock for ->attend_link
Date: Thu, 30 Jul 2026 16:16:21 +0200
Message-ID: <20260730141448.431183227@linuxfoundation.org>
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
@@ -482,9 +482,9 @@ int rxrpc_io_thread(void *data)
 		while ((conn = list_first_entry_or_null(&conn_attend_q,
 							struct rxrpc_connection,
 							attend_link))) {
-			spin_lock_bh(&local->lock);
+			spin_lock_irq(&local->lock);
 			list_del_init(&conn->attend_link);
-			spin_unlock_bh(&local->lock);
+			spin_unlock_irq(&local->lock);
 			rxrpc_input_conn_event(conn, NULL);
 			rxrpc_put_connection(conn, rxrpc_conn_put_poke);
 		}
@@ -501,9 +501,9 @@ int rxrpc_io_thread(void *data)
 		while ((call = list_first_entry_or_null(&call_attend_q,
 							struct rxrpc_call,
 							attend_link))) {
-			spin_lock_bh(&local->lock);
+			spin_lock_irq(&local->lock);
 			list_del_init(&call->attend_link);
-			spin_unlock_bh(&local->lock);
+			spin_unlock_irq(&local->lock);
 			trace_rxrpc_call_poked(call);
 			rxrpc_input_call_event(call);
 			rxrpc_put_call(call, rxrpc_call_put_poke);


