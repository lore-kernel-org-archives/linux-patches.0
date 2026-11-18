Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046385;
	b=qGpDyE5Aj74pX2nJ9fs4GKlJumCICkVk905LpBOQCQ+tvxtmlzSWVqxHk5D9yPNZZ782
	 N1+6z9A203cWZ1+LIOFkE0UOGgKqb8jy0Zu+WsdLrqSbvusF+hX1Cy5LSkwgzapfzqUH/
	 3o3eJDpPmM7o+XUYuDWiu9lhIXtPCkAm+GuHkIVJfp+u6b93e93WGoqxJs4eFny5m0QUg
	 K7CLiYPEsFDhGisPAgG/C22NfQiovnMd2ukPFtA4bosgdG9odghu+VNOEM6ams1NxJ+Bt
	 +knO5sBiiK66lM6Gmz1uyIvUg22SGWLcMmwl7iqlvlpnxC/LuDlSlijVZZsJVpMBC4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZIAFj7Tp+xcRBVzNSZVBbVqDOvqiKev9WwjeSecp58=;
	b=a4Bi9aqUQeCaW2TFwPLYViR4MH5hgraJ30+015WFnCnKQjotYiy04x+ZgOMNToHXTfTp
	 meWqeKLG1gV220vL991x18RvnciuQ9HxB+csP1jgypVkPanPBtatMiWVsCPBC2lxYQabE
	 SfVKBIVrd3UOeu6rMuhlWVw+9gAYsguMkdEZ0FLaH13zBg0fyoqpHylQv93FXf3+yHZOI
	 l/fjtfUKDZUyN72j6fcg6+o0zDB7NDl98u3+/oPjbLJcA3q8ph0IdIeXeE5EgxmwQZEwR
	 Ur7HXAPJ1TJy/NPrArMxWBZKy7+jYCH1nRvYzikAMOQQNZmgStBsq1jku7+yL/p3m+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQe8DStq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143C606A325;
	Wed, 18 Nov 2026 23:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQe8DStq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5891F000C4;
	Wed, 18 Nov 2026 23:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046385;
	bh=QZIAFj7Tp+xcRBVzNSZVBbVqDOvqiKev9WwjeSecp58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQe8DStqXCZYEq78W/l/c5yHXtvpBjPzNu+SefoVA7BXBO3xBVRRJq1WFyE9fmA5K
	 9pRCKTI0PkXa9fXcJhC+JepXMWMcEuAiMQbSWyM0n0zf6eZhGI04kr+fDRU8hPkvBy
	 XUZMcZxpf9NQZuiNc5NWjFUGP4KvRwrK+XGztAyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1263/2857] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Wed, 18 Nov 2026 15:38:17 +0100
Message-ID: <20261118150247.007299582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 2bbca049deeb1699cafd966cb2793fee576ee409 ]

In xfs_btree_lshift and xfs_btree_rshift, when XFS_IS_CORRUPT detects
an invalid firstrec/lastrec result after xfs_btree_dup_cursor has
successfully allocated a temporary cursor, the error path jumps to
error0 which returns without freeing tcur.  This leaks the cursor
memory, the xfs_group reference, and the per-level buffer references
held by the duplicated cursor.  Jump to error1 instead, which calls
xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR) to properly release all
resources.

Cc: stable@vger.kernel.org
Fixes: 9eaead51bed95 ("[XFS] implement generic xfs_btree_rshift")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f5c3be85b1356..001db93eb0b90 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2468,7 +2468,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2638,7 +2638,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.53.0



