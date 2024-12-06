Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCABA1494D9;
	Fri,  6 Dec 2024 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495956; cv=none; b=qUGDdXY0JFJyyWsruCR4C3lCKCZx+5yW0GoCl0m9Zx+744kpOVZd77WLzsgas8+DN0S0ppvVqjGaIoeNYfsMwg+FCC4IJCnZVbCUm51CGQLUqDdH4weAm8SeGL4G3C3cg6SoVTUVJ8/MNKb2DSOIjlEgFng6cpAVyJDbSZ1QKd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495956; c=relaxed/simple;
	bh=qZTImxgkxVkbJnfZC3KmzIJZt4FjRt0KDObnoLGIT/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/OW/BFteyEBnJAwEZU8hgePaUnzriQv7e2hnG9oZtTd5TJ2it/A3jDfFLrtPJY43fDqeIglQKo+VqkE2SeTCEnOZXlYKep72F3S0lR340D7Tkdcc4Kl2EiTKmlfjXvJgnkCUc+bb8TV5nnhQn5OksGcm3v3FyUyS8boI49g4Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNP5sAQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNP5sAQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51B4C4CED1;
	Fri,  6 Dec 2024 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495954;
	bh=qZTImxgkxVkbJnfZC3KmzIJZt4FjRt0KDObnoLGIT/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNP5sAQYUgh6+N4x210EcCbtMAfYuGRWEcGdfS4KC2Sbqi/KtBKpfrr+RFN8EMrw4
	 i79GlaZ5gjILg5ekxl2ctkCWE8JzS0lG8Wk+AtENaJuFWg/d5Yx+iyDvAC5Qev+6Wr
	 wzFS+aGjrWyotNY7DK7wGk8u6x5BVk3XWOGRvZS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/146] quota: flush quota_release_work upon quota writeback
Date: Fri,  6 Dec 2024 15:35:33 +0100
Message-ID: <20241206143527.755848010@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit ac6f420291b3fee1113f21d612fa88b628afab5b ]

One of the paths quota writeback is called from is:

freeze_super()
  sync_filesystem()
    ext4_sync_fs()
      dquot_writeback_dquots()

Since we currently don't always flush the quota_release_work queue in
this path, we can end up with the following race:

 1. dquot are added to releasing_dquots list during regular operations.
 2. FS Freeze starts, however, this does not flush the quota_release_work queue.
 3. Freeze completes.
 4. Kernel eventually tries to flush the workqueue while FS is frozen which
    hits a WARN_ON since transaction gets started during frozen state:

  ext4_journal_check_start+0x28/0x110 [ext4] (unreliable)
  __ext4_journal_start_sb+0x64/0x1c0 [ext4]
  ext4_release_dquot+0x90/0x1d0 [ext4]
  quota_release_workfn+0x43c/0x4d0

Which is the following line:

  WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);

Which ultimately results in generic/390 failing due to dmesg
noise. This was detected on powerpc machine 15 cores.

To avoid this, make sure to flush the workqueue during
dquot_writeback_dquots() so we dont have any pending workitems after
freeze.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
CC: stable@vger.kernel.org
Fixes: dabc8b207566 ("quota: fix dqput() to follow the guarantees dquot_srcu should provide")
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241121123855.645335-2-ojaswin@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b40410cd39af4..71c0ce31a4c4d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -689,6 +689,8 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 
 	WARN_ON_ONCE(!rwsem_is_locked(&sb->s_umount));
 
+	flush_delayed_work(&quota_release_work);
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
-- 
2.43.0



