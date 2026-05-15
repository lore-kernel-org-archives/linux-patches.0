Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB963C9EED;
	Fri, 15 May 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861109; cv=none; b=ZuOsg0ke+YM2lSibNEEMAnCjibY4YC39DjwS/OkE6BlO7j4011e5yYKTmtd7zkb49Y1DnaNk15Z8B7Jb+c/KtJZQWFYFDdXjAmIdymf+qpozHo5eS9nvnWRwFMe2suRCUKFOgjdlC02/6N+cbf3HUr17jsDopigl6k17IBNeIsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861109; c=relaxed/simple;
	bh=cj7IE4ngO5Mqwv86ZO+TY98zBv3eJ3Q0MtnwUIPbCuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv6la6etZZ1+dU9FHswXE1xFdEir6LntHsgpAZLkj58Jg6QWb/6LguywFu4nzdwfugUqq+WOZLFyUBUpEJqkpBSzHzn3x6JpEAc3AMApyaWrkv5jR0xZlrV4zHaZO/o4xViYsc4yTO79LvtDqcsDw2T3OBsP/HM5Zm4z9HEkQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7evoYiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7evoYiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCEAC2BCB0;
	Fri, 15 May 2026 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861109;
	bh=cj7IE4ngO5Mqwv86ZO+TY98zBv3eJ3Q0MtnwUIPbCuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7evoYiQnlxT9+5GTQJ5Lnq1mXbT3EZhW6XmmG9dTKVWjUaMOhnzDeE8XD/RCe4Un
	 tRetCIEi1i+o3BAeRpWxHGqq9Ywk+Ktdmifz4ni+0EPvXxbLjG0jFNpBSvafxUtseJ
	 C2kHZGX36k3L+V94yv6HLJlBuTzuH6BM3ZQbCrNY=
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
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/474] rxrpc: Fix rxrpc_input_call_event() to only unshare DATA packets
Date: Fri, 15 May 2026 17:44:30 +0200
Message-ID: <20260515154718.509197816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

[ Upstream commit 55b2984c96c37f909bbfe8851f13152693951382 ]

Fix rxrpc_input_call_event() to only unshare DATA packets and not ACK,
ABORT, etc..

And with that, rxrpc_input_packet() doesn't need to take a pointer to the
pointer to the packet, so change that to just a pointer.

Fixes: 1f2740150f90 ("rxrpc: Fix potential UAF after skb_unshare() failure")
Closes: https://sashiko.dev/#/patchset/20260422161438.2593376-4-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260423200909.3049438-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index c8a4a4c979eb6..d6dfc7c08cf04 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -459,7 +459,9 @@ bool rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	if (skb) {
 		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
-		if (sp->hdr.securityIndex != 0 && skb_cloned(skb)) {
+		if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
+		    sp->hdr.securityIndex != 0 &&
+		    skb_cloned(skb)) {
 			/* Unshare the packet so that it can be modified by
 			 * in-place decryption.
 			 */
-- 
2.53.0



