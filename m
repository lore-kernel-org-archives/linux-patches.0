Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241A313BC0B;
	Wed,  3 Jul 2024 11:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004486; cv=none; b=R9LAPCyKB7C0muYjqOjr6mcdmnDk1RFoIBIjgMWjRuqaMXCrTiUdmiQJQyzq7yhxlsmsJKRzOuKdqblxxnoJcgE092cDl0ZM3nnDDPqInbScNYHqwlBIPoEX4x6odTkBUPsmDssvE/3KKDtSB/MU3YVguTgRCVkhfei8JVd+U8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004486; c=relaxed/simple;
	bh=JmE+kPtdSJLE4jP2YCzrBk9O2IQAczbPgMzFVkJHuxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pfc6xK+miyRX2cZkXFF//eAXvz8y1e9W1HxTJBsTosjtIHQfiHp6dV39b7JsHQoXa7/59iM/a4tC/7R6MMmSfju35wNYdQZ/+7tMNQrNfEoeS1tEp0vT0u7MKyhEINyq6NKftVQ8bRUSF5VrLPmSAkoAB5TfU3i978xP8cpyRoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yH8Y5hrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yH8Y5hrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1484C2BD10;
	Wed,  3 Jul 2024 11:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004486;
	bh=JmE+kPtdSJLE4jP2YCzrBk9O2IQAczbPgMzFVkJHuxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yH8Y5hrzFzO2mENqw7fHwjOE+YuWXiUewr7ML1IBc9yyhd3GVYgE+OBDEhHpi1Pbv
	 urJ3mYGYCjBH5PXTxUErFhKXnDoiDkmfk4IRnTcYLd1WML90ew9j50AAQKwc88D84Y
	 lLhr6x/tdEDJBBlfi11cY3OL8B7+yJGPvIiNbB7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/290] af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().
Date: Wed,  3 Jul 2024 12:36:47 +0200
Message-ID: <20240703102905.182173659@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5d915e584d8408211d4567c22685aae8820bfc55 ]

We can dump the socket queue length via UNIX_DIAG by specifying
UDIAG_SHOW_RQLEN.

If sk->sk_state is TCP_LISTEN, we return the recv queue length,
but here we do not hold recvq lock.

Let's use skb_queue_len_lockless() in sk_diag_show_rqlen().

Fixes: c9da99e6475f ("unix_diag: Fixup RQLEN extension report")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 4666fabb04933..5bc5cb83cc6e4 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -103,7 +103,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	struct unix_diag_rqlen rql;
 
 	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
-		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
+		rql.udiag_rqueue = skb_queue_len_lockless(&sk->sk_receive_queue);
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
 		rql.udiag_rqueue = (u32) unix_inq_len(sk);
-- 
2.43.0



