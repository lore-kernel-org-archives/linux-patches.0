Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0159221FCA;
	Mon,  2 Jun 2025 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873111; cv=none; b=f2epxeVwXo0Ce0/nAeNRfrErFIPEUP5NJsvQBgMr7jOzMWt96O/CyRY6DKsZTcrIbgMEzne90H05C9KC9DpGye39h22zfGyQA8Jtbm5gcq0tKk5/8Bd+7DI8Oz1lCtJhIm62cQOJiIWY+c0NWrkKVtnpuZAe6+oNO8fPK15eo8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873111; c=relaxed/simple;
	bh=Vouz4teya7lc9/i1vDwEF2KCAuaGpMxl3izMUiXC8Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptyk/zpcoCp1YdCw4WbZaAS7KC70bfgQGJ6FTJ9UwXag/up1ZW1wSS/cAAmbugv4YA9EbNMh65xdsOi2QJnLA0aO33lcU7DzPjAckBasMOMfEk9XFV8x/tFjypUjQgl8Ebs0Os+c+9iXUCUwP5PXkMeSRONtcQvfVXwEAB+uF/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcRWsVB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcRWsVB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F370C4CEEB;
	Mon,  2 Jun 2025 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873111;
	bh=Vouz4teya7lc9/i1vDwEF2KCAuaGpMxl3izMUiXC8Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcRWsVB7g4Kc9WweXQasosObjyrNaBLs+dq3UKcKc85z38btDtUF6ifcDMYU5vhEt
	 QG+pdlkBDha8lUtKFQU7vtv88TSSlHkZXPqHaAwS23+v7Yd6j3kx2yi8vBQhi1NK+w
	 knILwxHdpe57VCeO4RYQgK9G8VoxXcj2JWRMff3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/444] NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()
Date: Mon,  2 Jun 2025 15:41:44 +0200
Message-ID: <20250602134342.555082628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

[ Upstream commit 9e8f324bd44c1fe026b582b75213de4eccfa1163 ]

Check that the delegation is still attached after taking the spin lock
in nfs_start_delegation_return_locked().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 55cfa1c4e0a65..bbd582d8a7dc9 100644
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



