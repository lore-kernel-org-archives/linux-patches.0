Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0487E28B4FA;
	Sat, 12 Sep 2026 09:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204270; cv=none; b=KwfxMvistLia73/OzImQprPGZqaOVjzU92XjAdspz/mtJJKxRqfZdl7hdNNGH3Di3bppsT2mWlaysRLgefsrEYViYv1Ne3oYLl6+O9vtZF7WlVw/opr32Seub0zyPHQNYeKf5orpxujMQt3lQkDKvcvQXDNU3QNi3z6MBTW0yG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204270; c=relaxed/simple;
	bh=E3O5tKSuDotERBNtuCDmAIpTtB6+PL7Yr3/qrQETxHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMlRg+uDYqlzkaptmY3BFErOB/tYfhtpUM2odYBuJODddSz6EY3r2N1xfRFpRdPzxFB3NNdRO0Kmxaa9wxyb4xKsUuWH4gnc8V3YzrqQcwfsQYJK5mZqdpmNpvRb7d85ay0Asgi4Pw3Jj5CJrxzeY4W5k/Yf/r8S+R/WHR8Ai2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSwKAgBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSwKAgBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6B71F000FF;
	Sat, 12 Sep 2026 09:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204268;
	bh=vu1nQP68tKBpkjVfXaxu7XYCFZPTxIz9B6eKHBQh5Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vSwKAgBCB8b/SpalnR+xCGmJz+QVUUKDeoPipK2TSlxhoDXqaKTKb8bU+hG6nZx8L
	 Igz038GYKShGQJfea+6Jyv6FmIcl1YClgFQgyb0OYF84PHqZM8t9ty0b0nJckwI83B
	 5NyCcbIYCT6DnS8EbFZ6XF57KqqOe1oMjEEbnqxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1578/1815] tls: fix RX desync on overlapping skbs
Date: Sat, 12 Sep 2026 08:55:28 +0200
Message-ID: <20260912065726.034424300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>

[ Upstream commit 9466ef3ec972bee926731a766f73533dec590065 ]

The TCP receive queue can hold adjacent skbs whose sequence ranges
overlap. The tls fast-path reads the record header with skb_copy_bits()
by byte offset, which assumes skbs do not overlap, so a header split
across the overlap is misread and the connection aborts
(-EMSGSIZE/-EINVAL). tls_strp_check_queue_ok() detects such overlaps but
only ran after the header was parsed, never covering the header itself.

Observed with parallel kTLS connections on:
- ConnectX-7 + IPsec crypto offload + GRO
- VirtIO (8 queues) + GRO

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
Link: https://patch.msgid.link/20260813121337.3300688-1-maxbr@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 61b10c697eccb..6cc222008d95c 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -430,9 +430,10 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 	return 0;
 }
 
-static bool tls_strp_check_queue_ok(struct tls_strparser *strp)
+static bool tls_strp_check_queue_ok(struct tls_strparser *strp,
+				    unsigned int len)
 {
-	unsigned int len = strp->stm.offset + strp->stm.full_len;
+	unsigned int remaining = strp->stm.offset + len;
 	struct sk_buff *first, *skb;
 	u32 seq;
 
@@ -443,9 +444,9 @@ static bool tls_strp_check_queue_ok(struct tls_strparser *strp)
 	/* Make sure there's no duplicate data in the queue,
 	 * and the decrypted status matches.
 	 */
-	while (skb->len < len) {
+	while (skb->len < remaining) {
 		seq += skb->len;
-		len -= skb->len;
+		remaining -= skb->len;
 		skb = skb->next;
 
 		if (TCP_SKB_CB(skb)->seq != seq)
@@ -525,6 +526,11 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 
 	tls_strp_load_anchor_with_queue(strp, inq);
 	if (!strp->stm.full_len) {
+		if (inq < TLS_HEADER_SIZE)
+			return tls_strp_read_copy(strp, true);
+		if (!tls_strp_check_queue_ok(strp, TLS_HEADER_SIZE))
+			return tls_strp_read_copy(strp, false);
+
 		sz = tls_rx_msg_size(strp, strp->anchor);
 		if (sz < 0)
 			return sz;
@@ -535,7 +541,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 			return tls_strp_read_copy(strp, true);
 	}
 
-	if (!tls_strp_check_queue_ok(strp))
+	if (!tls_strp_check_queue_ok(strp, strp->stm.full_len))
 		return tls_strp_read_copy(strp, false);
 
 	WRITE_ONCE(strp->msg_ready, 1);
-- 
2.53.0



