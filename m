Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3329A344DAC;
	Thu, 28 May 2026 19:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998370; cv=none; b=XmWfO444D4xU903RTbAmILCZWlW0pHb2j20uULFCA+pCaJEnAviU0gIaQdTO9b1pSgkKW9ed40e2FWOYotCZR/gRjFFyvnBsBtk3YHOsUUm9eaKkIetTTdgkazkHgl54N3VYOtj/DI3azoshTb5JT3ivTmyihKkC9JhQoogRqlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998370; c=relaxed/simple;
	bh=fA1oWo4v6YJ+dhDsQU57m3cO1SwfTrY9WvNaRHlK8nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emXoVBTJzjlXlsA9inoXfgbfZUEHC5wzSCs1K1rQSsSZcUQIRcKiSEgGoQDmqb6POtQEyWuSoPSuIxJC9EtqgT+0bdWf9ur73wLaHoPLGcYiLqD7fhEnMKAVXTtT6ZbqKCH5mpaJnWDkdR7XBduWHFJczM49XmNgfkKflAwen6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOLw1SJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOLw1SJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D831F000E9;
	Thu, 28 May 2026 19:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998369;
	bh=Kj5xZzw3GD50+QLeZinzw2icSl3MFGH9JM9qOlbsjZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOLw1SJU7xk0SXmuKHtaWoeWl4qE96DL7iDwMXdeU1r5Y1BhBEkQNo7+bZQQ3ZMq2
	 HE8PL5vkhqReS/P6K+dD7KH4I4zw+UG0bRc09R4mM7sebPRAJpYCoNPsa/ymDMSkKh
	 KI9hL216XoVhIdhO7ykqqK9WpgS/O/B51AvTI1+Y=
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
Subject: [PATCH 7.0 148/461] batman-adv: fix fragment reassembly length accounting
Date: Thu, 28 May 2026 21:44:37 +0200
Message-ID: <20260528194651.309563294@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -80,9 +81,9 @@ void batadv_frag_purge_orig(struct batad
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
@@ -143,7 +144,9 @@ static bool batadv_frag_insert_packet(st
 	struct batadv_frag_packet *frag_packet;
 	u8 bucket;
 	u16 seqno, hdr_size = sizeof(struct batadv_frag_packet);
+	bool overflow = false;
 	bool ret = false;
+	size_t data_len;
 
 	/* Linearize packet to avoid linearizing 16 packets in a row when doing
 	 * the later merge. Non-linear merge should be added to remove this
@@ -153,6 +156,7 @@ static bool batadv_frag_insert_packet(st
 		goto err;
 
 	frag_packet = (struct batadv_frag_packet *)skb->data;
+	data_len = skb->len - hdr_size;
 	seqno = ntohs(frag_packet->seqno);
 	bucket = seqno % BATADV_FRAG_BUFFER_COUNT;
 
@@ -171,7 +175,7 @@ static bool batadv_frag_insert_packet(st
 	spin_lock_bh(&chain->lock);
 	if (batadv_frag_init_chain(chain, seqno)) {
 		hlist_add_head(&frag_entry_new->list, &chain->fragment_list);
-		chain->size = skb->len - hdr_size;
+		chain->size = data_len;
 		chain->timestamp = jiffies;
 		chain->total_size = ntohs(frag_packet->total_size);
 		ret = true;
@@ -188,7 +192,11 @@ static bool batadv_frag_insert_packet(st
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
@@ -201,13 +209,16 @@ static bool batadv_frag_insert_packet(st
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
@@ -304,7 +304,7 @@ struct batadv_frag_table_entry {
 	u16 seqno;
 
 	/** @size: accumulated size of packets in list */
-	u16 size;
+	size_t size;
 
 	/** @total_size: expected size of the assembled packet */
 	u16 total_size;


