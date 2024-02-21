Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877E04C62;
	Wed, 21 Feb 2024 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525268; cv=none; b=McxWHJSsLBW3HYsRnB96otP1jDdavABcySD2X5ZnGclyq2WskcqWtcErtRwYPRf+0c7JNsrKlNX3ZbVJvowd7z92HjGedNm1L9f69zW7eE84BtN4RgYolgG8K/CyeuLgPMU5aHWqKo2U/c5MmViEO+c+PO+AneP4C1m9mCKPiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525268; c=relaxed/simple;
	bh=StDN7G5NwUoB3jN8q3WSkLAV4EFAgxxsoMFfDF+tlMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot87v7ATw8PEgi7K+qHn8kFc5k/rB9WS4y6LoVIurP1NvEcTQ/0o4karXOEub25PJJILXhOprHH0tu4wxjcGO6dgDnkzyPaxzUySELXQXvubIbT/JFyiqOHdwZPSN0UpiJBnYDGTdPkwHOtReX/EX5Pb4nQVAA701DPR7Hec2Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuwPrxJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuwPrxJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9669DC433C7;
	Wed, 21 Feb 2024 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525268;
	bh=StDN7G5NwUoB3jN8q3WSkLAV4EFAgxxsoMFfDF+tlMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuwPrxJoR69lu22wYLuphcLLHx7fUZ48wYmfzRbEnvnm29UdHHnnn/2jgS3cLCmTk
	 UrEk9FCdQnDhFSqnXR/MbWUeATuwq5zIiMQkomcw1hvevNJsqaUgAPXAKwQbjPRggc
	 JBF7/QKgVUVeIcQ2LDr80fYI9j7H8LyfmYOFqseU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Subject: [PATCH 5.4 077/267] jfs: fix uaf in jfs_evict_inode
Date: Wed, 21 Feb 2024 14:06:58 +0100
Message-ID: <20240221125942.398939068@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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
index d41733540df9..459324f3570a 100644
--- a/fs/jfs/jfs_mount.c
+++ b/fs/jfs/jfs_mount.c
@@ -171,15 +171,15 @@ int jfs_mount(struct super_block *sb)
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



