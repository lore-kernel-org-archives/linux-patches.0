Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE63143757;
	Wed, 19 Jun 2024 13:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803619; cv=none; b=jcZO8JHiH6gTR/asCSzQl/dO66eZqYRCf/G2VWTC9wpq4yXz9s0BR8BSv6WDWx3RQXENCP95Gz04utUvCeXR5MXay8U5nWMtwbH8dutbqdhdkEkHC3Rygi0+5TuxL423s1QuM7L5/L8H0z6390ELr6c/p67lKNHMIWZMEWQwfME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803619; c=relaxed/simple;
	bh=2cpGn5EGbdGO6vfqdeWWtjavtEAOrGBnYlbnyaqdbLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgVMKvUwr93DhjXgKkUPYzw2GGb/YtczImVlS1zhCu1aJppcrk7PqAyQmmeSdnX6yc0XUeuZ/0hL9qWLcozUQMsdr5vIe9ihOSq0KB4aWKovQmZD2mRUMVtl2dp2Dd0ZeoemU6y3FlXjPNXcdNnuu+tUVFc7G5GNbhlvoZAlYK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljVueAz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljVueAz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F41C2BBFC;
	Wed, 19 Jun 2024 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803618;
	bh=2cpGn5EGbdGO6vfqdeWWtjavtEAOrGBnYlbnyaqdbLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljVueAz4jaR9+UKyrvoEkiJHVnFJpCltMk3GjJXG8aUNtxuoDtsHyqK+bDDO1LO4E
	 ovqtwRf01wE2iL7187woCdOA8Bahv6bqALzdaGAff6GlnIPAfnTgaDLBA312wAl+Ra
	 BfIKV5bACisb7UBv6AbAYFtFcFnsGffle5oJVqJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/217] af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().
Date: Wed, 19 Jun 2024 14:54:50 +0200
Message-ID: <20240619125558.478907336@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



