Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEABC26CE33;
	Fri, 21 Nov 2025 13:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731164; cv=none; b=jAZM6eFALkXaKc8w8Wz1l2L5PbobenYbT57RwKVhK0rCZkRKU1LdXolqMoQfaa7spJkmQJ0TXVHZEv7NC9JtbqZhtNLuWHbQqg2a1pjat6716KyC2ns13Kt4EJjHjFZNrM8M6Efi2zPNDIPEOPrYJVd3rmklLaSHTVlrtoun1/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731164; c=relaxed/simple;
	bh=tLFGxlgF42GbLxLXSHpHd2IDOz7Git4cvyj/I62glfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISTNPcUiST4s+vPe7ywL2jNpy1u5o+OVwv9a3TYcnD/KqaUG9oMDLJdYLZZbdqdY5hFOxUrg9/PEi1zJN28i0CfSvzsw08rvhCEXn5RuSAzD2P1iwcPXamUPdUCzwV/G3xsswvSQoMDi9bjR09qVO2f24rnp4WQoLLtoisj/8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWRFFmj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWRFFmj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D23C4CEF1;
	Fri, 21 Nov 2025 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731164;
	bh=tLFGxlgF42GbLxLXSHpHd2IDOz7Git4cvyj/I62glfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWRFFmj32Em8fIr3JfjP2xfeQ82ahPkMBCZrX5d2/q4VBuqSbgeV1paow+Mst81Np
	 lyIWyxwXg3tW7rI05XjKfvrIMyNeWboc3BrE2/r6oojXHdn8bBW6cPiDv8nQuiMWsV
	 IBuKcG3/XSpKn9RH8tvCzbtGky4Wfrnu5FhYrGj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 111/247] NFSv4: Fix an incorrect parameter when calling nfs4_call_sync()
Date: Fri, 21 Nov 2025 14:10:58 +0100
Message-ID: <20251121130158.568142826@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e5fa29dcdd114..a1e95732fd031 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4715,16 +4715,19 @@ static int _nfs4_proc_lookupp(struct inode *inode,
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



