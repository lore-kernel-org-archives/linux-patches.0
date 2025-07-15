Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963152E7F0B;
	Tue, 15 Jul 2025 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586785; cv=none; b=qr5XyXxytH4x39D4L/JQ4pBMgKYqyyE0CC8r/FmyPANKt+LG0sRcHgXYQPFOQpsd58PkrH4t4Ak6/kXPNZ7lwHu84qq099AcQYUkyh/aQezJrs5uPteCn3CAuqTYdmGhaqLgDTpl+R4PTHHxwhIGcb7j2rdc9jjekLInTevvTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586785; c=relaxed/simple;
	bh=GE6M/xDtZ0B0kU/LeDKpBCNKLQADlUTvFUQYeZI+PHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPri4EDT5Lbo6tMLKqiWaBvWwEvs3R0dvfJUw6M2I3VOE/zqw4GcpezA4peIv+xjEwTq5kWSKvI5e59D3wSlD2xl++h+GomIVOQDuU4tNTyIxnwxyi7CvIBZrifnRB0unCCfO5GxVNA788HdcW2wOOXLSxqTZwdGcs2h/jc+Wvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXk8MGQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXk8MGQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284CCC4CEE3;
	Tue, 15 Jul 2025 13:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586785;
	bh=GE6M/xDtZ0B0kU/LeDKpBCNKLQADlUTvFUQYeZI+PHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXk8MGQ8fJ+0M1dX0ucVE7iobng8Ir1titU+wZFaD6enQZXESwMMaDjPAZamUesIs
	 /JxfvVXoAn83m6C/seSyZTJfxcgIrdmreGrrKwLWMKnmHLJmtfLcZz74+WC4utXzCq
	 3NjNZOI09p8te/a4jnT5oUrulZ2sP1bhxWJ8UXm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	David Howells <dhowells@redhat.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 047/192] rxrpc: Fix bug due to prealloc collision
Date: Tue, 15 Jul 2025 15:12:22 +0200
Message-ID: <20250715130816.737308169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 69e4186773c6445b258fb45b6e1df18df831ec45 ]

When userspace is using AF_RXRPC to provide a server, it has to preallocate
incoming calls and assign to them call IDs that will be used to thread
related recvmsg() and sendmsg() together.  The preallocated call IDs will
automatically be attached to calls as they come in until the pool is empty.

To the kernel, the call IDs are just arbitrary numbers, but userspace can
use the call ID to hold a pointer to prepared structs.  In any case, the
user isn't permitted to create two calls with the same call ID (call IDs
become available again when the call ends) and EBADSLT should result from
sendmsg() if an attempt is made to preallocate a call with an in-use call
ID.

However, the cleanup in the error handling will trigger both assertions in
rxrpc_cleanup_call() because the call isn't marked complete and isn't
marked as having been released.

Fix this by setting the call state in rxrpc_service_prealloc_one() and then
marking it as being released before calling the cleanup function.

Fixes: 00e907127e6f ("rxrpc: Preallocate peers, conns and calls for incoming service requests")
Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250708211506.2699012-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_accept.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index e685034ce4f7c..e862990c5b37c 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -149,6 +149,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 
 id_in_use:
 	write_unlock(&rx->call_lock);
+	rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, -EBADSLT);
 	rxrpc_cleanup_call(call);
 	_leave(" = -EBADSLT");
 	return -EBADSLT;
-- 
2.39.5



