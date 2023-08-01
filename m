Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FE61FB24
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A759AC433C8;
	Tue,  1 Aug 2023 09:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882316;
	bh=YIJ8iip5sT6GDUmpZCrhZn5u/26BQbRjuvDfgp3nKiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiGfABlO7RxmA2D7M67+aSCi13+nA/clpg9dkkULZ+tpLUqjQHHm+x9GnR/FRQLjK
	 nLSJM53y6lIIl5OVwAN2zz//hPEd601BVEMIK6oE4OR+XTCJCy+607IRxQJHLqhtkL
	 p3jfCs2kI5qi7dLqkGJ5w96ZDjj62q/X6ehbYvX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/228] test_maple_tree: test modifications while iterating
Date: Tue,  1 Aug 2023 11:18:40 +0200
Message-ID: <20230801091925.095763683@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@Oracle.com>

[ Upstream commit 5159d64b335401fa83f18c27e2267f1eafc41bd3 ]

Add a testcase to ensure the iterator detects bad states on modifications
and does what the user expects

Link: https://lkml.kernel.org/r/20230120162650.984577-5-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7a93c71a6714 ("maple_tree: fix 32 bit mas_next testing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_maple_tree.c | 72 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index f7364b9fee939..f1db333270e9f 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -1709,6 +1709,74 @@ static noinline void check_forking(struct maple_tree *mt)
 	mtree_destroy(&newmt);
 }
 
+static noinline void check_iteration(struct maple_tree *mt)
+{
+	int i, nr_entries = 125;
+	void *val;
+	MA_STATE(mas, mt, 0, 0);
+
+	for (i = 0; i <= nr_entries; i++)
+		mtree_store_range(mt, i * 10, i * 10 + 9,
+				  xa_mk_value(i), GFP_KERNEL);
+
+	mt_set_non_kernel(99999);
+
+	i = 0;
+	mas_lock(&mas);
+	mas_for_each(&mas, val, 925) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite end of entry 92 */
+		if (i == 92) {
+			mas.index = 925;
+			mas.last = 929;
+			mas_store(&mas, val);
+		}
+		i++;
+	}
+	/* Ensure mas_find() gets the next value */
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(i));
+
+	mas_set(&mas, 0);
+	i = 0;
+	mas_for_each(&mas, val, 785) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite start of entry 78 */
+		if (i == 78) {
+			mas.index = 780;
+			mas.last = 785;
+			mas_store(&mas, val);
+		} else {
+			i++;
+		}
+	}
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(i));
+
+	mas_set(&mas, 0);
+	i = 0;
+	mas_for_each(&mas, val, 765) {
+		MT_BUG_ON(mt, mas.index != i * 10);
+		MT_BUG_ON(mt, mas.last != i * 10 + 9);
+		/* Overwrite end of entry 76 and advance to the end */
+		if (i == 76) {
+			mas.index = 760;
+			mas.last = 765;
+			mas_store(&mas, val);
+			mas_next(&mas, ULONG_MAX);
+		}
+		i++;
+	}
+	/* Make sure the next find returns the one after 765, 766-769 */
+	val = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, val != xa_mk_value(76));
+	mas_unlock(&mas);
+	mas_destroy(&mas);
+	mt_set_non_kernel(0);
+}
+
 static noinline void check_mas_store_gfp(struct maple_tree *mt)
 {
 
@@ -2702,6 +2770,10 @@ static int maple_tree_seed(void)
 	goto skip;
 #endif
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_iteration(&tree);
+	mtree_destroy(&tree);
+
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_forking(&tree);
 	mtree_destroy(&tree);
-- 
2.39.2



