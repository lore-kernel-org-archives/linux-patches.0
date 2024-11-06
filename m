Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98301DED58;
	Wed,  6 Nov 2024 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896012; cv=none; b=CJzpYAtNn8TPlajjbpKXbQHEm8gHKwLXmMlpVJxTAlPrpJOieBju93cH9LrnbobX3NgBtY+03v7vEuaLqyns2BPYwHNYR2COKl+HxQjJOpuU1zDcLudQ4swMXjhJbq7reDbplf+ZjbIGO68Kc2ctVTBcJhGyeYQ84KJJvIkoQXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896012; c=relaxed/simple;
	bh=0U3XUqH3A5ouYA9Juk7pjqRvx2c69tQbZYhP9mf2jfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/H4VbrYnKGhpOhs/1wJO8mGEPwfDjpStCU6G/ThBewEeWOaGDvTPjHPbwI+oFuY8LmYPkeiTINTb+Qtq0VDKLnvpyHRU3YoSmfW8Dn5yeMihkJ563U1782Zs1jpuKulpqbs4uGn57lYJAsjj7QEC7OdibYj+X2nH6unIC+QeiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvhL75Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvhL75Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D716C4CECD;
	Wed,  6 Nov 2024 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896012;
	bh=0U3XUqH3A5ouYA9Juk7pjqRvx2c69tQbZYhP9mf2jfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvhL75HvWBSgCnV45Riam630AkO238xxedVKAPoDv3WXU99fGta5fwIYYV5p3uQ/P
	 u9AOWTm7fJvP5iKYqojFMnsLLr/umqh9NKUroUp/jrQoYJbEOgR/BEYPsWPvyrW4sb
	 9H9tGW+BY9krDM3VzNwX0mzVCxHEKKm9sURoX6Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruansy.fnst@fujitsu.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 060/245] fsdax: remove zeroing code from dax_unshare_iter
Date: Wed,  6 Nov 2024 13:01:53 +0100
Message-ID: <20241106120320.685604600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 95472274b6fed8f2d30fbdda304e12174b3d4099 ]

Remove the code in dax_unshare_iter that zeroes the destination memory
because it's not necessary.

If srcmap is unwritten, we don't have to do anything because that
unwritten extent came from the regular file mapping, and unwritten
extents cannot be shared.  The same applies to holes.

Furthermore, zeroing to unshare a mapping is just plain wrong because
unsharing means copy on write, and we should be copying data.

This is effectively a revert of commit 13dd4e04625f ("fsdax: unshare:
zero destination if srcmap is HOLE or UNWRITTEN")

Cc: ruansy.fnst@fujitsu.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/172796813311.1131942.16033376284752798632.stgit@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5064eefb1c1e4..9fbbdaa784b43 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1276,14 +1276,6 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	if (ret < 0)
 		goto out_unlock;
 
-	/* zero the distance if srcmap is HOLE or UNWRITTEN */
-	if (srcmap->flags & IOMAP_F_SHARED || srcmap->type == IOMAP_UNWRITTEN) {
-		memset(daddr, 0, length);
-		dax_flush(iomap->dax_dev, daddr, length);
-		ret = length;
-		goto out_unlock;
-	}
-
 	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
-- 
2.43.0



