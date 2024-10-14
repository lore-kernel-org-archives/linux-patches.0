Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF3713B7A1;
	Mon, 14 Oct 2024 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916983; cv=none; b=JwkY/mbRDY+k2H/Err59UzDYRtNT6kpad7c21JN9wAR2Uccir00Z16zL5AUKtE+89VX3bcEXIi1i5Llpj+hxj/5EI1jrYOt3ENlmBTr/a3owNZWdyEuYwYE9OO4UHYKcTthPpuclYId09jdjpxpMocfylp74dt1kG/pf7BzLkZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916983; c=relaxed/simple;
	bh=sTuEKnZMnOttwsVxFKgvj9JCZBpg7HWwRrRC1tn2LZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMZpeupJPtHXSUW0AU3pgugHVSTozxEFAXFcvB9xxoLU7NO5qH87d3H7RVH8XWvSUhztGlk4akYdQ/djQAH2XVR0MVrlfBHr89RPxAaW60jnd8St73AVeX3WI4eT1PMj79Pswp7Ref4sMFizEDu2wjWoKxxgOMsii4IJnvMZ+mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3p5iXjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3p5iXjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15133C4CEC3;
	Mon, 14 Oct 2024 14:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916983;
	bh=sTuEKnZMnOttwsVxFKgvj9JCZBpg7HWwRrRC1tn2LZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3p5iXjfbAsyfdZMZmpLiX5n0iFP/GX1cWzHeC29GeSvBrCODXl0qhkVceZLrLqgU
	 CbKhT2XRzf/GbM7nfLTforxLrTC08c6oI7NchpQemnRUjMKGRuwrlS1hLdWiGZK3/0
	 rqFqe00W3/wh+kAqt2oIbkFNhZpc562spYsOZDYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/213] rxrpc: Fix uninitialised variable in rxrpc_send_data()
Date: Mon, 14 Oct 2024 16:20:25 +0200
Message-ID: <20241014141047.612523466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

[ Upstream commit 7a310f8d7dfe2d92a1f31ddb5357bfdd97eed273 ]

Fix the uninitialised txb variable in rxrpc_send_data() by moving the code
that loads it above all the jumps to maybe_error, txb being stored back
into call->tx_pending right before the normal return.

Fixes: b0f571ecd794 ("rxrpc: Fix locking in rxrpc's sendmsg")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lists.infradead.org/pipermail/linux-afs/2024-October/008896.html
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20241001132702.3122709-3-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 8e0b94714e849..24f765d243db1 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -303,6 +303,11 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
 reload:
+	txb = call->tx_pending;
+	call->tx_pending = NULL;
+	if (txb)
+		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
+
 	ret = -EPIPE;
 	if (sk->sk_shutdown & SEND_SHUTDOWN)
 		goto maybe_error;
@@ -329,11 +334,6 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 			goto maybe_error;
 	}
 
-	txb = call->tx_pending;
-	call->tx_pending = NULL;
-	if (txb)
-		rxrpc_see_txbuf(txb, rxrpc_txbuf_see_send_more);
-
 	do {
 		if (!txb) {
 			size_t remain, bufsize, chunk, offset;
-- 
2.43.0



