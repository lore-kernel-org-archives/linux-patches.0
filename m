Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8536AC2;
	Tue,  5 Dec 2023 03:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfDuHTmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566B2C433C8;
	Tue,  5 Dec 2023 03:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747707;
	bh=FGGqSsOMiFuLL5/fVZlo1MXU1BhuwoyqA2i05p/ByXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KfDuHTmXjSIu4jhb1Yq22iB1a4ZsutRFrODqju84qjBAh1hK5iWFZsDsKxZk7tHlt
	 TkGi13sbYkhFVKZJiadyKjGF9Y1hU1W7MlUuOG/q/8J8xNvw4InP0yQCrTPYbQYrty
	 c/cVx5smzt4QSxjmsz22TZ/En2Wiv6G6ml6Fhpos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Coly Li <colyli@suse.de>,
	Markus Weippert <markus@gekmihesg.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 15/67] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
Date: Tue,  5 Dec 2023 12:17:00 +0900
Message-ID: <20231205031520.688879759@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Weippert <markus@gekmihesg.de>

commit bb6cc253861bd5a7cf8439e2118659696df9619f upstream.

Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
node allocations") replaced IS_ERR_OR_NULL by IS_ERR. This leads to a
NULL pointer dereference.

BUG: kernel NULL pointer dereference, address: 0000000000000080
Call Trace:
 ? __die_body.cold+0x1a/0x1f
 ? page_fault_oops+0xd2/0x2b0
 ? exc_page_fault+0x70/0x170
 ? asm_exc_page_fault+0x22/0x30
 ? btree_node_free+0xf/0x160 [bcache]
 ? up_write+0x32/0x60
 btree_gc_coalesce+0x2aa/0x890 [bcache]
 ? bch_extent_bad+0x70/0x170 [bcache]
 btree_gc_recurse+0x130/0x390 [bcache]
 ? btree_gc_mark_node+0x72/0x230 [bcache]
 bch_btree_gc+0x5da/0x600 [bcache]
 ? cpuusage_read+0x10/0x10
 ? bch_btree_gc+0x600/0x600 [bcache]
 bch_gc_thread+0x135/0x180 [bcache]

The relevant code starts with:

    new_nodes[0] = NULL;

    for (i = 0; i < nodes; i++) {
        if (__bch_keylist_realloc(&keylist, bkey_u64s(&r[i].b->key)))
            goto out_nocoalesce;
    // ...
out_nocoalesce:
    // ...
    for (i = 0; i < nodes; i++)
        if (!IS_ERR(new_nodes[i])) {  // IS_ERR_OR_NULL before
028ddcac477b
            btree_node_free(new_nodes[i]);  // new_nodes[0] is NULL
            rw_unlock(true, new_nodes[i]);
        }

This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.

Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in node allocations")
Link: https://lore.kernel.org/all/3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de/
Cc: stable@vger.kernel.org
Cc: Zheng Wang <zyytlz.wz@163.com>
Cc: Coly Li <colyli@suse.de>
Signed-off-by: Markus Weippert <markus@gekmihesg.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1489,7 +1489,7 @@ out_nocoalesce:
 	bch_keylist_free(&keylist);
 
 	for (i = 0; i < nodes; i++)
-		if (!IS_ERR(new_nodes[i])) {
+		if (!IS_ERR_OR_NULL(new_nodes[i])) {
 			btree_node_free(new_nodes[i]);
 			rw_unlock(true, new_nodes[i]);
 		}


