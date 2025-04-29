Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3AE2B2DA;
	Tue, 29 Apr 2025 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949204; cv=none; b=qe5jJuwkl7hzpdneqIVZpPpkzpaO6lLpXK+lYwT3OQQd/tIjcdjbKrk5LtTmB90P7gqR4/nFKxXXn4SB8Mg3fLaoIm7mtXYfH8Go7KbNaAh5d4bEgOFg9np1mecdM07YVm9dbB3yKdgre7kKDGcIgKuBATO/XhIHQK1eDO9dUi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949204; c=relaxed/simple;
	bh=x+GTstSXba4JlaXNaxuzX4gCTIqIW70ABQBZO5qIxnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Abco4lkkT5q0Kx/tj7oyJEmAMi0KAkKPUVcO+fhG68HEoxmInOTMJQjccqYaWioQ+54P3lHT0Nme2Lii6LHC+33VzIPxzo7bhyFBpPGf3wetnNZMz20sMBbdcZhW8hj+dqYPIwcoy5PUn2MsWr5Yj8e7NdQBg3hFS+il9WgQx1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNxZ/Tz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNxZ/Tz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E094C4CEE3;
	Tue, 29 Apr 2025 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949203;
	bh=x+GTstSXba4JlaXNaxuzX4gCTIqIW70ABQBZO5qIxnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNxZ/Tz9MLUl6AugIZzItN4sLUWz3i2CaRrhn74QFzeAIPB0Y6jT61Pe2JowikJ/m
	 +8nauXU/ntT1UiZxHMNrbkks4XuxxNSwbylrLZScAqlDucs5VloH8F8nl9w4mPaUw3
	 EdmLhH5HtAOXc30gLp8c/xO3XATKOOB5cAoa0Nbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com,
	Pei Li <peili.dev@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Zhi Yang <Zhi.Yang@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 244/373] jfs: Fix shift-out-of-bounds in dbDiscardAG
Date: Tue, 29 Apr 2025 18:42:01 +0200
Message-ID: <20250429161133.164813982@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Li <peili.dev@gmail.com>

commit 7063b80268e2593e58bee8a8d709c2f3ff93e2f2 upstream.

When searching for the next smaller log2 block, BLKSTOL2() returned 0,
causing shift exponent -1 to be negative.

This patch fixes the issue by exiting the loop directly when negative
shift is found.

Reported-by: syzbot+61be3359d2ee3467e7e4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=61be3359d2ee3467e7e4
Signed-off-by: Pei Li <peili.dev@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Zhi Yang <Zhi.Yang@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1698,6 +1698,8 @@ s64 dbDiscardAG(struct inode *ip, int ag
 		} else if (rc == -ENOSPC) {
 			/* search for next smaller log2 block */
 			l2nb = BLKSTOL2(nblocks) - 1;
+			if (unlikely(l2nb < 0))
+				break;
 			nblocks = 1LL << l2nb;
 		} else {
 			/* Trim any already allocated blocks */


