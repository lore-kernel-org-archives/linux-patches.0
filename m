Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117F576ED7;
	Wed,  9 Sep 2026 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963323; cv=none; b=pp5LZNpdzFyRs4N13C/RcbGyTNCwxTSyiYOdI5K/uk4HZCuDFmlUfehk6+elEdE9+NTGVo6Q4DLz0vRB/Cr8OsSscUFfGpvyUsC3RwGmE1ocwyYqTfDVvGQlu3DgSACTkVvaeE4zAqSoIhwdFBvHRpCsw+LhHX6J4i+/3hfg0us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963323; c=relaxed/simple;
	bh=lacInrbsMbRuEVi4Hf29O0fs1qmsPJ3ybE3ciuq3S4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Al/x0xWY922ALesYorMa04vHPkCPemPFMOeiG6oL7fvXP1yKY7Ip4ROUaT5dqx8ZZQ25W5xRpPZXtffgsS5igOrt/l3XB9LkldycUxzl+IUGyXvfUe+/jerevBoZzBE6E4sYbVCMhduqo/CC5tHOw++aqK4ikLyGkhAtyG1CYmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7zavw80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7zavw80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4F11F00A3D;
	Wed,  9 Sep 2026 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963322;
	bh=pBu2y6vRoYZP9ShAvOhhXoWnqqzPC24eDSj4DSANKcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7zavw80Flh4pFszXYCK3AaOA7v0phvlvJv4eRyV281oY3U/9EvLJEVL4qdj4Sq5A
	 DK3mpWyfZd5VI1JCKegI8IOoTFKCKPFvlNaxql2BGMW7UM/pmhDuLRUOil7CPqLsKc
	 OkxjZ9fgSBEY/rUspEmHCzLRGTz+Y7PUO21UeF2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Youngjae Kwon <yjkwon0026@snu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/583] fsnotify: inotify: pass mark connector to fsnotify_recalc_mask()
Date: Wed,  9 Sep 2026 15:34:54 +0200
Message-ID: <20260909134238.123613726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit 4520b96b8136ba2465a3f4dc5c3fb8bdf3d92e4e ]

fsnotify_recalc_mask() expects a plain struct fsnotify_mark_connector *,
but inode->i_fsnotify_marks is an __rcu pointer.  Use fsn_mark->connector
instead to avoid sparse "different address spaces" warnings.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://patch.msgid.link/20260214051217.1381363-1-sun.jian.kdev@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
(cherry picked from commit 4520b96b8136ba2465a3f4dc5c3fb8bdf3d92e4e)
Signed-off-by: Youngjae Kwon <yjkwon0026@snu.ac.kr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 2a8a83d8f4a7f..6eaf0d382eec8 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -562,7 +562,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	fsn_mark->flags |= inotify_arg_to_flags(arg);
 	spin_unlock(&fsn_mark->lock);
 
-	fsnotify_recalc_mask(inode->i_fsnotify_marks);
+	fsnotify_recalc_mask(fsn_mark->connector);
 
 	/* return the wd */
 	ret = i_mark->wd;
-- 
2.53.0



