Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2E247276C;
	Tue, 16 Jun 2026 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624728; cv=none; b=tRG68Z4HN0cBtTW9Df6i973MGGyNYGdWsDzLToDUzuCtIS1sM7pMfBpd6EhqA5ABc3fZkGJApIToLktQAW1sXBo84eZodvqgYED97jv9RcnTn9ugDMRWvBwuI5aReTxZSUnyNew61qptb6thcvhypx6phTaoeUf7n+MqGxaDULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624728; c=relaxed/simple;
	bh=zURapxo5Aw7xMvCrd7d2HTic7PfRz0yC+ZdVG5XRJuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2rj4FlnX2VyFX/iOX16Irv5BFhQflEHwiIe/GV1ealyj1E7QthN0+VHAtgSFSXLev5QN4wY6Py/BgHgWqzBpKZAllGdvAOmE1g8S1b5fqBU09oF+Y+4Sn25Kv2Lf9n1+CS9/dsl6apmOb65J207qXTiPDmLQKASsI2niVRs9rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llgq0qjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llgq0qjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD271F000E9;
	Tue, 16 Jun 2026 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624725;
	bh=4V4NnslVOTaTLduLVPq6xrY52ehfo2P80FUPoBeNXoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llgq0qjofDnhyKYbsNwRCtizbj0hM9urVNBt51OWIYOFWrZsbhQWTPi/YRMe+Cu3W
	 oQTxff4cC2e6PyLD/B+g7CLakg9x7be6QJ2l26jKAnpYrwSjml99AWYymkUcEkNW//
	 8S8MRHfxxFhcm4BAkbuyRDmD5n9fsLmXnp1yPWMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jianan Huang <jnhuang95@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/325] erofs: fix use-after-free on sbi->sync_decompress
Date: Tue, 16 Jun 2026 20:26:54 +0530
Message-ID: <20260616145058.704496159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e98d9cb4fe99a4..a02ce7c06f9e1e 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1443,6 +1443,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	if (z_erofs_in_atomic()) {
+		/* See `sync_decompress` in sysfs-fs-erofs for more details */
+		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
+			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
@@ -1459,9 +1462,6 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
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



