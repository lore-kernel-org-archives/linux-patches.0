Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F2363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9438FC433EF;
	Mon, 20 Feb 2023 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901087;
	bh=cvcivxIL80FFiIQlJ5LTpUr9MREuDHyJz6RC1Xq1ey0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgTYKnXqcHUvmkElU+4SWeF8zefAzMWkWqTP6iZvgiOpfM7btODq8ZjG7RlrP/3As
	 5DCTcdt0DVWj11evCN0BvxVNoTrOgcyw5DIK7VzfbxXnFgdfmuEqh5aFIPwpjTNIVO
	 qfrnUsY/Znw9+6aCmBO9j7aBfUBb69IcVaQSFW80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/83] xfs: zero inode fork buffer at allocation
Date: Mon, 20 Feb 2023 14:35:57 +0100
Message-Id: <20230220133554.537432194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cb512c921639613ce03f87e62c5e93ed9fe8c84d ]

When we first allocate or resize an inline inode fork, we round up
the allocation to 4 byte alingment to make journal alignment
constraints. We don't clear the unused bytes, so we can copy up to
three uninitialised bytes into the journal. Zero those bytes so we
only ever copy zeros into the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1d174909f9bdf..20095233d7bc0 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,8 +50,13 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
+		/*
+		 * As we round up the allocation here, we need to ensure the
+		 * bytes we don't copy data into are zeroed because the log
+		 * vectors still copy them into the journal.
+		 */
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -500,10 +505,11 @@ xfs_idata_realloc(
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
+	 * We enforce that here, and use __GFP_ZERO to ensure that size
+	 * extensions always zero the unused roundup area.
 	 */
 	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL);
+				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.39.0



