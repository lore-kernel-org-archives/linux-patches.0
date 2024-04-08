Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E1F7F467;
	Mon,  8 Apr 2024 13:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581987; cv=none; b=kiOkxaNkSMEGoRlCPB14SjSvmLu1i5i+gdHv+EpW6iU902ta0iQRI9O+Z9F6kGf12ZQBvm9W+ZmrtE3b5V+sthdnIr7m6gZyHb+2VkN7iLyc6rGa8QQu7Y5tj5e59IIRVTH5UUJ4OE4VyfwYzaej3n9Fc15J3z8PGjQ0cVZvpkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581987; c=relaxed/simple;
	bh=i4ixOYZ74czkSGwS5e1i41KgZdPp/JYArNN6xSba4NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJp8LqWU6AfwLRt/MOciNc7KrssDGjqDrQMV0rgRWpjwOPRIlp+5S/G1Vv3ajCcukAgP0VwyxGzLNZvStSuiT6X+vJApLyyILrY2nsVpVSoxm2RW+lORRigpMn9mr3pJhCvQQQPlwiRDGb+b5ItJmwVvTEihi5ECULhR32R95Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yL264CpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yL264CpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D90DC433B1;
	Mon,  8 Apr 2024 13:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581987;
	bh=i4ixOYZ74czkSGwS5e1i41KgZdPp/JYArNN6xSba4NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yL264CpO2cKnyqwijmNhgMtD2NWDQy8tc91FxtUc0Cwk43yH19ejBQgWwO8hgTI9V
	 NXO7nf/rg9hmZLWCp1Lu3lEPMULmOx9gQsbSXsbhWjnQikKUdbpuQEJ3//QDTq4KiF
	 tvorPLu6oOf/X728DudHmwPawJArvHz7f+LHgXz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/690] nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Mon,  8 Apr 2024 14:49:28 +0200
Message-ID: <20240408125403.186804379@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 269cdf353b5bdd15f1a079671b0f889113865f20 ]

Fix a bug where nilfs_get_block() returns a successful status when
searching and inserting the specified block both fail inconsistently.  If
this inconsistent behavior is not due to a previously fixed bug, then an
unexpected race is occurring, so return a temporary error -EAGAIN instead.

This prevents callers such as __block_write_begin_int() from requesting a
read into a buffer that is not mapped, which would cause the BUG_ON check
for the BH_Mapped flag in submit_bh_wbc() to fail.

Link: https://lkml.kernel.org/r/20240313105827.5296-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 324e23236c341..475fd522c7e3f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -112,7 +112,7 @@ int nilfs_get_block(struct inode *inode, sector_t blkoff,
 					   "%s (ino=%lu): a race condition while inserting a data block at offset=%llu",
 					   __func__, inode->i_ino,
 					   (unsigned long long)blkoff);
-				err = 0;
+				err = -EAGAIN;
 			}
 			nilfs_transaction_abort(inode->i_sb);
 			goto out;
-- 
2.43.0



