Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED127C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5DEC433EF;
	Mon, 24 Apr 2023 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342788;
	bh=3JMwIcLEnNpI8C2ZRhAyW4fzqGUjSEX0W9hCEeJbn2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMXnWxBNZv/8/dBpaSTKbW7KropqHfVKYoWvyK+Iv1HLg5CvQyFERJsz5oMtlSh6z
	 8DcsJTH+uuDhAL1/NKJ9/Shk0Km1rnrbAUR2ZgtFCBBTAFl20fiwNPiJELgRrA5CwQ
	 ctav6EhZ6xL6Ye4s8KhHzQMI9mv3fawdqypUkGaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 58/98] maple_tree: make maple state reusable after mas_empty_area_rev()
Date: Mon, 24 Apr 2023 15:17:21 +0200
Message-Id: <20230424131136.115980395@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit fad8e4291da5e3243e086622df63cb952db444d8 upstream.

Stop using maple state min/max for the range by passing through pointers
for those values.  This will allow the maple state to be reused without
resetting.

Also add some logic to fail out early on searching with invalid
arguments.

Link: https://lkml.kernel.org/r/20230414145728.4067069-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4968,7 +4968,8 @@ not_found:
  * Return: True if found in a leaf, false otherwise.
  *
  */
-static bool mas_rev_awalk(struct ma_state *mas, unsigned long size)
+static bool mas_rev_awalk(struct ma_state *mas, unsigned long size,
+		unsigned long *gap_min, unsigned long *gap_max)
 {
 	enum maple_type type = mte_node_type(mas->node);
 	struct maple_node *node = mas_mn(mas);
@@ -5033,8 +5034,8 @@ static bool mas_rev_awalk(struct ma_stat
 
 	if (unlikely(ma_is_leaf(type))) {
 		mas->offset = offset;
-		mas->min = min;
-		mas->max = min + gap - 1;
+		*gap_min = min;
+		*gap_max = min + gap - 1;
 		return true;
 	}
 
@@ -5310,6 +5311,9 @@ int mas_empty_area(struct ma_state *mas,
 	unsigned long *pivots;
 	enum maple_type mt;
 
+	if (min >= max)
+		return -EINVAL;
+
 	if (mas_is_start(mas))
 		mas_start(mas);
 	else if (mas->offset >= 2)
@@ -5364,6 +5368,9 @@ int mas_empty_area_rev(struct ma_state *
 {
 	struct maple_enode *last = mas->node;
 
+	if (min >= max)
+		return -EINVAL;
+
 	if (mas_is_start(mas)) {
 		mas_start(mas);
 		mas->offset = mas_data_end(mas);
@@ -5383,7 +5390,7 @@ int mas_empty_area_rev(struct ma_state *
 	mas->index = min;
 	mas->last = max;
 
-	while (!mas_rev_awalk(mas, size)) {
+	while (!mas_rev_awalk(mas, size, &min, &max)) {
 		if (last == mas->node) {
 			if (!mas_rewind_node(mas))
 				return -EBUSY;
@@ -5398,17 +5405,9 @@ int mas_empty_area_rev(struct ma_state *
 	if (unlikely(mas->offset == MAPLE_NODE_SLOTS))
 		return -EBUSY;
 
-	/*
-	 * mas_rev_awalk() has set mas->min and mas->max to the gap values.  If
-	 * the maximum is outside the window we are searching, then use the last
-	 * location in the search.
-	 * mas->max and mas->min is the range of the gap.
-	 * mas->index and mas->last are currently set to the search range.
-	 */
-
 	/* Trim the upper limit to the max. */
-	if (mas->max <= mas->last)
-		mas->last = mas->max;
+	if (max <= mas->last)
+		mas->last = max;
 
 	mas->index = mas->last - size + 1;
 	return 0;


