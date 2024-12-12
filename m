Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9213214227;
	Thu, 12 Dec 2024 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023445; cv=none; b=fnH1M45nVoV15DpYRcdK8y1+e0x+X4p0oRfGjmWgoJZ1mwmBnjfMOhf1cSHKX9/P7fpaRjKoDVT0clKCSyX9hR/hHvQ9wVYfoBDal8ScQHbj8vtT9XLRQ+jij3YMZk2497jPwne55ezcZlVyyv0YG7T4JmgsGKBP1ofn9lSYc2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023445; c=relaxed/simple;
	bh=SKIrCNKiNlOsnlbhZsw4fnOL9rZ/RfGa570izYahRus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAwj+wsRbP09B2MDPRGfv2f+04AeOBUZerQiO3c8u5k/Gk4mPG1Iks7iHC9Wca79LVVoRYtq5v3MAdXy3c/3dZ6wCDQfbmBoigrUvuYCOQ4enz4f3A7kVGCPB3UZXv4Zo1YHt4WA7AwE2zrPnPGYVhCWVvpnIDVPvadz5PVcbeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHDZt5a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHDZt5a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4462C4CECE;
	Thu, 12 Dec 2024 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023445;
	bh=SKIrCNKiNlOsnlbhZsw4fnOL9rZ/RfGa570izYahRus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHDZt5a/nma2fo21Ax6QtzauekjhOrqKXCJWUVozBW/6GtoJIVWl606lKcVyXAMj6
	 JO/lJUt7NHQDnhVacwsoUDP5gOU6HqYlfKkgO38DErDGAbQQFwb6u0qdOhnsbLKZ1K
	 FQiA3juY91VV11mcFX8OF4akMd2PiLO58ya9ObvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 536/565] btrfs: fix missing snapshot drew unlock when root is dead during swap activation
Date: Thu, 12 Dec 2024 16:02:11 +0100
Message-ID: <20241212144333.022990579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb12ba64ac7a7..8f048e517e656 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10891,6 +10891,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (btrfs_root_dead(root)) {
 		spin_unlock(&root->root_item_lock);
 
+		btrfs_drew_write_unlock(&root->snapshot_lock);
 		btrfs_exclop_finish(fs_info);
 		btrfs_warn(fs_info,
 		"cannot activate swapfile because subvolume %llu is being deleted",
-- 
2.43.0



