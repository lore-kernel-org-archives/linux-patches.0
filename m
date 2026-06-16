Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB551684BE;
	Tue, 16 Jun 2026 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624944; cv=none; b=qtjdvnU9sPweGll9xWOONFaVDydlt8Cj9stDjqov23UsDnJaJIfMVtLhLOqQJ2mkyL2vglBLZB/lJWtqtxFX59eTZCfac841juyUQXCcYJV7EnJBpb3jsaKGZVcCh7MzIhO/TgJ1mlYwoW+nxY6AIu0DpspfbXd1CpC9nATGBWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624944; c=relaxed/simple;
	bh=nNaDPu/TMN1HA8zJmDbXpzUuYCzFRMwcQ5sI++7JPh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3EmO8u8Adgkhun5EQgKl9VEsf4ga4Txeq/XnTncndD2HD8cG0KYq1wpo4O4JuGshplvbihqJPlZaZRai+nQox4PxkcoKtgUhNe9q2cSwR8bYAtXRzXbVi8LRADzFyGJy9PV9BjDcHyupr3MLYlqrWYWKDDfCfnWj8OsMY5x7ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJwr1d3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJwr1d3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84521F000E9;
	Tue, 16 Jun 2026 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624943;
	bh=zOqb917tQoSImqVJD7M/pJMd6d1KXmtxZydrJOWVvng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJwr1d3Oy4zAofiT5LfQqlyRVwA2Ho58l0TEsNKVlLRDLyUEsdSuInNLeIVzR3RLL
	 DCsKfulzkVpFRkGI8a9Gy1paxFctXc+XVOOxWsrv5vyakQn9TB6ulsUtpVWC1RhK2u
	 nd9YeIJ7VmahouJcyaTEhjxA+t0Auj5vciXxs4vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyu Li <jianyu.li@mediatek.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/325] af_unix: Fix inq_len update problem in partial read
Date: Tue, 16 Jun 2026 20:27:31 +0530
Message-ID: <20260616145100.435440804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyu Li <jianyu.li@mediatek.com>

[ Upstream commit c1f07a7f2d47aeb9878301e7bb36bc1c2bc2be8e ]

Currently inq_len is updated only when the whole skb is consumed.
If only part of the data is read, following SIOCINQ query would
get value greater than what actually left.

This change update inq_len timely in unix_stream_read_generic(),
and adjust unix_stream_read_skb() accordingly to prevent
repetitive update.

Fixes: f4e1fb04c123 ("af_unix: Use cached value for SOCK_STREAM in unix_inq_len().")
Signed-off-by: Jianyu Li <jianyu.li@mediatek.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260601113640.231897-2-jianyu.li@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index faf04d1b6c013c..b339f83caf036e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2891,7 +2891,7 @@ static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		return -EAGAIN;
 	}
 
-	WRITE_ONCE(u->inq_len, u->inq_len - skb->len);
+	WRITE_ONCE(u->inq_len, u->inq_len - unix_skb_len(skb));
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (skb == u->oob_skb) {
@@ -3065,11 +3065,12 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				unix_detach_fds(&scm, skb);
 			}
 
-			if (unix_skb_len(skb))
-				break;
-
 			spin_lock(&sk->sk_receive_queue.lock);
-			WRITE_ONCE(u->inq_len, u->inq_len - skb->len);
+			WRITE_ONCE(u->inq_len, u->inq_len - chunk);
+			if (unix_skb_len(skb)) {
+				spin_unlock(&sk->sk_receive_queue.lock);
+				break;
+			}
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			spin_unlock(&sk->sk_receive_queue.lock);
 
-- 
2.53.0



