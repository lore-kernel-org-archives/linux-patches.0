Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BA66F2F7;
	Wed,  7 Aug 2024 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042956; cv=none; b=baGFNCKvWTOl28NFKIRNuxWdZer2jzhjBzsBsfgcY2v69t3Jp5vxNVZoe73FMbi5SLZCDcnhDycZHouCmvle/7wuGF/BXnu0GV74S/FiKMdAZwlCVtrHoyUOJzNESX1BbYOlAwZaH3IjugKFE6+vDe1z5YtXfdkpttZfRErerr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042956; c=relaxed/simple;
	bh=bwvQ+4+O/hHt60vT0/Yx+GmjlpRMyZPfEjDaMxUSbvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjemO1Bd8oDLtnayxLTcAdQaPO9QSMHDTg22Vffm5lPKZNFMDqm040k4HtiPEo95Hgr3UbYxgLWYHIAOzk+X2Nm7y+9x4v1jk9mdeSovb/KIkEYcvmDF8j3JvwpcNOj8gMrIf013vqxy0t6c7sRXNWvkOP2aIW3UlzWAn93+F4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4ngXY5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4ngXY5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FCAC32781;
	Wed,  7 Aug 2024 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042956;
	bh=bwvQ+4+O/hHt60vT0/Yx+GmjlpRMyZPfEjDaMxUSbvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4ngXY5i/9PJ8ufKYxoBSE15RbIZZWoQtGxVA5/r/kxjNR5Q7/qvVJtMNcb+VjPon
	 7I4UCvD6nNEdotgKOx2xbKysj9XdL0k/IUDdxFIt0gzqV4sFtSkOqLuLr/kQmfCnDH
	 5a0PeMcgLV0oSc8fM/UHjYgzTcLXnphx9WEQz69M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Will McVicker <willmcvicker@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 009/123] f2fs: assign CURSEG_ALL_DATA_ATGC if blkaddr is valid
Date: Wed,  7 Aug 2024 16:58:48 +0200
Message-ID: <20240807150021.117423000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 8cb1f4080dd91c6e6b01dbea013a3f42341cb6a1 ]

mkdir /mnt/test/comp
f2fs_io setflags compression /mnt/test/comp
dd if=/dev/zero of=/mnt/test/comp/testfile bs=16k count=1
truncate --size 13 /mnt/test/comp/testfile

In the above scenario, we can get a BUG_ON.
 kernel BUG at fs/f2fs/segment.c:3589!
 Call Trace:
  do_write_page+0x78/0x390 [f2fs]
  f2fs_outplace_write_data+0x62/0xb0 [f2fs]
  f2fs_do_write_data_page+0x275/0x740 [f2fs]
  f2fs_write_single_data_page+0x1dc/0x8f0 [f2fs]
  f2fs_write_multi_pages+0x1e5/0xae0 [f2fs]
  f2fs_write_cache_pages+0xab1/0xc60 [f2fs]
  f2fs_write_data_pages+0x2d8/0x330 [f2fs]
  do_writepages+0xcf/0x270
  __writeback_single_inode+0x44/0x350
  writeback_sb_inodes+0x242/0x530
  __writeback_inodes_wb+0x54/0xf0
  wb_writeback+0x192/0x310
  wb_workfn+0x30d/0x400

The reason is we gave CURSEG_ALL_DATA_ATGC to COMPR_ADDR where the
page was set the gcing flag by set_cluster_dirty().

Cc: stable@vger.kernel.org
Fixes: 4961acdd65c9 ("f2fs: fix to tag gcing flag on page during block migration")
Reviewed-by: Chao Yu <chao@kernel.org>
Tested-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 92331f8dbe4e3..601825785226d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3484,6 +3484,7 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type == FS_DATA_IO) &&
 				(fio->sbi->gc_mode != GC_URGENT_HIGH) &&
+				__is_valid_data_blkaddr(fio->old_blkaddr) &&
 				!is_inode_flag_set(inode, FI_OPU_WRITE))
 				return CURSEG_ALL_DATA_ATGC;
 			else
-- 
2.43.0



