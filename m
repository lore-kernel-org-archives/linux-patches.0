Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C28D3B2FC0;
	Tue, 21 Jul 2026 20:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666028; cv=none; b=Z81Or+AdgusSX08SHy/aVnlzuQRHfZV5CqZGGXNCtOY1s9q69Q0hefmOc0vXs5lVmajNYammgR0OEw7B9G0OfDnQSs41IoAAgL9DQ5oaYlqw+hIc4GyJ/qtm3Xu6ENoMcDbF7QYYXNNxRUZA+x32dB6IllSE//7SuySim9Xqp0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666028; c=relaxed/simple;
	bh=rS44M745p3RIEA+6LDRyaiqhQkkS8y7Di83y0q/ZuS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7x/GbIHSgeso5JfMPkocrOqPq0yafXfIZOeydOkvcDq+bs8SEfwL1JsJmjyfVq+bgo5rquMS93ZvhgFb4CufjhtlZnJltVhHyyP6TjqGZ/guHyQQgHMX0Uo6o6Fj57Po+fEHqO8oJz6RGuqOgtMir3IV7KKcOc/Xqo42HhpEXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0rbF/6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0rbF/6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741F51F000E9;
	Tue, 21 Jul 2026 20:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666026;
	bh=HuRFE4oTvmkH9wn7NNiQaXuegrTE9bZPNWUUnwChLu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0rbF/6gNEf3vZWGmFAg9m02NSAEx27aEipbOy2fyzh2c2IvjRPfGxgbKjNo0RlXN
	 cZaEfqy9+ousEVTQhfD8fa/psvVcyuEY2RlODi7g2say59xseiVKMIGS74NbImcJ5d
	 81PbmKedpwExTOel3vDBgXMlb+szAQZdIqQAJ+GI=
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
Subject: [PATCH 6.6 0527/1266] btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
Date: Tue, 21 Jul 2026 17:16:04 +0200
Message-ID: <20260721152453.647504839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fbeb515e178f35..72d32a254cdb5c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2061,7 +2061,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			locked_ref = btrfs_obtain_ref_head(trans);
 			if (IS_ERR_OR_NULL(locked_ref)) {
 				if (PTR_ERR(locked_ref) == -EAGAIN) {
-					continue;
+					count++;
+					goto again;
 				} else {
 					break;
 				}
@@ -2109,7 +2110,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		 * Either success case or btrfs_run_delayed_refs_for_head
 		 * returned -EAGAIN, meaning we need to select another head
 		 */
-
+again:
 		locked_ref = NULL;
 		cond_resched();
 	} while ((nr != -1 && count < nr) || locked_ref);
-- 
2.53.0



