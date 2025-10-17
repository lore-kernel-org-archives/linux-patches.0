Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277CE330B2E;
	Fri, 17 Oct 2025 15:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715875; cv=none; b=WH1kKPJQBJgHO8PQSjy7IekBK2nNPb8hfeE45IiD2oLo88oeQRgfVn334ykle6P3/9EFp4f8M2WlK1Oc6T/UO7/ADV7WlgkowS2Oul1Dr3tL3r2Uv/dYxxW2xVH+9qB3sdVAbovkuKpxDrJGtR50x4KafszMe8L8Jp53Hl/F5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715875; c=relaxed/simple;
	bh=0/2sL1Y4+5v96NLdl+A+2LySwB8y3wRwWCAaTzsBFsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BD4i3uB4sTGM2A0DlzgZCcQoyLpO+45JnsXLQ/L9X6zje/8cjIF9cys0EXcReXvdBjcFLY/X2tYNn+nBWv4tGGdX3+t9yo01aMNg1VlJbg2G4r2aB7eWMXjTWI6aR+GXYKqdOHr6nuqpFn5Fl6bYPvaGcm0r/mwwHqQ7CskK/Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y15y4KqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y15y4KqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A021EC4CEE7;
	Fri, 17 Oct 2025 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715875;
	bh=0/2sL1Y4+5v96NLdl+A+2LySwB8y3wRwWCAaTzsBFsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y15y4KqDwYJB9PNba15Nf1o4uks/y3o1hsrGBnfI0xV0e3wSeSGR/KwRUQX8qPq+F
	 q6vdvfvJDe/CSRs6GKwGijj4abTsG7PGTOg8n7UZjlp03U+HtFwoRx1ZsPpxpXZi+D
	 Vw5r8vDaH37ywujoaOlvl1mzKdCIq0Mp5lssNLts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 367/371] writeback: Avoid softlockup when switching many inodes
Date: Fri, 17 Oct 2025 16:55:42 +0200
Message-ID: <20251017145215.363686117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a07b8cf73ae27..b4aa78da7d94e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -502,6 +502,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 */
 	down_read(&bdi->wb_switch_rwsem);
 
+	inodep = isw->inodes;
 	/*
 	 * By the time control reaches here, RCU grace period has passed
 	 * since I_WB_SWITCH assertion and all wb stat update transactions
@@ -512,6 +513,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 * gives us exclusion against all wb related operations on @inode
 	 * including IO list manipulations and stat updates.
 	 */
+relock:
 	if (old_wb < new_wb) {
 		spin_lock(&old_wb->list_lock);
 		spin_lock_nested(&new_wb->list_lock, SINGLE_DEPTH_NESTING);
@@ -520,10 +522,17 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
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



