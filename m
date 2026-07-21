Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E809D415F10;
	Tue, 21 Jul 2026 21:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667971; cv=none; b=QaOvbuPaBiDqiuDkziIM9SMCD2yb8fuyoXcijERcO/RXrWOgpMB030Qyo21Ww0qCbf2RHqN4INqy3jlMeXD7TfTUVNeV0tc09Gm+jfKPkRY1g7uYp1nphUI0xPUWjQtmWvqU1WbyICp0uoL5dz7OuShC5i9wPqhYqMa5VSnmSpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667971; c=relaxed/simple;
	bh=JGccPRH+P6+j9nckwgJMVneh1iAarSJec2xK3sFR+0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyvGOSpVIDc82al5bgvhtFfZvdgq4Bhzvgip/DID4nfqH7l/8+yGSar/f+yN59t02yAXhcL6tmXyJSAg55EBgtOZrOKazMdLBXr8lEuL9coLgA5WgtxfDBCjg0o4g+Ah5FycZrA4/3RbGj4vopwNDUQqUe/2OBvWMSIOx90ALQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9iJXTDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9iJXTDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A26F1F000E9;
	Tue, 21 Jul 2026 21:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667969;
	bh=2x4EDL6HQDm1uXajTu4uUfcf6C64srF+G1QrXjQj2NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9iJXTDVKg7alDIjRaJolXbuNCuiflv5qhV2Zk28GvUQOjLybRDgpZyH2a3HOV1U/
	 yJTdUOQIPRzUgIQC95RxnqGCzF25z7c+lpdef2O1DYcLbvWNjD+HLXYzGKD9w9WOLr
	 d6LDzqXCffWbMTcoFn1LgxOECB2+bdgZbAqhF61A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 1262/1266] writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umount()
Date: Tue, 21 Jul 2026 17:28:19 +0200
Message-ID: <20260721152510.064293303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit e90a6d668e26e00a72df2d09c173b563468f09c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1191,11 +1191,6 @@ void cgroup_writeback_umount(void)
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


