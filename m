Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2623415F07;
	Tue, 21 Jul 2026 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656520; cv=none; b=cJv6pTtAZjji3VWvrJd/GFl0qMp9VvPQnkXigRlroVuH++37F2t1E6FYIqFRiPbdcLvig6YFrCqC2jnOBInqBfVW9gD8nb5xHqfaDWI8uVIDyVOsJ32vxzkUOkpTNgkbJ2BZZjYrm8IlQ3VCLKsWFhr134pjHArhRmBwa8V2/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656520; c=relaxed/simple;
	bh=wnvGQR1ByRIRUsqD8Wg5nAaG9XTV/Rj0adlkbUoF4Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODHaEkGEba0MqrOFVnA81aFqROtuIHCwM6D+aXKygAokrhd/cU8npam46VZaRXLzOeHPzdDA15klgNTKgxfParKDMEOI/oAL8k8XB31hGQDpdSyRblWgo2bccyNGP0zzYo9XbuclzVUCY7QZcvBXOCIlWlOsbD173FuMTtuOHHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2efIK9Wf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2efIK9Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C91D1F000E9;
	Tue, 21 Jul 2026 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656518;
	bh=sCOXkPI7cOkkK04dIvfhzOTCXdU1m1mqXwdRMoHTg6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2efIK9WfmbB1wcfaHNDa5W2ySFwBRqEEnjtPWjN1J057KdJYRPYNeO55A99s53taQ
	 lYTuyMiEPmmJUa03yosI0k5j1IroZIm6NN85xscr4RsUS9cyNRkITfvvk4Ge/QsD1U
	 dkJS01oOx3MxZHLQvKaEnyuMHGmHN1m6KF868xKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0416/1611] btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
Date: Tue, 21 Jul 2026 17:08:52 +0200
Message-ID: <20260721152524.614957327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 486f8298b6188ff11ef1f4be7f1d5d2e4d1b1fae ]

In the beginning of the loop, we try to obtain a locked delayed ref head,
if 'locked_ref' is currently NULL, by calling btrfs_select_ref_head(),
which can return an error pointer. If the error pointer is -EAGAIN we do
a continue and go back to the beginning of the loop, which will not try
again to call btrfs_select_ref_head() since 'locked_ref' is no longer
NULL but it's ERR_PTR(-EAGAIN), and then we do:

   spin_lock(&locked_ref->lock);

against a ERR_PTR(-EAGAIN) value, generating an invalid pointer
dereference.

Fix this by ensuring that 'locked_ref' is set to NULL when
btrfs_select_ref_head() returns ERR_PTR(-EAGAIN) and incrementing 'count'
as well, to prevent infinite looping. We do this by doing a goto to the
bottom of the loop that already sets 'locked_ref' to NULL and does a
cond_resched(), with an increment to 'count' right before the goto.
These measures were in place before the refactoring in commit 0110a4c43451
("btrfs: refactor __btrfs_run_delayed_refs loop") but were unintentionally
lost afterwards.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/ag8ARRwykv8bpJ87@stanley.mountain/
Fixes: 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ffe6c80495666b..6ef7cc116bfcca 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2022,7 +2022,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			locked_ref = btrfs_select_ref_head(fs_info, delayed_refs);
 			if (IS_ERR_OR_NULL(locked_ref)) {
 				if (PTR_ERR(locked_ref) == -EAGAIN) {
-					continue;
+					count++;
+					goto again;
 				} else {
 					break;
 				}
@@ -2070,7 +2071,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		 * Either success case or btrfs_run_delayed_refs_for_head
 		 * returned -EAGAIN, meaning we need to select another head
 		 */
-
+again:
 		locked_ref = NULL;
 		cond_resched();
 	} while ((min_bytes != U64_MAX && bytes_processed < min_bytes) ||
-- 
2.53.0



