Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8806A191F66;
	Mon, 22 Sep 2025 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569698; cv=none; b=us2GxAdVnp9a0bCKy8gVboWxqlcLB5aewcLLB/IGhIKYbZK0zrdw67wY9Vz2ejeW4TtwGkWCw9+OH+tt8pECr5rk8GV25lamK1rO6tDk3aiJpQz4pNJ0D7V5Tj5Ii/Mc30wbjznJclow6XRiD2POHpGlrBiZpttdUXbWd+jB3vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569698; c=relaxed/simple;
	bh=pEQDqdwO4WNZlJngPMU+omxjQeehNixo3uo+qwjujBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+GYKALI7AbYdUhseBSOKRmWjE1IuYd4wU7Le8G0TDN6LrIBIYCzZ2BEJ6UvcwHI5RIpDevZw4fsm0VaT7X7QrVKBZFkygiQ4qNwBbTbjMJA4IdhTWR37hYKimQ3Ud64A6e1iwWF2yIKWwH+PJBf5ZHZCsS61/OEgEdrMp8Gmi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr5j6eWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr5j6eWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2152AC4CEF0;
	Mon, 22 Sep 2025 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569698;
	bh=pEQDqdwO4WNZlJngPMU+omxjQeehNixo3uo+qwjujBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr5j6eWJetDuMOV3PUsWfhPaLEBy504HPUxXKSG2NnETn0l3j68gvrRv6XtoZNCKf
	 u1ZwH+CpUN8+HvptN91CmDbugldWHk9POBh5re/AlLrK1rEa0SUtSbsXZl97zf1mG/
	 QWVLdzt/eSN2U0P0Yw17Ut3J5bUW0cFBZEYAZuvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/70] tls: make sure to abort the stream if headers are bogus
Date: Mon, 22 Sep 2025 21:29:21 +0200
Message-ID: <20250922192405.127501935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0aeb54ac4cd5cf8f60131b4d9ec0b6dc9c27b20d ]

Normally we wait for the socket to buffer up the whole record
before we service it. If the socket has a tiny buffer, however,
we read out the data sooner, to prevent connection stalls.
Make sure that we abort the connection when we find out late
that the record is actually invalid. Retrying the parsing is
fine in itself but since we copy some more data each time
before we parse we can overflow the allocated skb space.

Constructing a scenario in which we're under pressure without
enough data in the socket to parse the length upfront is quite
hard. syzbot figured out a way to do this by serving us the header
in small OOB sends, and then filling in the recvbuf with a large
normal send.

Make sure that tls_rx_msg_size() aborts strp, if we reach
an invalid record there's really no way to recover.

Reported-by: Lee Jones <lee@kernel.org>
Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250917002814.1743558-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls.h      |  1 +
 net/tls/tls_strp.c | 14 +++++++++-----
 net/tls/tls_sw.c   |  3 +--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 5dc61c85c076e..a3c5c5a59fda6 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -141,6 +141,7 @@ void update_sk_prot(struct sock *sk, struct tls_context *ctx);
 
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 void tls_err_abort(struct sock *sk, int err);
+void tls_strp_abort_strp(struct tls_strparser *strp, int err);
 
 int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx);
 void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 6ce64a6e4495e..ae723cd6af397 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -12,7 +12,7 @@
 
 static struct workqueue_struct *tls_strp_wq;
 
-static void tls_strp_abort_strp(struct tls_strparser *strp, int err)
+void tls_strp_abort_strp(struct tls_strparser *strp, int err)
 {
 	if (strp->stopped)
 		return;
@@ -210,11 +210,17 @@ static int tls_strp_copyin_frag(struct tls_strparser *strp, struct sk_buff *skb,
 				struct sk_buff *in_skb, unsigned int offset,
 				size_t in_len)
 {
+	unsigned int nfrag = skb->len / PAGE_SIZE;
 	size_t len, chunk;
 	skb_frag_t *frag;
 	int sz;
 
-	frag = &skb_shinfo(skb)->frags[skb->len / PAGE_SIZE];
+	if (unlikely(nfrag >= skb_shinfo(skb)->nr_frags)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
+		return -EMSGSIZE;
+	}
+
+	frag = &skb_shinfo(skb)->frags[nfrag];
 
 	len = in_len;
 	/* First make sure we got the header */
@@ -519,10 +525,8 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 	tls_strp_load_anchor_with_queue(strp, inq);
 	if (!strp->stm.full_len) {
 		sz = tls_rx_msg_size(strp, strp->anchor);
-		if (sz < 0) {
-			tls_strp_abort_strp(strp, sz);
+		if (sz < 0)
 			return sz;
-		}
 
 		strp->stm.full_len = sz;
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 27ce1feb79e14..435235a351e2f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2441,8 +2441,7 @@ int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb)
 	return data_len + TLS_HEADER_SIZE;
 
 read_failure:
-	tls_err_abort(strp->sk, ret);
-
+	tls_strp_abort_strp(strp, ret);
 	return ret;
 }
 
-- 
2.51.0



