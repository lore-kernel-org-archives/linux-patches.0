Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC803370E0;
	Fri, 17 Oct 2025 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713460; cv=none; b=u2k3V+SQb7s7UdKZ3V9U/pXCeaCPPqMrRGothvBajuPcTagTn7QLnwhvWhsO6VtJ8XfsSNNycHQlzyGUQ8onhZwtv6U/s+NYVYFY2z0+NTMuLxij5NKu25L2RiWOQ0HamnbJc8V/7WaTOua5o4dm6dzpXRvV1cD8ofBEt4Br+dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713460; c=relaxed/simple;
	bh=T7W2qSFFxiXToSvEyi8ziadcYPtYM0PQ79xHi8FEO/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkMKWaPmMx+uKvgGQySTMTNJP9UWMWwbSRB0ErukOSp1YMMd43bLEUJgp5hEHDvRK4+Jlq6MMSL82DE78RTnC3UIptMqhtXFjLfCNJzbxMBt8DsmMtvkuWcZ+cMvd6k1kCE90JKCQbLozb/QW/8J+7IamZp5COwJiBPGsar2yaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZM5INfpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZM5INfpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43DEC4CEF9;
	Fri, 17 Oct 2025 15:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713460;
	bh=T7W2qSFFxiXToSvEyi8ziadcYPtYM0PQ79xHi8FEO/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZM5INfpWXR1lmPsRVr13a/m1f7UyXxUc6ZFGvVUA3xz4GVj520cQ/QHZ0v/O1UR7/
	 2FMq58kOwtHUP6PeRUAeb0sgEWw46rqodprMBnuqupFbBTV3hwNqPwA8TAO4yH/2SO
	 445MwWOIGQWyesOMFKjo2hp8NazNAKkioBdxmCZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/168] writeback: Avoid softlockup when switching many inodes
Date: Fri, 17 Oct 2025 16:54:05 +0200
Message-ID: <20251017145135.164465469@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 41f8ae8a416fb..07473cf2a7c9b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -477,6 +477,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 */
 	down_read(&bdi->wb_switch_rwsem);
 
+	inodep = isw->inodes;
 	/*
 	 * By the time control reaches here, RCU grace period has passed
 	 * since I_WB_SWITCH assertion and all wb stat update transactions
@@ -487,6 +488,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	 * gives us exclusion against all wb related operations on @inode
 	 * including IO list manipulations and stat updates.
 	 */
+relock:
 	if (old_wb < new_wb) {
 		spin_lock(&old_wb->list_lock);
 		spin_lock_nested(&new_wb->list_lock, SINGLE_DEPTH_NESTING);
@@ -495,10 +497,17 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
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



