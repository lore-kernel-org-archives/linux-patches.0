Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591175;
	b=YQ4AOc6nlVnejwKTyMKw2XsYxhShX1LqcAL8JLYrqA76gi9qz35Rb5Dry0rF2JmMUo5t
	 xGYUj6ZzZTrKRuOmjz6+iuixN+rvtjkijlLDtzM0gZDi7TuKraXpaKAbwQBKhNeyj2f7c
	 WVcfIzCliekz4SZA/oXGT+TyvLTtXyaX6BTL5YdaF8RZFU2tTrw8579wkz1L7xjIH3Heb
	 /97OHNWfI+DYOtgFr0ANwkhcndzchgfyrAw5eCrA8TKdjl4pPndQUU9ufoRpZFJ2FruIo
	 lJ6xW0csWArsw2OhI0T6EAcAs1Z/NNz1YMQF4Kh25E6Y/9kVSMneZe4IXVzHCtgy1GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dsMXHr4TeILPaDlLsVDt3WU0eTd9tDrNI5uG2BMiRYc=;
	b=Qod9d0oJLqa06ovxNBY7pVSiGEJiw9dQYmWNSs1V/1yFqfTI15yIkoUE1LjuxPeQmRFf
	 TXbu844a7cMS+V2CmAnZtLUGJAq6QV+xKuTWcyG0qm/Ac8MWXvaAS7s92hhf+7PEuTM9A
	 FqZcfdeBgRGsOarFlxC4OUNFhWNUhDGSGp2/YgaPRFEQ90EFsoMUahZbtDqZpUzFaRJ4B
	 a8ItVSXjsgrzQiiloYH7Ctl0m63A+/SqUThAYWHLxImluoHBndxDuXdi5NHsvDbXsz1Fb
	 z5hPoxQxOaDEJshUIIFeR0K0cSvcPxwpXja7A4FXY3AHN6Naso6fULGaGUK80yIsNoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlZwOFlj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569E606C0B0;
	Fri, 13 Nov 2026 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlZwOFlj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7211F1F000C5;
	Fri, 13 Nov 2026 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591175;
	bh=dsMXHr4TeILPaDlLsVDt3WU0eTd9tDrNI5uG2BMiRYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlZwOFljcRuTzN6c2PBthCzc4q/F+MWuWk5hA2fLB72MjFnUT8HSHDauggPwkUm4r
	 5Pf3M0FL8iqqFVJbU2+yZXfFg8tBmY6Qx8a1wMBQWcrVLuedWC9rKKkHsEvCxmUxm9
	 fyaVYajQssGDbcamYGY1ns+G/rlnhVoVg7yFuJzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/670] xfs: fix recovery of partial attr removals
Date: Fri, 13 Nov 2026 10:47:59 -0500
Message-ID: <20261113153822.574602838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 30bb61651d2da5a502cf504bcdad16c093c1bb08 ]

When running xfs/753 on parent pointer-enabled file systems with DEBUG
enabled, log recovery will eventually crash after a few dozen iterations
due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
xfs_attr3_leaf_setflag is called:

XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045

This is because parent pointer use logged attributes, and the attribute
intents do not track the work that has been done as the transaction
rolls, and the recovery mechanism is to run the operation from scratch.
Because of this various places check for XFS_DA_OP_RECOVERY skip work
already done.  But while recovery tolerates an attribute already fully
removed, it currently trips the above assert for an attribute that
already has the INCOMPLETE bit set, but still exists.  Fix this by
handling the case like all the others.

Fixes: 1d08e11d04d2 ("xfs: Implement attr logging and replay")
Cc: stable@vger.kernel.org # v5.19
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index aef8d66a016f9..b3f1eaa1ec45a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2961,7 +2961,14 @@ xfs_attr3_leaf_setflag(
 #endif
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
-	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
+	if (entry->flags & XFS_ATTR_INCOMPLETE) {
+		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
+			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
-- 
2.53.0



