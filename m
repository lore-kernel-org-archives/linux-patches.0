Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696BEE560;
	Tue, 30 Apr 2024 10:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474303; cv=none; b=t3YPvv8rUs6oBWpPe22VG/blkT06DxHlbLnvkTSBisaGeHQ55vL8KjRqfGeCZTxHJUyljWB+0OksDAjOhkDydg66WX3yp8pipYsP0JtrXiDbYurZD2JREWs7bYhRmPbIHqOBa3OO4GPv+N9AOUcOFS3r4K5isd+UYLdyJAGMLTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474303; c=relaxed/simple;
	bh=KnbB/6VHUQrV0a19zvwlhqnFElOInqdz2opf7h/4O5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzkB6Cxyt8vt3BWczKYfML2l85qEoo+wa5GqAiy7b92navijkIlhvRgC6R2TNMq/GLKAA1pcNvpitC+4z2N/kxOwn3TGj11ERVTs/8dR2w7f4PeCxpyZQSGwXS+Y//i9q6XhD70GZbXleM9ZQpdhcnuNrHrmdF/mapERt8zoq0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HudfDgGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HudfDgGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BC6C2BBFC;
	Tue, 30 Apr 2024 10:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474303;
	bh=KnbB/6VHUQrV0a19zvwlhqnFElOInqdz2opf7h/4O5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HudfDgGC0wgGfMlCYYoW5K2FkNtIbrfd0O/bxSn6okoPV67kVwONAv9e1cpETWGZz
	 vPkiRbT9Af/zrypfcJoCepVOMQPdHqljy2tuA2wFVL5DnYi61nYD0dCEy6CMBzUX9t
	 DgNUNgIkqImjqetI7nOyzmA8bTz/qb/PjImmxKPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 117/228] tls: fix lockless read of strp->msg_ready in ->poll
Date: Tue, 30 Apr 2024 12:38:15 +0200
Message-ID: <20240430103107.185384526@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 0844370f8945086eb9335739d10205dcea8d707b ]

tls_sk_poll is called without locking the socket, and needs to read
strp->msg_ready (via tls_strp_msg_ready). Convert msg_ready to a bool
and use READ_ONCE/WRITE_ONCE where needed. The remaining reads are
only performed when the socket is locked.

Fixes: 121dca784fc0 ("tls: suppress wakeups unless we have a full record")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/0b7ee062319037cf86af6b317b3d72f7bfcd2e97.1713797701.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h  | 3 ++-
 net/tls/tls.h      | 2 +-
 net/tls/tls_strp.c | 6 +++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 340ad43971e47..33f657d3c0510 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -111,7 +111,8 @@ struct tls_strparser {
 	u32 stopped : 1;
 	u32 copy_mode : 1;
 	u32 mixed_decrypted : 1;
-	u32 msg_ready : 1;
+
+	bool msg_ready;
 
 	struct strp_msg stm;
 
diff --git a/net/tls/tls.h b/net/tls/tls.h
index 762f424ff2d59..e5e47452308ab 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -215,7 +215,7 @@ static inline struct sk_buff *tls_strp_msg(struct tls_sw_context_rx *ctx)
 
 static inline bool tls_strp_msg_ready(struct tls_sw_context_rx *ctx)
 {
-	return ctx->strp.msg_ready;
+	return READ_ONCE(ctx->strp.msg_ready);
 }
 
 static inline bool tls_strp_msg_mixed_decrypted(struct tls_sw_context_rx *ctx)
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index ca1e0e198ceb4..5df08d848b5c9 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -360,7 +360,7 @@ static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
 	if (strp->stm.full_len && strp->stm.full_len == skb->len) {
 		desc->count = 0;
 
-		strp->msg_ready = 1;
+		WRITE_ONCE(strp->msg_ready, 1);
 		tls_rx_msg_ready(strp);
 	}
 
@@ -528,7 +528,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 	if (!tls_strp_check_queue_ok(strp))
 		return tls_strp_read_copy(strp, false);
 
-	strp->msg_ready = 1;
+	WRITE_ONCE(strp->msg_ready, 1);
 	tls_rx_msg_ready(strp);
 
 	return 0;
@@ -580,7 +580,7 @@ void tls_strp_msg_done(struct tls_strparser *strp)
 	else
 		tls_strp_flush_anchor_copy(strp);
 
-	strp->msg_ready = 0;
+	WRITE_ONCE(strp->msg_ready, 0);
 	memset(&strp->stm, 0, sizeof(strp->stm));
 
 	tls_strp_check_rcv(strp);
-- 
2.43.0



