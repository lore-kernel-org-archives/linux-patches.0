Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A3433CCA;
	Fri, 24 Nov 2023 18:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZINLJiSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBBC433C7;
	Fri, 24 Nov 2023 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851598;
	bh=oDgtQWijoQJedI2dGKqS1wvXJPHXq2AtBBU0yjXitKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZINLJiSvBbE4fi0TUIC1GVvrl6A3ffzPVdE45oDGIKw+P46iYJmZDBQNQbb2t/Hqw
	 omwZvQycIsjyFHSUbB9oWLC9Fo9v2+pLICtivnJpNdt0duYK36WoB+oB52SD8ki7qk
	 EPlHHnagW7kQNhTWmNO13p/yySeOcO1pboLHLxeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/372] lib/generic-radix-tree.c: Dont overflow in peek()
Date: Fri, 24 Nov 2023 17:46:29 +0000
Message-ID: <20231124172010.514046367@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Kent Overstreet <kent.overstreet@gmail.com>

[ Upstream commit 9492261ff2460252cf2d8de89cdf854c7e2b28a0 ]

When we started spreading new inode numbers throughout most of the 64
bit inode space, that triggered some corner case bugs, in particular
some integer overflows related to the radix tree code. Oops.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/generic-radix-tree.h |  7 +++++++
 lib/generic-radix-tree.c           | 17 ++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
index 107613f7d7920..f6cd0f909d9fb 100644
--- a/include/linux/generic-radix-tree.h
+++ b/include/linux/generic-radix-tree.h
@@ -38,6 +38,7 @@
 
 #include <asm/page.h>
 #include <linux/bug.h>
+#include <linux/limits.h>
 #include <linux/log2.h>
 #include <linux/math.h>
 #include <linux/types.h>
@@ -184,6 +185,12 @@ void *__genradix_iter_peek(struct genradix_iter *, struct __genradix *, size_t);
 static inline void __genradix_iter_advance(struct genradix_iter *iter,
 					   size_t obj_size)
 {
+	if (iter->offset + obj_size < iter->offset) {
+		iter->offset	= SIZE_MAX;
+		iter->pos	= SIZE_MAX;
+		return;
+	}
+
 	iter->offset += obj_size;
 
 	if (!is_power_of_2(obj_size) &&
diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
index f25eb111c0516..7dfa88282b006 100644
--- a/lib/generic-radix-tree.c
+++ b/lib/generic-radix-tree.c
@@ -166,6 +166,10 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 	struct genradix_root *r;
 	struct genradix_node *n;
 	unsigned level, i;
+
+	if (iter->offset == SIZE_MAX)
+		return NULL;
+
 restart:
 	r = READ_ONCE(radix->root);
 	if (!r)
@@ -184,10 +188,17 @@ void *__genradix_iter_peek(struct genradix_iter *iter,
 			(GENRADIX_ARY - 1);
 
 		while (!n->children[i]) {
+			size_t objs_per_ptr = genradix_depth_size(level);
+
+			if (iter->offset + objs_per_ptr < iter->offset) {
+				iter->offset	= SIZE_MAX;
+				iter->pos	= SIZE_MAX;
+				return NULL;
+			}
+
 			i++;
-			iter->offset = round_down(iter->offset +
-					   genradix_depth_size(level),
-					   genradix_depth_size(level));
+			iter->offset = round_down(iter->offset + objs_per_ptr,
+						  objs_per_ptr);
 			iter->pos = (iter->offset >> PAGE_SHIFT) *
 				objs_per_page;
 			if (i == GENRADIX_ARY)
-- 
2.42.0



