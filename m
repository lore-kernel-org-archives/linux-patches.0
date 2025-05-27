Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877C61E89C;
	Tue, 27 May 2025 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366492; cv=none; b=r4/7TgmLHwByvdoJ0pgtD2ttVRTKCuqhUchA3WiD8lch64ovCQlf1yzYFF8/L2R+qeAay7K6AqPoDzPfl/D8JYAtDsj8vtgBU9CbQMNSAdTYBrig0hoKdchbpCl/7nCCRtl8vHfgh93SzMG0BEaSR+1/7Qn9qEPIaZt81YbHxN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366492; c=relaxed/simple;
	bh=UKX/NNFWGCGX/ub1Z8Io+lM7ivaAbR14gjB+3S3IDJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UixImE0Ct7mUxKF+ed76QOJFt5FqVarD42bkjQySKeAKxX3i/R620rwgtx78PdYEltP4ZsW7NYtjKtB/5BN8yEIGsbJANV65WKWCk2MzxPeTx/dEGKeK8uMDez0k4HUWnDgpOqUlQcwVkX/nBY7PTYIoWA0FfXm3/G6TPn8hibI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmy45atI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmy45atI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EE0C4CEF3;
	Tue, 27 May 2025 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366492;
	bh=UKX/NNFWGCGX/ub1Z8Io+lM7ivaAbR14gjB+3S3IDJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmy45atI0PHzLeckTBWT/e6rkn+n6GxkYY8xPPMYZlz1kXo8lfmsTsP1V8aU7/dPL
	 7gGagsD68NDmSy73a1Z6CjTidzEgKQFCqVy262Xss/UicM22Wu1TeRhbrr8XA+luOU
	 PsHZPHu9/C2l5fLm5eisb8texnLy8moPDfU0/INc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 055/783] NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()
Date: Tue, 27 May 2025 18:17:32 +0200
Message-ID: <20250527162515.367236512@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 325ba0663a6de..8bdbc4dca89ca 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -307,7 +307,8 @@ nfs_start_delegation_return_locked(struct nfs_inode *nfsi)
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



