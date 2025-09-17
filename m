Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04FD393DC1;
	Wed, 17 Sep 2025 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113698; cv=none; b=ST+yYk++OVl3VcTT+sDvmyHxjrMWApU4vT5M7sk9LolvNMaKi85LUkvEJO7eO5gaI66YoQV5a1DAQJkE3PSO3XB177kTmgMLU9j+Zo1Y0RyTOQHc3nbidD3kkRM+fuBEztSYxOrp0KmlSh+ld7CKK/QTAplCNcHt1BBgTDzlOOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113698; c=relaxed/simple;
	bh=eB10m804QzM4duHm78hp9VGoqZ2+hnB4gAXFBrercN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cojLnXAW5WX3CE77SMgCyFqFMF2NUkpNUudkoJHVvtSE2Ji10zwGnVj1+0Sf/4vhAArV4e8Zz6TXkAG4lgaUGERenWer5Oxz3eim7U+FqOy02mm2kSdG1JNvrKusDqPWo6qxCy+8zjCqEWmdM1jCSghPdl4z07iKK72oH62MJKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7vDnZJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7vDnZJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F28DC4CEF0;
	Wed, 17 Sep 2025 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113698;
	bh=eB10m804QzM4duHm78hp9VGoqZ2+hnB4gAXFBrercN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7vDnZJIrNCjHnygU4f8QGNGICvcO5srXTQ9gKof4b6SEf12pZDosdE2QbbbG75vN
	 jEDydpShlVbnNMs1DKFyNDe4v21iJby9dnJCoJz2N/rTA9D3VLwTWBk6UCAIawaIyq
	 92DNIKEB7APwjsXvT+t3VZdbFARl9FvwCYLXR644=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/101] NFSv4.2: Serialise O_DIRECT i/o and fallocate()
Date: Wed, 17 Sep 2025 14:34:01 +0200
Message-ID: <20250917123337.300180686@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit b93128f29733af5d427a335978a19884c2c230e2 ]

Ensure that all O_DIRECT reads and writes complete before calling
fallocate so that we don't race w.r.t. attribute updates.

Fixes: 99f237832243 ("NFSv4.2: Always flush out writes in nfs42_proc_fallocate()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 9f0d69e652644..66fe885fc19a1 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -112,6 +112,7 @@ static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	exception.inode = inode;
 	exception.state = lock->open_context->state;
 
+	nfs_file_block_o_direct(NFS_I(inode));
 	err = nfs_sync_inode(inode);
 	if (err)
 		goto out;
-- 
2.51.0



