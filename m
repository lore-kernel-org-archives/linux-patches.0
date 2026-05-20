Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16DC37DE8A;
	Wed, 20 May 2026 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301695; cv=none; b=GJU//P3vo9/3DLrG2k+b16oLW2/KWyTOLTCuh1/dFFdIHjIbd1nuogHAzgoLHPyXzJaT4pubGDvlXAbYSnlCzDKQ6T9VxeXWD2p1t+mckYRr2eAk65jAScVlaFAZU4leH8jxFyn+G76hfo4DEH19PXb3dz2vCwtrVTCykUeswVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301695; c=relaxed/simple;
	bh=0qPnmIz7km8IcGXdgVXOaLaYuxrBQJyTasM90vO5BvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUKULyDNxaqSN8mpUxVxVuJPDRaN13Zx3V+o558MlorN7azWi+SzAub/do4CK3xP7/NCNV86YTzHIZtWnv7zg4cMkgo4fXu6dMm9b5bwto3fer+vSo5Mlc0J5Wcee0LyPHEU8hpIdnzgcB/+QtManYrBtalq/pJnzkR8GVpNEIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8zD9aLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8zD9aLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B081F000E9;
	Wed, 20 May 2026 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301694;
	bh=heeU5ZpJAhDdIElo8m/U5zjF7EGFDvbFG8g3AQkN0qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8zD9aLNX20Nmq16oBbVyGGSggsa2n53B6BzX4cA3i11y/UIcPd4KSffd7ZUAcmCa
	 fJ5Dqx5Ymbn2d01ukvnd9AGXCRMrqnJyA7Svy7YubB3S0umsi5sOAbKf9rbuU2PJTk
	 ZP/SslyIS9AKTwbiNbsWH42pWx/NcBoK+OIRp68g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 650/666] btrfs: use inode already stored in local variable at btrfs_rmdir()
Date: Wed, 20 May 2026 18:24:21 +0200
Message-ID: <20260520162125.371578852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9f82a4ed34d870b5719f9b95f7da4f74d3325a6f ]

There's no need to call d_inode(dentry) when calling btrfs_unlink_inode()
since we have already stored that in a local inode variable. So just use
the local variable to make the code less verbose.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 999757231c49 ("btrfs: fix missing last_unlink_trans update when removing a directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4801,8 +4801,7 @@ static int btrfs_rmdir(struct inode *dir
 		goto out;
 
 	/* now the directory is empty */
-	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
-				 &fname.disk_name);
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(inode), &fname.disk_name);
 	if (!ret)
 		btrfs_i_size_write(BTRFS_I(inode), 0);
 out:


