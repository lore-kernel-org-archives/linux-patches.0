Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF4F2E62CD;
	Thu,  3 Jul 2025 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554421; cv=none; b=UgTFcGCrrBHj4ITDoBrEJJzK9AnHb6ijoYVSpDB48DfUF7vxnjB8vC0m1NQ7+JGwHpP9gxEhLH+gGS/yXmWr15MBmsumLaToH3uwmkjXvD4s1BxKNQgRjrm/99JLcna6pVcqgpIFwBU8Y3D5uKTCWgSEuJfP6WPXAWCCgbg47vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554421; c=relaxed/simple;
	bh=GVp8gRB+iV9NW7RTRdFIvuyIdmu7Go4AmO0jGJU3qps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoLHnbSCbZEgO6goOrmBkDChU9x9z282vMmOn4y0HTQ/7gK2KNeMcGpNLe4XLL37WIr9di5rTCx91K1EBzY3DaJkGsjYx/HNwZ+aYdB7kCE4G3wzyyTjm08KKmoakGs+BmJtOluGc7eXdFYZtATJvjejpo2+ZqsiPfTnQ5+qO98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaI/QaPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaI/QaPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CA9C4CEE3;
	Thu,  3 Jul 2025 14:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554421;
	bh=GVp8gRB+iV9NW7RTRdFIvuyIdmu7Go4AmO0jGJU3qps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaI/QaPUiZTBCM+Xub1ke5PC+bY1+tZOZAr2HopSRUMRV4kaPyUWxARWBscEp2RIs
	 /57mtzeMVqI7GxyY61WohgmuKZ2gTOtCiAVXpFCY9yGKYuEBnUmoBr3pMxLr9cgPjB
	 KRn2ukRYxRsVKvyANEjk2hAGT5rWoa0pZgBivOT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d335893772467199ab6@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 6.12 182/218] io_uring/rsrc: fix folio unpinning
Date: Thu,  3 Jul 2025 16:42:10 +0200
Message-ID: <20250703144003.457619541@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 5afb4bf9fc62d828647647ec31745083637132e4 upstream.

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
@@ -119,8 +119,11 @@ static void io_buffer_unmap(struct io_ri
 	if (imu != &dummy_ubuf) {
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
-		for (i = 0; i < imu->nr_bvecs; i++)
-			unpin_user_page(imu->bvec[i].bv_page);
+		for (i = 0; i < imu->nr_bvecs; i++) {
+			struct folio *folio = page_folio(imu->bvec[i].bv_page);
+
+			unpin_user_folio(folio, 1);
+		}
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
 		kvfree(imu);
@@ -1010,8 +1013,10 @@ static int io_sqe_buffer_register(struct
 done:
 	if (ret) {
 		kvfree(imu);
-		if (pages)
-			unpin_user_pages(pages, nr_pages);
+		if (pages) {
+			for (i = 0; i < nr_pages; i++)
+				unpin_user_folio(page_folio(pages[i]), 1);
+		}
 	}
 	kvfree(pages);
 	return ret;


