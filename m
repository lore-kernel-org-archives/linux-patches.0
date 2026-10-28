Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210298;
	b=PFTRuKC95ecR1Ll5CUzktCNs/E3rZ4hsFRzC40jX2i0F+mNSHDAsOdUSDaJD+Knd61TS
	 ZSyDJ4/3oLLtuM6Zq7fMhfdXqzDGqfSQxChef1/lE6MqeAf5+DtcOwBnMDSQ8WOW5VAt7
	 YSi1rG5uDyuYR9FqGGq6w6IyQ7tQIiV56bznVloAGnpK1XAoyyvznZh8ztUomHd/DRR0U
	 F8Mt/nZveNPE9VKycT4typd5iN0tX6jA6ezctuJaD+AWDI5hFydmqqAJyyUD9l3SwjeyP
	 VbPtTwZRrQo6iOn3Rlcgs7pIwsfPahWgBKC0ihxUJgPcgWAYQgru4VwLwmJFi6lwmig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QLClMWVvQYVkO5Wp4smiMJA5YtUG4VUXjbl4m8IQUGU=;
	b=Ogu/m2BSEkkF8qGwWzu+pZCNUuS8SsMCPYT4NPL0STWHwY3P4PHrtDNpJEQ1selS1r0U
	 fDavdgLg63alt8NNLC2Gf8zcYX3I4yf+BMmx8vKaLo+xnzqqYyMnyEPIvBmehJZLBxqAk
	 5zTj91uKY9HpDVKumlMGr17RRGOyFxHkgIinL+bT7W/MZs01SY+Jzv9o8C7UaWbFsgpip
	 NScYpnQU7LQV6Jxk/cDTxfKjO/omPxelhAEzM4y2tDCdfu3q+Y6fitTKcrlaQuw1nsBd/
	 fjgBz8kspDijaroISQYygP9sbxiHw4s5FsL+8rYQ9yjbchiMAgQ12tFWRnZT+o2wBnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSw18nc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F257606A31C;
	Wed, 28 Oct 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSw18nc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3C31F01825;
	Wed, 28 Oct 2026 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210298;
	bh=QLClMWVvQYVkO5Wp4smiMJA5YtUG4VUXjbl4m8IQUGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSw18nc3YS9TqUPP38KCQ+TQt4ngM9xt8FToAKhiMmGUOzFiH2kK7raWPEPlGpkdB
	 a9RtEGR6dinyskRYO5wmmclmCejyy+Oiis2ONu9T0g6Bfrki5juIUJuEZ1BUnqCJWS
	 oi4Gvoeo7/xGeKSAi+LoDIGDk1lsVVE/NVFd44Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 144/168] io_uring/sqpoll: let the thread sleep on disabled rings
Date: Wed, 28 Oct 2026 18:01:20 +0100
Message-ID: <20261028165946.493397665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit d492dcbb3b81c1c2d0aabef41fa1307093f3a556 upstream.

__io_sq_thread() doesn't submit anything as long as the ring has
IORING_SETUP_R_DISABLED set. The check that keeps the SQPOLL thread from
going to sleep while the SQ ring holds entries doesn't know about that.
If an application fills in SQEs first and enables the ring later, the
thread finds that there is work each time it is about to sleep, goes
around, doesn't submit it, and so on. It uses up a CPU until the ring
gets enabled.

Entries in the SQ ring of a disabled ring are no reason to stay awake.
io_register_enable_rings() clears the flag and then wakes the thread, and
the flag is looked at after prepare_to_wait(), so the thread can't miss
that.

Fixes: 0298ef969a11 ("io_uring: clean R_DISABLED startup mess")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-37-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -300,6 +300,13 @@ static int io_sq_thread(void *data)
 				 */
 				smp_mb__after_atomic();
 
+				/*
+				 * Nothing gets submitted before the ring is
+				 * enabled, which comes with a wake up.
+				 */
+				if (READ_ONCE(ctx->flags) & IORING_SETUP_R_DISABLED)
+					continue;
+
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;


