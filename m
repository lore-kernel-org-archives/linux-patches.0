Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FEB1D0E27;
	Wed,  2 Oct 2024 14:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878864; cv=none; b=Ys/sEli3W/jmQ72f+qUP/wIu8lGROcD2gLV4B0cnECbwyVmxK8V/0XWlBdOEgrBia5QUolACtVHPdgr1mP07i7uEGAkrrnvnrM2FE5zxQQOZrxOrONhua2Qkxx80dVDS+I5cHVyvhNp9CutZKLr64hpEDaP3M3Hzl2x4jzt0qP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878864; c=relaxed/simple;
	bh=ASMvqSDp5gUcZDE2weiJUQ/+skGiIVhvYS5JLRECzAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSp/jIWu7P1BZPXfk8TGc8ftQ7oRXz0Sp0QzntxMcq4oOgNr8zGntDbYC+Xy5PqM4tMdPlr48r+FiA9cgi52o6fzEDwiYfPk2Fm//ZGZA2oH3S8HNAxNdUwlfACMhBibn999OZfv+AyvEFY1d0VSbdirSGjnRtwKf9V7K8DBOmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2RrPMPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2RrPMPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4A3C4CECD;
	Wed,  2 Oct 2024 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878864;
	bh=ASMvqSDp5gUcZDE2weiJUQ/+skGiIVhvYS5JLRECzAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2RrPMPIakNESFqlYmsaqRHQEfKxMlLiaQceVz7aP2TOp9g4OhqdkSodwzb5ENg8F
	 MTHh6ESULyDM6tjAQBU7edaZhuYsafF83jn5N6Dd51Y/lgk9HHEIfEQDhr4fY4Haih
	 OIJVhY0aVwR5fsnfflnQvW50Pkj5GNpDJzE5XhIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Parton <njparton@gmail.com>,
	Archange <archange@archlinux.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 558/634] btrfs: tree-checker: fix the wrong output of data backref objectid
Date: Wed,  2 Oct 2024 15:00:58 +0200
Message-ID: <20241002125833.137347327@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit b0b595e61d97de61c15b379b754b2caa90e83e5c upstream.

[BUG]
There are some reports about invalid data backref objectids, the report
looks like this:

  BTRFS critical (device sda): corrupt leaf: block=333654787489792 slot=110 extent bytenr=333413935558656 len=65536 invalid data ref objectid value 2543

The data ref objectid is the inode number inside the subvolume.

But in above case, the value is completely sane, not really showing the
problem.

[CAUSE]
The root cause of the problem is the deprecated feature, inode cache.

This feature results a special inode number, -12ULL, and it's no longer
recognized by tree-checker, triggering the error.

The direct problem here is the output of data ref objectid. The value
shown is in fact the dref_root (subvolume id), not the dref_objectid
(inode number).

[FIX]
Fix the output to use dref_objectid instead.

Reported-by: Neil Parton <njparton@gmail.com>
Reported-by: Archange <archange@archlinux.org>
Link: https://lore.kernel.org/linux-btrfs/CAAYHqBbrrgmh6UmW3ANbysJX9qG9Pbg3ZwnKsV=5mOpv_qix_Q@mail.gmail.com/
Link: https://lore.kernel.org/linux-btrfs/9541deea-9056-406e-be16-a996b549614d@archlinux.org/
Fixes: f333a3c7e832 ("btrfs: tree-checker: validate dref root and objectid")
CC: stable@vger.kernel.org # 6.11
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1499,7 +1499,7 @@ static int check_extent_item(struct exte
 				     dref_objectid > BTRFS_LAST_FREE_OBJECTID)) {
 				extent_err(leaf, slot,
 					   "invalid data ref objectid value %llu",
-					   dref_root);
+					   dref_objectid);
 				return -EUCLEAN;
 			}
 			if (unlikely(!IS_ALIGNED(dref_offset,


