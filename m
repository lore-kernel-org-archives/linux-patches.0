Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A153816;
	Wed, 21 Feb 2024 13:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521252; cv=none; b=bniodWJma5nsWU0K7jVrS9l0Aq3w+L66dmzTlnmaGV3PYYUDewHyUHiKto+K80Q84uhPadJBw4bvTJfJvK23nMxdvGTpdPQ2SMof6kkO3SF3TZDnGRyq7qVHwM0GO03HaYqfhPSc2YI80twS2vb32nods4VXy00AflxL49aUVSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521252; c=relaxed/simple;
	bh=15u5F+OOR7pPnGXRulAhh5G0p12kHhyLSLMiSvNEXao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPGes931Wj9dfpYv5YTFTRl5tYRFRsVhoqNrFed+uTtwX/sdConV4i++nguaz/KKuFqshRMxExyAEKkGdA/xi85QxN6C0qqeXU6+GFcJpBN/gfnHQEcDt5vo7Sgrx4fHM2HjiRYkRrvNlRgMu9VVp2Am3pbb4CaRACZs0I4GXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7bpXtJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7bpXtJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD3C433C7;
	Wed, 21 Feb 2024 13:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521251;
	bh=15u5F+OOR7pPnGXRulAhh5G0p12kHhyLSLMiSvNEXao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7bpXtJoyYK0FZnD0muMfGSgd/4GZ1qMrgm64MkqQuCir5RFTbyRnodFdxWsN0lON
	 gV5/7/uft3wr0wIcLIRN4gqI6dJKB2LmJAUuvO9F5sNvWepPxW1Iatt3LZHqnttwPx
	 FrWxUXQe9xeWpb7kgG9PGYc6/SnDg4i1ud+pbWDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Subject: [PATCH 4.19 062/202] jfs: fix uaf in jfs_evict_inode
Date: Wed, 21 Feb 2024 14:06:03 +0100
Message-ID: <20240221125933.844224505@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f1a705d15904..97d91c1686b8 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -184,15 +184,15 @@ int jfs_mount(struct super_block *sb)
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



