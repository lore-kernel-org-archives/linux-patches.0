Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4304E3769;
	Thu, 17 Sep 2026 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658922; cv=none; b=GiszbZ9OodYQ8uo+AwODP/SP8PbgiNnS6XJmJR3EdA1dyvBxq+VMf4MtH4ZdGq21LAwpzzOqzd8gYKMxKoCBKFsVjjjgezp+resA/4PS3VJCUfZhqwrhwkYLuKtrDqdJReBJMJhBL5LFlIE9awQDTrJWPYiv+RKCpt7amnZ2hdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658922; c=relaxed/simple;
	bh=8TPqDg7iCwZpO2NOQSao3JYs1dqfcD77eAJxCpb/5uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuNufBIhyzLJ2HBJklWvGHp8loYLfzsa2bHFhfhIn5SebLO16anvTuQbv1QPXouqIwegC29ltnstfKksz1dprkCTOUn/4EdHWTK8o3OXZzPEroYzFTbmQFb7fEyfmXvuJQWHgWZZHzjisqi3M5zgTaNAN+dDBCJSKCRPIT0jel8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGsOotOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGsOotOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE35A1F00893;
	Thu, 17 Sep 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658913;
	bh=AB2wbfT6vyfKtDY9Bi/IZBuRQb4vMY5oNnVBVMTPiPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGsOotOuynNX6cFDrhm1utCQyLocW6fiqnu7eOXguV0cdFeZXJTvqvhsjj4hRRKGs
	 bYw/oYxmefFlaEx5rULObgjxjmR1LCfU0ej4pid1sfldI8vt2cQP3XT99hOak0k7ij
	 w4EriOg8GxIbPcPYNYhUilz9wzdREmzNyBWFcsWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 043/733] ntfs: only count successfully cleared runs when freeing clusters
Date: Thu, 17 Sep 2026 16:05:51 +0100
Message-ID: <20260917151351.834006317@linuxfoundation.org>
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

[ Upstream commit be9e89ccb8e52a3e4b67feeb03ebd8133091dc7e ]

ntfs_cluster_free_from_rl_nolock() adds a run's length to nr_freed
whenever the error bookkeeping condition is false, which includes
cases where ntfs_bitmap_clear_run() actually failed - e.g. a second
run failing with the same errno as an earlier one, or any failure
after a non-ENOMEM error was already recorded. Since a failed
ntfs_bitmap_clear_run() rolls back its partial modifications, no
bits were cleared for that run, yet its length still inflates
vol->free_clusters, corrupting statfs output and the allocator's
free space gate.

Only count runs whose bitmap clear succeeded.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/lcnalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index aa2e017a43844..795f71d26895f 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -53,10 +53,10 @@ int ntfs_cluster_free_from_rl_nolock(struct ntfs_volume *vol,
 		if (rl->lcn < 0)
 			continue;
 		err = ntfs_bitmap_clear_run(lcnbmp_vi, rl->lcn, rl->length);
-		if (unlikely(err && (!ret || ret == -ENOMEM) && ret != err))
-			ret = err;
-		else
+		if (likely(!err))
 			nr_freed += rl->length;
+		else if (!ret || ret == -ENOMEM)
+			ret = err;
 	}
 	ntfs_inc_free_clusters(vol, nr_freed);
 	ntfs_debug("Done.");
-- 
2.53.0



