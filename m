Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215066;
	b=1kDQQ7E7wGqZa76SLcZwIjx9P50HLzJ3jPZBItqeJDiC7DQk1HSEOUgEZWaQDlaekcgu
	 NVDGHFBuSa0yRap4nCYmaFceAL9pgGE0IDGN1ZqqayZ2hpl9OmNiEh/ht6xP9RrMsxEyx
	 i7ZKKyzYvjHKzJwa0uZvA9TKczBdDvb1YkRTOuqgF93R+XaX0Um3kojYXvFJOG1rLFANI
	 uZORZ0DQ878yok9VPYb0jASZoctmh0IwxfVJpWUMLX60JnH5st/KuRymEnhsQ26E5rfMQ
	 jLpUf1DkF5nSaCv3WTGDFxMr4uduwejPQhfnuV2blQ61G8K3KzWFg0JRtsdf9Bc2N0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOmnFDLnxBqTb6Ed3KHpFnyx8Rx9nQSoTGs82rcffO4=;
	b=0Whb+lsHxqDPrqEcXcLJgUz7QZP+2Uk2lpJM81Di0evgOs7xGLxQOKsmLjvgCOcyHAs7
	 saJtGyn0oFs7Yy8H3MD/to/yuQtV/XU1sTfk2i4EjffRbvWj1EQOMBTkEGF6YGMNd0ibv
	 hAHp1oC6jD9LaNujAcYfxQYjdACdmD/8nMMv76CguqV1QTFBNjgYYMXIlUSU/BGvQyY08
	 r2s+hrBpBFrO47ld/tJAgcCtgK65Jit7OpiNVLH2ne31uzh28pEuds7JsavoNRARWTO8u
	 8WIj0SAfJGo/GXiId/ybMxp3+ZNox2E3CGmDcyhNIxkZ8PIH5tTDtsYy8VSarvR2H3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adrlJpSG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF49B606A31A;
	Wed, 28 Oct 2026 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adrlJpSG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7541F01825;
	Wed, 28 Oct 2026 19:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215065;
	bh=OOmnFDLnxBqTb6Ed3KHpFnyx8Rx9nQSoTGs82rcffO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adrlJpSGdoAZR0ZgpjIIH7orfxeoqfDvAL1SSAQ7Z3Er7q+kyOQsUovb3CSzAIzwX
	 amCDCPcRwDaGtkB+NAz/1ymYCptSEp53sX/q11PZnqfGaQP2qi2gCKd8WxDPXrEmVa
	 Ubpa+f8EVlDVHxV0YzZ7mJGPpAv07r1+1ZjfCAUg=
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
Subject: [PATCH 6.1 1043/1887] rxrpc: Fix conn-level packet handling to unshare RESPONSE packets
Date: Wed, 28 Oct 2026 17:52:19 +0100
Message-ID: <20261028170523.146854090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 24481a7f573305706054c59e275371f8d0fe919f ]

The security operations that verify the RESPONSE packets decrypt bits of it
in place - however, the sk_buff may be shared with a packet sniffer, which
would lead to the sniffer seeing an apparently corrupt packet (actually
decrypted).

Fix this by handing a copy of the packet off to the specific security
handler if the packet was cloned.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-5-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/conn_event.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 8079094844c0e..ef9303dcf7bd1 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -285,6 +285,34 @@ static void rxrpc_call_is_secure(struct rxrpc_call *call)
 	}
 }
 
+static int rxrpc_verify_response(struct rxrpc_connection *conn,
+				 struct sk_buff *skb,
+				 u32 *_abort_code)
+{
+	int ret;
+
+	if (skb_cloned(skb)) {
+		/* Copy the packet if shared so that we can do in-place
+		 * decryption.
+		 */
+		struct sk_buff *nskb = skb_copy(skb, GFP_NOFS);
+
+		if (nskb) {
+			rxrpc_new_skb(nskb, rxrpc_skb_unshared);
+			ret = conn->security->verify_response(conn, nskb, _abort_code);
+			rxrpc_free_skb(nskb, rxrpc_skb_freed);
+		} else {
+			/* OOM - Drop the packet. */
+			rxrpc_see_skb(skb, rxrpc_skb_unshared_nomem);
+			ret = -ENOMEM;
+		}
+	} else {
+		ret = conn->security->verify_response(conn, skb, _abort_code);
+	}
+
+	return ret;
+}
+
 /*
  * connection-level Rx packet processor
  */
@@ -345,7 +373,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		}
 		spin_unlock_bh(&conn->state_lock);
 
-		ret = conn->security->verify_response(conn, skb, _abort_code);
+		ret = rxrpc_verify_response(conn, skb, _abort_code);
 		if (ret < 0)
 			return ret;
 
-- 
2.53.0



