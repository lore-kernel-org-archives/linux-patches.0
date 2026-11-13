Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590361;
	b=JCZJyiwtKFM8/XQq+74Z9sWHqEqVk5U1Z5irOYzmkIxmnxMlM+IAy7S1ULtnbYJM/VSv
	 oZW7XhNIVceP/f19qFlCJmqqYClvU6b29pBiMf57AuXRLRDhqu7lxQWVJj6AwZ5zq/ba1
	 f2/eF9xU6VnExrjzt+aNImRSqpzDLvbqd+HGfbNWl6zytyOZdtygUHp08yxYIP4uEGsk4
	 1qErcXh+iuXH1/RiXC07wktGlHFrIcfUpf7qs3qunP+ZOWoG53R9IvXb0yRgsXxem+FIp
	 Y7ayMC7dJlnc9obOgVFUNHwTjPrVCjHsAFhgXgBwcskBRR7rseP8+att774ydJhWngw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYgzkLKt0+oJGG2ftdCDy2tB5Y0V45ODmgKOoqzJWow=;
	b=Olm9GpvwEqsO1aDuLXdTmaauSJ62dU9EWTDn29OlGSmJdyy5ETJG3+x+rjimIIFgUZgQ
	 m05XSrfj0C5UQ0MU2nHSPZQ/LtQ+XWVqwiULr/8YfEyshT4n1Ato+OjvytFgPMZh3wpVE
	 ePaHLHxcFKnWNrleUUIj+8cFo+qU/H6NqwM8t0aVBG70Esme5HDuhRncpbDF+CGc0Vqd+
	 pH4Z7lDDPZFjJ9V+ms1jpmO3Cm+L2FVIBGk5ZebDvrHlgqAKWcW2/OkgcYh5zzrpk7TdF
	 nC6fECwC8eLSfS/pWcdfHX6sggHyvT4cvnTZtZGrHL9T/IaQUmE6kyH1mwyOt6AL54g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M3uk8OJY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326B9606E219;
	Fri, 13 Nov 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M3uk8OJY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CC81F000C7;
	Fri, 13 Nov 2026 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590361;
	bh=JYgzkLKt0+oJGG2ftdCDy2tB5Y0V45ODmgKOoqzJWow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3uk8OJYdZ1K8WZ2FF0rpKgs95neXbyGgTe6+jakVKWtlkLEGCMUv+ZEB0nUsHtOj
	 O2mwTZwIbeoInXKMTQCXVsvyJYG0mHfdkpzFxXfUK6wKjklqWLa0mSb7xoYRtsAV2i
	 KJl4XJMDXqsi9PedDPinmhMVPBU94jm5Moc5kdCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 337/686] xfs: fix temporary cursor leak in btree shift corruption paths
Date: Fri, 13 Nov 2026 10:47:50 -0500
Message-ID: <20261113153832.362868808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dbe9df8c33004..b0824d381e7c6 100644
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



