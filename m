Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E081D3B6C17;
	Tue, 21 Jul 2026 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673660; cv=none; b=twq/+rYHYSs3ih5AABJKmuufGq4/cLFwdY1tyj/6c/07gyq77EiGdUIEfMB+VYwqu6ZxbpnuIT1NHyIaANGybuWDzZF7SZMVzaW6oYu1GUWZ1PVQ03Za9OR73H6mdEI8oV51rGmoI/czIrNFGUYoT+TgpJSDzImlXz0L4G2ko2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673660; c=relaxed/simple;
	bh=hAZgiUngq/R3rwRwIwb17zSea3NQedHnEkfCGfBUFTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okmKDJHXNutrUnok+rVCeUTowu5dXYKCGfyVwMWDX3hhMZ0eBi0fxGk2zLSbmqU6ogZllGUyJ6QBGvLilR1I2Yt5JbiIPbrXaBZ6kkw4eKbibLXLWsqD4m8vbGMIA6WfKYs8TTgITqoiEf7EpJ0u9X7623icynIjV0jAMV8uCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XStj6BBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XStj6BBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0871F000E9;
	Tue, 21 Jul 2026 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673658;
	bh=b0AdKjI7qOaMGZjAJrDhhW7Q3b+5KK4iWPcDGRj9cJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XStj6BBmbyOA0xKoLFPqCco2EnxCHlA1ZvX+AQB2banlvXX0yUpE8wWAv+S4Q10/N
	 +P9fn8Qv9ySfzhURiKgaVREek6HE/AtNRg7MUb2FhVqLi8PfP/m3yiBkFd/woHOEcb
	 Avr9GHC8OFItC00OCj3fVMYRptvhlgchdgDShUcw=
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
Subject: [PATCH 5.10 246/699] btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
Date: Tue, 21 Jul 2026 17:20:05 +0200
Message-ID: <20260721152401.247415031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9207fe878dd201..906905ffe6c043 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1995,7 +1995,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			locked_ref = btrfs_obtain_ref_head(trans);
 			if (IS_ERR_OR_NULL(locked_ref)) {
 				if (PTR_ERR(locked_ref) == -EAGAIN) {
-					continue;
+					count++;
+					goto again;
 				} else {
 					break;
 				}
@@ -2044,7 +2045,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
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



