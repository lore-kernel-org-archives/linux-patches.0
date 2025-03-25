Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC0F25745F;
	Tue, 25 Mar 2025 12:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905668; cv=none; b=Ru0tq9sLhliuUoijqqJ57TcKNhFWClNBCGyX0xve48PE1ABPetqPQdaJhBLcjBNJ8LNfvqd0UaSF1kk1PKsCH2/rIgCp8bE2knKJ2PUVgXNudYpWkP7HSrjxPCKsNA6k9/WIrl9yqV4hXCDTx6X6AA18O27bwPqj+Kbg+CYTLxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905668; c=relaxed/simple;
	bh=JE6nTQIKA2MI8mJOQS2Oka+UWqJK4d+KB5xPj/fopYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUbkOH1HhHSUnGjqOoS9MsIFY/V5Pvy2kBjqiCrVY14XuwkOIIBQQXGvDY7MkTrMndUdFOxlYhdCx5OVqXSueAwua+4pzSatqmjDDa5kTWKq3dWoo7DKjz5thsjJ+GLMthDz2JdiiqoUGkwzeqemxezP9+zqlVZbNCgUL6YN/90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejCXCle/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejCXCle/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08EFC4CEE4;
	Tue, 25 Mar 2025 12:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905667;
	bh=JE6nTQIKA2MI8mJOQS2Oka+UWqJK4d+KB5xPj/fopYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejCXCle/zqHUuMT7DX381+sHzOaqk6qckJd3RkGFNgVcEJvRtkf2u4c0gVwdpYIU/
	 ENKilUDQmg4RuaQ1GTzDDDmbYkb2kngoPevjLMH77QijjxIzX78pJw0s3xD9Rb0fK1
	 vAGzTIlW9r9PWsrg2QaSU4xq2QhY6J6JNSm3594E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 098/198] xfs: add lock protection when remove perag from radix tree
Date: Tue, 25 Mar 2025 08:21:00 -0400
Message-ID: <20250325122159.222411906@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 07afd3173d0c6d24a47441839a835955ec6cf0d4 ]

[ 6.1: resolved conflict in xfs_ag.c ]

Take mp->m_perag_lock for deletions from the perag radix tree in
xfs_initialize_perag to prevent racing with tagging operations.
Lookups are fine - they are RCU protected so already deal with the
tree changing shape underneath the lookup - but tagging operations
require the tree to be stable while the tags are propagated back up
to the root.

Right now there's nothing stopping radix tree tagging from operating
while a growfs operation is progress and adding/removing new entries
into the radix tree.

Hence we can have traversals that require a stable tree occurring at
the same time we are removing unused entries from the radix tree which
causes the shape of the tree to change.

Likely this hasn't caused a problem in the past because we are only
doing append addition and removal so the active AG part of the tree
is not changing shape, but that doesn't mean it is safe. Just making
the radix tree modifications serialise against each other is obviously
correct.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -345,13 +345,17 @@ xfs_initialize_perag(
 	return 0;
 
 out_remove_pag:
+	spin_lock(&mp->m_perag_lock);
 	radix_tree_delete(&mp->m_perag_tree, index);
+	spin_unlock(&mp->m_perag_lock);
 out_free_pag:
 	kmem_free(pag);
 out_unwind_new_pags:
 	/* unwind any prior newly initialized pags */
 	for (index = first_initialised; index < agcount; index++) {
+		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
 		xfs_buf_hash_destroy(pag);


