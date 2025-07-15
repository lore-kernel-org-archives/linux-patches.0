Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67822E3AF9;
	Tue, 15 Jul 2025 13:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585840; cv=none; b=c2UJkWV1BoViJ4GYLOpNJZ4cxluV1YNAF+Z9oxTb8Q34r+ofDNBwqm4ggzhVYOou+yj3ClxncsKtyRtv1sUAjahY86Exi3ntdvV0D8lRq+G/BXGR6l4r/4kRQQrejTnVw44guRTegVQc+t5PzWwcdfbuCAdVJgxxyWl38FxJ3G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585840; c=relaxed/simple;
	bh=chKQqaTLnNShTwhfDY0GbUXT3vYF2/vAIVerGz8UMn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMnCLSEXPxdNNqgbJHOVs72vk921d7YdyrqClxeyT05/HCJamA15MwHNcb73v+pzYjGs9i1xmBsscDgQHlKKfF98+lzo/Uu0hH1CFtsFqEzlUfJ9c30KWDWbVl/ZDZfFagejWsqnNNUzGt8o4+U8QnkruGrkX0iP3maa2FD2oJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zI2b11r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zI2b11r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23629C4CEF1;
	Tue, 15 Jul 2025 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585840;
	bh=chKQqaTLnNShTwhfDY0GbUXT3vYF2/vAIVerGz8UMn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zI2b11r+i5ZLR8i0Edua9M+i6HeW5RDeFvsbDwkwrIdjC86vb0U1pehBHwYwiUXn6
	 Aw84N3M90Ns4gr3gEdnWq8nNNPRsqLAEYib5XETb3O91OKaaulPbs+H3HIqtBOLPC8
	 cJDrticM/ULExofCpM++cLLAnQn9Tfbge7I+GPcM=
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
Subject: [PATCH 6.6 027/109] rxrpc: Fix bug due to prealloc collision
Date: Tue, 15 Jul 2025 15:12:43 +0200
Message-ID: <20250715130759.969824841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f5a1d77b890f..65ef58ab7aa0c 100644
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



