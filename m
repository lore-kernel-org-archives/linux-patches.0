Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0EB253F0F;
	Wed,  5 Mar 2025 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198659; cv=none; b=B7Xc/0ISxkv1wymvtWIeet8NQQJ25BjTq0BW7Ic7qoLeaZwFGvGbXBdNUMKgyEv1lNVWkg5GB8wAwn6wm+cKi39EMuqV4P2yGOnYRV+lHv2lxlscJvpWnTyQY1OrLsUoB6VVsdt5s6mpoFNhlCDCmfWCcq7PaE66+S55webV8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198659; c=relaxed/simple;
	bh=twA+3+UYYJ4pLWJjputV4FhTVS4PRiSGVDsw0EfgjHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtB+f0C9Avb3kKMs4KNRz8heZdldRgp/aJUeQDcJMEUvWQfKlSMkCSaMwpe1Bg+DpIiNScAvXQa8tbZ0Ks7WGvUxzFOFCh4a2jiHQ3vXWTtn8zIjcwRc7ZMJzU8+SqTuRf845ndypHRcKbTu0K8kVU6Ecb0O7ODOKzt9YpPrn7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc/m+JwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc/m+JwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5F6C4CED1;
	Wed,  5 Mar 2025 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198659;
	bh=twA+3+UYYJ4pLWJjputV4FhTVS4PRiSGVDsw0EfgjHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc/m+JwB5/zh+N8u0lvgyr6qOH3z22WGlza/nCuQLuhVrhhehUN3So5XGPAPm/I1I
	 eMFtgCdOKF5iTI/NzfncwKgmfqsX2yJefehKs5QD6qHDBH0SWfWvlyFPzzXnYFw2GR
	 ZJseWU3jquRvMWYC3MUzjSY3IvM6i7XYNQS6ya9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.13 105/157] btrfs: fix use-after-free on inode when scanning root during em shrinking
Date: Wed,  5 Mar 2025 18:49:01 +0100
Message-ID: <20250305174509.528131438@linuxfoundation.org>
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

commit 59f37036bb7ab3d554c24abc856aabca01126414 upstream.

At btrfs_scan_root() we are accessing the inode's root (and fs_info) in a
call to btrfs_fs_closing() after we have scheduled the inode for a delayed
iput, and that can result in a use-after-free on the inode in case the
cleaner kthread does the iput before we dereference the inode in the call
to btrfs_fs_closing().

Fix this by using the fs_info stored already in a local variable instead
of doing inode->root->fs_info.

Fixes: 102044384056 ("btrfs: make the extent map shrinker run asynchronously as a work queue job")
CC: stable@vger.kernel.org # 6.13+
Tested-by: Ivan Shapovalov <intelfx@intelfx.name>
Link: https://lore.kernel.org/linux-btrfs/0414d690ac5680d0d77dfc930606cdc36e42e12f.camel@intelfx.name/
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_map.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1258,8 +1258,7 @@ static long btrfs_scan_root(struct btrfs
 		fs_info->em_shrinker_last_ino = btrfs_ino(inode);
 		iput(&inode->vfs_inode);
 
-		if (ctx->scanned >= ctx->nr_to_scan ||
-		    btrfs_fs_closing(inode->root->fs_info))
+		if (ctx->scanned >= ctx->nr_to_scan || btrfs_fs_closing(fs_info))
 			break;
 
 		cond_resched();


