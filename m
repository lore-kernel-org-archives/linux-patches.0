Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACB74F797E;
	Thu, 17 Sep 2026 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658924; cv=none; b=rb22nmQrSG3Pz1M777Z806+jGHoBnIcCbHi+8OcnwBiZlPpVzXfWk4ulYj3g4L8rOAVYUardZk8szM3y30ycr3G1e3JNKCrmjO7BUiZOsaC+Yfs4gFFdHzfbH0zDeSINQJR9ca1GvX1Z+PYIiJLScLEGZ7xgX8zxE1yMxb5bDxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658924; c=relaxed/simple;
	bh=4jBUIW5i2/0mKJYiQ8w7+A2+Fhn6XB8uvgZfkrRyt8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKfFCrqyKOwDHigEN5eUzWkLQIsMWM7J4bSmn3K1ZRCHhRdaQZ1lh9sN3PDzCDAOxGqsu4wbwY8boMBfCTD06zDh7Ny9ar9xMwno90dYdnkW13G6QDmwtgpW4z8ksd0b8dp7kcihKtnEFZUylK//GLv/isSIQJV4czkuMCkFQfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogjeC7Me; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogjeC7Me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DDE1F00898;
	Thu, 17 Sep 2026 15:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658916;
	bh=zPtO7emmHINfbD237vhGRc64ZkwOjWrZasGAUnTMuSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogjeC7MeqwY8NBxFiYUTGlH0zFz1NNn6AMeJqmUSC0JnA8yaxrjlUjgnB8AzVeCkj
	 rOSR46v/rCoGgiWLrL2vdsSk2MHQQnMVBLQ9vDm/6f3+VZAL1id/xFlEpZsjpV1vct
	 gD2EZaZBLFzD96ZuSngWHYz7KWPGgbeanIWjJxEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 044/733] ntfs: skip free cluster decrement when rollback fails
Date: Thu, 17 Sep 2026 16:05:52 +0100
Message-ID: <20260917151351.863635434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 5f2a22b36fe34c98f6d5e35ddb759ee53d684145 ]

When the rollback in __ntfs_cluster_free() fails, the recursive
call returns a negative errno and the subsequent
ntfs_dec_free_clusters(vol, delta) subtracts that negative value,
adding bogus clusters to the counter on an already-failing volume.

Skip the decrement when the rollback failed.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/lcnalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index 795f71d26895f..0d6cd08ee2e76 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -1045,8 +1045,9 @@ s64 __ntfs_cluster_free(struct ntfs_inode *ni, const s64 start_vcn, s64 count,
 			"Failed to rollback (error %i).  Leaving inconsistent metadata!  Unmount and run chkdsk.",
 			(int)delta);
 		NVolSetErrors(vol);
+	} else {
+		ntfs_dec_free_clusters(vol, delta);
 	}
-	ntfs_dec_free_clusters(vol, delta);
 	up_write(&vol->lcnbmp_lock);
 	memalloc_nofs_restore(memalloc_flags);
 	ntfs_error(vol->sb, "Aborting (error %i).", err);
-- 
2.53.0



