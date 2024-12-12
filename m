Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D0221DBE;
	Thu, 12 Dec 2024 16:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021777; cv=none; b=LE3dDHGNAaX0EMWrlzaN24M2EI2WhoroF4mxrjRBmRS1p6JouGRMvqzYedq84VdqVLTgZ6OLBHDROx76Y1BUUeVGBlECfGg0G66QYm2D5N/vW2NAJO+dwsN54nWNJthobOJBECrHXZXjbxK0VV2S1Qsp7d9oBVgQz9PrzUCZXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021777; c=relaxed/simple;
	bh=HvX7mMabEz3JksvG8ijdNC7otWltTjX961IKaBi236o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XA3Lxpu4zWOPe2EywN3mhPEp8eaNzUV4N+pQBJk2ivdhdyxQG1TjMJ93bd37eIsRCjgGUygXB6IsznB5xe1H56VVkQB0keu3nDuFMeh4K/VrSGKSLdol5xGd3iiXmyvozYLZz/7OcXugMCC4mPhDcGhafI7osNC0itzs3Ky5noc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccZOII04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccZOII04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED69C4CECE;
	Thu, 12 Dec 2024 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021777;
	bh=HvX7mMabEz3JksvG8ijdNC7otWltTjX961IKaBi236o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccZOII04OAadQtd9YGy8lwh+MeTaq3WCu9l02LiQxSi3KsCF/GH4OWeURfXTMrCk+
	 Qij2BwS4zDMcbCVNEj9YtkIoJkgtdvKJ1LFE984wrjVIT8poeBAPZf7V/JBc4YEhgq
	 6oBAdQ1iik9RNc2RmAkvZMOCz3GMTYxnDUl+mfow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Ubisectech Sirius <bugreport@valiantsec.com>,
	syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 030/565] nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
Date: Thu, 12 Dec 2024 15:53:45 +0100
Message-ID: <20241212144312.640962170@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit cd45e963e44b0f10d90b9e6c0e8b4f47f3c92471 upstream.

Patch series "nilfs2: fix null-ptr-deref bugs on block tracepoints".

This series fixes null pointer dereference bugs that occur when using
nilfs2 and two block-related tracepoints.


This patch (of 2):

It has been reported that when using "block:block_touch_buffer"
tracepoint, touch_buffer() called from __nilfs_get_folio_block() causes a
NULL pointer dereference, or a general protection fault when KASAN is
enabled.

This happens because since the tracepoint was added in touch_buffer(), it
references the dev_t member bh->b_bdev->bd_dev regardless of whether the
buffer head has a pointer to a block_device structure.  In the current
implementation, the block_device structure is set after the function
returns to the caller.

Here, touch_buffer() is used to mark the folio/page that owns the buffer
head as accessed, but the common search helper for folio/page used by the
caller function was optimized to mark the folio/page as accessed when it
was reimplemented a long time ago, eliminating the need to call
touch_buffer() here in the first place.

So this solves the issue by eliminating the touch_buffer() call itself.

Link: https://lkml.kernel.org/r/20241106160811.3316-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20241106160811.3316-2-konishi.ryusuke@gmail.com
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Ubisectech Sirius <bugreport@valiantsec.com>
Closes: https://lkml.kernel.org/r/86bd3013-887e-4e38-960f-ca45c657f032.bugreport@valiantsec.com
Reported-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9982fb8d18eba905abe2
Tested-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/page.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -39,7 +39,6 @@ __nilfs_get_page_block(struct page *page
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
 	bh = nilfs_page_get_nth_block(page, block - first_block);
 
-	touch_buffer(bh);
 	wait_on_buffer(bh);
 	return bh;
 }


