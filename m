Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D11F337110;
	Fri, 17 Oct 2025 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713899; cv=none; b=gVg93dozuYSXXjvKQs69vpJp3zfTQiKJhF99eJeMgZi0WWAqy++X8ZzTcY3fkIEUveHnkuJeJ4kklo+UYymCR66YPtt/qOiq/0DjCPmmU8GFQD0zZgt+Qc0p1EkvG3lmWixTMDOPvhmkktk2hqSC30fTM/kYLIeV5CodzT0cxMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713899; c=relaxed/simple;
	bh=brsEMo2Qb9mYTX86VLstFPzczHOpyMvZKEolEg3CDCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8C8gQGdoo9A7+fIXmh3IFoRReLJvIxYZmoYJTiQ0Is1D1eNcdGm5XdyYoqHJZZlUq/dIbeITwXi5ijt1F7dYOU32ObQeHQGn+GZhg4M+57PkG4mK3GjEajMwXOB1wCJO/+aM3tZAR4FuOaR4UUkM4OyH73twEoDEqL3rEQD/lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxJzHuBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxJzHuBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E466C4CEE7;
	Fri, 17 Oct 2025 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713898;
	bh=brsEMo2Qb9mYTX86VLstFPzczHOpyMvZKEolEg3CDCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxJzHuBJF4WSs1fv/3dJchjm7y/bPpyICwr9PORqsJ5+18U6gkI2HOQBKSWEy3akM
	 tjSDP/79OaqIXK2s3I2GukQ1jSDgiyvBm+vD243iHs783WkLckuLDR24kg56T3PXms
	 QT4kg2P/IGVnb4dmiYx4ex+iHAKhzXsVEiq+ihDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 151/201] ext4: fix an off-by-one issue during moving extents
Date: Fri, 17 Oct 2025 16:53:32 +0200
Message-ID: <20251017145140.280016363@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

commit 12e803c8827d049ae8f2c743ef66ab87ae898375 upstream.

During the movement of a written extent, mext_page_mkuptodate() is
called to read data in the range [from, to) into the page cache and to
update the corresponding buffers. Therefore, we should not wait on any
buffer whose start offset is >= 'to'. Otherwise, it will return -EIO and
fail the extents movement.

 $ for i in `seq 3 -1 0`; \
   do xfs_io -fs -c "pwrite -b 1024 $((i * 1024)) 1024" /mnt/foo; \
   done
 $ umount /mnt && mount /dev/pmem1s /mnt  # drop cache
 $ e4defrag /mnt/foo
   e4defrag 1.47.0 (5-Feb-2023)
   ext4 defragmentation for /mnt/foo
   [1/1]/mnt/foo:    0%    [ NG ]
   Success:                       [0/1]

Cc: stable@kernel.org
Fixes: a40759fb16ae ("ext4: remove array of buffer_heads from mext_page_mkuptodate()")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20250912105841.1886799-1-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index adae3caf175a..4b091c21908f 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -225,7 +225,7 @@ static int mext_page_mkuptodate(struct folio *folio, size_t from, size_t to)
 	do {
 		if (bh_offset(bh) + blocksize <= from)
 			continue;
-		if (bh_offset(bh) > to)
+		if (bh_offset(bh) >= to)
 			break;
 		wait_on_buffer(bh);
 		if (buffer_uptodate(bh))
-- 
2.51.0



