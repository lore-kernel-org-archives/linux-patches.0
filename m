Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E56A423A85;
	Tue, 25 Aug 2026 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665972; cv=none; b=Wi45RI8tnAmKkHnUbeu9PvjzE94GILt0N1DiGlLeTncsFXvzZN2R2xDP9GZnyPrQxseaDn56W6XXP4bhrxv8zKBaq+t/MMLMbf7ewfMb+NQoxZEZPbJ5NCV7yn+rEcJkSMjtGx9FrbVACWn3hm/vM9VX6FUDqWPaRxuouGmBtXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665972; c=relaxed/simple;
	bh=HWv+saPKD/5ri6uO0m2WHZaSLE659u3O6VWHkCt71Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXe2S8PgFDBab04yhBV+ZnXmiIf0V1pFy9YZDOPcYMnbf6btW3fkgTy9XzchC816fghd0CTUSvgtYm1Ms+VmKgahE7B221PukJcR4DQ7HlDouPtTvy638hcQLIBkRHmLx/WVkxwnGFvvpjww81LCiA2gj4zP09hWbhD6vfaF/IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfJ1Id0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfJ1Id0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5954A1F000E9;
	Tue, 25 Aug 2026 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665970;
	bh=vp282VNG+uSvZYTGwAv59stzfIoH0cDX++oQVLHJAMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfJ1Id0f26XYFgqLNyrDx1BqSb/nEqBLm1MN1uXTKn0ti2OMQlszL7CKxoQjN+MK3
	 z41JskMUQr+zF3d2eqrJi1Zm+pv+bziN9Z1XkKhUvdPDz6dAiFFML+yBl6i0gYUz+M
	 eVJtwF9NPI3JvDqfq4JuCxEs6rz8DzZhXxNhYBH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>
Subject: [PATCH 6.1 39/79] tls: fix lockless read of strp->msg_ready in ->poll
Date: Tue, 25 Aug 2026 15:26:19 +0200
Message-ID: <20260825132543.234597854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit 0844370f8945086eb9335739d10205dcea8d707b upstream.

tls_sk_poll is called without locking the socket, and needs to read
strp->msg_ready (via tls_strp_msg_ready). Convert msg_ready to a bool
and use READ_ONCE/WRITE_ONCE where needed. The remaining reads are
only performed when the socket is locked.

Fixes: 121dca784fc0 ("tls: suppress wakeups unless we have a full record")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/0b7ee062319037cf86af6b317b3d72f7bfcd2e97.1713797701.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0844370f8945 ("tls: fix lockless read of strp->msg_ready in ->poll")
Assisted-by: Codex:GPT-5
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h  |    3 ++-
 net/tls/tls.h      |    2 +-
 net/tls/tls_strp.c |    6 +++---
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -122,7 +122,8 @@ struct tls_strparser {
 	u32 stopped : 1;
 	u32 copy_mode : 1;
 	u32 mixed_decrypted : 1;
-	u32 msg_ready : 1;
+
+	bool msg_ready;
 
 	struct strp_msg stm;
 
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -167,7 +167,7 @@ static inline struct sk_buff *tls_strp_m
 
 static inline bool tls_strp_msg_ready(struct tls_sw_context_rx *ctx)
 {
-	return ctx->strp.msg_ready;
+	return READ_ONCE(ctx->strp.msg_ready);
 }
 
 static inline bool tls_strp_msg_mixed_decrypted(struct tls_sw_context_rx *ctx)
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -366,7 +366,7 @@ static int tls_strp_copyin(read_descript
 	if (strp->stm.full_len && strp->stm.full_len == skb->len) {
 		desc->count = 0;
 
-		strp->msg_ready = 1;
+		WRITE_ONCE(strp->msg_ready, 1);
 		tls_rx_msg_ready(strp);
 	}
 
@@ -533,7 +533,7 @@ static int tls_strp_read_sock(struct tls
 	if (!tls_strp_check_queue_ok(strp))
 		return tls_strp_read_copy(strp, false);
 
-	strp->msg_ready = 1;
+	WRITE_ONCE(strp->msg_ready, 1);
 	tls_rx_msg_ready(strp);
 
 	return 0;
@@ -585,7 +585,7 @@ void tls_strp_msg_done(struct tls_strpar
 	else
 		tls_strp_flush_anchor_copy(strp);
 
-	strp->msg_ready = 0;
+	WRITE_ONCE(strp->msg_ready, 0);
 	memset(&strp->stm, 0, sizeof(strp->stm));
 
 	tls_strp_check_rcv(strp);


