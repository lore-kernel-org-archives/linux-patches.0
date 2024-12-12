Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0CE223C55;
	Thu, 12 Dec 2024 17:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025538; cv=none; b=OXRLsNKpOOjowNM5ld35pwTpZyIt7ktwKAazeErWgnZutbsRo/FC39eBIXULiqr8R/hYbuwTAE0uWMP3DxmaU6/VLhLCBWuc/uNfmF4r0D+c52sEZGj1apmsuQA1dJ4Rx5hGWvEpAKz0GP5LN6+SETAtOlsECCyK3Pg3ElD2qs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025538; c=relaxed/simple;
	bh=n8C0TOess7nUBYbBQxU7/r98/O5okIe6HWsfVjRAdJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhz7y57P1zeLK9rcJ8FZBVyQXoE2ky3W2dwZYHdmTIB0TiEXF8/HqRIVHLACUIRQoKfDYXpWgoVB2DprCb/60J5b2SwjLug7iAY13jOPE8yj1Jo2yJoc2jCqTS4BvDbIw/eiflvbb0GO8hrt63zCsrdcYlAEpMfMh00l3tEnnpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh4GpyeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh4GpyeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8536C4CECE;
	Thu, 12 Dec 2024 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025538;
	bh=n8C0TOess7nUBYbBQxU7/r98/O5okIe6HWsfVjRAdJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hh4GpyeLLQjYXzGAtytB5JaPln9f3T/midJuvL9SbZ2D+cgVma/PY0DwXJ0HVv6nN
	 oRe/3em/mcfUimQbalmPQ+dzk4Mmm+Y+LDcrhkzZOSFEmys7y+g/EUN+X/xJnc+haC
	 e27S7M6pAJ2AyOFbxlelbeZVYlzfqYJhxV3STDBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	Baokun Li <libaokun1@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 202/321] quota: flush quota_release_work upon quota writeback
Date: Thu, 12 Dec 2024 16:02:00 +0100
Message-ID: <20241212144237.959751462@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 14c0dd5b65a43..42c2ac0cc8fc9 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -681,6 +681,8 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 
 	WARN_ON_ONCE(!rwsem_is_locked(&sb->s_umount));
 
+	flush_delayed_work(&quota_release_work);
+
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (type != -1 && cnt != type)
 			continue;
-- 
2.43.0



