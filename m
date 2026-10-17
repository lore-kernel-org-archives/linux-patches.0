Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CB834C98C;
	Sat, 17 Oct 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259716; cv=none; b=r1ZS/pwz4D+MkcPMc3wS1yKUYLzo6ljivQAY6NbFv5Hzvx9iLtpOvoj+Vycj2T4BWqcx4n4x9dfK27VWfC8EzXRIxAcutLjv5daNBonJRVveKsr1Zr5Q2yRP0sm8T2o1sOhJV8Q9Cjbg2idk6Jy2qC49UCPsaxCtRojUb6UaFWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259716; c=relaxed/simple;
	bh=NnPX0ukyZubyZ/Di2ghRumJDj53AuYLvnUMqFklnpVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihIkLvXebCFcgAm4SR39VqhSpVgel5woH9i/dGA559XQBJ7DXgjb2i9gv1QJkGOkqYy5G0bU72CvwucluuDEzigI83tce2cmsBlWD5hysMkBGoJyEKh6Fw0AXlHuTA7VZfB7Q99nb4gAb7jCkz6055McWM2K3+7Vc2eIy3IiZQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpPuTg+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpPuTg+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA441F000C4;
	Sat, 17 Oct 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259715;
	bh=+LM+D8lwZXoZvk1O4qFfS7iWxO9xgoKGEU+dLM5FEDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpPuTg+e5ZXwfWhEPpj7Xek82ook0o3FPI6IlNjyQ7ml4WhAIRrVFRPxiiOCTn8Sa
	 1IPU6jFDhhvqpv26GVUin+Dx88dtPRDC30XO3G4s83F6jKkK0FRxElyMJUMYpILwT4
	 iTuArrUnW5RP8nGAY0iKdTCCdtOW5VJExzW6WfqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1279/1674] lockd: fix NULL dereference on lockowner allocation failure
Date: Sat, 17 Oct 2026 17:59:11 +0200
Message-ID: <20261017160503.969684656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit 4c7fc129db061c7daab841c4f3c342d894832362 ]

nlmclnt_locks_init_private() installs NLM file lock operations even when
nlmclnt_find_lockowner() fails to allocate a lockowner. nlmclnt_proc()
then returns -ENOMEM, but the VFS still tears down the partially
initialized file_lock and calls locks_release_private().

That invokes nlmclnt_locks_release_private(), which dereferences
fl->fl_u.nfs_fl.owner and crashes because the owner was never installed.

Clear fl_ops before attempting to initialize the NLM private state, and
install the NLM lock operations only after a lockowner has been allocated
successfully.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/clntproc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 78cb1e592d73a..2926002e9020b 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -487,9 +487,12 @@ static const struct file_lock_operations nlmclnt_lock_ops = {
 static void nlmclnt_locks_init_private(struct file_lock *fl, struct nlm_host *host)
 {
 	fl->fl_u.nfs_fl.state = 0;
+	fl->fl_ops = NULL;
 	fl->fl_u.nfs_fl.owner = nlmclnt_find_lockowner(host,
 						       fl->c.flc_owner);
 	INIT_LIST_HEAD(&fl->fl_u.nfs_fl.list);
+	if (!fl->fl_u.nfs_fl.owner)
+		return;
 	fl->fl_ops = &nlmclnt_lock_ops;
 }
 
-- 
2.53.0



