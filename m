Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215071;
	b=mAQUFy5h2sZKnYbas9YsFoMMmz3+WLoyYk66R0nR35Yyb4QMfTJMAlAVroeIRcMoJUj7
	 ygfaKyaXeLFukl9LBnGEnGMK+QZS31cK9C/3ZflPhMLST14oeXbsTvzkgZFf7wN8zgPG9
	 AvwCizzxJmM0hSbK5AEXFzYwqEkBbTBBSFwhts+blkXRdxBLBAazkifsKAtabm00o6E+9
	 uGTCkrkn+/HUI53J7IpOrxRLNI78ARF/lLvx0UiLHsyG2LO4RVsQ7DSOsH8Hle1dtxMCh
	 670t3D7fkxieJH7Lrb/5P+0irBh+AHAmkxShGYk2i0Cixy3aP0n5vqSbkBU9EHU5+HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KVe8q9SaCxi8mvwFfPM9AMzTjdJUvV2lbhdOskPdVxQ=;
	b=BuK5n+Dq4m+3Eesp0xGezFf/hGDVtj3VBcJlw6R9CGIcmoYDqVwB95GHvDRunnRmU3pE
	 fzM2eyPq71fQx1uGnZuKEVTvzSOfvzHzvEmnXTqEQn0UPwETS/T6Ek9YdJ5Hmjt6hmv9q
	 xkbb6kyab00RqSQAcrTnBSiUKULq99i4EnItYGAMiNRVw20OQLDyL8dA/cwQ8Ka6QM5St
	 IBhas71+SykJAISVHs52Ay8sXRFAwSxOrr415H0uvTBkwDe/b3pjXUSiH0G2IyNsSb1yo
	 f10fM3RhYLDA8y+CUQ2JfP3ZIgEpfh4bNrsZqjZKFWqxGHc3aUKNAvni9uoGhezrtCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4XUGhcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD7D606A31A;
	Wed, 28 Oct 2026 19:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4XUGhcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF641F01825;
	Wed, 28 Oct 2026 19:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215071;
	bh=KVe8q9SaCxi8mvwFfPM9AMzTjdJUvV2lbhdOskPdVxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4XUGhcRHryYMStvfONMDCqTkBmOuggYB2TZ15ZDUuMX2fHQNd1mc1L19ccNwBG2p
	 3A3jMcR1G2fOtcOX1snmnv/RDl8J68loyvCkcG/eKHxT2xPXCSMv9OiuB/OfflS36M
	 QHMCBY3SfyTmCIfHoqfCciJHKXXnptYDcWe/OWLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <huangjianan@xiaomi.com>,
	Sheng Yong <shengyong1@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1080/1887] f2fs: avoid reading already updated pages during GC
Date: Wed, 28 Oct 2026 17:52:56 +0100
Message-ID: <20261028170523.982233881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianan Huang <huangjianan@xiaomi.com>

[ Upstream commit 570e2ccc7cb35fe720106964e65060602d3d2ac4 ]

We found the following issue during fuzz testing:

page: refcount:3 mapcount:0 mapping:00000000b6e89c65 index:0x18b2dc pfn:0x161ba9
memcg:f8ffff800e269c00
aops:f2fs_meta_aops ino:2
flags: 0x52880000000080a9(locked|waiters|uptodate|lru|private|zone=1|kasantag=0x4a)
raw: 52880000000080a9 fffffffec6e17588 fffffffec0ccc088 a7ffff8067063618
raw: 000000000018b2dc 0000000000000009 00000003ffffffff f8ffff800e269c00
page dumped because: VM_BUG_ON_FOLIO(folio_test_uptodate(folio))
page_owner tracks the page as allocated
 post_alloc_hook+0x58c/0x5ec
 prep_new_page+0x34/0x284
 get_page_from_freelist+0x2dcc/0x2e8c
 __alloc_pages_noprof+0x280/0x76c
 __folio_alloc_noprof+0x18/0xac
 __filemap_get_folio+0x6bc/0xdc4
 pagecache_get_page+0x3c/0x104
 do_garbage_collect+0x5c78/0x77a4
 f2fs_gc+0xd74/0x25f0
 gc_thread_func+0xb28/0x2930
 kthread+0x464/0x5d8
 ret_from_fork+0x10/0x20
------------[ cut here ]------------
kernel BUG at mm/filemap.c:1563!
 folio_end_read+0x140/0x168
 f2fs_finish_read_bio+0x5c4/0xb80
 f2fs_read_end_io+0x64c/0x708
 bio_endio+0x85c/0x8c0
 blk_update_request+0x690/0x127c
 scsi_end_request+0x9c/0xb8c
 scsi_io_completion+0xf0/0x250
 scsi_finish_command+0x430/0x45c
 scsi_complete+0x178/0x6d4
 blk_mq_complete_request+0xcc/0x104
 scsi_done_internal+0x214/0x454
 scsi_done+0x24/0x34

which is similar to the problem reported by syzbot:
https://syzkaller.appspot.com/bug?extid=3686758660f980b402dc

This case is consistent with the description in commit 9bf1a3f
("f2fs: avoid GC causing encrypted file corrupted"):
Page 1 is moved from blkaddr A to blkaddr B by move_data_block, and after
being written it is marked as uptodate. Then, Page 1 is moved from blkaddr
B to blkaddr C, VM_BUG_ON_FOLIO was triggered in the endio initiated by
ra_data_block.

There is no need to read Page 1 again from blkaddr B, since it has already
been updated. Therefore, avoid initiating I/O in this case.

Fixes: 6aa58d8ad20a ("f2fs: readahead encrypted block during GC")
Signed-off-by: Jianan Huang <huangjianan@xiaomi.com>
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 216171e020710..771e38aaeba32 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1183,7 +1183,7 @@ static int ra_data_block(struct inode *inode, pgoff_t index)
 		.in_list = 0,
 		.retry = 0,
 	};
-	int err;
+	int err = 0;
 
 	page = f2fs_grab_cache_page(mapping, index, true);
 	if (!page)
@@ -1237,6 +1237,9 @@ static int ra_data_block(struct inode *inode, pgoff_t index)
 		goto put_page;
 	}
 
+	if (PageUptodate(fio.encrypted_page))
+		goto put_encrypted_page;
+
 	err = f2fs_submit_page_bio(&fio);
 	if (err)
 		goto put_encrypted_page;
-- 
2.53.0



