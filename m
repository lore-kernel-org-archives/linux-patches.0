Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6F1199920;
	Tue, 21 Jul 2026 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665907; cv=none; b=kq8S8KdD/7jxuwXj/I9x7ao1Asy2lLQhCUvgx00PuICNDwwY9TTEFoW+mERq1XeBgLtKec/HwhLdTp0xSLyLVr4stwRUIRd4CCEOx9/YnJTwQX8uGbrWdS0y2jRGnpQNaD+etOkZVNJ8i9lGHpOX+C2XVSD1Apzbj+VG5n3EI6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665907; c=relaxed/simple;
	bh=lddt8yOt5t6Lb5Z6SPvZMQJpEhtK4T6Uczsf9TDYEkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyWdUnZGUhd9johWSwxYI+b3bsC3PX8CGLHznYIJ0mIW84ELb6r/d34JrHh9q18/ucgIuhg21FukzKMs6oFcgv+qmIMSOA3hui/ex60tyVQPPmkFORi+mTmpqnVg3AdSA1SXbRieoPl4ZZtWuUzesVKOiMNRWwTDiQgkfcux8qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOxU4FQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOxU4FQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A4C1F000E9;
	Tue, 21 Jul 2026 20:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665906;
	bh=1DCagdvTqQw6/n5OqRBZLA+OxieEtZ/ovLl5Gn8gd1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOxU4FQhyZA4623RVF5iwl3AtkDYabK2CJugGsarAwnVIL3mWVEOhS8xbAqMpNZZj
	 ERUkTxD2SjKt1YnHZwxywYc/tSyqz0MzMeKRKDFytRwJs4UKZa1EnZUo2po9LJsu+k
	 7e3FydkL2ovKTvswiEL2hqkBGFnHr+ZqUtJ59UIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0481/1266] ext2: fix ignored return value of generic_write_sync()
Date: Tue, 21 Jul 2026 17:15:18 +0200
Message-ID: <20260721152452.602510434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit a4659be0bc7cb1856ffb15b67f903229ae8891ec ]

Fix ext2_dio_write_iter() to propagate the error returned by
generic_write_sync() instead of silently discarding it, which could
cause write(2) to return success to userspace on O_SYNC/O_DSYNC files
even when the sync failed.

The correct pattern, already used in ext2_dax_write_iter() in the same
file and in ext4, xfs, f2fs among others, is:
    if (ret > 0)
        ret = generic_write_sync(iocb, ret);

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[JK: Reflect also filemap_write_and_wait() return value]

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Link: https://patch.msgid.link/20260530122311.136803-1-listdansp@mail.ru
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 4ddc36f4dbd407..a6913e4eb523e1 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -262,12 +262,15 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		endbyte = pos + status - 1;
 		ret2 = filemap_write_and_wait_range(inode->i_mapping, pos,
 						    endbyte);
-		if (!ret2)
+		if (!ret2) {
 			invalidate_mapping_pages(inode->i_mapping,
 						 pos >> PAGE_SHIFT,
 						 endbyte >> PAGE_SHIFT);
-		if (ret > 0)
-			generic_write_sync(iocb, ret);
+			if (ret > 0)
+				ret = generic_write_sync(iocb, ret);
+		} else {
+			ret = ret2;
+		}
 	}
 
 out_unlock:
-- 
2.53.0



