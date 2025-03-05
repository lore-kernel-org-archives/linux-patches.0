Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F020253F12;
	Wed,  5 Mar 2025 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198656; cv=none; b=AQs8kxc5oNN1N5ksDny/PNvIzjQbedRKF5jAAQakWjGwLXBgLs8S5D0JqFXyMJBKNHbUCGkiVO0VuoD1vGY2X4wL7S3IeF5ZTD0Y2RMb25UruNQDNrjO2aVLpLKp8WnMpqr47SZhKe4r6Y2SPOmy338gLzEyz5uYotw8DNR8Cg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198656; c=relaxed/simple;
	bh=sbAzgAZny5mEQdbiAwkncGX0J26/gleysGqJwDqMx98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aptUBiKkTnZj+qHu/ePqc2Wz8EPvlb1cY5oRlAln5Z/4BXy7FhvIac4WZdkRulwuURW3ccN5nvswDbgWEt7wv4bI4LajSpVE+6gzRAj56N+KsI+YefH1j6cjTLgao8LF8BczpqWZdZPzL4ucnLr1H4sRyYEuc3puXA0o1Vsx4PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS0ZYB47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS0ZYB47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07439C4CED1;
	Wed,  5 Mar 2025 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198656;
	bh=sbAzgAZny5mEQdbiAwkncGX0J26/gleysGqJwDqMx98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS0ZYB473emQHvOAngxyh1P8+Vgvo74MZD4IFRjeqEURqsw/RwMeBgbjAUXd4mlY6
	 RTqCSViBnxkQkrly5DsAk7YxNEvAJp9FR5+9jwAqn9t9jYEPu6cnnX1pABWC5KRLCw
	 Gnyiuk6+9ZimPjTskw9IURQouYUVBTw/xUGXhdvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 104/157] btrfs: do regular iput instead of delayed iput during extent map shrinking
Date: Wed,  5 Mar 2025 18:49:00 +0100
Message-ID: <20250305174509.487077310@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 15b3b3254d1453a8db038b7d44b311a2d6c71f98 upstream.

The extent map shrinker now runs in the system unbound workqueue and no
longer in kswapd context so it can directly do an iput() on inodes even
if that blocks or needs to acquire any lock (we aren't holding any locks
when requesting the delayed iput from the shrinker). So we don't need to
add a delayed iput, wake up the cleaner and delegate the iput() to the
cleaner, which also adds extra contention on the spinlock that protects
the delayed iputs list.

Reported-by: Ivan Shapovalov <intelfx@intelfx.name>
Tested-by: Ivan Shapovalov <intelfx@intelfx.name>
Link: https://lore.kernel.org/linux-btrfs/0414d690ac5680d0d77dfc930606cdc36e42e12f.camel@intelfx.name/
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1256,7 +1256,7 @@ static long btrfs_scan_root(struct btrfs
 
 		min_ino = btrfs_ino(inode) + 1;
 		fs_info->em_shrinker_last_ino = btrfs_ino(inode);
-		btrfs_add_delayed_iput(inode);
+		iput(&inode->vfs_inode);
 
 		if (ctx->scanned >= ctx->nr_to_scan ||
 		    btrfs_fs_closing(inode->root->fs_info))


