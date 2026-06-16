Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568803264FF;
	Tue, 16 Jun 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622843; cv=none; b=BsUvSyNITEZZ2ay34Sb6JeKaMFVMj1b1vZyQm85mKB7KDeLMxz33XT2eP2Fn73XYC5TJqt75e8Lb603zlqz+4xcMkxbmrIG2WSCmM+LerIyS95jgkeCVq9l82F3guUkqAIuRUA75MLNXLNAVsU3usPdLdhAVJYpYfK1CBnCwdMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622843; c=relaxed/simple;
	bh=D0FLt0Uryp2WEuIoQnKRTaBVKzu6RJVw/u2vkQSBkPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxtpjMocWuCJmV3vsp/DDp30pCOCpL6y0jPDX7bV2IuEbImBMa98oxPckf8xhQugNOG/9gKnciIvDPyJDKxMPuaBST3VLBrPnA5mjOn4+kr+VkHXMxMnEXnXHfk1BT2gf6DrhLurp4a3RZ2A799XY2UaC8C8i0oqIpM/Jv5fCb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYOz4mWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYOz4mWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670531F00A3A;
	Tue, 16 Jun 2026 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622842;
	bh=WiU3jAp7AErxV5OuUMRf6myUu8oo+NFdePuhGzboaZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYOz4mWRMuP1d86XJy5TM/CUA6qcLs+oiyZozUzwp/oT1M8icRaGq/37VmYONijnz
	 aB7/L5wBoOObhStoMwFY9EKTB9ZpP1fd/ViINaqdyXigtFehfOnfbffLb93En3aIlK
	 XfD3uCdyxExRqBv15//j0ADS2A+hn1MvhYIE9P1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52bae5c495dbe261a0bc@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jianan Huang <jnhuang95@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 016/378] erofs: fix use-after-free on sbi->sync_decompress
Date: Tue, 16 Jun 2026 20:24:07 +0530
Message-ID: <20260616145110.665994826@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d7445e98312d80..50a5a1568370b0 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1457,6 +1457,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
 	if (z_erofs_in_atomic()) {
+		/* See `sync_decompress` in sysfs-fs-erofs for more details */
+		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
+			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 #ifdef CONFIG_EROFS_FS_PCPU_KTHREAD
 		struct kthread_worker *worker;
 
@@ -1473,9 +1476,6 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
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



