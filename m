Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84770134DE;
	Sat,  3 Feb 2024 04:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933761; cv=none; b=iX53jqwLc9dtes8zfPoiz7o6pXhilPwxZ7YfpZf16pdLDUmZi6v63UNzeIOg1L/jdYltApoSctl6xH4LY6KFXJjLrpcZ653x1E+eF9YdRKg2OIOMdc7BKDj0TM9AYie/6+09mm/k7XSdU9SUUQTgOx22FAprOqDPuOfNNeVaqUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933761; c=relaxed/simple;
	bh=R1+iX+Sl3DpOnXDfv8lmZl1nhCXYNRVwfYG3I6jEX0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeWOFj7IurQAjNjnmwyJ8EPv25OM7K1c6WGGw2pgEhsfHjhdxlZrdwMUTtUAH98lV028z+Fit4awO2+PPSZruCNcLFQUZeoiD3ynDFmKrbA/zzIUNGZhYonmzT2Ko3EA+oZDyE6XjJpqjhW4vJ3+6e5nNJZ2M7RrAXomlk1TR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iIJSwB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iIJSwB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0A6C433F1;
	Sat,  3 Feb 2024 04:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933761;
	bh=R1+iX+Sl3DpOnXDfv8lmZl1nhCXYNRVwfYG3I6jEX0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iIJSwB+A3Ps+gCGqCgE3hJfs2sLVN0YCTfsNj3LrSKa/f45NV/lqbuCvgQ+qxnRc
	 FwEGThrrtVN1UJL1UO62ALOiUiZn07FzHfXEQYdtvP75AI8QqFxIL0N/xeRvbmbpu7
	 /eXJTfXB+x9oidwkauZwnJZHlsqPhF9313mSYj6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Subject: [PATCH 6.7 034/353] jfs: fix uaf in jfs_evict_inode
Date: Fri,  2 Feb 2024 20:02:32 -0800
Message-ID: <20240203035404.875057539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 415eb65a36ff..9b5c6a20b30c 100644
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



