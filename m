Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6D830F951;
	Fri, 21 Nov 2025 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733335; cv=none; b=er/MrGEBa8QgHKMXUSWiELz9rDOc1o0kiEUvjcqhMVIVYZ1mUP+PyvKYq/7sLPNgfrJ1H5dfPN+KZNWjz5zC+l4J/SXG/oSZdHiAzCeKnAJd44CGdpOMMJix54Y+E9wbnHMDKggw/U8JnXp4gmBkCy4W72fRRw6Of21Xw756jBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733335; c=relaxed/simple;
	bh=vHpnXiMyh7rxe7AKzosbNoVnRqmhblwsUxT0oOk+8ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPVC8qSy2rAEztdOoHGHthrqjpK11eE4DZjgV5rA14gOuCURgny/SEZfVkgunqdTAMFLPNBxyfxzcZCWNQ7wnbLTO8PjuHZy6P2xjGbip56DxfnP/yZ1HCEpDfX3h4Bx5Bu2NHqzmLFFv0Y4MASBzVWBI0YSMOjqQoWBcxUgrek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jr1JmLUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jr1JmLUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9E6C4CEF1;
	Fri, 21 Nov 2025 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733335;
	bh=vHpnXiMyh7rxe7AKzosbNoVnRqmhblwsUxT0oOk+8ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jr1JmLUFZjQ1oRRXjhu3eGujZuOdtL9foT+skE2YglbkbV/oIsgDHv5MDadf3dXlo
	 LtWUszAgykdb3rNXkCOpO10q02nYkMUryUvAW6iL/p1LMvDEsrXnvlahCnYWujZCLU
	 vfuy8TEfrNar0+bwEGvzoirEVlz02fUPjAv5Uyno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 434/529] NFSv4: Fix an incorrect parameter when calling nfs4_call_sync()
Date: Fri, 21 Nov 2025 14:12:13 +0100
Message-ID: <20251121130246.456601261@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1f214e9c3aef2d0936be971072e991d78a174d71 ]

The Smatch static checker noted that in _nfs4_proc_lookupp(), the flag
RPC_TASK_TIMEOUT is being passed as an argument to nfs4_init_sequence(),
which is clearly incorrect.
Since LOOKUPP is an idempotent operation, nfs4_init_sequence() should
not ask the server to cache the result. The RPC_TASK_TIMEOUT flag needs
to be passed down to the RPC layer.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Fixes: 76998ebb9158 ("NFSv4: Observe the NFS_MOUNT_SOFTREVAL flag in _nfs4_proc_lookupp")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 92e40e41443cd..a0a71a163ffed 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4578,16 +4578,19 @@ static int _nfs4_proc_lookupp(struct inode *inode,
 	};
 	unsigned short task_flags = 0;
 
-	if (NFS_SERVER(inode)->flags & NFS_MOUNT_SOFTREVAL)
+	if (server->flags & NFS_MOUNT_SOFTREVAL)
 		task_flags |= RPC_TASK_TIMEOUT;
+	if (server->caps & NFS_CAP_MOVEABLE)
+		task_flags |= RPC_TASK_MOVEABLE;
 
 	args.bitmask = nfs4_bitmask(server, fattr->label);
 
 	nfs_fattr_init(fattr);
+	nfs4_init_sequence(&args.seq_args, &res.seq_res, 0, 0);
 
 	dprintk("NFS call  lookupp ino=0x%lx\n", inode->i_ino);
-	status = nfs4_call_sync(clnt, server, &msg, &args.seq_args,
-				&res.seq_res, task_flags);
+	status = nfs4_do_call_sync(clnt, server, &msg, &args.seq_args,
+				   &res.seq_res, task_flags);
 	dprintk("NFS reply lookupp: %d\n", status);
 	return status;
 }
-- 
2.51.0



