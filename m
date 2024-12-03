Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB2B1AB6C9;
	Tue,  3 Dec 2024 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241293; cv=none; b=LKbouImkrWwMWnLpZGbje/T7A8E3vN+xZlms8FC1oAPWMyle1R+B9E0XhGXStDYP8y9OJFAruuvoXtqd3IN5CV7bx91xANxoE69e8EQLyYYJAAel0/ByTIxIkLxbh7ir02xdF3bs2GEtQCsGSO5TS5NLHHr0H2pKzVT4EOveXJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241293; c=relaxed/simple;
	bh=goEJOB3gllb1QBBWbA3fXTcKfIeOJFmEsxMPNinP/pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=my1JtC/Fv/SeGMNNAjbWnntYO22pvTkcUEwSPBB/oOYoynBwZNXp6xPYaDW5g6P1B7Jk3WF4wsUBIVv+Rl7/6vtnm8PScnygg97RxH1cdoZU4VlCTM+ZghCTVZZogqAummdbDv5gr5tySH5nlBmVelS/pD+Jo2p89/eV+7m9N6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAMLxq6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAMLxq6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55574C4CED6;
	Tue,  3 Dec 2024 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241292;
	bh=goEJOB3gllb1QBBWbA3fXTcKfIeOJFmEsxMPNinP/pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAMLxq6UQBlY7lPbXpebV/hl38arAfm5FXGctXqQKEGckDzNDg27JwZZ1djuAl4gr
	 AnVFaKYf4jETio6fCrr4kPCa7aUP3PJ9qHM1kZ1CVfKPbusjYv/G31EvKZfLminPcN
	 hpKRUdfML5TfBwMAumsvNoJlABdgINsspjsDgdc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0b1279812c46e48bb0c1@syzkaller.appspotmail.com,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/826] erofs: fix file-backed mounts over FUSE
Date: Tue,  3 Dec 2024 15:41:14 +0100
Message-ID: <20241203144757.296721196@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 3a23787ca8756920d65fda39f41353a4be1d1642 ]

syzbot reported a null-ptr-deref in fuse_read_args_fill:
 fuse_read_folio+0xb0/0x100 fs/fuse/file.c:905
 filemap_read_folio+0xc6/0x2a0 mm/filemap.c:2367
 do_read_cache_folio+0x263/0x5c0 mm/filemap.c:3825
 read_mapping_folio include/linux/pagemap.h:1011 [inline]
 erofs_bread+0x34d/0x7e0 fs/erofs/data.c:41
 erofs_read_superblock fs/erofs/super.c:281 [inline]
 erofs_fc_fill_super+0x2b9/0x2500 fs/erofs/super.c:625

Unlike most filesystems, some network filesystems and FUSE need
unavoidable valid `file` pointers for their read I/Os [1].
Anyway, those use cases need to be supported too.

[1] https://docs.kernel.org/filesystems/vfs.html

Reported-by: syzbot+0b1279812c46e48bb0c1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6727bbdf.050a0220.3c8d68.0a7e.GAE@google.com
Fixes: fb176750266a ("erofs: add file-backed mount support")
Tested-by: syzbot+0b1279812c46e48bb0c1@syzkaller.appspotmail.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241114234905.1873723-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c     | 10 ++++++----
 fs/erofs/internal.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 61debd799cf90..fa51437e1d99d 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -38,7 +38,7 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset,
 	}
 	if (!folio || !folio_contains(folio, index)) {
 		erofs_put_metabuf(buf);
-		folio = read_mapping_folio(buf->mapping, index, NULL);
+		folio = read_mapping_folio(buf->mapping, index, buf->file);
 		if (IS_ERR(folio))
 			return folio;
 	}
@@ -61,9 +61,11 @@ void erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb)
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
-	if (erofs_is_fileio_mode(sbi))
-		buf->mapping = file_inode(sbi->fdev)->i_mapping;
-	else if (erofs_is_fscache_mode(sb))
+	buf->file = NULL;
+	if (erofs_is_fileio_mode(sbi)) {
+		buf->file = sbi->fdev;		/* some fs like FUSE needs it */
+		buf->mapping = buf->file->f_mapping;
+	} else if (erofs_is_fscache_mode(sb))
 		buf->mapping = sbi->s_fscache->inode->i_mapping;
 	else
 		buf->mapping = sb->s_bdev->bd_mapping;
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 4efd578d7c627..9b03c8f323a76 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -221,6 +221,7 @@ enum erofs_kmap_type {
 
 struct erofs_buf {
 	struct address_space *mapping;
+	struct file *file;
 	struct page *page;
 	void *base;
 	enum erofs_kmap_type kmap_type;
-- 
2.43.0



