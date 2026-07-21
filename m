Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673893382C7;
	Tue, 21 Jul 2026 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656237; cv=none; b=beoDQXWHWTgBbdXKd8+LeFtVc2MRbnbjz7Lh6KQVdTZLu4tITC2VGCMSS1QOx/SD/Tia9F6tGSIGhYAmQaeZ7izhP+6jc/AVZRRoZkuD559bP2rJCcEzMRwfOMQ67dFadRdnk5/SiAc0vxUN3t0K//DFFiCxj2punuofflhI/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656237; c=relaxed/simple;
	bh=75nh0qcsmdhuAVThet7D/5y3j5jeECuWdUmwfQp/nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqtLPydgJ2N2vFbR+TokKM8RjzZs2fTgRjeq+OPWKCayA6M3Rc3j3XY5MPukCVI+fIF8tpDnyv4QOqSza6gjpyWmIKTjwDXfMoklk8bqSj1wpHKhG0p9Q1Odb6b5k2rDLTL0I5hZWdoRg4LT7oFgNg0ckjhVEpniI0hX/Y+vRys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zz0JAfQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zz0JAfQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE01D1F000E9;
	Tue, 21 Jul 2026 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656236;
	bh=rZTpxylGSGCTLedx2bXsuPp5gf2ENneNZc/tdkIQffk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zz0JAfQv9x2Rdirj83z83J25HlKIEJXi7N+rDW/LPtydm0C8Ryrw/aUXLGtfiqFcr
	 EA2EMaaHkCKh/LC/94zD4kj0ocg2ND1FpXQ1HMfwkh0wSFsP3ADgZI7XhNiVrqHsai
	 sz0ll+qKtklfG4kjqlIjvt6vYSjmrUlclF5ChmN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0310/1611] ext2: fix ignored return value of generic_write_sync()
Date: Tue, 21 Jul 2026 17:07:06 +0200
Message-ID: <20260721152522.049153086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 76bddce462fced..c59c19e5ff72ba 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -264,12 +264,15 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
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



