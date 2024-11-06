Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F041E0493;
	Wed,  6 Nov 2024 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899213; cv=none; b=ZpLA2TV+CEGwe9MvdXBrjlm+oVt/lRNImzezQ2PEdCaRgfKh3CdZUdtUSB/it/EjUdYs+ztAWCYyXz82p0HflvJFmPpV1cwHZj36iecj43NVdAxU5WETsH8JGmXQKng/w/8uO8bOm4h9NZJefy5xz4oNPDc+zrPxFvrIMIzyBI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899213; c=relaxed/simple;
	bh=xGhEA+/IAbkxK7zlLg9NXmW8m1vf3O6f+tPqEd5DrlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suuLeSx99u1iuGUtdm5ntgrxTgnq8oTmbR2fIECnWeycArSR8O3w7ROGbKq9/W04NdgDJMLRAZlrt2tddgVNaXtcrdJ8ySE4Fo7xHdrnA9bllgUbYSW0rElqu7N3e6KFvjWXxPmAmd6/DbPYJDWVDHc4X+vdh9h1zUKNcVms4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPiQYJPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPiQYJPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D94BC4CECD;
	Wed,  6 Nov 2024 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899212;
	bh=xGhEA+/IAbkxK7zlLg9NXmW8m1vf3O6f+tPqEd5DrlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPiQYJPdPbTZKbi9M/wkHGhSw8rbEymKqBE38ZOLTPuB7a7HdPHV+XPc24UnhLSJW
	 UA7augXehzQxHKwK5g/p07dF2FAvzhZukbWT6WEDm5pJ6pfRZ17HTU4/9yC439fWpE
	 WImnQOFBU2oL7MH/6Da9hcw1eJ2olZOjSCGb4pm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/73] NFS: remove revoked delegation from servers delegation list
Date: Wed,  6 Nov 2024 13:05:40 +0100
Message-ID: <20241106120301.042347210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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
index 8124d4f8b29a6..ac79ef0d43a73 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -981,6 +981,11 @@ void nfs_delegation_mark_returned(struct inode *inode,
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



