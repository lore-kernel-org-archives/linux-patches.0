Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D49FC00
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1ED8C433EF;
	Mon, 15 May 2023 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171919;
	bh=Gf5vcxUqVMXCCfZA7pUAKHw/feiI8+HhUqgKVzG2U3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIm2ppVG2uwRs/YWkEF41z3BGpHhsthcT+grQpSQdhCeHUrKmo1Gy8mP/C4Zuy89M
	 2S7+odJYfGsY3Uwm5RgutBXr2lWaVNlk/pyFqtCCcr4vAIlJAy60GinGQcNlyszO45
	 a5hnLIQfQTRHqYkYkQ50qh0/PtD73KLgDaWe7nco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+4a03518df1e31b537066@syzkaller.appspotmail.com,
	Dmitry Vyukov <dvyukov@google.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 121/134] ext4: fix data races when using cached status extents
Date: Mon, 15 May 2023 18:29:58 +0200
Message-Id: <20230515161707.174490618@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit 492888df0c7b42fc0843631168b0021bc4caee84 upstream.

When using cached extent stored in extent status tree in tree->cache_es
another process holding ei->i_es_lock for reading can be racing with us
setting new value of tree->cache_es. If the compiler would decide to
refetch tree->cache_es at an unfortunate moment, it could result in a
bogus in_range() check. Fix the possible race by using READ_ONCE() when
using tree->cache_es only under ei->i_es_lock for reading.

Cc: stable@kernel.org
Reported-by: syzbot+4a03518df1e31b537066@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000d3b33905fa0fd4a6@google.com
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230504125524.10802-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents_status.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -269,14 +269,12 @@ static void __es_find_extent_range(struc
 
 	/* see if the extent has been cached */
 	es->es_lblk = es->es_len = es->es_pblk = 0;
-	if (tree->cache_es) {
-		es1 = tree->cache_es;
-		if (in_range(lblk, es1->es_lblk, es1->es_len)) {
-			es_debug("%u cached by [%u/%u) %llu %x\n",
-				 lblk, es1->es_lblk, es1->es_len,
-				 ext4_es_pblock(es1), ext4_es_status(es1));
-			goto out;
-		}
+	es1 = READ_ONCE(tree->cache_es);
+	if (es1 && in_range(lblk, es1->es_lblk, es1->es_len)) {
+		es_debug("%u cached by [%u/%u) %llu %x\n",
+			 lblk, es1->es_lblk, es1->es_len,
+			 ext4_es_pblock(es1), ext4_es_status(es1));
+		goto out;
 	}
 
 	es1 = __es_tree_search(&tree->root, lblk);
@@ -295,7 +293,7 @@ out:
 	}
 
 	if (es1 && matching_fn(es1)) {
-		tree->cache_es = es1;
+		WRITE_ONCE(tree->cache_es, es1);
 		es->es_lblk = es1->es_lblk;
 		es->es_len = es1->es_len;
 		es->es_pblk = es1->es_pblk;
@@ -934,14 +932,12 @@ int ext4_es_lookup_extent(struct inode *
 
 	/* find extent in cache firstly */
 	es->es_lblk = es->es_len = es->es_pblk = 0;
-	if (tree->cache_es) {
-		es1 = tree->cache_es;
-		if (in_range(lblk, es1->es_lblk, es1->es_len)) {
-			es_debug("%u cached by [%u/%u)\n",
-				 lblk, es1->es_lblk, es1->es_len);
-			found = 1;
-			goto out;
-		}
+	es1 = READ_ONCE(tree->cache_es);
+	if (es1 && in_range(lblk, es1->es_lblk, es1->es_len)) {
+		es_debug("%u cached by [%u/%u)\n",
+			 lblk, es1->es_lblk, es1->es_len);
+		found = 1;
+		goto out;
 	}
 
 	node = tree->root.rb_node;


