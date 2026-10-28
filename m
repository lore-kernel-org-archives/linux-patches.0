Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209014;
	b=gbnS0WjSBLoQT9+SUHFUvG732ZTbE5eJ1OOUe9a+6XytGTHqSc2EuCEDKuNbVIIhoUQ0
	 gKKefDsY/E917cGITcn910SUUDPdWHA71kDZMHLTGHuMBOGWaZlMhc8zqTbNkb7NQBfPs
	 Gc+cbl3HyNervoYMeXwJIcPhKN+zlSWBwQ8DXBJVf4ZJoORZTgHIh02u7EB3kEvu5XLxL
	 emZrfOCBdCjLm/6q0bFPCMbAOrlOwwduaU/lEXvUC+6lNdDp/YF3NNiFKozpelM3tvwTH
	 FrGnamaTxOJXmtfvbLCZI/BrSAIjZJTxCa92yMG6wvMw/qyd9BKDsDmJx3NH5NhXYow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sc3Mz+8t7vwWXRux/QEXzIZ8UiI2Pimzhy3EMAa57aU=;
	b=iY/qf2WNyBGklAp+xuLBgxeu1L7/ZzJce9TAew//dwTl9lX90b01DGViGpx8FmCxTwvT
	 Q3sresFRtgAe1xYtUZn9hMcXgrw9yB0gcAR9pnPpXQ8qy7JB1bk/+HKyT7ge7Ae5NbJij
	 WOuCEm+CDEZENXsO4L7FIr6acAxy9B1YaTC4ZuCTOWTp0U2S/4iMdKG0l/L2wFsHmTRF7
	 vuO9sn3bzzNb5l4LL68qrfS66jMpb0jx4yiLvPYDYIP+VHJwtEQJU912qSv0qTyer1USA
	 jnKkQJO7cqoGmXww2mQqDXg/6BEpH0P7LeSh154V3WD5JFgNUUy1O4NsnTHZeNzwlTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xi+QGirg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB28F606A31A;
	Wed, 28 Oct 2026 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xi+QGirg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391681F01825;
	Wed, 28 Oct 2026 17:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209013;
	bh=sc3Mz+8t7vwWXRux/QEXzIZ8UiI2Pimzhy3EMAa57aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xi+QGirgOFerwR+fbj5Rdk0engVMdw1zOgTAjPdS2Ma53j/pmdkl7XU8TfjpWaL7r
	 /KmBzCvZ6NnYBswah3eyKVe+pewrUCs94XJDiLzmyk+VjRjAAGBAxSqLPvqVJs60l4
	 /GH/8RV/zWT1Ie6Q2D88nyZ1lt17+l9feSFcSmXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 320/516] strparser: make sure __strp_recv isnt running before tearing down the parser
Date: Wed, 28 Oct 2026 17:57:52 +0100
Message-ID: <20261028170011.070219313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit 0984ebc631792acf8fff105112ee74a6b8f1efcc upstream.

The comment above strp_done() claims that if strp is stopped,
strp_recv will no longer be called. That's only true if the caller has
a mechanism (eg locking) to guarantee that strp_recv() calls that
started before strp_stop() have completed by the time we call
strp_done().

This adds a dummy lock_sock/release_sock pair to guarantee that any
in-flight strp_recv() (which runs under either bh_lock_sock or
lock_sock, depending if it's called from ->sk_data_ready or strp_work)
has completed.

Only espintcp can be affected by this race condition, but this patch
makes sure no future user of strp can have the bug.

This could crash on strp->sk ("general mode" of strp), but this mode
has been here for 9 years and has never been used. It'll be gone soon,
no point worrying about it.

Switch the stopped/paused/etc bits to u8's to avoid races between
strp_stop() and strp_pause/unpause().

A reproducer has been published and turns the possible UAF into an
exploit [1].

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/all/aZLn2Faeg1FB7XOf@v4bel/
Link: https://lore.kernel.org/all/aZgpkyTDU3aXe_V0@v4bel/
Link: https://github.com/m0x41nos/RustyTux [1]
Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@vger.kernel.org
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://patch.msgid.link/425d9d926709b542ed5331110c19fee4aee1f28d.1791206940.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/strparser.rst |    2 +-
 include/net/strparser.h                |   10 +++++-----
 net/strparser/strparser.c              |    6 +++++-
 3 files changed, 11 insertions(+), 7 deletions(-)

--- a/Documentation/networking/strparser.rst
+++ b/Documentation/networking/strparser.rst
@@ -77,7 +77,7 @@ Functions
 
      strp_done is called to release any resources held by the stream
      parser instance. This must be called after the stream processor
-     has been stopped.
+     has been stopped. The socket lock must not be held.
 
      ::
 
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -78,11 +78,11 @@ static inline struct strp_msg *strp_msg(
 struct strparser {
 	struct sock *sk;
 
-	u32 stopped : 1;
-	u32 paused : 1;
-	u32 aborted : 1;
-	u32 interrupted : 1;
-	u32 unrecov_intr : 1;
+	u8 stopped;
+	u8 paused;
+	u8 aborted;
+	u8 interrupted;
+	u8 unrecov_intr;
 
 	struct sk_buff **skb_nextp;
 	struct sk_buff *skb_head;
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -511,12 +511,16 @@ void strp_unpause(struct strparser *strp
 EXPORT_SYMBOL_GPL(strp_unpause);
 
 /* strp must already be stopped so that strp_recv will no longer be called.
- * Note that strp_done is not called with the lower socket held.
+ * Note that strp_done must not be called with the lower socket held.
  */
 void strp_done(struct strparser *strp)
 {
 	WARN_ON(!strp->stopped);
 
+	lock_sock(strp->sk);
+	/* sync with pending strp_recv */
+	release_sock(strp->sk);
+
 	cancel_delayed_work_sync(&strp->msg_timer_work);
 	cancel_work_sync(&strp->work);
 


