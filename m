Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99DD78B5E;
	Wed, 21 Feb 2024 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524029; cv=none; b=OuyMEAtYwsYDG3sPmZy5B8GF4KMMD/gfswz/Gq+Qdj2/KG9mLvHpndT+jTmu0kbW3zkMqENRHa2PAOTPdhNCNZCuuK5DASRQLsXKPQJnEBxjyR1k+TaYzf+Qty35BwC8V4aXRwK8Ia5OJLg1mFLkOeaWKZlCblAC7pl9RzbrptY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524029; c=relaxed/simple;
	bh=ARyPrDk7hk9sOBWlthu94Hs+9dD9gtxQZdRBMUSVGqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9nsjxsr+1g1PgN4khJ/1NRDou7/oJuJwpDbvZjH0lRi9ae6D2ulwEt0lWBce93qX9eji8LU3BjLpnnSyiFoD73JLqjAuNGzK3adJKS/aZD/MVflR9IeR3T4L9skNQqhp7fcBvS2UBHn8Tq66JyaXVhCkRQls75obM60OdJJjPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKpvnT9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKpvnT9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576DBC433F1;
	Wed, 21 Feb 2024 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524028;
	bh=ARyPrDk7hk9sOBWlthu94Hs+9dD9gtxQZdRBMUSVGqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKpvnT9XK7GhiuUQGCqRz18MH5cxg5ZBXh1Mjm4tNX9hIBMsjcyL1jujUBfYM3dh9
	 bkiix+zp3KTg0aVZ4rzl2mFgTh1IkhKSSwGCAksZGySLkz3vSAccvdiT9G4RgCO1V7
	 ih3xkNqxieBT4GHbt1bNtkB01tK3+4N1hLNxyeaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Subject: [PATCH 5.10 122/379] jfs: fix uaf in jfs_evict_inode
Date: Wed, 21 Feb 2024 14:05:01 +0100
Message-ID: <20240221125958.538191194@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa4ff7bcaff2..55702b31ab3c 100644
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



