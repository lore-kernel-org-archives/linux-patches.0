Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2802E540B;
	Tue,  8 Jul 2025 16:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993921; cv=none; b=Z3klh7Qm/Iqs4inydFUB8gI6IRga4uuc1txORz0M+vNwkOdLmbG75Gf7JHY2DrZzK6inudutePCxeCwZcyrQ2A9d9+Rmm2/hpvveWCVSu4j2gxc1cuMOXhsFM80Du3bw4Dj0XqkvNS5yFXfar2aWpJIaMH3yXeT7tZb8Dbc+aHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993921; c=relaxed/simple;
	bh=azzzpsh1Q6cxtlTdH2GwbeV/Zp5Z1RR2rCy3uDgBsNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZT8TRA0oyFEyW20JBQf0rZQtFJGdGCcJ8eLxaxLpTJlRtQ8vyJkXbKU2uf7Ai40H2jiDzWF60JJ4BYlitf6PrQf+tKvgwEnn2jKKYIaESAqX4hLA/Njn4STC4P/DPoFh+sK16+cAONjSCPkcKUY5RSSTy2cWLgr0WapA+4530k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUDjrIVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUDjrIVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721C8C4CEED;
	Tue,  8 Jul 2025 16:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993920;
	bh=azzzpsh1Q6cxtlTdH2GwbeV/Zp5Z1RR2rCy3uDgBsNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUDjrIVCuCROuInEQDN7ngXEi445OMKer56XglKRhO/aqI0TkFxsH0GyZrjEMsVq3
	 AlxN5Ba7E1L1k+gzJ/WqL5y9kM8zpJXzndLKqFo3gimCMprxYa0EJ1dy2QAPEAz0P1
	 VywjNh8qt8/s0c92c9i2vWiYxgx562BKR51U6hQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/160] attach_recursive_mnt(): do not lock the covering tree when sliding something under it
Date: Tue,  8 Jul 2025 18:21:40 +0200
Message-ID: <20250708162233.298243223@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
index 900738eab33ff..adb966833a4b9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2205,14 +2205,14 @@ static int attach_recursive_mnt(struct mount *source_mnt,
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



