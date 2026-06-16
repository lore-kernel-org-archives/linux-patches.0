Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A5E46AEEA;
	Tue, 16 Jun 2026 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626510; cv=none; b=MOjrJrnwl9Z2EV0UQWUBNIC3OnqqDGrTDURoMQI3LLM9xW1igCz/802Jf3pgL6LBEyY0jA67VpbsRS6uVtHcJs/k9YNdL1T7yPLmZctIrdVVh+4Rzo5aKYiHfcGFm7P1g9n7XG0iet6tjmRj38VDFkCpoTKgc2A5MA1zlnqRJuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626510; c=relaxed/simple;
	bh=qiuYUrFvwlWUb+lcnkCpGd7w8Uqrr5Z26i/esgpSlD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6MofYJo7UAludVZEJFUEN48ZkNnTAM6T6dagSWLHHQPRvsa7qVmKofXlsBKgHMAVFzTtux3bDlFDbjm/4Z0U/+3rA7wjizL0DAgZ4Sn8VM49S6P8kGhjm4tiytprrTYQKupohhGbCDFA32ZEAI/+8nfOSVIuVF0ncTqOYPdQs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6wn7czW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6wn7czW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D531F000E9;
	Tue, 16 Jun 2026 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626509;
	bh=jGsN11JQgvk8qovklzqjKkJUn6cJAyWMb6Tqq1yXJYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6wn7czWkb68DuGoK4vfBZdAc08PghtTN8K4dvxNdeONSz3iMG5KXmtVp+7C8ejn6
	 fBeB9HOaE6cX+ASuEC8wY5YiwLt8XZUaOtk5AO6xI4FjOSUON2UQ8AblwuUpsLlu5b
	 4aRPXzfCNrrb+ErZXgZRNcYbW3rpjBDuXggt+UyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jianan Huang <jnhuang95@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/261] erofs: fix use-after-free on sbi->sync_decompress
Date: Tue, 16 Jun 2026 20:27:34 +0530
Message-ID: <20260616145045.770032214@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1aee05e814d292064bf5fa15733741040cdc48ba ]

z_erofs_decompress_kickoff() can race with filesystem unmount, causing
a use-after-free on sbi->sync_decompress.

When I/O completes, z_erofs_endio() calls z_erofs_decompress_kickoff()
to queue z_erofs_decompressqueue_work() asynchronously. Then, after all
folios are unlocked, unmount workflow can proceed and sbi will be freed
before accessing to sbi->sync_decompress.

Thread (unmount)        I/O completion        kworker
                        queue_work
                                              z_erofs_decompressqueue_work
                                               (all folios are unlocked)
cleanup_mnt
 ..
 erofs_kill_sb
  erofs_sb_free
   kfree(sbi)
                        access sbi->sync_decompress  // UAF!!

Fixes: 40452ffca3c1 ("erofs: add sysfs node to control sync decompression strategy")
Reported-by: syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=52bae5c495dbe261a0bc
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Jianan Huang <jnhuang95@gmail.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index da421fe310df11..d625e3be9ec6ce 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1424,6 +1424,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	if (z_erofs_in_atomic()) {
+		/* See `sync_decompress` in sysfs-fs-erofs for more details */
+		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
+			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
@@ -1440,9 +1443,6 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 #else
 		queue_work(z_erofs_workqueue, &io->u.work);
 #endif
-		/* See `sync_decompress` in sysfs-fs-erofs for more details */
-		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
-			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
 	gfp_flag = memalloc_noio_save();
-- 
2.53.0



