Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7497179FD;
	Thu, 11 Apr 2024 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831738; cv=none; b=Oew01wieOekgun8zHAidI8l6RK0Ni41GYA87epV0JET3JORl89ZBWf+wd2MInzyZY/SB0mfkCSW4b25a09UT8oDHsumpLgQuE8lJ6E4hBFpjoYKB/gwguIeD3Uj4pOwa/B7hyf1WOP2RNe7g11pGWAF+qYDxorGIwG8yDiA854k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831738; c=relaxed/simple;
	bh=8ufM0Q5t4MUB+JWeWFT0qB9R/WmxsGcXyaXzR1SMtzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvOyEnOk0mfzB0xpyC9NrNftn/wbGMAhYe2qw7HnZg6N+HVT0TeImep7QdNTTkKlpr4ysfoAhLU4LSetVEH1DZhFNPFg41Yx8wQT0GcguTrGPJoQeas5Alf6Z+dj+agP6Q9gqhjPPr3vn2Vl9NA3ZyWFGQJ5XjrXCnIYhCrC9+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGo8RPjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGo8RPjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF703C433F1;
	Thu, 11 Apr 2024 10:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831738;
	bh=8ufM0Q5t4MUB+JWeWFT0qB9R/WmxsGcXyaXzR1SMtzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGo8RPjdjIrfOR9/jo0XnsXar/yFDpl1jlYt0I+N6+WRaHAd8++3HVNdIMvFTGKAw
	 5EdH/5Hup6c49R6zK0d4xto6Lqwm4n/WGTn30BWPcMboX22x2eptamVTy0VonX74ix
	 w/R+qWesItf1dDXmSvCYufqwncu5ugcUxoriGG8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/294] nilfs2: prevent kernel bug at submit_bh_wbc()
Date: Thu, 11 Apr 2024 11:54:25 +0200
Message-ID: <20240411095438.742965416@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d144e08a9003a..06f4deb550c9f 100644
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



