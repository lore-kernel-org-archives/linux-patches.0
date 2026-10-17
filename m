Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C1A3AF66D;
	Sat, 17 Oct 2026 17:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257206; cv=none; b=ZC0XpY5Yyn+bHonOf5KQOFS65NGBT98E2wTMLP8CXm+2R3o5TSBx2aLwFV9/LZyhDKj8PneiCPZ/OSfKpJTJp592EaVN6pAAGk08p9GjecSNBbztFFgC0FG2RDlH8PNSi/lPAn6+ulqC4J7+SBgHkcdabjleP2oWrcphSf3NsuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257206; c=relaxed/simple;
	bh=0boz6A6VsTnzzfjMwYCx+ILtR488IJ/ktDAwfhCECzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liSB5w0O1zCM6rDUYcfp8DDlhk5CfSaD7oecudyse+GUrN4IlybO+i+zn9nu0jH3pkMbhK0Q1RXT66boLYNPeCdPPps53Domgs+PzsStZsUYpH3CEeRRmbLMB5kRk0eBbnFvu6J8edbt8Cv/EEYgIyE3fceJHVFrxFl/pm+jACE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCFrcuAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCFrcuAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876491F000C4;
	Sat, 17 Oct 2026 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257205;
	bh=vuJtz/lfhB+9NwUrlmvG/d6OXqdf1l0JIQxbLjjg1T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCFrcuAY9l9R+/NHq35l7KG+zLgO/A/OJz3/M3sW5vv2jlVD43PqP9isTan9l3XbF
	 87heTZc0Xtl6/IGqBTk/QrhoGRSJWwoThCDD12jpIRwt4VoPnFIW1hf8oqQtmiRlBS
	 9hLtpeB4pAasMAcgLImPw/1QdRZw6WqcXjKFI+y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0478/1674] strparser: make sure __strp_recv isnt running before tearing down the parser
Date: Sat, 17 Oct 2026 17:45:50 +0200
Message-ID: <20261017160443.383045865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -91,11 +91,11 @@ static inline struct strp_msg *strp_msg(
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
@@ -518,12 +518,16 @@ void strp_unpause(struct strparser *strp
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
 


