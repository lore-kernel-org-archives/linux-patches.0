Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF22A3AA9CA;
	Sat, 17 Oct 2026 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255507; cv=none; b=VKB4v9dAN98N3YgWWm0RVXasSO0U5EFcI3KPAoAc7Whvix3fL94WD0D01on5cKyGR3wiAH56TkS6RrRnnz+SMj0FQx78+XLz6CMi5k9sGuOi/ANJbBfIhHvGliRBRuKG2wzVqSX64eufzNobSEO4D5kHps3anS/uJN9RTFvyXEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255507; c=relaxed/simple;
	bh=OLkXe5Htha9qKnMa8kTopMNrOscbL8oO0xrBzwUBkIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foC1fFZSNWYpqDUFmvTjJVZAsvIxzBFOayjNoN6mtiUDM4GOIDFk7ctSvUIist5J+K+Zm8ycymvH73GxzXiTxD/tPzDHxDGNLSGyyRBx7T8ghLcYTQg8HigDd0kDtTKDkKgt3muFBU6GIC5wrysVUDkYLCZ8/yLAq/iPO4Pi9Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETvzcvyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETvzcvyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407961F000C5;
	Sat, 17 Oct 2026 16:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255506;
	bh=p7TTh9h2piKldKG//XIEFOi+5jaz4pDlUGgyqJIujmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETvzcvybpSkyDp9tHbHocveGuIoxYio8bCVEt8ziIEbDflIHsCRRuFizz1GBVQIgn
	 WOklJtihU8Sw+loV81qsPUnZYEliNAvju9QCrAxJn/ZidqUoHjbYBXmXguwmYNrs4M
	 DPyV1qGG/IxO20NFuN0tjVc8auskAakQNorMLvXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	FAN YE <fy15309206903@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 792/869] btrfs: zstd: fix lost wakeup when waiting for a workspace
Date: Sat, 17 Oct 2026 18:00:33 +0200
Message-ID: <20261017160057.213991305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FAN YE <fy15309206903@gmail.com>

[ Upstream commit 2acb9f3d1cc8f65dc81ed55e238cbf8e5b60bff7 ]

A writer can sleep forever in zstd_get_workspace() even though a workspace
is free.  When zstd_alloc_workspace() fails, the task is queued on
zwsm->wait and schedules unconditionally, never re-testing the pool.
zstd_put_workspace() publishes the workspace and then calls cond_wake_up(),
which only wakes when a sleeper is already visible, so a workspace returned
between the failed allocation and prepare_to_wait() wakes nobody.  The
window is wide: zstd_alloc_workspace() goes through kvmalloc() and may
enter reclaim.

Only a max level workspace triggers the wakeup and one is deliberately kept
allocated as the fallback every waiter waits for, so once its wakeup is
lost the writer stays in TASK_UNINTERRUPTIBLE until some other task happens
to return one.  Re-check the pool after prepare_to_wait() has published the
waiter, and use the workspace if one turned up.

Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
Assisted-by: Claude:claude-opus-5
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: FAN YE <fy15309206903@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zstd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index c9ea37fabf659..732a84c0f6b1e 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -290,8 +290,17 @@ struct list_head *zstd_get_workspace(unsigned int level)
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&wsm.wait, &wait, TASK_UNINTERRUPTIBLE);
-		schedule();
+		/*
+		 * Re-check after being queued: zstd_put_workspace() only wakes
+		 * a queue that already has a sleeper, so a workspace returned
+		 * since the failed allocation woke nobody.
+		 */
+		ws = zstd_find_workspace(level);
+		if (!ws)
+			schedule();
 		finish_wait(&wsm.wait, &wait);
+		if (ws)
+			return ws;
 
 		goto again;
 	}
-- 
2.53.0



