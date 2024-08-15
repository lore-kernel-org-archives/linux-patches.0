Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704DE1A0710;
	Thu, 15 Aug 2024 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730589; cv=none; b=Vy7wjGGJOvOlpDikPap3ZD8UrBBXnCT2qoxZykJviwTF1qjOEkNkgz7YXF4DWPItESD4YFMQ4DFsZCc7RmxHj8Typ8Y/vsp1305eRiRcr+A2jYFK3KaoURdXwjQHXkzu2JzuTKkOfGdqzuxNUuwqsDWG/IKOAmBU8rXlg+rdY3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730589; c=relaxed/simple;
	bh=coubS2iPOSyG2XDTEAXXin0O+Qdo/3LH6iWskwDua28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1sW5DiGDtvNSGa7rn0hdsTRbMkENHYMQtDdlTt2Z2XW55d3scAUGK1Ml8bk0uMJ0e9P/Z4fkpQuW1vr4CX16nhTQUvV9++v0rOp9koKlKgZxpV7GVUkY3beqaMwwR1aKDYI+VBpC9w/mrhrJHG5C+VVqDW1RDbB5+xZEeVB9ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns4MWvFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns4MWvFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874AAC32786;
	Thu, 15 Aug 2024 14:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730589;
	bh=coubS2iPOSyG2XDTEAXXin0O+Qdo/3LH6iWskwDua28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ns4MWvFB4gEPO4dsj9ovJdTy8y39EUMwWZ3XfSpMsxdIyQsU13VKv7aD3GP48AJCs
	 RsfdiNDCSUvVTeDXTugb6WxVI9y1tczXCRYTEBeHTCZneYO78Pnqwf5s+lgGdSBfzX
	 MW/AcLaj8pm2K6xHimfCoPGB7mtzMrZRMShohiaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 455/484] mptcp: fix bad RCVPRUNED mib accounting
Date: Thu, 15 Aug 2024 15:25:13 +0200
Message-ID: <20240815131959.041709030@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 0a567c2a10033bf04ed618368d179bce6977984b upstream.

Since its introduction, the mentioned MIB accounted for the wrong
event: wake-up being skipped as not-needed on some edge condition
instead of incoming skb being dropped after landing in the (subflow)
receive queue.

Move the increment in the correct location.

Fixes: ce599c516386 ("mptcp: properly account bulk freed memory")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in protocol.c, because the commit 6511882cdd82 ("mptcp:
  allocate fwd memory separately on the rx and tx path") is not in this
  version. The fix can still be applied before the 'goto drop'. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -288,8 +288,10 @@ static bool __mptcp_move_skb(struct mptc
 	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
 		int amount = sk_mem_pages(skb->truesize) << SK_MEM_QUANTUM_SHIFT;
 
-		if (ssk->sk_forward_alloc < amount)
+		if (ssk->sk_forward_alloc < amount) {
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
 			goto drop;
+		}
 
 		ssk->sk_forward_alloc -= amount;
 		sk->sk_forward_alloc += amount;
@@ -774,10 +776,8 @@ void mptcp_data_ready(struct sock *sk, s
 		sk_rbuf = ssk_rbuf;
 
 	/* over limit? can't append more skbs to msk, Also, no need to wake-up*/
-	if (__mptcp_rmem(sk) > sk_rbuf) {
-		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RCVPRUNED);
+	if (__mptcp_rmem(sk) > sk_rbuf)
 		return;
-	}
 
 	/* Wake-up the reader only for in-sequence data */
 	mptcp_data_lock(sk);


