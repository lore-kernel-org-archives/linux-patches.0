Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF8617990
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq8t/wlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3FAC433CB;
	Mon,  9 Oct 2023 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856889;
	bh=Cs7d3LVPlcbt0hPGcT+XcGzNci5Vu+Lk9EIHUSxDSDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fq8t/wlckvwXaMY89QKeiyqFlx8mblMRkgX9xm9cP+2yFVfXEIUpTpHj69cgSeiIs
	 0y8xWkaSdlhiwkCFnmB+tmSbFJSIOk579yvEFlVIULIHHDN2utPuwH4NEQaz0JCb2Q
	 NlTdAvY3DLSpxICD0Y+s2BpTVwgyslsgnzrwq1jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 024/163] maple_tree: reduce resets during store setup
Date: Mon,  9 Oct 2023 14:59:48 +0200
Message-ID: <20231009130124.677965844@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit fec29364348fec535c55708b1f4025b321aba572 upstream.

mas_prealloc() may walk partially down the tree before finding that a
split or spanning store is needed.  When the write occurs, relax the
logic on resetting the walk so that partial walks will not restart, but
walks that have gone too far (a store that affects beyond the current
node) should be restarted.

Link: https://lkml.kernel.org/r/20230724183157.3939892-15-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5439,19 +5439,34 @@ static inline void mte_destroy_walk(stru
 
 static void mas_wr_store_setup(struct ma_wr_state *wr_mas)
 {
+	if (mas_is_start(wr_mas->mas))
+		return;
+
 	if (unlikely(mas_is_paused(wr_mas->mas)))
-		mas_reset(wr_mas->mas);
+		goto reset;
+
+	if (unlikely(mas_is_none(wr_mas->mas)))
+		goto reset;
+
+	/*
+	 * A less strict version of mas_is_span_wr() where we allow spanning
+	 * writes within this node.  This is to stop partial walks in
+	 * mas_prealloc() from being reset.
+	 */
+	if (wr_mas->mas->last > wr_mas->mas->max)
+		goto reset;
+
+	if (wr_mas->entry)
+		return;
+
+	if (mte_is_leaf(wr_mas->mas->node) &&
+	    wr_mas->mas->last == wr_mas->mas->max)
+		goto reset;
+
+	return;
 
-	if (!mas_is_start(wr_mas->mas)) {
-		if (mas_is_none(wr_mas->mas)) {
-			mas_reset(wr_mas->mas);
-		} else {
-			wr_mas->r_max = wr_mas->mas->max;
-			wr_mas->type = mte_node_type(wr_mas->mas->node);
-			if (mas_is_span_wr(wr_mas))
-				mas_reset(wr_mas->mas);
-		}
-	}
+reset:
+	mas_reset(wr_mas->mas);
 }
 
 /* Interface */


