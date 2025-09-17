Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9734E36D;
	Wed, 17 Sep 2025 12:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112635; cv=none; b=pEOi/SjClVx51b80n/VQ7PeVwmgSIsaHrPj+3tDMHIwHrkJJVxrapNGD1ddthKjF0KnAOsqhQZUGKPpmCo/8+QgSz6l55kIzfnddJwLpqVJW8d1G6UV/1VZ48ZcrZQ2tWPtNOwCdo2942PT+bqLiNFH3+jZ7v0R6Nqeis/iFUPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112635; c=relaxed/simple;
	bh=Bjx7PnUcZNqlqsCHiG7LPBEACXEw2z0BmiFNSNAtDqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwukSifDYrPkEPzsi2Il/8Abhf+eUvD6Pvjfj9mt6Owhf+fXWVYN1/j0voFCOJbnOtXDMAWZ6Sb1mVVxTPwm2fNRMCvmhitqcyqFzoRztYyg3EXaBeUdxreEMPKetG0wyLy7KZUavSA2xdkjh4yoOOGrZjYgOg0j6IfKrno6TjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1KjwKP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1KjwKP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A9C4CEF0;
	Wed, 17 Sep 2025 12:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112635;
	bh=Bjx7PnUcZNqlqsCHiG7LPBEACXEw2z0BmiFNSNAtDqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1KjwKP3o9yU4r2y5FE7kZMyWwk0ClX+zFldlo6vwSGH+TpLh84AYDgT1wmsO7tto
	 LZrE7mtIpb286Jsis7HCTVzi6MZMby3yfjpYcMkJqRu2QUVdC8FvPsOhwPnSNKr8Ty
	 AQcKW9BGzLcHNnlQN+amUbhTfLsRIOcIczq78Vvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 030/189] NFSv4.2: Serialise O_DIRECT i/o and fallocate()
Date: Wed, 17 Sep 2025 14:32:20 +0200
Message-ID: <20250917123352.589831696@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 01c01f45358b7..3774d5b64ba0e 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -114,6 +114,7 @@ static int nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 	exception.inode = inode;
 	exception.state = lock->open_context->state;
 
+	nfs_file_block_o_direct(NFS_I(inode));
 	err = nfs_sync_inode(inode);
 	if (err)
 		goto out;
-- 
2.51.0



