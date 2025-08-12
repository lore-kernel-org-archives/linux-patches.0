Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061A2DFA3E;
	Tue, 12 Aug 2025 18:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022868; cv=none; b=LC+wqyXEukZ9zpkkqbjc/dbMpzLG5jWMpM16Q3bF3Os7//u76g8O7pD90pL4wO/zA/ZwM1XZod9gZUiRpWRmEGYBjdSLughJeCMZDV/KwKfidgp2IebxS7jF5c9nRuGEdp/mpJLzdQa2dvb/SX/hDsFo/gs8Wtxm5BJb4hxqe7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022868; c=relaxed/simple;
	bh=nqYFghbd0MwTZbW9bBJXTKv48FBnXLNWbHeUsve52+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuEz2kMGr50az9hARb0ZaJ4zq2zkR0J8VJBZUaqTtCzzREqCZfM4XEKFHhvZ2DTYb53gP3ct7uyDujQpaRvZ/dHVDHMm/uv7IXAnFdeqVVrStC+fDVlYYXtyN/18YwTwB30iM54NHueJtQt0SFPN0izJpI0Fj4QTLaJeloJnfy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd5BHpZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd5BHpZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BBDC4CEF1;
	Tue, 12 Aug 2025 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022867;
	bh=nqYFghbd0MwTZbW9bBJXTKv48FBnXLNWbHeUsve52+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zd5BHpZ/8BS25H/QKGSeqaCNey/BeiusKColH/sW25litt2dSEISGsXn2KQBVmJK6
	 ERo4o7wlpilhw+yltk/fI2eK/fGALwhlmnGe8Sepaihl51BdMuTN9iTtEW2RFyKDHj
	 PRZ81vE/m8KZU4iRTk7/Ra62he3MZB2qGytIAA4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/369] f2fs: fix bio memleak when committing super block
Date: Tue, 12 Aug 2025 19:29:07 +0200
Message-ID: <20250812173024.167430367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Sheng Yong <shengyong1@xiaomi.com>

[ Upstream commit 554d9b7242a73d701ce121ac81bb578a3fca538e ]

When committing new super block, bio is allocated but not freed, and
kmemleak complains:

  unreferenced object 0xffff88801d185600 (size 192):
    comm "kworker/3:2", pid 128, jiffies 4298624992
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 80 67 c3 00 81 88 ff ff  .........g......
      01 08 06 00 00 00 00 00 00 00 00 00 01 00 00 00  ................
    backtrace (crc 650ecdb1):
      kmem_cache_alloc_noprof+0x3a9/0x460
      mempool_alloc_noprof+0x12f/0x310
      bio_alloc_bioset+0x1e2/0x7e0
      __f2fs_commit_super+0xe0/0x370
      f2fs_commit_super+0x4ed/0x8c0
      f2fs_record_error_work+0xc7/0x190
      process_one_work+0x7db/0x1970
      worker_thread+0x518/0xea0
      kthread+0x359/0x690
      ret_from_fork+0x34/0x70
      ret_from_fork_asm+0x1a/0x30

The issue can be reproduced by:

  mount /dev/vda /mnt
  i=0
  while :; do
      echo '[h]abc' > /sys/fs/f2fs/vda/extension_list
      echo '[h]!abc' > /sys/fs/f2fs/vda/extension_list
      echo scan > /sys/kernel/debug/kmemleak
      dmesg | grep "new suspected memory leaks"
      [ $? -eq 0 ] && break
      i=$((i + 1))
      echo "$i"
  done
  umount /mnt

Fixes: 5bcde4557862 ("f2fs: get rid of buffer_head use")
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3f2c6fa3623b..875aef2fc520 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3388,6 +3388,7 @@ static int __f2fs_commit_super(struct f2fs_sb_info *sbi, struct folio *folio,
 		f2fs_bug_on(sbi, 1);
 
 	ret = submit_bio_wait(bio);
+	bio_put(bio);
 	folio_end_writeback(folio);
 
 	return ret;
-- 
2.39.5



