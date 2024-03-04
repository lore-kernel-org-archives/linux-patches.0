Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD761F92C;
	Mon,  4 Mar 2024 21:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588447; cv=none; b=TB8R5juIJiPbuGR8QWIvnG/hsV1p8T5YarBVom7Z0bsUnCDeY3qRebRA5uK/8MEOJDrR2kDb15+oimOkM6Xxgd42RdwtjKP3SpR61MnPL9lht0K20pgKRJf8ffu4l8mEfNq6O2TA65246cTnLgIRfVL/e0j6LhLsgvFlokEflBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588447; c=relaxed/simple;
	bh=Ex5JVjpSPnYqGGOD9KyWueq0bH50AR8a3ENVpkN9zso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtpNhriF+1dItmnf+ZAdjqMZizOW3nG7M8q0zuQ72Yyda3BoMwl4pSap86dLsud47GvxeHYZiAGoy/JYvrJJzLgZ21XqhK7oo/+mf1XOe+PyT8rmQIbzCW9XNFwrkTklpwcbxJ72CX/qIKZYTJ98xBPpruYgRa93qAKiipNro0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMjRw0ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMjRw0ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EB1C433F1;
	Mon,  4 Mar 2024 21:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588447;
	bh=Ex5JVjpSPnYqGGOD9KyWueq0bH50AR8a3ENVpkN9zso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMjRw0ca14+C109+WWljVNdF9aaRrnArK1KWn+by0JjauBd1MEjI4HJJV8bii5j5M
	 ecHTUjFlBTHfeA4ua/463qc4ujzwb8ycHJ5PgOE9jtA7mZDZhrXVdeGA39h3eKaadr
	 4s6UUoZVWQF0RrQJF7s/epCh04XdARy+FjzjpqMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 111/143] mptcp: fix potential wake-up event loss
Date: Mon,  4 Mar 2024 21:23:51 +0000
Message-ID: <20240304211553.472250724@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit b111d8fbd2cbc63e05f3adfbbe0d4df655dfcc5b upstream.

After the blamed commit below, the send buffer auto-tuning can
happen after that the mptcp_propagate_sndbuf() completes - via
the delegated action infrastructure.

We must check for write space even after such change or we risk
missing the wake-up event.

Fixes: 8005184fd1ca ("mptcp: refactor sndbuf auto-tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-6-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -772,6 +772,16 @@ static inline bool mptcp_data_fin_enable
 	       READ_ONCE(msk->write_seq) == READ_ONCE(msk->snd_nxt);
 }
 
+static inline void mptcp_write_space(struct sock *sk)
+{
+	if (sk_stream_is_writeable(sk)) {
+		/* pairs with memory barrier in mptcp_poll */
+		smp_mb();
+		if (test_and_clear_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags))
+			sk_stream_write_space(sk);
+	}
+}
+
 static inline void __mptcp_sync_sndbuf(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -790,6 +800,7 @@ static inline void __mptcp_sync_sndbuf(s
 
 	/* the msk max wmem limit is <nr_subflows> * tcp wmem[2] */
 	WRITE_ONCE(sk->sk_sndbuf, new_sndbuf);
+	mptcp_write_space(sk);
 }
 
 /* The called held both the msk socket and the subflow socket locks,
@@ -820,16 +831,6 @@ static inline void mptcp_propagate_sndbu
 	local_bh_enable();
 }
 
-static inline void mptcp_write_space(struct sock *sk)
-{
-	if (sk_stream_is_writeable(sk)) {
-		/* pairs with memory barrier in mptcp_poll */
-		smp_mb();
-		if (test_and_clear_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags))
-			sk_stream_write_space(sk);
-	}
-}
-
 void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags);
 
 #define MPTCP_TOKEN_MAX_RETRIES	4


