Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF1A44AB62;
	Tue, 21 Jul 2026 21:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670753; cv=none; b=CNj+/Eol+5/PBTyBH3GXtkKSf26h1TFSJAHQW7/5E8aS4fMRib9nEyUiFTX3UvZm4sThJee/KThYhJVjHPl9W+5iP3ZtUChK2uNlWj1YathFcf3kBCbtfxs1piO1YmDBAPHMCmS72bBfkZMdC8AsVM6TzLAbad590RkxHN1lKgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670753; c=relaxed/simple;
	bh=I6fIVi386HvWh6twd9xMLkJyOtG+HHmbepgdqvzmD6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3HsmPIxbCfq1Dbkw0wn5dpUrRpbQpmI4pNomBnsPo2e7qvqvQffY96pd9YBMpag0cm40g/bDbF7RNcFm6kE3OyD4LoSPkDOTYk70X6qS/bd9M/ETlBQTIjGvyowS2rxEI8HmrIDti8k4cDvGcKmUtyL0WsP4q/sk5nw+9Fb2lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMHC7hhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMHC7hhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F34D1F000E9;
	Tue, 21 Jul 2026 21:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670751;
	bh=2PFs9dzTkyD94ed2RntkfbYrZF2E252TsQguCTF8ufY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMHC7hhVagcfMzqpTEsxrfbiLSee9hGeN1Tsf/o7O2nT9/RUAgJbdhRsYMJQpzDsZ
	 dnQRScAEchAZtp5wYeaLRE22vJ93FwSnLaxb779ByJGaaBdjU3VNoSsePfI6Bcb1TY
	 QfmhiCJlQ9/UdngnxGz8X2EFwFg5luJsL3swPEnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 1051/1067] writeback: drop now-unnecessary rcu_barrier() in cgroup_writeback_umount()
Date: Tue, 21 Jul 2026 17:27:32 +0200
Message-ID: <20260721152448.099270349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1187,11 +1187,6 @@ void cgroup_writeback_umount(void)
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


