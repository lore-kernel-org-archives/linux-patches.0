Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CBF394470;
	Sat, 17 Oct 2026 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260509; cv=none; b=auUHo0C8+pvVV/hGsQ9v+ZBH1rSqg6M4orUYVNuvPM2B5f4uF2bSocgpclZmkIdqR3EcQhIa4XLF5brc+Ryv0VUs55jn/xjUXc69M21TV5emq8jUpvwq7cQmH2sTGvHWCdEWNL4K5GwmxsDs6+nCEVBs2U3GpTAik+lwteA0578=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260509; c=relaxed/simple;
	bh=jsjJIyeClsRGpOXeBQEsAcM9B2C70Dbw2xYD5oSsBsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKXEkOulZa+UWTsEBVP+8EaMt4sCwuFktmC5Qg/P5MdXInHSB51cR01vWoqRD5hKyW9+UsFWSJTHdEzh8l5KpXvmaUzQxCpp/2dg91Sr/qhFUS8/bccrhq5o/uMz0qbSwGHF8gsUMILxtWPVzl4a/GGx70m3A0xnBC4ZKLb9S/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUT4BYPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUT4BYPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5C91F000C4;
	Sat, 17 Oct 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260508;
	bh=CCO+gZ9eeAe43XTo0Edf74PVLBBrnn/H1L7Cw92Bi1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUT4BYPHMzAv4vB8PgYt8o/hKwt/QffHAsVUS8x35MmB0Rv2c6fPfUVBt3HLSt45y
	 GhdUgeR2O0wtbGiPFPIofky1hJsMvUo1y/Nt5+nb6CfGATqPxaZQRcTegrQMZaQO3a
	 FMKDq7NSaEyd5dRaFZFRBFV806w8H+FEIuRtGPxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jianan Huang <jnhuang95@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1568/1674] erofs: fix use-after-free on sbi->sync_decompress
Date: Sat, 17 Oct 2026 18:04:00 +0200
Message-ID: <20261017160511.348925735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08af755ebd8e4..ede86dd93b5dd 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1430,6 +1430,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	if (z_erofs_in_atomic()) {
+		/* See `sync_decompress` in sysfs-fs-erofs for more details */
+		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
+			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
@@ -1446,9 +1449,6 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 #else
 		queue_work(z_erofs_workqueue, &io->u.work);
 #endif
-		/* enable sync decompression for readahead */
-		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
-			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
 	gfp_flag = memalloc_noio_save();
-- 
2.53.0



