Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78B32C21F7;
	Tue, 12 Aug 2025 19:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026689; cv=none; b=TR/RywP7Frbh6zTy5V5QxKRmLFJ+4PvvmY4q84n5WsjOdm+U+epHV+pscmRQlJiaF2NMgLOZ32YyXNG2yj+N8/rHPNIknFVtI/yOMeMNM0laGWTQ0x1zW4MF6LaVtodeC9Glls/lJv8FElGzQtbjIRAN2VX+5vsv/IJglm3xnZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026689; c=relaxed/simple;
	bh=sTntPvhtE/HTXHQS0a/loG9/x7j7EuFJqfY1pb9CpZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVfg4SeWvt18290HNyCxYqZaN8dAkt+CJ126Apj+NWugy8Jt/UHhAHgRkc0gzKdVAtQL6CJ+slHL+yOHDIxJ4aJUb/zckkuw57w/xIAZfz8a0TPZUq7efy+hgt3FxSnrHd06mlk+kkd0PV8GLbuZ63cuwN6/+X/mkPPyxkeTIdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU3QSAaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU3QSAaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F031C4CEF9;
	Tue, 12 Aug 2025 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026689;
	bh=sTntPvhtE/HTXHQS0a/loG9/x7j7EuFJqfY1pb9CpZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU3QSAaVUq8AtsxW91bhVn4V431xqZXOMyaheWYPkZkXB9Ql2bxc05LRc74zfBSyx
	 pQn7SpG+a77WK2t153EY3koZD4n4hnN5caSOly15RmGxWtt4CMsXukNMrvQl/db2Sc
	 vy5wCbUSGl2mdEJ5Bq8wCjSTL6c6IQGBWjy2SlUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neil@brown.name>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 412/480] NFS/localio: nfs_close_local_fh() fix check for file closed
Date: Tue, 12 Aug 2025 19:50:20 +0200
Message-ID: <20250812174414.416088605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e144d53cf21fb9d02626c669533788c6bdc61ce3 ]

If the struct nfs_file_localio is closed, its list entry will be empty,
but the nfs_uuid->files list might still contain other entries.

Acked-by: Mike Snitzer <snitzer@kernel.org>
Tested-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Fixes: 21fb44034695 ("nfs_localio: protect race between nfs_uuid_put() and nfs_close_local_fh()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfslocalio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 05c7c16e37ab..64949c46c174 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -314,7 +314,7 @@ void nfs_close_local_fh(struct nfs_file_localio *nfl)
 		rcu_read_unlock();
 		return;
 	}
-	if (list_empty(&nfs_uuid->files)) {
+	if (list_empty(&nfl->list)) {
 		/* nfs_uuid_put() has started closing files, wait for it
 		 * to finished
 		 */
-- 
2.39.5



