Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C81A3FB21;
	Wed, 21 Feb 2024 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522488; cv=none; b=ac9KcPct5An29iDCSB1U21QuM1cWiuPEnyrweWuBnSVz0xxuJjJ/fNdcYKnvRmDCipkumbCFwEvsST0QGx8fLlBQhwYOVuclN4NBljZ6r3iXlc3lVZorVW5M/+rYXIieRKbBWXZv6hWi7GOwUZe8D72C9ESNcQQhrB/V1D00l/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522488; c=relaxed/simple;
	bh=2836fKI8HXdbF5YYyi3OvS/M9G9CJDLxVCHKeAsdAvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1JNnk5Ci6v41SEbRnfurxQisNCvel5TkzfQCAbxwnFhrVTthuc0kJ+ySO+ThWx3kLR62mcbGNJZ8V61g+wKV4rtU8f+N/p/NDTg6nI+2e54yq1w2Wgvs0uWdJ3tUWOMSR5C8/K0CO1gTb6RKfv0WNYSa7iCMqdwpGQPyorSImI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJlVoAlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJlVoAlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A011C433F1;
	Wed, 21 Feb 2024 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522488;
	bh=2836fKI8HXdbF5YYyi3OvS/M9G9CJDLxVCHKeAsdAvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJlVoAlN/sD/8Wmi7CAdj8uPmCZ3o5XVbONHRtXGOBp75NYjZ5HNWO8aDmTs9nTSM
	 ar8omQWUaTBUkVgyDeWfjJKKYWs1Mmkz0A/D99c3KkW0ZWyr6r1fi4VZqC8HZ6GyPQ
	 JErKXOiU6s7nFz9ZNHUHH+8S4CHeJ+8zP9yVJEvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+01cf2dbcbe2022454388@syzkaller.appspotmail.com
Subject: [PATCH 5.15 148/476] jfs: fix uaf in jfs_evict_inode
Date: Wed, 21 Feb 2024 14:03:19 +0100
Message-ID: <20240221130013.396101872@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



