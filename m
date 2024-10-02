Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E818E1C9B91;
	Wed,  2 Oct 2024 13:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877042; cv=none; b=igcM/nJVTx+u0/GZbx+ZKldIvkk1WcgLFlmnJR6suSiknLGy+IFT+D1Z8wIw1a7T2FGiGfO/UG+K/4ShMs+kJ5k6eLy2KxAg0ePvv64GdLUFGIaUmKmH57xbjC5rRfVH0E2fVN+rM3tGrZVQTizjU5BuHpqlU1IphsTPOEtLuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877042; c=relaxed/simple;
	bh=SFmAXZddesVd+h+MZjaat17d/dXyRZdyu3pOTcd1JNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q67Wyl1mWrl/Pt0zNw1OkyjBr3022EMnXqBuOGmeKhIOE9DWAxtFmpJlKGtMmmhrJ87nF3a7XSvWCdLIfqKZt4JmcvbX5ZOB8qwdZV8OvUewDu357lQzrvOHEtRPhmcvg4AQP+9Y0kEY8bMrA00Y3ZZ0zRbyTUVg8vMWeLxrMF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfYvK1KA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfYvK1KA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB96C4CEC2;
	Wed,  2 Oct 2024 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877041;
	bh=SFmAXZddesVd+h+MZjaat17d/dXyRZdyu3pOTcd1JNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfYvK1KAtxmomnYsHvsV9FOSwgICDO4SOj2byNDwII3ieb9aTmxq+YmnHEtImvAvq
	 ABuU1Z2QeQqndrTsmqjbElsjKY2MZ1CAPb8wi78cmqYydZgTnJAVqgYP5H2hfoGqG1
	 +lSE+6CpNe1u/131Y7xBWAsMoo1N8kpS9hqVNVT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Parton <njparton@gmail.com>,
	Archange <archange@archlinux.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 627/695] btrfs: tree-checker: fix the wrong output of data backref objectid
Date: Wed,  2 Oct 2024 15:00:25 +0200
Message-ID: <20241002125847.540533528@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1517,7 +1517,7 @@ static int check_extent_item(struct exte
 				     dref_objectid > BTRFS_LAST_FREE_OBJECTID)) {
 				extent_err(leaf, slot,
 					   "invalid data ref objectid value %llu",
-					   dref_root);
+					   dref_objectid);
 				return -EUCLEAN;
 			}
 			if (unlikely(!IS_ALIGNED(dref_offset,


