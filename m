Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7854333A8E;
	Wed, 17 Sep 2025 12:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113980; cv=none; b=hwmuVK1bNdDP4DJdIeNuVXKI2MfAVbYBe2Sq1VDPwI+J6Tj9LY/3E+gWwoCIZOfj/gvEU8e+wmr4GuuLdXNAcCnWxJQ1aWUNEbtTSnjVeaTwZ2cjmlVEGem2bQ9W8uVQyEXb4Nce/L2P8v1aWeKlp9KOVJz0XMdSSAW+rXKx6Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113980; c=relaxed/simple;
	bh=CN9kLrhx5NRlM+w9YFr/laNN6hX97mLKDSClA4hU3JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks992eJ5jbbr6gaq2VZo0kCgUPi/1syCXr6ce1F/c6k+a5b+CISVm/V6A5m2PRtkaBQhNZquF7YXIQJqGtmh4qdncRE7E66qpXZuXP6MVYNinXzRMKVc5VSCADHYgL6BhPaEgQBvG7BrFgQO/GXLg0MzzPGQMMw+LRymvFZQ3dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dq8+JZ5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dq8+JZ5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EE4C4CEF0;
	Wed, 17 Sep 2025 12:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113980;
	bh=CN9kLrhx5NRlM+w9YFr/laNN6hX97mLKDSClA4hU3JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dq8+JZ5RueHj56mkOoQoLzCBlAQntsbFvJFFrCibxwWuLl2MAQNe5Gj7U6LqEw2bM
	 4+kP3B2hhSyyCWtJjQO0YqwL/30dL6g1GXnt1KocBXF6y+ArXBrJ+rBlvohy8OZ6kQ
	 KbUSTpuf5Jw5RsP6mdYHEi6EuRImUOQoBLB+K/x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/78] NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set
Date: Wed, 17 Sep 2025 14:34:32 +0200
Message-ID: <20250917123329.843768183@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dd5a8621b886b02f8341c5d4ea68eb2c552ebd3e ]

_nfs4_server_capabilities() is expected to clear any flags that are not
supported by the server.

Fixes: 8a59bb93b7e3 ("NFSv4 store server support for fs_location attribute")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 29f189dc334fd..f8a91d15982dc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3888,8 +3888,9 @@ static int _nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *f
 			res.attr_bitmask[2] &= FATTR4_WORD2_NFS42_MASK;
 		}
 		memcpy(server->attr_bitmask, res.attr_bitmask, sizeof(server->attr_bitmask));
-		server->caps &= ~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS |
-				  NFS_CAP_SYMLINKS| NFS_CAP_SECURITY_LABEL);
+		server->caps &=
+			~(NFS_CAP_ACLS | NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS |
+			  NFS_CAP_SECURITY_LABEL | NFS_CAP_FS_LOCATIONS);
 		server->fattr_valid = NFS_ATTR_FATTR_V4;
 		if (res.attr_bitmask[0] & FATTR4_WORD0_ACL &&
 				res.acl_bitmask & ACL4_SUPPORT_ALLOW_ACL)
-- 
2.51.0



