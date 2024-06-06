Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A53196DA8;
	Thu,  6 Jun 2024 14:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683020; cv=none; b=APU/KWC8y9iwum814LxBvW1ATFTZUXCQNNsQ62hLqlSAOb2hjKp2W7o5O/iKyLkayXRo5exF+Wqm75bng9fcB9EuiU9hiYp2L1ERKDEALl1qF4KXCgDFJYcbmTW89PXcW2PXjH+fEQ1moso6xWSS3L7Mj1uliIbuccOZ7hUdddY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683020; c=relaxed/simple;
	bh=vYAodncs2chlTbGn39+JuzKStNRSYYY+He4Xn61N0hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKlN9sRa7bwFahXwC1za/NA5sAtFDRoILdL5vTX+c/1CHuZLrq/SCER9t9i00EwBG0aw6TnL01hglPzdjZsDoBEamKTJvTC+ZVH67tUeKh6iZ/JvdKghPmJG0szR/Od9GBH6mW0qjdCg8NtzYIMxC8vkJE9Zqsra6+r47TVlAAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqLsXhvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqLsXhvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA663C32781;
	Thu,  6 Jun 2024 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683020;
	bh=vYAodncs2chlTbGn39+JuzKStNRSYYY+He4Xn61N0hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqLsXhvw3tGxf8sFaIcbG+EIxQD3zPdcZO7R4mjMB4k9D/tQ+Hr9pnTsrlD76cazU
	 qgn2Ra3eETwVJU+Wl1vOMnhMnVruXlSfOysUngAUY1PsToc9w2OpkkcdBKO3i3mM8f
	 p86aT6LFyeEtwrMmN3aQkfI/pki3hinewOh2mOLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 240/374] nfs: keep server info for remounts
Date: Thu,  6 Jun 2024 16:03:39 +0200
Message-ID: <20240606131659.864744099@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit b322bf9e983addedff0894c55e92d58f4d16d92a ]

With newer kernels that use fs_context for nfs mounts, remounts fail with
-EINVAL.

$ mount -t nfs -o nolock 10.0.0.1:/tmp/test /mnt/test/
$ mount -t nfs -o remount /mnt/test/
mount: mounting 10.0.0.1:/tmp/test on /mnt/test failed: Invalid argument

For remounts, the nfs server address and port are populated by
nfs_init_fs_context and later overwritten with 0x00 bytes by
nfs23_parse_monolithic. The remount then fails as the server address is
invalid.

Fix this by not overwriting nfs server info in nfs23_parse_monolithic if
we're doing a remount.

Fixes: f2aedb713c28 ("NFS: Add fs_context support.")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index d0a0956f8a134..cac1157be2c29 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -1112,9 +1112,12 @@ static int nfs23_parse_monolithic(struct fs_context *fc,
 		ctx->acdirmax	= data->acdirmax;
 		ctx->need_mount	= false;
 
-		memcpy(sap, &data->addr, sizeof(data->addr));
-		ctx->nfs_server.addrlen = sizeof(data->addr);
-		ctx->nfs_server.port = ntohs(data->addr.sin_port);
+		if (!is_remount_fc(fc)) {
+			memcpy(sap, &data->addr, sizeof(data->addr));
+			ctx->nfs_server.addrlen = sizeof(data->addr);
+			ctx->nfs_server.port = ntohs(data->addr.sin_port);
+		}
+
 		if (sap->ss_family != AF_INET ||
 		    !nfs_verify_server_address(sap))
 			goto out_no_address;
-- 
2.43.0



