Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D9A59;
	Thu, 13 Jun 2024 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282866; cv=none; b=XYCZSYzShB9Fs1A5RELg4K2T7iV4GSmZuFLSCjPysF6VPqjG+qMEUaSZH4q70IF1YKQy7xJzi2K14A665nOg2MHVEmZupmurv7w1aOC8VNbR7I2JEvjcGIdyRsc02P5ei0pB8ZZfPZm0l53dpNuu0kDDZUqFary1nrrZb4/iuL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282866; c=relaxed/simple;
	bh=a9j7l3NDlqSY01P02CdihskdHMriOiO1oMwVMW5bB/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQyrs95A6e37XO+yCFQsgwHloflncKELmQn2uRiHujLMnor1rqr9g3S/59uLYGo0e5NoCSUvsVHbfyiSWNPRm31OkW4QHSNjNp7+8HVF3ky1OKNToe4C/6be8rk6hDmOzxH73mSvxziGCbVkZ4vdoAe3SRIgpia4pz6gllEojsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZn8EmSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZn8EmSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECDBC2BBFC;
	Thu, 13 Jun 2024 12:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282866;
	bh=a9j7l3NDlqSY01P02CdihskdHMriOiO1oMwVMW5bB/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZn8EmStueo8HRbMOAjAvod5gwi/T0z/oUf7dQerHAaC/HeJQqG355lvH4eaGnshd
	 W68DFvaSC/gccyA86NUGIM9Pdq8gU7lrbE+fOlbc+Ury/T35H3CJCBVCCiSscLhcH/
	 REZGGKs5Fwfm+4CNyfv8xkF6f1zKd9HoGGuEYMmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 04/85] maple_tree: fix allocation in mas_sparse_area()
Date: Thu, 13 Jun 2024 13:35:02 +0200
Message-ID: <20240613113214.307653699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit 29ad6bb313487370f9dfe5441fc8982593b6384e upstream.

In the case of reverse allocation, mas->index and mas->last do not point
to the correct allocation range, which will cause users to get incorrect
allocation results, so fix it.  If the user does not use it in a specific
way, this bug will not be triggered.

This is a bug, but only VMA uses it now, the way VMA is used now will
not trigger it.  There is a possibility that a user will trigger it in
the future.

Also re-check whether the size is still satisfied after the lower bound
was increased, which is a corner case and is incorrect in previous
versions.

Link: https://lkml.kernel.org/r/20230419093625.99201-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5277,25 +5277,28 @@ static inline void mas_fill_gap(struct m
  * @size: The size of the gap
  * @fwd: Searching forward or back
  */
-static inline void mas_sparse_area(struct ma_state *mas, unsigned long min,
+static inline int mas_sparse_area(struct ma_state *mas, unsigned long min,
 				unsigned long max, unsigned long size, bool fwd)
 {
-	unsigned long start = 0;
-
-	if (!unlikely(mas_is_none(mas)))
-		start++;
+	if (!unlikely(mas_is_none(mas)) && min == 0) {
+		min++;
+		/*
+		 * At this time, min is increased, we need to recheck whether
+		 * the size is satisfied.
+		 */
+		if (min > max || max - min + 1 < size)
+			return -EBUSY;
+	}
 	/* mas_is_ptr */
 
-	if (start < min)
-		start = min;
-
 	if (fwd) {
-		mas->index = start;
-		mas->last = start + size - 1;
-		return;
+		mas->index = min;
+		mas->last = min + size - 1;
+	} else {
+		mas->last = max;
+		mas->index = max - size + 1;
 	}
-
-	mas->index = max;
+	return 0;
 }
 
 /*
@@ -5324,10 +5327,8 @@ int mas_empty_area(struct ma_state *mas,
 		return -EBUSY;
 
 	/* Empty set */
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_sparse_area(mas, min, max, size, true);
-		return 0;
-	}
+	if (mas_is_none(mas) || mas_is_ptr(mas))
+		return mas_sparse_area(mas, min, max, size, true);
 
 	/* The start of the window can only be within these values */
 	mas->index = min;
@@ -5377,10 +5378,8 @@ int mas_empty_area_rev(struct ma_state *
 	}
 
 	/* Empty set. */
-	if (mas_is_none(mas) || mas_is_ptr(mas)) {
-		mas_sparse_area(mas, min, max, size, false);
-		return 0;
-	}
+	if (mas_is_none(mas) || mas_is_ptr(mas))
+		return mas_sparse_area(mas, min, max, size, false);
 
 	/* The start of the window can only be within these values. */
 	mas->index = min;


