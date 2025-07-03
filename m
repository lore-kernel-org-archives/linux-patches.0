Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8225F2E7BBF;
	Thu,  3 Jul 2025 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554979; cv=none; b=OtKoyAzYlZamCGs/mh+m/4qDlgd4RPbDC26rgXHPNMmbsbmAvK1YvX0eMOAjpuhHe2iQ/nD8Mx8wmaGmxzdq7q+SJ7h0ObKKb5lZSgNH7NbSCzz0whqEJ4kLaqmlUeL+r5jFGCKe4PzolKBcGIvjd2PpbCmLL3sVMSCTPRLWzGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554979; c=relaxed/simple;
	bh=97VTEJQZ+mRnhw6axTjNBkIsbpJA7xM5C2sk9Uh9+jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ry/gZcsk6GmyR5zgknRTwVJkIFZbJp111dGoEM+9R3U3cUcEFHE5ILwi0haZk4nBLs/FszKdYq0FhqAIKbX6NacXxy5RVLydcsg4/ZHAAMyMV0TEVd/mdY0oSIG+AdK3Yo36g1zuqCFqAt1LUkQUTORbjiF4RyIgi1LXnjo+kPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGJvUmzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGJvUmzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB65C4CEE3;
	Thu,  3 Jul 2025 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554979;
	bh=97VTEJQZ+mRnhw6axTjNBkIsbpJA7xM5C2sk9Uh9+jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGJvUmzFWP/deBmaxB6mSMN/8yMXG3l/tVBQBUuyLAVGHRuQtWEn65S7DZzyu2yJB
	 3dNxIfIRHzI7O4X8ah5FX9yRIF0fGpmWTeKcDwprKp9pMMSpzopSf3Z3bSYywpnDnZ
	 Q/wkWfNtvTUiTpgzk+fk/Na29FQwebua8i4s7R8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 139/263] attach_recursive_mnt(): do not lock the covering tree when sliding something under it
Date: Thu,  3 Jul 2025 16:40:59 +0200
Message-ID: <20250703144009.930671954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d6ac7e533b021..24b087ba88159 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2765,14 +2765,14 @@ static int attach_recursive_mnt(struct mount *source_mnt,
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



