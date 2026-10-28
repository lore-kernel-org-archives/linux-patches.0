Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211371;
	b=Ya64QaCm8+uOuiti0C0jZjgDWCR2KJm56VGIVpUSDkAAywTKHA/r6GCyq93fnrHOhAxb
	 TvJTawTxIUCKIr2cSqW+alsRI4BPfZSHkJ7wtxAfmkucW8tGwcrLU33MD3ho8jTZwRv8+
	 TzulNfK0AqNZd8wM9vPeUfH0GXv1YMdoZPziLRbEa9t3HO+g9Q1+IYmlSiIJV9ZRCtLJk
	 7n+ImbU12OdRT7aOExhWY1jUnwD0N8sEWiPghUXfzXdvEE+tsD2hhPSustB9pkhBlzAVb
	 RLU3H3G08Mhexp7ucgyitbIDI5s7RSIZejCo7DDEYZaghqlRyPKoOTvmiEymAgkcFmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DIFaEKzy0nYMsmoNM9m6TDU/8gYYcj3XaHbJ2WGP7OM=;
	b=bk2spx9o0iTVheS3QlUyhfbfgs2p5pPeVBmjMR6Vcnb1zlwH80za6qzp++efdXjj5RV4
	 EIXTGbEzdRIyeAQmbo27fTWaiPcHtmUxcP+RlONhFNYFmm8v2fIaoZa6r4vVPY13UQg2w
	 J1hNqiHjuXuH2LkPq0ym17wSBjowmx68vLIbN5wviiQHWQlB9+JgeQaEIIgyjykgeThdU
	 zaI7zuwXILf81xYRXFCeW4yyB07odjA9LaE1hwqVlbbIPxdQv1ZYqWHd/t93/xva9JVIn
	 GYQ3KpINaENRysDTUUOKk5lqidAUdWFQQ4sMvzoWdfp2tue1gJ75Ie8m4qra7G2Fcyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1eP8Uu8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6299606A327;
	Wed, 28 Oct 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1eP8Uu8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124931F01825;
	Wed, 28 Oct 2026 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211370;
	bh=DIFaEKzy0nYMsmoNM9m6TDU/8gYYcj3XaHbJ2WGP7OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1eP8Uu84syU15Oa7ETSWZCEMZRwSnylfozcGUCcEDSguchsIsXahrwx+AdmB4wb2
	 Vw4jlNBuV6fgQOwUScX3AwNQZA4nFrKD3cAMTBVTzoYs3/DBcFRWSRqHI8xvx/+j/L
	 xJWacjhpjJqi0FVMrIudus4ULXYf8BrPGOmyDqQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 353/571] strparser: make sure __strp_recv isnt running before tearing down the parser
Date: Wed, 28 Oct 2026 17:58:20 +0100
Message-ID: <20261028170016.393936318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -86,11 +86,11 @@ static inline struct strp_msg *strp_msg(
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
 


