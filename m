Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B762E3B06;
	Tue, 12 Aug 2025 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022668; cv=none; b=jcGLmSbao9RKGKsZlmTV8/L0+1i68DeUSl+njLOHaZQJPs3njLBuFdjTo68Pl1mYRm4ppQXAf5XV9pTmfUyNl+zy7xS/yci97cY5vOHpAJqjPb0ePvj9h4sGRItqylycT8ojpMmAxipT/JLCbOpLOTfqidonfzIvirqc0ffSiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022668; c=relaxed/simple;
	bh=o6RIn0a4l6LcvnDg1ReMHMM3xuAEgQN1jrn8dMUiVFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5nJU8SA5yL3XnqkHg7OVzvlm/ZVBf5TYbxdJU6IoIombCGnxDiXxNrbV0wD+82Up4HsWelPKuBWA/WYdh8mOEKTXIoR+KCkzIuNQbGchfwzCsKbFSzqd8xTuM1wTI/ZhG+AZsnndOPmsmgayJpr/bakOZVUnszYxERJ5EIKvxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8R/73P2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8R/73P2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE135C4CEF7;
	Tue, 12 Aug 2025 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022668;
	bh=o6RIn0a4l6LcvnDg1ReMHMM3xuAEgQN1jrn8dMUiVFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8R/73P2zdyHRWZ48oz8R57r9t7IWfBSuv2aN6Mv9+crkt3vBYF0VRto7zgDhp/il
	 Xt3IBLPDzc5HDJWv0EhcnERdHkVQldUMWDRJVlhxrfcOEJsdLbA5GIE1cHVhSAiRFg
	 zjxsU+o4LMp6V4ZBS+NE1xjpfE8+6ZCG19qDEbEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yu <zheng.yu@northwestern.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 224/369] jfs: fix metapage reference count leak in dbAllocCtl
Date: Tue, 12 Aug 2025 19:28:41 +0200
Message-ID: <20250812173023.183925080@linuxfoundation.org>
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
index 35e063c9f3a4..5a877261c3fe 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1809,8 +1809,10 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
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



