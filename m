Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4B47ACE6;
	Sat, 12 Sep 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218804; cv=none; b=Rq+rqK2KnbKkzLVbAaq4TgackVmOcDQv739GMye1XuGDG94ESJcGT4tsWwe1NFy6GVS4sAsmt7J/DOflDixtbMYClQzHCQkIyCYlAkxldZYDHGlG8QU9rabXNduhVMqj6y2RjYw2OEo2OUwKhdtwa03/tntsScRKe7rmHzRF+pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218804; c=relaxed/simple;
	bh=8sDgJoLjwPt3YWyS5UKDMtOnrCcxy2zFfARDeaCvKT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPn2albWbvrQfzwXw/Wrb738tudGvCEuc6bjTNioQsaO8zSpVL2YJZ7GkCL51uVanfzdKYqfPUtjoitt9mNtrJlxoDG753D8KAdX2z1BXmK1GZeDBqhaeDHzVQcJqrCzU7yyLsH7ZEHcRbaR21acZY9dhZaBZmLnnf0HxHK+yzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRmWuEao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRmWuEao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13731F000FF;
	Sat, 12 Sep 2026 13:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218802;
	bh=OnIX7+258wy2cXECck8aTI59vsMCHkmXbbbiZZ3fcYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRmWuEaoz8LInFzdZq0RUzyciODdNR/ykIBWUmsnBkAXV7K3X3sBog33LRpUwrakA
	 9SX2H0UYhp2m43YOiBarGHqSSPMmplwyrZsTSjGmw/j9L7WVC3rtN+wCpSWhiC77tC
	 2rVeoFvuwD7c0bbru4qZT/ums/bYetbfwBEiGIog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1203/1376] tls: fix RX desync on overlapping skbs
Date: Sat, 12 Sep 2026 09:00:29 +0200
Message-ID: <20260912065634.360484800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c72e883176273..c0611c4327769 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -431,9 +431,10 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
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
 
@@ -444,9 +445,9 @@ static bool tls_strp_check_queue_ok(struct tls_strparser *strp)
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



