Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D2522258C;
	Thu,  3 Jul 2025 15:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555945; cv=none; b=uB/mCvLJDu7106zc8IElw7C5v04gebiVVJ1JMUO3UO+OQ+9fGqFtMHGjceTThp6QTga1IoPIBBUW+qc7nsSPAIVLEfimXx0pJt9NcVPmX3n8ejvYispEG8LwEG9QmsM0oBYYcexlDNzpBBYzjBZoGCYq/PAHiXUhtDEFr6NQKuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555945; c=relaxed/simple;
	bh=GdNBAFlcBylG2F/QPb2XqYyIWw9PchLCFucfdXojUvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaNyPPvRvpK79NB6cagvpNULLKeUiO5eS2p86OJtNqO2xzvcl/UPvAJjFQrey8+JSSj0vRXf28BraE5SSaBlfdt1Hwoww7NRU3enrV9zp1k7SX9306RZB7Ga0OTfGlkjT4RWXa8F20QSe9w7oAR8NIqpUjOOr4wCQ6g22UksKC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=107lknPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="107lknPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D393CC4CEE3;
	Thu,  3 Jul 2025 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555945;
	bh=GdNBAFlcBylG2F/QPb2XqYyIWw9PchLCFucfdXojUvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=107lknPZPXT5+WlNcqjpHP9zWyOq4NlM+ow49M1xNbkff0fxDwGzO860xwhA6KwKF
	 gbfku88UYrkfg6WrQEvRVcxMo5alJaSxw8cTjnUklVPWedhTSVxxgG5MCdVCBtFvKJ
	 2QFRnjYOSt+hb9sG8UY+kJPwN2SPLeggpdhsLgfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Young <hanyang.tony@bytedance.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/132] NFSv4: Always set NLINK even if the server doesnt support it
Date: Thu,  3 Jul 2025 16:41:32 +0200
Message-ID: <20250703143939.519377849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

From: Han Young <hanyang.tony@bytedance.com>

[ Upstream commit 3a3065352f73381d3a1aa0ccab44aec3a5a9b365 ]

fattr4_numlinks is a recommended attribute, so the client should emulate
it even if the server doesn't support it. In decode_attr_nlink function
in nfs4xdr.c, nlink is initialized to 1. However, this default value
isn't set to the inode due to the check in nfs_fhget.

So if the server doesn't support numlinks, inode's nlink will be zero,
the mount will fail with error "Stale file handle". Set the nlink to 1
if the server doesn't support it.

Signed-off-by: Han Young <hanyang.tony@bytedance.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f2e66b946f4b4..e774cfc85eeed 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -555,6 +555,8 @@ nfs_fhget(struct super_block *sb, struct nfs_fh *fh, struct nfs_fattr *fattr)
 			set_nlink(inode, fattr->nlink);
 		else if (fattr_supported & NFS_ATTR_FATTR_NLINK)
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_NLINK);
+		else
+			set_nlink(inode, 1);
 		if (fattr->valid & NFS_ATTR_FATTR_OWNER)
 			inode->i_uid = fattr->uid;
 		else if (fattr_supported & NFS_ATTR_FATTR_OWNER)
-- 
2.39.5



