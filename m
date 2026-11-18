Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037712;
	b=3N07xDRD7NPfBcFDUfBikeseJKRCC3cP1tl/+i+f3gvIx+tiSWqq+uB0iYG+42Icv8fy
	 0EcMJ/zMOkeCmoYsdp0doNj+wGL2f+B6O2CO/m/qZrOcuWbD6+2lb2OGSdFZxGigHgGWX
	 M0m/xv1oMR3zvRrPUk0/O/yL3tQ9TOInWNgqg56AxodiiNBqy9AlFoFcqkR5F6CocXyNK
	 etv63PfLYtTHe8UbFAFfLTQJkvr5bmuf0SmAcSvavYepNfVOmUCdIWwJiqP/oibTDQhRY
	 mPYgxm2BikyRUdhFFWAuVz3jfDCdOpj4JjGPNtuto03N3xOKgdUfdDREWcUd/RGQJzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4NwOHqMTYJC4ZkNQe2x5JQQcVI5X+lWIMwGwnk4QOUI=;
	b=m2/HeL/p4CqMI/lQ7m440QFbk3+nMR1d+U+/3VOTtao7tpu9B4Chb/f3ZrALsyL8/7Oy
	 sRYC9qGaMJKP7KNBw1fsulHFv0cWFR27G6g8C5TzVDsO40xlrwUBQDFSatMInUTPtHxjV
	 SiG3aL4yE+/4hVAvkNE5ibGcnHbFC4yGWsOkj07GmiCYb5efQjW2JYnK3DZ3oJqXBMmkb
	 Es+5nJj6DYOdqa2GjaCyU/mMFDjlA0njyHbxmnxIjcYVMV/U2rEnEcB6fx+dn287AVrtY
	 7FYTiLjigvda4TvkSkj4qMs/8yuavkvK8Z0/w5zlhgw7wwl+L8+EAdidjzk7uca2nZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTb0msxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89838606A320;
	Wed, 18 Nov 2026 21:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTb0msxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2771F000C4;
	Wed, 18 Nov 2026 21:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037712;
	bh=4NwOHqMTYJC4ZkNQe2x5JQQcVI5X+lWIMwGwnk4QOUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTb0msxjhfXGTA9rk6LCNI1FQLArdQw+O1/1W7zUjz7qNIOtMM9j+WOHvFbIfiT3c
	 +Ad1/p75MzNuxH+pBGXpVCXEKhkMOKSnhcVa/v7nzrzSdF8cE26YFPx16aryM6E4B1
	 Z6o8QS8djB5L63KBQmqG4FTZ/NsQgyTQ97CU2we8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1493/3318] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Wed, 18 Nov 2026 15:35:15 +0100
Message-ID: <20261118150405.696772840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1328dadcfc299..331bf27f2b219 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2467,7 +2467,7 @@ xfs_btree_lshift(
 		i = xfs_btree_firstrec(tcur, level);
 		if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 			error = -EFSCORRUPTED;
-			goto error0;
+			goto error1;
 		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
@@ -2637,7 +2637,7 @@ xfs_btree_rshift(
 	i = xfs_btree_lastrec(tcur, level);
 	if (XFS_IS_CORRUPT(tcur->bc_mp, i != 1)) {
 		error = -EFSCORRUPTED;
-		goto error0;
+		goto error1;
 	}
 
 	error = xfs_btree_increment(tcur, level, &i);
-- 
2.53.0



