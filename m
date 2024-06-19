Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC671474DA;
	Wed, 19 Jun 2024 13:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802034; cv=none; b=oyXNoOTIIXvUTLvDGBcH2LQO96cittmuGSsy37QhG0oRIFRkp0Ph9cSjoVjuldareTmidPe0P4avIolQxkDr/lR2KvNYb3/OIeF2/Zs1BcUfY/PnW0QuAZShVgI9I8ouFZgE4pjszeSij16TyYvr7mF11vQXx71CdtItZSMk1/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802034; c=relaxed/simple;
	bh=4SyzzMkiMifZuz9mVKQLR3djCykA06qevvUnaqYZjxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5nWi8ixQQQHvgdMC7jhD9H7K4DuzEcbxs4oRw6lq2OhS1fnOrT1pKPAW6Y2+M9wV/e24Sf2ZzzyxaCeiqyDHXNmAUPKeN+BnOOvkpSlrSTklBitPbMWWVOBwrsIctptCHuRZBh3hMuq4G7kF84mI+IP/QirKad5JrNO1scFO08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceV0+pQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceV0+pQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBF7C32786;
	Wed, 19 Jun 2024 13:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802033;
	bh=4SyzzMkiMifZuz9mVKQLR3djCykA06qevvUnaqYZjxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceV0+pQhN1IKQWaXtRwIe4Fftx6aNGV22kIc25x7cXURReBYMORKVZC1uH5A1YiAr
	 v2fLcQRn1gEAAwMcg33KDpzPSpWCMhKY1HBYToazrqtiYf+vL3K/jZB9NSb3i9jFDR
	 199DqHC7Z+T0mrnmHc9Ov8TOgnOGYgugs6nst79I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/267] af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().
Date: Wed, 19 Jun 2024 14:53:31 +0200
Message-ID: <20240619125608.664390893@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index 9151c72e742fc..fc56244214c30 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -104,7 +104,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	struct unix_diag_rqlen rql;
 
 	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
-		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
+		rql.udiag_rqueue = skb_queue_len_lockless(&sk->sk_receive_queue);
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
 		rql.udiag_rqueue = (u32) unix_inq_len(sk);
-- 
2.43.0



