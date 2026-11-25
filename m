Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623896;
	b=mHMm4dlms9O0N7GHBK15rBFhXQ2m6XTPr4X/Mj6anV333FrfQOc2P+qIePwNjty3PR/d
	 frZffWJ5N5aBYxIP3CJ6QtKNHpeUKUe3gTYDnJM1MrK0gZWqYtZzizUh7TNmtECG/ybFt
	 to8HuqkMdyDhCczCBEif0fs9jIMkHjDd8RoZuwAxhEpTIbR6LDL5dzJ99LgOFGD08/5oZ
	 gbcac6HEYllPKvqqCapPMf2zM1Dyu0VinmDp40QBWcbfN+fZfhaLDiM55rJEwQbrrObPb
	 pMdMtiFDYcdyZDyzksrVw63gMZrfeyuIVS4KienFokJsZXJdalSwR/3FuefGmtnTNow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FABBogl4Fvhwa7wHeUs2QYzbxLwgcSe4pRC87J673Ys=;
	b=eD4kCKopJawmKihioCexG5QRjapX7TzE8CTZrum8EMH+FAzUdKbM0NoMF7cJ7fBf4vMa
	 374iJD9F8BI9JP1EjRsijkol0XLAUB9pO9vUPqDUXMfsbm2zx/TEdgxJcaafr6r97Ib1f
	 Jcdb+S7vTCGYHntDV7cotLGtLjD8TFhNBWhZCgKIEienHL5uXgIh0dRPLweI5sC2XguXm
	 gk47Q/1aSX97r7KAj1QCN5tel+/OCAmnR3fUoZ2IoSh4XvTHM7txpN/rxbKCu6OqMrdxS
	 RXd4RzMMKSbwc8FP+Vrwz1lCi3T7WEqaCV1J5z/m4bVP68F1pWrhHPP5qeJxAyv87Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPOId3B0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3367606A31E;
	Wed, 25 Nov 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPOId3B0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8BC1F000C4;
	Wed, 25 Nov 2026 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623896;
	bh=FABBogl4Fvhwa7wHeUs2QYzbxLwgcSe4pRC87J673Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPOId3B0wBCqWu+Gi2Lp/t8r1zM95zEMAq5ZXofh7h7Nc6CwFMSZ04cOHSu8o8HrG
	 rOO5xbpBXL/lapztFfeKyMx2QvEdMaEtUez3qCM6RCfSfO6RrXBTabXHVuNuiGEXP2
	 en3xCxLpYM3jleBuFGog+FHNPE+wh+USeuAJwvd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/816] xfs: only assert new size for datafork during truncate extents
Date: Wed, 25 Nov 2026 15:26:08 +0100
Message-ID: <20261125143849.683738712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit e942498385bf80f4d6d075b47174035545eb6a2e ]

The assertion functions properly because we currently only truncate the
attr to a zero size. Any other new size of the attr is not preempted.
Make this assertion is specific to the datafork, preparing for
subsequent patches to truncate the attribute to a non-zero size.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3b487341348a0..5abdcf1f46c96 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1025,7 +1025,8 @@ xfs_itruncate_extents_flags(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	if (atomic_read(&VFS_I(ip)->i_count))
 		xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
-	ASSERT(new_size <= XFS_ISIZE(ip));
+	if (whichfork == XFS_DATA_FORK)
+		ASSERT(new_size <= XFS_ISIZE(ip));
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	ASSERT(ip->i_itemp != NULL);
 	ASSERT(ip->i_itemp->ili_lock_flags == 0);
-- 
2.53.0



