Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD22B748A;
	Thu, 12 Dec 2024 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017324; cv=none; b=d/FkiceHE2aBrLVKR9+Cn99pbWPYUkMplxMZo/mNwi3bHuWLBiptkQYiifIJAXGUJhq7wHDSagkFcKMVUmWaxzKWT8/Wmxh/txp0O66qbGYi5n4PaJ55SsYApkwm8kcUWd3KvXnIbDQK7fNrH0n7Cuq7uVWvy98YigEfXmOpA4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017324; c=relaxed/simple;
	bh=Lfx77xCwfu+jUY2ZnCLkzgNS9RopBA0b2mcKa52MGw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgYjifAn++hBBN//ydAKp8EiGq4X3MhWdvTWayDHjiJcuGH7pXwFRIrHpilmwyb9OLCC4amUgkzdWdYZw8+yNg63YeXwWZoajw+6VY6t5w1L9DCD1emfnpxYistQfRbqoenfo64sPQsh1zS1CQZoZR6o4qNucpSHJ0hWwG3V8oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bmmo9PjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bmmo9PjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5214AC4CECE;
	Thu, 12 Dec 2024 15:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017324;
	bh=Lfx77xCwfu+jUY2ZnCLkzgNS9RopBA0b2mcKa52MGw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bmmo9PjVgKVsl7mElACSjzSJPFv6K2ERM86JvRvAMoyKcXayRCvq++w+p6zC04l9J
	 lV5jtKyi6pltDWmiIDkfzrYjOqNeL0jsZTg6E77bfHK+08Bq7Suq4LLB08bnI1pmMD
	 OHyre03HrtpL+G7LCU3mq5lLOlsX5Nf3P2bUQdYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/466] btrfs: fix missing snapshot drew unlock when root is dead during swap activation
Date: Thu, 12 Dec 2024 16:00:16 +0100
Message-ID: <20241212144324.517508180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9c803c474c6c002d8ade68ebe99026cc39c37f85 ]

When activating a swap file we acquire the root's snapshot drew lock and
then check if the root is dead, failing and returning with -EPERM if it's
dead but without unlocking the root's snapshot lock. Fix this by adding
the missing unlock.

Fixes: 60021bd754c6 ("btrfs: prevent subvol with swapfile from being deleted")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d067db2619713..58ffe78132d9d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9857,6 +9857,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (btrfs_root_dead(root)) {
 		spin_unlock(&root->root_item_lock);
 
+		btrfs_drew_write_unlock(&root->snapshot_lock);
 		btrfs_exclop_finish(fs_info);
 		btrfs_warn(fs_info,
 		"cannot activate swapfile because subvolume %llu is being deleted",
-- 
2.43.0



