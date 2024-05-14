Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D142F9D4;
	Tue, 14 May 2024 11:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687772; cv=none; b=rhAXSm9sNiKGtr0mUmJo2kSTvhHYlNRxB0I522CLHWUPq6Kr3VALbK4Zz5WwupEJ2WMCO1dYIzCAoRkh9TUKXG6WAz9M+2oAsfzMS7zK3zuFKTyb6XgaQ6/fVXgupCs/S4MSdb0jYkpDowC5AbkKgwpmxhEIIyT3NnpjJ/rQ9rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687772; c=relaxed/simple;
	bh=5Kt15Vp9AHI9oKtwE4bN/5ld/B6ugx/gm1drrexM8Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv7jlRdW+T1VfpipyBzJZWUZZ4nrI90a5rYgFUpVHzAwi/Nj4OxEP/nWU3o2Z5XtToKXLCMQyV68PSlSkmzEzvluvDdTqcsBaQfWiC1wT0lhl5V6q1q4DL3Rz7pjnAARTdlwA2R9ISyf77WvEgzlr9vfr/SgKbBRoem1t/WkSOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gldvdVvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gldvdVvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2318AC32781;
	Tue, 14 May 2024 11:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687772;
	bh=5Kt15Vp9AHI9oKtwE4bN/5ld/B6ugx/gm1drrexM8Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gldvdVvgAZcb+d2gM2FEoFBmhmCEjzpdNwKsv+/DOzqaBw9VU9yL1PmTdAfdLmXGg
	 2FDRQXqBLldMah0uoTqWiTrHoyqvez5C378WxD2ijGBp2UaXBBMdrqGSBq1cBFt6tC
	 6sjhZcsPDJs6SKEmmBB2QsYXSaFGQ/MLFv11hhYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	William Findlay <will@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/168] bpf, sockmap: Improved check for empty queue
Date: Tue, 14 May 2024 12:19:57 +0200
Message-ID: <20240514101010.426565013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 405df89dd52cbcd69a3cd7d9a10d64de38f854b2 ]

We noticed some rare sk_buffs were stepping past the queue when system was
under memory pressure. The general theory is to skip enqueueing
sk_buffs when its not necessary which is the normal case with a system
that is properly provisioned for the task, no memory pressure and enough
cpu assigned.

But, if we can't allocate memory due to an ENOMEM error when enqueueing
the sk_buff into the sockmap receive queue we push it onto a delayed
workqueue to retry later. When a new sk_buff is received we then check
if that queue is empty. However, there is a problem with simply checking
the queue length. When a sk_buff is being processed from the ingress queue
but not yet on the sockmap msg receive queue its possible to also recv
a sk_buff through normal path. It will check the ingress queue which is
zero and then skip ahead of the pkt being processed.

Previously we used sock lock from both contexts which made the problem
harder to hit, but not impossible.

To fix instead of popping the skb from the queue entirely we peek the
skb from the queue and do the copy there. This ensures checks to the
queue length are non-zero while skb is being processed. Then finally
when the entire skb has been copied to user space queue or another
socket we pop it off the queue. This way the queue length check allows
bypassing the queue only after the list has been completely processed.

To reproduce issue we run NGINX compliance test with sockmap running and
observe some flakes in our testing that we attributed to this issue.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230523025618.113937-5-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h |  1 -
 net/core/skmsg.c      | 32 ++++++++------------------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 07a8e7c695373..422b391d931fe 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -73,7 +73,6 @@ struct sk_psock_link {
 };
 
 struct sk_psock_work_state {
-	struct sk_buff			*skb;
 	u32				len;
 	u32				off;
 };
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 51ab1e617d922..675fd86279d87 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -615,16 +615,12 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 
 static void sk_psock_skb_state(struct sk_psock *psock,
 			       struct sk_psock_work_state *state,
-			       struct sk_buff *skb,
 			       int len, int off)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
-		state->skb = skb;
 		state->len = len;
 		state->off = off;
-	} else {
-		sock_drop(psock->sk, skb);
 	}
 	spin_unlock_bh(&psock->ingress_lock);
 }
@@ -635,23 +631,17 @@ static void sk_psock_backlog(struct work_struct *work)
 	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
 	struct sk_buff *skb = NULL;
+	u32 len = 0, off = 0;
 	bool ingress;
-	u32 len, off;
 	int ret;
 
 	mutex_lock(&psock->work_mutex);
-	if (unlikely(state->skb)) {
-		spin_lock_bh(&psock->ingress_lock);
-		skb = state->skb;
+	if (unlikely(state->len)) {
 		len = state->len;
 		off = state->off;
-		state->skb = NULL;
-		spin_unlock_bh(&psock->ingress_lock);
 	}
-	if (skb)
-		goto start;
 
-	while ((skb = skb_dequeue(&psock->ingress_skb))) {
+	while ((skb = skb_peek(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
 		if (skb_bpf_strparser(skb)) {
@@ -660,7 +650,6 @@ static void sk_psock_backlog(struct work_struct *work)
 			off = stm->offset;
 			len = stm->full_len;
 		}
-start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
 		do {
@@ -670,8 +659,7 @@ static void sk_psock_backlog(struct work_struct *work)
 							  len, ingress);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
-					sk_psock_skb_state(psock, state, skb,
-							   len, off);
+					sk_psock_skb_state(psock, state, len, off);
 
 					/* Delay slightly to prioritize any
 					 * other work that might be here.
@@ -683,15 +671,16 @@ static void sk_psock_backlog(struct work_struct *work)
 				/* Hard errors break pipe and stop xmit. */
 				sk_psock_report_error(psock, ret ? -ret : EPIPE);
 				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
-				sock_drop(psock->sk, skb);
 				goto end;
 			}
 			off += ret;
 			len -= ret;
 		} while (len);
 
-		if (!ingress)
+		skb = skb_dequeue(&psock->ingress_skb);
+		if (!ingress) {
 			kfree_skb(skb);
+		}
 	}
 end:
 	mutex_unlock(&psock->work_mutex);
@@ -784,11 +773,6 @@ static void __sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		sock_drop(psock->sk, skb);
 	}
-	kfree_skb(psock->work_state.skb);
-	/* We null the skb here to ensure that calls to sk_psock_backlog
-	 * do not pick up the free'd skb.
-	 */
-	psock->work_state.skb = NULL;
 	__sk_psock_purge_ingress_msg(psock);
 }
 
@@ -807,7 +791,6 @@ void sk_psock_stop(struct sk_psock *psock)
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
-	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
@@ -822,6 +805,7 @@ static void sk_psock_destroy(struct work_struct *work)
 	sk_psock_done_strp(psock);
 
 	cancel_delayed_work_sync(&psock->work);
+	__sk_psock_zap_ingress(psock);
 	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
-- 
2.43.0



