Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF7A3ED3B2;
	Tue, 21 Jul 2026 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661758; cv=none; b=CN7ABmVXTP4XomKPP5pbUtysnMmIy/pdUnjIsaEHarD3ccgTvBnfy5KDT3Lz3IvOlOFEn7Vn1TSNqDxZtH1r9UitgqMUPwPDUZm5f/HhZgiVaAtOdclQ72t06Th/tqbRqI2+XnUs9qUOE8nnTGs4Mcx728PyTPNdJ7oY6+ponkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661758; c=relaxed/simple;
	bh=UFgdakgOc2j6cdVHJsCM0WCv+PqY/R31uDAIEhUEmZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9i0zZCvokOM3mq+xpkBAzThwr4HEy6bIhHETVGhSdapdI82KEOXQnpuC/qPSBu0DGOCvm0Y7gFW40ZGIhvRiBwWpLpeW8ej1mbSaXoL92shLwln7CXDry5wBc5n4tZP+71ZOp5eg6zs5FJ8gWGz8WkM8O17gMvIZGb47C/3KYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aghbehD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aghbehD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0821F00A3A;
	Tue, 21 Jul 2026 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661757;
	bh=MJBsFtK1ApwQ2AaSNI/N++P+R8WW1DeqYisvoUJbmzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aghbehD+4XGM7Ynj6IxvDcCqZK5FJ+nF0CvmqV3pID1uI5Dghc0g1XS3TNjLN5Ur4
	 PQchaAQidkYhQ+X9BuwnC8w8IcOjzsS9ZefW2SGJLkYYak+YN828qyT4mGkUlCZsRq
	 ZiOG8aKoyFHwv38BLBRXm0a0kgHThd/is5FTVLMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0144/1276] writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umount()
Date: Tue, 21 Jul 2026 17:09:47 +0200
Message-ID: <20260721152449.323916487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit e90a6d668e26e00a72df2d09c173b563468f09c9 ]

Commit e1b849cfa6b6 ("writeback: Avoid contention on wb->list_lock when
switching inodes") replaced the queue_rcu_work() based scheduling of
inode wb switches with a plain queue_work().  Since then no switcher
goes through call_rcu(), so rcu_barrier() in cgroup_writeback_umount()
has no callbacks of its own to wait for.  It still drains unrelated
call_rcu() callbacks from other subsystems on busy systems, which
incidentally slows umount down; drop it.

Fixes: e1b849cfa6b6 ("writeback: Avoid contention on wb->list_lock when switching inodes")
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260521095016.2791354-3-libaokun@linux.alibaba.com
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 57a31bd110c0bf..4e1e0dd16428ba 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1218,11 +1218,6 @@ void cgroup_writeback_umount(struct super_block *sb)
 		 * will then drain it.
 		 */
 		synchronize_rcu();
-		/*
-		 * Use rcu_barrier() to wait for all pending callbacks to
-		 * ensure that all in-flight wb switches are in the workqueue.
-		 */
-		rcu_barrier();
 		flush_workqueue(isw_wq);
 	}
 }
-- 
2.53.0



