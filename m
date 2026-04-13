Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F33330D4C;
	Mon, 13 Apr 2026 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099478; cv=none; b=JCwiGiI/JQWE4YnZdp71NcqtR6wFFujdSo6BU8QDZwS+Z4cld7u2RNr/bVMMLw+pCqcfkagReSZMgydSkSbyQImVIN4K146Pjb6t5DAHrJ7ZRSb07+vkj78pwkmq+xbB3jGd+LQ4W31hYlb4esuwnuBS2rha14Nyeg8zRsdxOZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099478; c=relaxed/simple;
	bh=VqZvVzQz/7OvGjXg420arLP9ocE4tTjox06+3Fi49Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRvn0sW4OCEAULdcwJLJ4tHnX6BtKr3h6p1sm57v9Ly0YH7dg9jYP5kuhFlbPhqhnp3SKJgAxnyVzdOavPVHdztq3OEbJpVvKnPsTNsYUQqIUPJmpw7fFnBh9UHgfehgm62a/Z/bXkOHEW+ZVAi5oJTeGbvFDx70Pyb4laoYnNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKDNkprj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKDNkprj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26A0C2BCAF;
	Mon, 13 Apr 2026 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099478;
	bh=VqZvVzQz/7OvGjXg420arLP9ocE4tTjox06+3Fi49Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKDNkprjGiuy+fmmPBqtkM54xWSn09MXxNV63nENU6BwaacOylTxnje2YVxIDlZUE
	 E7AwVVDw6KV4eorM8zY/gHeZ7JByiUn0YIr10BujjocGjcgYYia2qqLTlUJfhJpcrH
	 P8HULsAwiv4S+7u+I3ULZtAyLTY+ts/vqtjmcHxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/491] btrfs: fix lost error when running device stats on multiple devices fs
Date: Mon, 13 Apr 2026 17:59:18 +0200
Message-ID: <20260413155830.757978214@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1c37d896b12dfd0d4c96e310b0033c6676933917 ]

Whenever we get an error updating the device stats item for a device in
btrfs_run_dev_stats() we allow the loop to go to the next device, and if
updating the stats item for the next device succeeds, we end up losing
the error we had from the previous device.

Fix this by breaking out of the loop once we get an error and make sure
it's returned to the caller. Since we are in the transaction commit path
(and in the critical section actually), returning the error will result
in a transaction abort.

Fixes: 733f4fbbc108 ("Btrfs: read device stats on mount, write modified ones during commit")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2bba6e8d43740..da77493f4c17d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7553,8 +7553,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
 		smp_rmb();
 
 		ret = update_dev_stat_item(trans, device);
-		if (!ret)
-			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
+		if (ret)
+			break;
+		atomic_sub(stats_cnt, &device->dev_stats_ccnt);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-- 
2.53.0



