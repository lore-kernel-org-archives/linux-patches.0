Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BD61BF3F;
	Sat,  3 Feb 2024 04:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933499; cv=none; b=JHguBQetKcOU+CztBJJODl0v5gFYTcnrCsp6vV34Rzl5uR++AW6vm/7p2H/p8Zz77esWbhE/yiWPgXbJa8hIdSbR4l9BPv1JQuHYGA3XO3SZmOd+Ms6lzm7NjT+2tWALhr7uVW4xoM51Gd2LU0/7ohLcV4Lk18SOS07VXPbcFuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933499; c=relaxed/simple;
	bh=oyF318lAPMceF/3ldDTWI8TX0sD/dnyvlm9PtfGctck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuRz8TFkHYyQD6CF7stj0mrTPkNXxK+JE6FfFvyEplFv8TpjoN+E05bjnemn5SAsfCMIfwsjNpzYsUsJjWfWu2MvcN9oymLwP2KrpoOfYkrUgXpPo37e/67SHZxHHpEufQdtC2s+wjLPUAr8SV47WaOzfLevkYHpyayZ5hlfivo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uba/Iz5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uba/Iz5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2046C43399;
	Sat,  3 Feb 2024 04:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933499;
	bh=oyF318lAPMceF/3ldDTWI8TX0sD/dnyvlm9PtfGctck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uba/Iz5hpxeIicWsIb52ImfH8XnSxl5R3kFnVfnVTQpcdZVgB1fjYU9xOa5O4YHhX
	 HU5u7VPkvnunDWxUE13NOx6m3e+oPaNbhBJdV33m62ZF0xwUzYMnOYSje5W30PXlFC
	 uZWes6ezFPqi6U7T1124GFEntg5ye3sayA1OD2mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Subject: [PATCH 6.6 030/322] jfs: fix uaf in jfs_evict_inode
Date: Fri,  2 Feb 2024 20:02:07 -0800
Message-ID: <20240203035400.027455510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit e0e1958f4c365e380b17ccb35617345b31ef7bf3 ]

When the execution of diMount(ipimap) fails, the object ipimap that has been
released may be accessed in diFreeSpecial(). Asynchronous ipimap release occurs
when rcu_core() calls jfs_free_node().

Therefore, when diMount(ipimap) fails, sbi->ipimap should not be initialized as
ipimap.

Reported-and-tested-by: syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_mount.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jfs/jfs_mount.c b/fs/jfs/jfs_mount.c
index b83aae56a1f2..631b8bd3e438 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -172,15 +172,15 @@ int jfs_mount(struct super_block *sb)
 	}
 	jfs_info("jfs_mount: ipimap:0x%p", ipimap);
 
-	/* map further access of per fileset inodes by the fileset inode */
-	sbi->ipimap = ipimap;
-
 	/* initialize fileset inode allocation map */
 	if ((rc = diMount(ipimap))) {
 		jfs_err("jfs_mount: diMount failed w/rc = %d", rc);
 		goto err_ipimap;
 	}
 
+	/* map further access of per fileset inodes by the fileset inode */
+	sbi->ipimap = ipimap;
+
 	return rc;
 
 	/*
-- 
2.43.0



