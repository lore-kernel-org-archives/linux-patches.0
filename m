Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5715C241C8C;
	Sat, 30 May 2026 18:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164961; cv=none; b=NKlyT+nm4ieyW9Fn71WJ6M9fwdIiRO9tyh3YNEzlmxuvaTY9Q4v8LEuaKkinHtsfyPSZAUeyNcrfZKzEu4XbswtcCVDRyPfK37cWsqGsTyZmlpV6BSTcmQnC1AlU6IYt0+uO7PWH5dPx9J+DYcgLdtAspAsB2HduR8o0QTkgrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164961; c=relaxed/simple;
	bh=gW9/wlLBlkLiTGYOPkRtdhT1hvhMKj6CaCmUdvJ/hks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxfNhhNCTCheQWWqN6zxjycQqF9zLPd+Dut5J/xqd8XkcI9ZuNXlk1cnjb3suzTORgTl86Tx5n2G9807EHAvdXNu4NgX2zNYpcF/7suy3gES+345POX0EnGEA4fvyxQngUFMbk2VTWGZeGqFjg6qGGfW76Ao174tlZ5v66WLiAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdWAvnZV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdWAvnZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD8C1F00893;
	Sat, 30 May 2026 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164960;
	bh=coQ6h4S/ps+f/XRM8RyKwxYRCezcPgALEDbnzvORtIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdWAvnZV9XALMd531nxfSG3+LrSLzfrxGfGjjoJEvyUyYKHm5TAhX03De7GP8MIhU
	 8dea739wIMgrxRdxPFIjRn3sShZHBg87nMMgvPC5tRw+NFTWjAceH3TzITxP4RPuE9
	 Kp6qRWBHlpdB3i9RG4rzT5JCQf7bPMOQDNngPmoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 709/776] batman-adv: fix fragment reassembly length accounting
Date: Sat, 30 May 2026 18:07:03 +0200
Message-ID: <20260530160258.163167892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruide Cao <caoruide123@gmail.com>

commit 9cd3f16c320bfdadd4509358122368deb56a5741 upstream.

batman-adv keeps a running payload length for queued fragments and uses it
to validate a fragment chain before reassembly.

That accounting currently allows the accumulated fragment length to be
truncated during updates. As a result, malformed fragment chains can
bypass the intended validation and drive reassembly with inconsistent
length state, leading to a local denial of service.

Fix the accounting by storing the accumulated length in a length-typed
field and rejecting update overflows before the existing validation logic
runs.

The fix was verified against the original reproducer and against valid
fragment reassembly paths.

Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |   23 +++++++++++++++++------
 net/batman-adv/types.h         |    2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -17,6 +17,7 @@
 #include <linux/lockdep.h>
 #include <linux/minmax.h>
 #include <linux/netdevice.h>
+#include <linux/overflow.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -81,9 +82,9 @@ void batadv_frag_purge_orig(struct batad
  *
  * Return: the maximum size of payload that can be fragmented.
  */
-static int batadv_frag_size_limit(void)
+static size_t batadv_frag_size_limit(void)
 {
-	int limit = BATADV_FRAG_MAX_FRAG_SIZE;
+	size_t limit = BATADV_FRAG_MAX_FRAG_SIZE;
 
 	limit -= sizeof(struct batadv_frag_packet);
 	limit *= BATADV_FRAG_MAX_FRAGMENTS;
@@ -144,7 +145,9 @@ static bool batadv_frag_insert_packet(st
 	struct batadv_frag_packet *frag_packet;
 	u8 bucket;
 	u16 seqno, hdr_size = sizeof(struct batadv_frag_packet);
+	bool overflow = false;
 	bool ret = false;
+	size_t data_len;
 
 	/* Linearize packet to avoid linearizing 16 packets in a row when doing
 	 * the later merge. Non-linear merge should be added to remove this
@@ -154,6 +157,7 @@ static bool batadv_frag_insert_packet(st
 		goto err;
 
 	frag_packet = (struct batadv_frag_packet *)skb->data;
+	data_len = skb->len - hdr_size;
 	seqno = ntohs(frag_packet->seqno);
 	bucket = seqno % BATADV_FRAG_BUFFER_COUNT;
 
@@ -172,7 +176,7 @@ static bool batadv_frag_insert_packet(st
 	spin_lock_bh(&chain->lock);
 	if (batadv_frag_init_chain(chain, seqno)) {
 		hlist_add_head(&frag_entry_new->list, &chain->fragment_list);
-		chain->size = skb->len - hdr_size;
+		chain->size = data_len;
 		chain->timestamp = jiffies;
 		chain->total_size = ntohs(frag_packet->total_size);
 		ret = true;
@@ -189,7 +193,11 @@ static bool batadv_frag_insert_packet(st
 		if (frag_entry_curr->no < frag_entry_new->no) {
 			hlist_add_before(&frag_entry_new->list,
 					 &frag_entry_curr->list);
-			chain->size += skb->len - hdr_size;
+
+			if (check_add_overflow(chain->size, data_len,
+					       &chain->size))
+				overflow = true;
+
 			chain->timestamp = jiffies;
 			ret = true;
 			goto out;
@@ -202,13 +210,16 @@ static bool batadv_frag_insert_packet(st
 	/* Reached the end of the list, so insert after 'frag_entry_last'. */
 	if (likely(frag_entry_last)) {
 		hlist_add_behind(&frag_entry_new->list, &frag_entry_last->list);
-		chain->size += skb->len - hdr_size;
+
+		if (check_add_overflow(chain->size, data_len, &chain->size))
+			overflow = true;
+
 		chain->timestamp = jiffies;
 		ret = true;
 	}
 
 out:
-	if (chain->size > batadv_frag_size_limit() ||
+	if (overflow || chain->size > batadv_frag_size_limit() ||
 	    chain->total_size != ntohs(frag_packet->total_size) ||
 	    chain->total_size > batadv_frag_size_limit()) {
 		/* Clear chain if total size of either the list or the packet
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -294,7 +294,7 @@ struct batadv_frag_table_entry {
 	u16 seqno;
 
 	/** @size: accumulated size of packets in list */
-	u16 size;
+	size_t size;
 
 	/** @total_size: expected size of the assembled packet */
 	u16 total_size;


