Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1994346E017;
	Tue, 21 Jul 2026 17:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656040; cv=none; b=Takbn4ZJ/1SJrL37e6qMPj7BgXFcBrWe1H/4Ed3s1q8t+IRoBvkPKKC+eZtE3MI5Q/pfsfR0plK0SpmwaCyHY6w6vjgP2EL8KROfxMXSjgGdpnDjUTNBbhIShbR6Q6jsIOoV9qbXp51h6vMPGa3p6qpnOqJTqXgSgpU2ZN9yhso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656040; c=relaxed/simple;
	bh=RmfC1URVH7wN0fRNSQR8nUo31fdgI6x6Pfn50LdfgGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsduSEdpVx/GdSRVnIbSL/o8sdHRBkKiRuH9YGUzlxvBxTjln5x6PonKm3GGesTutA3VYoovQRBfyOoEVDhnpIwSpFwmm3MsFl/ZAkgVQbdiowHKPgB5VUm6V9y/o2snkmAglIw28MX7ZjpTbHEHAJzt0U7uY/MPpv6TtH61yvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8dpyZJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8dpyZJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E8B1F000E9;
	Tue, 21 Jul 2026 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656038;
	bh=KQISrWgOGdKpdnxx100UufL1wblYaG/5SYniGwfCDPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8dpyZJrSReWvAgmb8+PzF7bAzSJSSfBQPFGCGY5Rn6G4IIKwuyaawRXgVsO0PeXn
	 YjSKyQFcpCsfUhCXxc6Nw51kzOU7MDIQVtPAEGEZX9LY0iHBkN1zuTDn71u7Ja/IpK
	 xj8lXe82EMQmFTE+VaTivyczFZZQAZajoPpHoeEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0193/1611] writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umount()
Date: Tue, 21 Jul 2026 17:05:09 +0200
Message-ID: <20260721152519.284670072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 99d0658b49a220..d2510c818da9aa 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1237,11 +1237,6 @@ void cgroup_writeback_umount(struct super_block *sb)
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



