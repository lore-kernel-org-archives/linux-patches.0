Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F684E322C;
	Thu, 17 Sep 2026 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665522; cv=none; b=e+Pe5rKtdQepEKrTvt0LOFELxRpWmNLIayRrs7BrCZR4pRdQV9LeV71scELDU8cMwyaHpPlRUu1LkigboaERC0HWoKwU+q5PlGZOa97DoKYTYp7JWHqUjvEqQz2Q803Wvhk1ZBpNGZ68pPgc9DkmTKT2PBBjwbxPCWnCYYj5syc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665522; c=relaxed/simple;
	bh=6ZVLYtAGwRtlr3nV7+p7R5FKwWypz4BqgDARTri5XxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqVuwGzw5/JfZhgSRGAuiZIaetRL0HaQRTd6CbACUI94jp5QedIJT9+LQ4a2dNnJySd4c6Ji0Pe7ibjHwgpCXlgagE7P+ov7X+NDCYc0U4TIPsniG67qL/5/zzyrOFm0GrYZnpJozDw96BCcMapsyilUswCgd7MLR/CxRU2VrlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKA6utXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKA6utXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F3D1F000FF;
	Thu, 17 Sep 2026 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665521;
	bh=7j9SPqmJ3A6y52STBkNazWd8Ujmgv0yj1421liBBb9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKA6utXUcYQK2HNZokqPjRhjqP6t7D+B6dr5WxSnJnfwSkhqoduPgHfF5VLx1W59A
	 bpqq39kBO76cZkWbICNn7S65B92LTKY8OwU7KmqNSwpL5wSh+ft5lTQhnHG4Ju+MgA
	 FDgB+OKIF2eBzBBWUPmWkdk8Prv2VWJRcJlMo6ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	FAN YE <fy15309206903@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0730/1250] btrfs: zstd: fix lost wakeup when waiting for a workspace
Date: Thu, 17 Sep 2026 16:08:45 +0100
Message-ID: <20260917151611.676547827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index c9cddcfa337b9..baaf3c1436323 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -307,8 +307,17 @@ struct list_head *zstd_get_workspace(struct btrfs_fs_info *fs_info, int level)
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(&zwsm->wait, &wait, TASK_UNINTERRUPTIBLE);
-		schedule();
+		/*
+		 * Re-check after being queued: zstd_put_workspace() only wakes
+		 * a queue that already has a sleeper, so a workspace returned
+		 * since the failed allocation woke nobody.
+		 */
+		ws = zstd_find_workspace(fs_info, level);
+		if (!ws)
+			schedule();
 		finish_wait(&zwsm->wait, &wait);
+		if (ws)
+			return ws;
 
 		goto again;
 	}
-- 
2.53.0



