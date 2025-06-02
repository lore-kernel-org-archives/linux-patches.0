Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AF121CA1E;
	Mon,  2 Jun 2025 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875393; cv=none; b=olTxuMdsxF8Wvp0sibGSXgv0JZ4DAOaaQViRkQWU0TrkSbdaJS9ukNNKMg0USFUTAMMtHRwrMCjyN/9ZvqknCTBLBmKryVQWaicv6/DMyiUe4M49RtOBRLtxvQ3nrv++uLhsZDD6onqlA9k4v1n28RLXgVgpPGBw6+KF2oit4go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875393; c=relaxed/simple;
	bh=TW7TLZC40qREbmmzIy+cR3dCqgGYMiKnmepVJXPgr2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOnivo1iLdezaGaULYWtBZLLlxjVqJHxD+WQ1ZG4xlKkJkWF1URkFsLY8txEFhcEGCQ/9AX1L3SzOBjUgd5pNGmxr69g7bt7L7GxUk3+UTyi/UM+tv/BVd1SwLSUQfVooQ9iSyycCHbpqWCZNRsKglTfOIu8/lbwYBTm/3TG0pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCnpk0s6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCnpk0s6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD86AC4CEEB;
	Mon,  2 Jun 2025 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875393;
	bh=TW7TLZC40qREbmmzIy+cR3dCqgGYMiKnmepVJXPgr2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCnpk0s6bkxY+9fZkMEO46i7UYD8N6SAg8czy9g+mk+LI1F3/lMfbwCxyxkzHo3Om
	 qhxI46AnxHyUIlLAZfAZV4ntDBz78c5EDgHMBnRc3kCw/+zVFe8p4IIEuFRGvrhEbK
	 ta568wwAD3VVMwq8zICRRu2eisOe1vRX781Lvdr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/270] NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()
Date: Mon,  2 Jun 2025 15:46:45 +0200
Message-ID: <20250602134312.130560932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9e8f324bd44c1fe026b582b75213de4eccfa1163 ]

Check that the delegation is still attached after taking the spin lock
in nfs_start_delegation_return_locked().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index dbed8d44d8053..f3bb987e9dba7 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -297,7 +297,8 @@ nfs_start_delegation_return_locked(struct nfs_inode *nfsi)
 	if (delegation == NULL)
 		goto out;
 	spin_lock(&delegation->lock);
-	if (!test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
+	if (delegation->inode &&
+	    !test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
 		clear_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags);
 		/* Refcount matched in nfs_end_delegation_return() */
 		ret = nfs_get_delegation(delegation);
-- 
2.39.5



