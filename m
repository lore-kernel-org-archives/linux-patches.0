Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A062E339E;
	Thu,  3 Jul 2025 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554912; cv=none; b=Lyq3MKqwgmNjmWEBIS/afF3ZL/SZy6ampUogQhmETx0d0qegPlW4yMEJDINFTT2oiMRNPTcqzG4uBtgi8EVpfZ/cA+JsmIoxctrUnko4UOnIgXB3/zt59lYvJZrx0tD8ItHgS+Hw3D1XsP4xMKc/nFgJ22QNaFCTl8Eq8unFNOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554912; c=relaxed/simple;
	bh=iHX4JR3RkhOev3vaEqiA4bDxi+ROGP+WBeonqAMuYkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ihm8PFub36SW604Z8P6M4yjfwNFf+M9WRRIhpILggLYX746Qe8LIKjr7TGup5jA3pm0y5IF4Y0XDLD6fFs0gmqv6ii/ViZ4PI/sAICidmF7FpbOEzwU3hXS+iM0idz428JujVJ7eQYFVJqWhj3eVW+2fqmWw59wkMQMnWbWSDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTc5gydC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTc5gydC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FAFC4CEED;
	Thu,  3 Jul 2025 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554912;
	bh=iHX4JR3RkhOev3vaEqiA4bDxi+ROGP+WBeonqAMuYkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTc5gydC9Ga7lT5VW0gy7WwtgTHa16oEzuuHIqByVibNq06XQ1qeXbXE+GNsor3bq
	 qUWkegXkrODfhCjHUyeRJ804hcnnxh0Uo/4JsQbjRqcv1jqcFe3mvgniOUMSUO5u4n
	 GA157JFRqUa+uOEmecM0SFQW62/2NzRamdTbFfWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d335893772467199ab6@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 6.15 117/263] io_uring/rsrc: fix folio unpinning
Date: Thu,  3 Jul 2025 16:40:37 +0200
Message-ID: <20250703144009.041867916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 5afb4bf9fc62d828647647ec31745083637132e4 upstream.

syzbot complains about an unmapping failure:

[  108.070381][   T14] kernel BUG at mm/gup.c:71!
[  108.070502][   T14] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[  108.123672][   T14] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250221-8.fc42 02/21/2025
[  108.127458][   T14] Workqueue: iou_exit io_ring_exit_work
[  108.174205][   T14] Call trace:
[  108.175649][   T14]  sanity_check_pinned_pages+0x7cc/0x7d0 (P)
[  108.178138][   T14]  unpin_user_page+0x80/0x10c
[  108.180189][   T14]  io_release_ubuf+0x84/0xf8
[  108.182196][   T14]  io_free_rsrc_node+0x250/0x57c
[  108.184345][   T14]  io_rsrc_data_free+0x148/0x298
[  108.186493][   T14]  io_sqe_buffers_unregister+0x84/0xa0
[  108.188991][   T14]  io_ring_ctx_free+0x48/0x480
[  108.191057][   T14]  io_ring_exit_work+0x764/0x7d8
[  108.193207][   T14]  process_one_work+0x7e8/0x155c
[  108.195431][   T14]  worker_thread+0x958/0xed8
[  108.197561][   T14]  kthread+0x5fc/0x75c
[  108.199362][   T14]  ret_from_fork+0x10/0x20

We can pin a tail page of a folio, but then io_uring will try to unpin
the head page of the folio. While it should be fine in terms of keeping
the page actually alive, mm folks say it's wrong and triggers a debug
warning. Use unpin_user_folio() instead of unpin_user_page*.

Cc: stable@vger.kernel.org
Debugged-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+1d335893772467199ab6@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/683f1551.050a0220.55ceb.0017.GAE@google.com
Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/io-uring/a28b0f87339ac2acf14a645dad1e95bbcbf18acd.1750771718.git.asml.silence@gmail.com/
[axboe: adapt to current tree, massage commit message]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -112,8 +112,11 @@ static void io_release_ubuf(void *priv)
 	struct io_mapped_ubuf *imu = priv;
 	unsigned int i;
 
-	for (i = 0; i < imu->nr_bvecs; i++)
-		unpin_user_page(imu->bvec[i].bv_page);
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct folio *folio = page_folio(imu->bvec[i].bv_page);
+
+		unpin_user_folio(folio, 1);
+	}
 }
 
 static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
@@ -844,8 +847,10 @@ done:
 	if (ret) {
 		if (imu)
 			io_free_imu(ctx, imu);
-		if (pages)
-			unpin_user_pages(pages, nr_pages);
+		if (pages) {
+			for (i = 0; i < nr_pages; i++)
+				unpin_user_folio(page_folio(pages[i]), 1);
+		}
 		io_cache_free(&ctx->node_cache, node);
 		node = ERR_PTR(ret);
 	}


