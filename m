Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3008A46AA6A;
	Tue, 21 Jul 2026 15:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647977; cv=none; b=Y3rjZupRqbEjeh0lhzEmLOkDbqyj+ifAmqwMKBlFw9faxwqVMp9jPKhVdVm9GD8jdWSbBCk8H+vfBx1txhK8WeY2xN8Q0wmQSe/w5yO9VQT/dkpMYbFKyMxqvDAkS9+Z4jrAxjD5Zp9moWJIwg7PkCe4b5bcNcY4Vvkhhc9hOJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647977; c=relaxed/simple;
	bh=DWcXAtOmc8tPrz/B4pxMF42Al6qXXoGOwpOm0GxGnE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbjC+ValoyOla3gf0fEMcI82LB1hDHg6e7E3uQNpM/h6Fh7sDF5+2SKZUJmwpVSL1sMMuiD9rg+GPf7rKR4v6R0Jr9VflbVgL9nVbJ8FRlWWczinDY6ZVw1yvDneb+R1XSkrg90NQ9Z59pMUlgBDMsMA/sU0w75dAN9Tqz4tvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgnSQhTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgnSQhTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E1D1F000E9;
	Tue, 21 Jul 2026 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647976;
	bh=TEZDiFCOOIwnuDLyo8L684Mmh3KOJI5o0acOPAhI9XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgnSQhTYmyHxjvl3TbyrFsYLWByhjaPZ4Rnql9C0QfZTXcCFb5WZ2nu8OiUpvPgTx
	 z+sT9mK2xU+A85gtdxVhdFYYS0FPKVzP97ns6a+o/IcN7SHr3W10ryHpONyBSGSix+
	 zjP7iou2dVOs3qRzIqVzXaZAUWPAdJGNy8Y80rLA=
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
Subject: [PATCH 7.1 0025/2077] rxrpc: Fix socket notification race
Date: Tue, 21 Jul 2026 16:54:58 +0200
Message-ID: <20260721152553.265677917@linuxfoundation.org>
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

commit e66f8f32f50116670dbbee5bc9e692cd2cd0c8f8 upstream.

There's a race between rxrpc_recvmsg() and rxrpc_notify_socket(), whereby
the latter's attempt to avoid disabling interrupts and taking the socket's
recvmsg_lock if the call is already queued may happen simultaneously with
the former's discarding of a call that has nothing queued.

Fix this by removing the shortcut.  Note that this only affects userspace's
use of AF_RXRPC; the AFS filesystem driver doesn't use the socket queue.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-10-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -27,8 +27,6 @@ void rxrpc_notify_socket(struct rxrpc_ca
 
 	_enter("%d", call->debug_id);
 
-	if (!list_empty(&call->recvmsg_link))
-		return;
 	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
 		rxrpc_see_call(call, rxrpc_call_see_notify_released);
 		return;


