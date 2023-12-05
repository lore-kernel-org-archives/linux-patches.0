Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9076FAF;
	Tue,  5 Dec 2023 03:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgIb4+UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580A9C433C8;
	Tue,  5 Dec 2023 03:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746848;
	bh=hXYlJBagf39G3N7LFm+MLU/GL/ou50yUugRt7V+M/Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgIb4+UV2/cpAUqaZCUIqM47supUNBY1ZCdWhdPzir/Br0hSJKTPCtHdQ4wr3F9gQ
	 sb4khfI+q8nvV7mZ1nKzTjxcAkrvYpWuiyU1GihhpJyV1w/xyAmGekV+HUDalO3own
	 vEztyNGtP2FsPK/Nmg1HZG+ZytILDUfNzJntPq2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 19/71] bcache: replace a mistaken IS_ERR() by IS_ERR_OR_NULL() in btree_gc_coalesce()
Date: Tue,  5 Dec 2023 12:16:17 +0900
Message-ID: <20231205031518.942838323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coly Li <colyli@suse.de>

commit f72f4312d4388376fc8a1f6cf37cb21a0d41758b upstream.

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") do the following change inside btree_gc_coalesce(),

31 @@ -1340,7 +1340,7 @@ static int btree_gc_coalesce(
32         memset(new_nodes, 0, sizeof(new_nodes));
33         closure_init_stack(&cl);
34
35 -       while (nodes < GC_MERGE_NODES && !IS_ERR_OR_NULL(r[nodes].b))
36 +       while (nodes < GC_MERGE_NODES && !IS_ERR(r[nodes].b))
37                 keys += r[nodes++].keys;
38
39         blocks = btree_default_blocks(b->c) * 2 / 3;

At line 35 the original r[nodes].b is not always allocatored from
__bch_btree_node_alloc(), and possibly initialized as NULL pointer by
caller of btree_gc_coalesce(). Therefore the change at line 36 is not
correct.

This patch replaces the mistaken IS_ERR() by IS_ERR_OR_NULL() to avoid
potential issue.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in node allocations")
Cc:  <stable@vger.kernel.org> # 6.5+
Cc: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-9-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1379,7 +1379,7 @@ static int btree_gc_coalesce(struct btre
 	memset(new_nodes, 0, sizeof(new_nodes));
 	closure_init_stack(&cl);
 
-	while (nodes < GC_MERGE_NODES && !IS_ERR(r[nodes].b))
+	while (nodes < GC_MERGE_NODES && !IS_ERR_OR_NULL(r[nodes].b))
 		keys += r[nodes++].keys;
 
 	blocks = btree_default_blocks(b->c) * 2 / 3;


