Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10A82EF9C2;
	Thu,  3 Jul 2025 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555651; cv=none; b=BXsPn3glongkYNtCW/h1VmBMOA5E+Qi6CQRVhqySWJDVvKZbuL1ewsFipY/G+Ub37psr7+Y34Vi4ThNJiGPbxr9xiA2xstxwK5HKtFcCefSVdnbWynHdD/+/YLpqnAGxbRNu6n90dDtR0TQBeAPl08yPM+sChhKOp57e9L8nrWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555651; c=relaxed/simple;
	bh=9IWndUI4aLEu7KWnt44BJaAuCKGke7YyCTDgJnKlQvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpqX7GD7HUfG3nWmZsFmokeBna3km2NjoUGgDeKoWeRNACn/0I97pHy3V11du/u665A4ultv/h9LmU1AGHXx5253G1lognMUw/xyN5/G+iYsXTwWsVY7XoFGAxOIc50GJcer3O05H9j0aFp/ePCTU41+f9DdCNVmbpJQCoePg7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNOODg0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNOODg0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55FCC4CEE3;
	Thu,  3 Jul 2025 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555651;
	bh=9IWndUI4aLEu7KWnt44BJaAuCKGke7YyCTDgJnKlQvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNOODg0q75nOHtLR/onapvA3BRA0fsXV46SEeAiyprX+I9XCW9V/8VAFkw8wQFMYU
	 2rjzoKS4fyyl0KqcSdgZksCk4v0Sz9AhjNGTBvIif9oEhk0MIi+odU8kKX9wmzF+Po
	 lmArWCB6dwaTYFecq7F+79IpzmXx3BkLMCxjQmi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/139] attach_recursive_mnt(): do not lock the covering tree when sliding something under it
Date: Thu,  3 Jul 2025 16:42:23 +0200
Message-ID: <20250703143944.291796318@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit ce7df19686530920f2f6b636e71ce5eb1d9303ef ]

If we are propagating across the userns boundary, we need to lock the
mounts added there.  However, in case when something has already
been mounted there and we end up sliding a new tree under that,
the stuff that had been there before should not get locked.

IOW, lock_mnt_tree() should be called before we reparent the
preexisting tree on top of what we are adding.

Fixes: 3bd045cc9c4b ("separate copying and locking mount tree on cross-userns copies")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index eab9185e22858..cebcb9fa2acc0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2364,14 +2364,14 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	hlist_for_each_entry_safe(child, n, &tree_list, mnt_hash) {
 		struct mount *q;
 		hlist_del_init(&child->mnt_hash);
-		q = __lookup_mnt(&child->mnt_parent->mnt,
-				 child->mnt_mountpoint);
-		if (q)
-			mnt_change_mountpoint(child, smp, q);
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns)
 			lock_mnt_tree(child);
 		child->mnt.mnt_flags &= ~MNT_LOCKED;
+		q = __lookup_mnt(&child->mnt_parent->mnt,
+				 child->mnt_mountpoint);
+		if (q)
+			mnt_change_mountpoint(child, smp, q);
 		commit_tree(child);
 	}
 	put_mountpoint(smp);
-- 
2.39.5



