Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74D83314B7;
	Sat, 12 Sep 2026 15:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225841; cv=none; b=FlfsSDv/lpmatawfa1UoAiyrT/In71G97YCsq84vFHI9h7lR43+/50R2Sgw5GBNzk0g1jjOL6pquLVRVoaOE02vk1ReOU+M5NNjlhcVpUpygTzDzcCzMyHtOj1RAONGiJPRacDRyaack6i/ZiJHMZJBfg3aXe3pxcLixaBDOfMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225841; c=relaxed/simple;
	bh=cW3frhVBteOzcIcjKqNZ7XHhQ5fRSJRrfXUJCJzYq40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyKCh3zEaYY9c27wD6N3QRLZTe3A+pkpwg5giN5Fvx327EDCTBDZOg7VYewkjyYcmHkZonyQPtYN+9uXfkliZAIgl/aA/Re6oTj20hBQ95lsCuna1zkldAfOk8gmz8xXvHtX2hEbNdiG/DbSWcm6Zs12FStlyPCQzF5qcNheMPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TU6qMo6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TU6qMo6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB761F00893;
	Sat, 12 Sep 2026 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225839;
	bh=gZ8Cp3VTQTukNqXTnRKm7r5zFjfDmqRvuRV5EgrK5UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TU6qMo6K54AjJS612OSTTtF0T+R9APEKdc0/Fslok52+U5g/Aw41OjBou9iiRjvGs
	 ElzYByJYFjhu1aFGBvmAPK7MU/KDP6T0Ka9gzo5ZJljR3WycCMTABeZ9zjR7CdW34F
	 U9ibXCg5VhDbK9UDanzi5T/f73/h9Ue5PUyalndw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1273/1424] tls: fix RX desync on overlapping skbs
Date: Sat, 12 Sep 2026 09:01:45 +0200
Message-ID: <20260912065635.785973009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 7d85feebdfd93..8d35e2912dd3b 100644
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
@@ -524,6 +525,11 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 
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
@@ -534,7 +540,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 			return tls_strp_read_copy(strp, true);
 	}
 
-	if (!tls_strp_check_queue_ok(strp))
+	if (!tls_strp_check_queue_ok(strp, strp->stm.full_len))
 		return tls_strp_read_copy(strp, false);
 
 	WRITE_ONCE(strp->msg_ready, 1);
-- 
2.53.0



