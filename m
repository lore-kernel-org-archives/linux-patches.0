Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585647;
	b=EG/18rfTZJcO7Wr4wr61fsO0S4zX+I1yzZn1YoxxYUYK7oUiPm79PlYX37Sgw3+X89tB
	 hnkOxmtlS5YrTjKxtgt6g+QjQmG6e9wBd1i6wgFUQ450Fl7B5alqAN7CpfK3nLpj4dRmc
	 GC2PL8FDHm9T3jfXsCb74v3d9Zl9DC5zVnU9uK07e1jtPVfGaTruEVGSDWh1Sm3HGj0YP
	 8Fpge6YQ2H6hFi5WU+x5WcnUxmgXy7sfRrbghmp5hRKZgscprdfxXyNrikbxmvJWgnjec
	 t0lFNF25e2vj+LJfLccFojtDxtx8b/vyo6GUmIO4tVWsJrBGT1yN7t9FsqT6T+Chrrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPekmYPBi8vg9LbgzMd6+FYhjcOvNAUKHp1xHz14g58=;
	b=LlRxe1UJq4mesqwZ0YEdS0hAwdKX6Pl2PGrE0hhJcUy5okEC5LnB8Qi29eMtGcSpDzhg
	 kyqgFJ3ENamrhTlQ6Uog4UuQOhqJMjMddKBrOBFN+ThmXH/BSUGoFVp4f9/+0pypng0pg
	 J1+vDMz86TnOmCczCSe6ZZYay/eW0kIROzZqQianlXc1mWXoKQFzQYsp5MaWCvFyrXV0E
	 77zSNeGPT1aEynJE/j5e9oYu1dcvo+kGvGQrQkTac1jwK35ISSnnOcfAhtZdKA1T8czqK
	 DHbylcte9aD+CGQKdm0KDIQ+zJMxYBsXgUl3dMlX3iB7S32B+0QF/aG15QosOgPaumA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I/vhipWB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA399606B2C0;
	Fri, 13 Nov 2026 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I/vhipWB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960B81F000C5;
	Fri, 13 Nov 2026 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585646;
	bh=HPekmYPBi8vg9LbgzMd6+FYhjcOvNAUKHp1xHz14g58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/vhipWB33nhm5RmmcOxrb0nh4YXCCaFEklsISXwZ5gLeHC7u7xNLln+mWG0kl4rj
	 eFxe/OAqaKhpHgShL02u88tFVkaECECVTPmyyi39bAVXM82ZKlagOfHvGRzcCA7cft
	 3/zaV/48a0CDtZ3Z/GGSJ2o6b8hNhvd6J880kKTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 263/507] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Fri, 13 Nov 2026 10:49:27 -0500
Message-ID: <20261113153803.463403085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 60ef7f08b1d30..b978ddc13c15c 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2567,7 +2567,7 @@ xfs_btree_lshift(
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			xfs_btree_mark_sick(cur);
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2737,7 +2737,7 @@ xfs_btree_rshift(
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.53.0



