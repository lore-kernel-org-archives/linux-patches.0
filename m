Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857763451D5;
	Tue, 26 Aug 2025 13:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215956; cv=none; b=qEcMKj1lr9KoRhlKgRe34RUgtJa9cwcs00Aj4b91pboeYF7MMW0VQ61nxO1xpQNainCGmTsWqJl5MxZdACs7vJA6RXLNMTsLmOHhH+AjN2FNqHWxamJo6SgIBx8VUB01EY+SzU33mP/wLOlWDGEahJVU7rBoKCdYhqOVZSwrsJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215956; c=relaxed/simple;
	bh=fdRZvGyacOacbx1Pd5URP9930axNkhpQWy4Kigy/NK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui244zJYrND+12q0FqgF42ovaFbM99KlCgIw2rSkOjCoel//zq+/zCvolqNwx7jOrDMn5atLxVK+x/2wSarzMpgWKcePLuPtU9I1d8egVwjKX+AGEKWpHuPUIDqIOwv7WEc8nOIuAVKFU5GVHVL8hRx2kA6xhTHrYC1EQufDKHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJAg56Zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJAg56Zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C018EC4CEF1;
	Tue, 26 Aug 2025 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215956;
	bh=fdRZvGyacOacbx1Pd5URP9930axNkhpQWy4Kigy/NK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJAg56ZzwGfyTtfaQEVpNAfWXpC62d97M3TLrZewPhTu5W7Rp8sh6QcR8tUu0vNk2
	 /J0EG9ozN9LuFSb9fTe9TGBe3Cgg/FY32o9GwnrrhlW4wZmRPIyv8j8zaY7rExVBui
	 u0l7cnIinS/6p+mLGr7U6pCyGDDGs0TpWw7yLgCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yu <zheng.yu@northwestern.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/644] jfs: fix metapage reference count leak in dbAllocCtl
Date: Tue, 26 Aug 2025 13:04:49 +0200
Message-ID: <20250826110951.351731134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yu <zheng.yu@northwestern.edu>

[ Upstream commit 856db37592021e9155384094e331e2d4589f28b1 ]

In dbAllocCtl(), read_metapage() increases the reference count of the
metapage. However, when dp->tree.budmin < 0, the function returns -EIO
without calling release_metapage() to decrease the reference count,
leading to a memory leak.

Add release_metapage(mp) before the error return to properly manage
the metapage reference count and prevent the leak.

Fixes: a5f5e4698f8abbb25fe4959814093fb5bfa1aa9d ("jfs: fix shift-out-of-bounds in dbSplit")

Signed-off-by: Zheng Yu <zheng.yu@northwestern.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index cfb81bf5881e..c2d4349cd959 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1877,8 +1877,10 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
 			return -EIO;
 		dp = (struct dmap *) mp->data;
 
-		if (dp->tree.budmin < 0)
+		if (dp->tree.budmin < 0) {
+			release_metapage(mp);
 			return -EIO;
+		}
 
 		/* try to allocate the blocks.
 		 */
-- 
2.39.5



