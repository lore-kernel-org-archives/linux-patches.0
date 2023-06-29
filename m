Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7FE134C6
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CB1C433C0;
	Thu, 29 Jun 2023 18:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064534;
	bh=4NvKQeRYA1WfxzHUitway+95HOYw1Z7kO+UNKSXrfjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u28eKUFepvzgzGlnOEKMec5+aSA1vsm649nN6evvBvQy503hqLyhHw3yYEU4E7H+O
	 frdqcdWGSnWCHllsnhJVcTo5PFhb9DD1vdGycyxAmfukIB2gpPpI+SjjwB90cEPeD9
	 XmC9COhJIvqFGIL9F7S77m2A6zzAycxQ3+w98CFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 09/28] maple_tree: fix potential out-of-bounds access in mas_wr_end_piv()
Date: Thu, 29 Jun 2023 20:43:57 +0200
Message-ID: <20230629184152.256585483@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.888604958@linuxfoundation.org>
References: <20230629184151.888604958@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit cd00dd2585c4158e81fdfac0bbcc0446afbad26d upstream.

Check the write offset end bounds before using it as the offset into the
pivot array.  This avoids a possible out-of-bounds access on the pivot
array if the write extends to the last slot in the node, in which case the
node maximum should be used as the end pivot.

akpm: this doesn't affect any current callers, but new users of mapletree
may encounter this problem if backported into earlier kernels, so let's
fix it in -stable kernels in case of this.

Link: https://lkml.kernel.org/r/20230506024752.2550-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4263,11 +4263,13 @@ done:
 
 static inline void mas_wr_end_piv(struct ma_wr_state *wr_mas)
 {
-	while ((wr_mas->mas->last > wr_mas->end_piv) &&
-	       (wr_mas->offset_end < wr_mas->node_end))
-		wr_mas->end_piv = wr_mas->pivots[++wr_mas->offset_end];
+	while ((wr_mas->offset_end < wr_mas->node_end) &&
+	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
+		wr_mas->offset_end++;
 
-	if (wr_mas->mas->last > wr_mas->end_piv)
+	if (wr_mas->offset_end < wr_mas->node_end)
+		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
+	else
 		wr_mas->end_piv = wr_mas->mas->max;
 }
 
@@ -4424,7 +4426,6 @@ static inline void *mas_wr_store_entry(s
 	}
 
 	/* At this point, we are at the leaf node that needs to be altered. */
-	wr_mas->end_piv = wr_mas->r_max;
 	mas_wr_end_piv(wr_mas);
 
 	if (!wr_mas->entry)


