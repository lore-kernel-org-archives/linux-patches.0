Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E568610B;
	Mon, 14 Oct 2024 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916256; cv=none; b=XHHd1A02m/dqc9uiXFn76Nx1LEbEFwIBcv+aJCvLWJuuXdnBBje4SpcDCqfxDQLRlxAzpoF+F016/69ZrE/+hyLiN9RVdPuMQ8Q5TnYmF9pTKALZ0A96UbmbOVmS5rPhpHX/SEZKO8Z8tpz4nvLwSMQGbyvsN4/s2sXeV6N0GhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916256; c=relaxed/simple;
	bh=b5WwNBZDJpssa8nPEwz2M+E2voSI6ODSHqLXxNYsXMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqd99S2+WVM4NITPZopb/e/zCKE0L2aet07spKPqViJULr5LCscyZ2fNLL3f6KT++yJK0cGqB9AG3KaDhc6mxBpAHWJm/x5RSv58a3LEOEAcqxzUMlE6CaXP+/ucIWwjvjKjjjCG/SByBbAyvVnFIdotmBcBlhR/UxVWJP7L8Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNsIfzSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNsIfzSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FDEC4CEC3;
	Mon, 14 Oct 2024 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916255;
	bh=b5WwNBZDJpssa8nPEwz2M+E2voSI6ODSHqLXxNYsXMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNsIfzSBkFj3Wd2Yt0yP1Yt0TSeSFtluw9gX0VHJ+V1Yuhj2Wbi44wC6NGXMiLteU
	 bSZTXZ9NAuFw8m0+rx+dKHzLotW+UqieXghaYzp7zU2x42bHFaCqposFY9Eg4tF11w
	 5Av8AdKUAC49S6174QpCVeAp2QJj05SKQya4aeE4=
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
Subject: [PATCH 6.11 097/214] rxrpc: Fix uninitialised variable in rxrpc_send_data()
Date: Mon, 14 Oct 2024 16:19:20 +0200
Message-ID: <20241014141048.781009093@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 894b8fa68e5e9..23d18fe5de9f0 100644
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
 			size_t remain;
-- 
2.43.0



