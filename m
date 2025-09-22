Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ED02F0C5C;
	Mon, 22 Sep 2025 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570191; cv=none; b=hBrvovZi+8X5hngjEle8gGcA7NswKqR0Y0rYAdFlfKKaGp3qYXJb09ZFifsPkTHsOm1F8JmCGpp+0AmtZ5yLiWseWodqKNHhZGV0ihG2cfybfehfoMSCFGzdFuUsXntLf5oLOsYNhxrrqp4WmNlmVZHQkmjTT5qsQUx2R1d3ty0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570191; c=relaxed/simple;
	bh=v3QGbj+Oy1UvXPVZQUgtm3kHQI5wh+VP/46pnhDOx+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9vnCMt7dHL5JuQZsQnKUC3kEpkHJlQtNHNRP/RBSZDjIsukuVJTA1+bUXC4PTrERLnaEJ0+eub/XI566ewj2NHMztKbqYWXo9l0XmIDa70hlT64r+FMqRacesNZVo23v58RGH8ZTmbkQC6xTbngmQRGB2hoZ8FEsqzn1OdoaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUE7WOvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUE7WOvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB39C4CEF0;
	Mon, 22 Sep 2025 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570191;
	bh=v3QGbj+Oy1UvXPVZQUgtm3kHQI5wh+VP/46pnhDOx+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUE7WOvtURNHSbt0WOsuI+UnKSoHQoxG/Epy81pRarllrB5agGDoei1xRVfpekzf1
	 lexR9UeetNSssfz24EYuNepniqiiawUOe4P6IX/lc7bjGIiOFLgLGa7MRNTmGy4rJH
	 MVSLu96LXCoPjFARYHe7H+jC4OmzqhPJT5d14A30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 041/149] tls: make sure to abort the stream if headers are bogus
Date: Mon, 22 Sep 2025 21:29:01 +0200
Message-ID: <20250922192413.899364897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 4e077068e6d98..e4c42731ce39a 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -141,6 +141,7 @@ void update_sk_prot(struct sock *sk, struct tls_context *ctx);
 
 int wait_on_pending_writer(struct sock *sk, long *timeo);
 void tls_err_abort(struct sock *sk, int err);
+void tls_strp_abort_strp(struct tls_strparser *strp, int err);
 
 int init_prot_info(struct tls_prot_info *prot,
 		   const struct tls_crypto_info *crypto_info,
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index d71643b494a1a..98e12f0ff57e5 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -13,7 +13,7 @@
 
 static struct workqueue_struct *tls_strp_wq;
 
-static void tls_strp_abort_strp(struct tls_strparser *strp, int err)
+void tls_strp_abort_strp(struct tls_strparser *strp, int err)
 {
 	if (strp->stopped)
 		return;
@@ -211,11 +211,17 @@ static int tls_strp_copyin_frag(struct tls_strparser *strp, struct sk_buff *skb,
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
@@ -520,10 +526,8 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
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
index bac65d0d4e3e1..daac9fd4be7eb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2474,8 +2474,7 @@ int tls_rx_msg_size(struct tls_strparser *strp, struct sk_buff *skb)
 	return data_len + TLS_HEADER_SIZE;
 
 read_failure:
-	tls_err_abort(strp->sk, ret);
-
+	tls_strp_abort_strp(strp, ret);
 	return ret;
 }
 
-- 
2.51.0



