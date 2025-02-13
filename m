Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992B626B08D;
	Thu, 13 Feb 2025 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458368; cv=none; b=kh1hJSuOw7NG6+i7ynqvooy5NDnnK47BDb6ug4vBavXQ+08N+jX+0Kkv9hqRpemYtygvxNCETM9EAE+bSioPCN2bYNAOg7s3u6RW6C8h44Lp4lKNUEc+XG86zCj518cr2Hv1PTckmafaeT2K7ZrWjzRxBor3vWq5brrRBCF92oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458368; c=relaxed/simple;
	bh=US7Neg8LDBtv5hilbpgbR7PEcvxjsjtQ5V474qKhfiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLUw1AMpTWkcwW0f8RmCBz8HoqeA6ZKV+YaMhQaDpC+3QECqP/kqede5SfwF4W+BP9xaMTbiOJNZWUyFCTgGnZXXvNsyNz1FAZDL+fywMRTvsZVlfBJXaZzi+zG5vyLiY4Fnw0XChFGOfIrPgS8D+as/42cm3ov//IMT6/W2ejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcrCbaMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcrCbaMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09029C4CED1;
	Thu, 13 Feb 2025 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458368;
	bh=US7Neg8LDBtv5hilbpgbR7PEcvxjsjtQ5V474qKhfiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcrCbaMiTAVKzglnnOf6ul5ggC7orGpwUvI9g7ti2M5QctqFdTDfPsgSejI2SEf/C
	 08A+chENhnaUZYzSuLKCa8qtTIxcZz9SpLX/2iiKQjdIw2UjRtHUYa8prvVuFkVtJ8
	 sec0ZiHoX56q6ER7PPuoLnIoxPO/+hYTBoaHPKFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 380/422] maple_tree: simplify split calculation
Date: Thu, 13 Feb 2025 15:28:49 +0100
Message-ID: <20250213142451.211675574@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 4f6a6bed0bfef4b966f076f33eb4f5547226056a upstream.

Patch series "simplify split calculation", v3.


This patch (of 3):

The current calculation for splitting nodes tries to enforce a minimum
span on the leaf nodes.  This code is complex and never worked correctly
to begin with, due to the min value being passed as 0 for all leaves.

The calculation should just split the data as equally as possible
between the new nodes.  Note that b_end will be one more than the data,
so the left side is still favoured in the calculation.

The current code may also lead to a deficient node by not leaving enough
data for the right side of the split. This issue is also addressed with
the split calculation change.

[Liam.Howlett@Oracle.com: rephrase the change log]
Link: https://lkml.kernel.org/r/20241113031616.10530-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241113031616.10530-2-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1849,11 +1849,11 @@ static inline int mab_no_null_split(stru
  * Return: The first split location.  The middle split is set in @mid_split.
  */
 static inline int mab_calc_split(struct ma_state *mas,
-	 struct maple_big_node *bn, unsigned char *mid_split, unsigned long min)
+	 struct maple_big_node *bn, unsigned char *mid_split)
 {
 	unsigned char b_end = bn->b_end;
 	int split = b_end / 2; /* Assume equal split. */
-	unsigned char slot_min, slot_count = mt_slots[bn->type];
+	unsigned char slot_count = mt_slots[bn->type];
 
 	/*
 	 * To support gap tracking, all NULL entries are kept together and a node cannot
@@ -1886,18 +1886,7 @@ static inline int mab_calc_split(struct
 		split = b_end / 3;
 		*mid_split = split * 2;
 	} else {
-		slot_min = mt_min_slots[bn->type];
-
 		*mid_split = 0;
-		/*
-		 * Avoid having a range less than the slot count unless it
-		 * causes one node to be deficient.
-		 * NOTE: mt_min_slots is 1 based, b_end and split are zero.
-		 */
-		while ((split < slot_count - 1) &&
-		       ((bn->pivot[split] - min) < slot_count - 1) &&
-		       (b_end - split > slot_min))
-			split++;
 	}
 
 	/* Avoid ending a node on a NULL entry */
@@ -2366,7 +2355,7 @@ static inline struct maple_enode
 static inline unsigned char mas_mab_to_node(struct ma_state *mas,
 	struct maple_big_node *b_node, struct maple_enode **left,
 	struct maple_enode **right, struct maple_enode **middle,
-	unsigned char *mid_split, unsigned long min)
+	unsigned char *mid_split)
 {
 	unsigned char split = 0;
 	unsigned char slot_count = mt_slots[b_node->type];
@@ -2379,7 +2368,7 @@ static inline unsigned char mas_mab_to_n
 	if (b_node->b_end < slot_count) {
 		split = b_node->b_end;
 	} else {
-		split = mab_calc_split(mas, b_node, mid_split, min);
+		split = mab_calc_split(mas, b_node, mid_split);
 		*right = mas_new_ma_node(mas, b_node);
 	}
 
@@ -2866,7 +2855,7 @@ static void mas_spanning_rebalance(struc
 		mast->bn->b_end--;
 		mast->bn->type = mte_node_type(mast->orig_l->node);
 		split = mas_mab_to_node(mas, mast->bn, &left, &right, &middle,
-					&mid_split, mast->orig_l->min);
+					&mid_split);
 		mast_set_split_parents(mast, left, middle, right, split,
 				       mid_split);
 		mast_cp_to_nodes(mast, left, middle, right, split, mid_split);
@@ -3357,7 +3346,7 @@ static void mas_split(struct ma_state *m
 		if (mas_push_data(mas, height, &mast, false))
 			break;
 
-		split = mab_calc_split(mas, b_node, &mid_split, prev_l_mas.min);
+		split = mab_calc_split(mas, b_node, &mid_split);
 		mast_split_data(&mast, mas, split);
 		/*
 		 * Usually correct, mab_mas_cp in the above call overwrites


