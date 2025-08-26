Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A88352081;
	Tue, 26 Aug 2025 14:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219451; cv=none; b=uGf08hsF5tRDNwQWfeU8xWz48QnF+Zwnb8Rlu0FqSnEDmPY6KaG1ksma31pfH2//XIITPywKX9ZJWCFbB23EjqGl0hzKEHXvIcGbU1lZGTkrKYAtsHLWFM1rKXrJHk3xg/7scu4EPmRo6WOfpyZKKf8oVq/i/FoZyjKlljtg9no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219451; c=relaxed/simple;
	bh=153HfmSyorCxoOpzJAF7V3n+c/JUtVXxGtsupAxsTsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je0e7s2oz0e4jQorhljnD0/WdIXR6wiReMNkTmigbFdS6S/rftNtTGt+RnKlPndSvfsDL0WJGLaUtQzIkOGoBLpJDk8+NO3KZJIqrzec9Y1IhBNqVSJJTy/xRmJS3PFcfbrpPeBaABA6I8Pft7py0SKISMyOfsFDrRd2wMKFi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfcyBrfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfcyBrfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E035C4CEF1;
	Tue, 26 Aug 2025 14:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219450;
	bh=153HfmSyorCxoOpzJAF7V3n+c/JUtVXxGtsupAxsTsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfcyBrflvucSFqE7rBSsp3Q1vAagBx1pShkpft5u6wknl6CQmUjbkA/9APJXqYfx7
	 /ubqJfomgU2fsR32ZUHX+sHyfRLzWsmut3eho4y0uh8WE1AMI8YLAPgcYS1eLsAx9a
	 t2lBjPo0a7VKodmAUlY/Zb0iPyJ2xrPKIRW/GmyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 356/403] NFS: Fix up handling of outstanding layoutcommit in nfs_update_inode()
Date: Tue, 26 Aug 2025 13:11:22 +0200
Message-ID: <20250826110916.712230955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 709fa5769914b377af87962bbe4ff81ffb019b2d ]

If there is an outstanding layoutcommit, then the list of attributes
whose values are expected to change is not the full set. So let's
be explicit about the full list.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a new filesystem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1869,7 +1869,11 @@ static int nfs_update_inode(struct inode
 	nfs_wcc_update_inode(inode, fattr);
 
 	if (pnfs_layoutcommit_outstanding(inode)) {
-		nfsi->cache_validity |= save_cache_validity & NFS_INO_INVALID_ATTR;
+		nfsi->cache_validity |=
+			save_cache_validity &
+			(NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_CTIME |
+			 NFS_INO_INVALID_MTIME | NFS_INO_INVALID_SIZE |
+			 NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
 


