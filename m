Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7F71D2784;
	Wed,  6 Nov 2024 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896132; cv=none; b=fihaADfL8MVcMiQkRcWtiARq7nblCbBhB9ZHAwApwn/UtF+8Ecvn/Zesz/NG85ok38XZKlQZi2y5wQxuKOR7T8fIDsMa8FXTlZod/CP1dTH1WWjGf+3v2LRqZb9wFb/lr9Sx4OreExy6Bv51eS7l020pHRWIf+qjj8xGQhP06zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896132; c=relaxed/simple;
	bh=P7gBiccvTBlpeqELr6QM89967xwontVDO4SbP3GkGkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OA8c11/XW8fw902GVgnNuITUnGG7THI+NDbPSmMVWBBg6XVld5csEnMHaVfAmsmJXmpWwSmJW7k3y4PafqnYwBzBZIpOw4SlpNh/rgWIE1HGyIy/dh1nXh2mSFIXnVVAMeTT1jhT7f6xm2r9jOTHPes1N7jHbF/94fNAlRsykws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9wZT8XV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9wZT8XV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E7CC4CECD;
	Wed,  6 Nov 2024 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896132;
	bh=P7gBiccvTBlpeqELr6QM89967xwontVDO4SbP3GkGkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9wZT8XVslvJkbICR/p/GFsO5Yqyn5iUSW8TZNqZUL4wTpnZ5NKIgq2700IdD70qF
	 ghQ6XeFGBSRcuAynV44Wawq+2g+HW6Bucak5KtMiWVNbacMeAVGBZdTRDCebBxR/oU
	 O+XNKQ0Df9c3jU67m3CLRUN5n8/rBXYogsn7IrZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 100/245] NFS: remove revoked delegation from servers delegation list
Date: Wed,  6 Nov 2024 13:02:33 +0100
Message-ID: <20241106120321.673689078@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 7ef60108069b7e3cc66432304e1dd197d5c0a9b5 ]

After the delegation is returned to the NFS server remove it
from the server's delegations list to reduce the time it takes
to scan this list.

Network trace captured while running the below script shows the
time taken to service the CB_RECALL increases gradually due to
the overhead of traversing the delegation list in
nfs_delegation_find_inode_server.

The NFS server in this test is a Solaris server which issues
CB_RECALL when receiving the all-zero stateid in the SETATTR.

mount=/mnt/data
for i in $(seq 1 20)
do
   echo $i
   mkdir $mount/testtarfile$i
   time  tar -C $mount/testtarfile$i -xf 5000_files.tar
done

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 20cb2008f9e46..035ba52742a50 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1001,6 +1001,11 @@ void nfs_delegation_mark_returned(struct inode *inode,
 	}
 
 	nfs_mark_delegation_revoked(delegation);
+	clear_bit(NFS_DELEGATION_RETURNING, &delegation->flags);
+	spin_unlock(&delegation->lock);
+	if (nfs_detach_delegation(NFS_I(inode), delegation, NFS_SERVER(inode)))
+		nfs_put_delegation(delegation);
+	goto out_rcu_unlock;
 
 out_clear_returning:
 	clear_bit(NFS_DELEGATION_RETURNING, &delegation->flags);
-- 
2.43.0



