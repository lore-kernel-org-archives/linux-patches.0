Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05081359A61
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302425; cv=none; b=ipvLpa2IPmLk1lB5w4HeAVdmODuzFVOVJAUFudTZPfHenyDpcWsSjAUcKLcVeF1jWamqQTxnqTR9ryYQIysMg/6O0D4YKdNop5cPHIVfal/aJfb3PnGAA6ebw/zTdFdWbDaVO3XjOOyetidzieIKbk/aSU5RZ1GYWtzpI3wNcVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302425; c=relaxed/simple;
	bh=ptJ3blSQAgfOOQi20YFr/znueBf5TktusPKnek7nZUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Elu5zAMgSDsWY/ALY3n+AFgY02HaklwaokT/aYTLrBkOc4BasDemppPfi5IdyRH1cyk5S1RPccjdpRcdUBt4r0nNzuAb3e742Wrt1PeWpuYS9IqOXta9jPxSmFtL5b9yDZqa9l6ts+vj/jgGl2G9vnkj4/auSME690Hiz6IvgXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DpPMVq8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DpPMVq8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F0FC116D0;
	Sat, 28 Feb 2026 18:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302424;
	bh=ptJ3blSQAgfOOQi20YFr/znueBf5TktusPKnek7nZUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpPMVq8YLd6/PsUFJc1tsbQECBwpMTusxy/hBYv09Tuimec15PCPuu7xY0lLtq4Pi
	 52ztdgTiRJZU/Ud3gSyBGe/rT53HJkH2mPpvUlvz5RdiuroH7NaOYaJ1j+tbJ+haFd
	 jUepfIuokODHocKzzcqDotibFBtIDH6dbFwG7oxXV9txlqjXjI9dQDsYZk/9haQqvL
	 KRQDYCnUMsWWTw9tfKIKuJerStbvKt+L7fta/om8h1nJ6srH7t+YgLGLe3N8lqBb+R
	 JOQby8holhQ1PoYG5XHMjYm/Z7gclklKBTfTepevoj8AWGzAb74GA+cxXQnxiPKq5u
	 PP2DHllL9IoZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/232] pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN
Date: Sat, 28 Feb 2026 13:10:14 -0500
Message-ID: <20260228181127.1592657-161-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 5248d8474e594d156bee1ed10339cc16e207a28b ]

It is possible to have a task get stuck on waiting on the
NFS_LAYOUT_DRAIN in the following scenario

1. cpu a: waiter test NFS_LAYOUT_DRAIN (1) and plh_outstanding (1)
2. cpu b: atomic_dec_and_test() -> clear bit -> wake up
3. cpu c: sets NFS_LAYOUT_DRAIN again
4. cpu a: calls wait_on_bit() sleeps forever.

To expand on this we have say 2 outstanding pnfs write IO that get
ESTALE which causes both to call pnfs_destroy_layout() and set the
NFS_LAYOUT_DRAIN bit but the 1st one doesn't call the
pnfs_put_layout_hdr() yet (as that would prevent the 2nd ESTALE write
from trying to call pnfs_destroy_layout()). If the 1st ESTALE write
is the one that initially sets the NFS_LAYOUT_DRAIN so that new IO
on this file initiates new LAYOUTGET. Another new write would find
NFS_LAYOUT_DRAIN set and phl_outstanding>0 (step 1) and would
wait_on_bit(). LAYOUTGET completes doing step 2. Now, the 2nd of
ESTALE writes is calling pnfs_destory_layout() and set the
NFS_LAYOUT_DRAIN bit (step 3). Finally, the waiting write wakes up
to check the bit and goes back to sleep.

The problem revolves around the fact that if NFS_LAYOUT_INVALID_STID
was already set, it should not do the work of
pnfs_mark_layout_stateid_invalid(), thus NFS_LAYOUT_DRAIN will not
be set more than once for an invalid layout.

Suggested-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Fixes: 880265c77ac4 ("pNFS: Avoid a live lock condition in pnfs_update_layout()")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 43cd2d6a0836a..34cd66c98021a 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -464,7 +464,8 @@ pnfs_mark_layout_stateid_invalid(struct pnfs_layout_hdr *lo,
 	};
 	struct pnfs_layout_segment *lseg, *next;
 
-	set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags);
+	if (test_and_set_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags))
+		return !list_empty(&lo->plh_segs);
 	clear_bit(NFS_INO_LAYOUTCOMMIT, &NFS_I(lo->plh_inode)->flags);
 	list_for_each_entry_safe(lseg, next, &lo->plh_segs, pls_list)
 		pnfs_clear_lseg_state(lseg, lseg_list);
-- 
2.51.0

