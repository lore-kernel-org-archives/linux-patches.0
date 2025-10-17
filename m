Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68723337100;
	Fri, 17 Oct 2025 15:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714805; cv=none; b=Xtby9Z43lzfT77ASv/dv9iJdW+kwrMU3dfr6p7feIZWuhIxFwlTwt+JrO4GdCWcGkhgz7KykXhfYTAY9ElhWdYcvwfEol9OqpZRnEDyZz3QkCwtuHjBw6MgK5uv87d3CUVB9GmQsiU/zON+IHtzeJ/hgEDv+kK2o9/kbrQjcrKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714805; c=relaxed/simple;
	bh=rDfxg2ZNLXHTgaFTkHp+8eYzskVn3z8W5IVDalR8C2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYgJEAjnpAjLKOv0QseRdTZ5+TlzBnY6Ksviwcd1PB/g8RyGDUQ/4ND7aFxuMmrA9fS+F6xhiPHOHQXOia5t3AsWllUhy5nL6eZjfMsSILLeBrd67gISk0ZXDuuXlHlLlsQw43WcNylsclafot6gfr3oVFwI3URhxnU2ZellNZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/HMSPj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/HMSPj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF787C4CEE7;
	Fri, 17 Oct 2025 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714805;
	bh=rDfxg2ZNLXHTgaFTkHp+8eYzskVn3z8W5IVDalR8C2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/HMSPj0VCmSrQC7iVYNHKLiNiUYTEbIWwN5NewNVu+3BF43Ad+iD2QINouNJtix8
	 DzlCHcUpYmZaHevYE2Q6HHdGDzlOMaMo1sUl+YvQV5q+Ptya5YaE8yPctv98AvfEbk
	 DWGG2QL01l9KN1YtNdYTLaxqKMR+1/wSIYKfJkWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/277] writeback: Avoid softlockup when switching many inodes
Date: Fri, 17 Oct 2025 16:54:38 +0200
Message-ID: <20251017145157.054321145@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 66c14dccd810d42ec5c73bb8a9177489dfd62278 ]

process_inode_switch_wbs_work() can be switching over 100 inodes to a
different cgroup. Since switching an inode requires counting all dirty &
under-writeback pages in the address space of each inode, this can take
a significant amount of time. Add a possibility to reschedule after
processing each inode to avoid softlockups.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4ae226778d646..eff778dc0386c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -503,6 +503,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 */
 	down_read(&bdi->wb_switch_rwsem);
 
+	inodep = isw->inodes;
 	/*
 	 * By the time control reaches here, RCU grace period has passed
 	 * since I_WB_SWITCH assertion and all wb stat update transactions
@@ -513,6 +514,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 * gives us exclusion against all wb related operations on @inode
 	 * including IO list manipulations and stat updates.
 	 */
+relock:
 	if (old_wb < new_wb) {
 		spin_lock(&old_wb->list_lock);
 		spin_lock_nested(&new_wb->list_lock, SINGLE_DEPTH_NESTING);
@@ -521,10 +523,17 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 		spin_lock_nested(&old_wb->list_lock, SINGLE_DEPTH_NESTING);
 	}
 
-	for (inodep = isw->inodes; *inodep; inodep++) {
+	while (*inodep) {
 		WARN_ON_ONCE((*inodep)->i_wb != old_wb);
 		if (inode_do_switch_wbs(*inodep, old_wb, new_wb))
 			nr_switched++;
+		inodep++;
+		if (*inodep && need_resched()) {
+			spin_unlock(&new_wb->list_lock);
+			spin_unlock(&old_wb->list_lock);
+			cond_resched();
+			goto relock;
+		}
 	}
 
 	spin_unlock(&new_wb->list_lock);
-- 
2.51.0



