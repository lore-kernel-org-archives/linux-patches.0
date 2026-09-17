Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B9E3CAE75;
	Thu, 17 Sep 2026 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668556; cv=none; b=sXOL79cJPhEu9Cviin72D6qWwESfZhT65M4ZOzyFYgsZd7/1eFENH0r96c5TaCJUevghBiWGi9mxxt3Ynlhu4PGeA1dg6MCO8MNPFs67c+GCN4z16TnCiCyJcyDnBujbHRbv7msl56cQ2PopIaUArocCWrpeTBGOdj9i8+d2690=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668556; c=relaxed/simple;
	bh=CmZbAn8iav5bZa4YT82NGxAvaa5HUMAYvg1tJm7prRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGLMxmLwDZj56r3nQ1ao3pcHLBuziNcOm8Qoi03czlYkqhGBofUm91ymlrkowPo3UZ2dbfGHQQqNcTEqYSDWC5ddmJfBr5L6EgaMbKfYxfc9DBxyLO4x4ImPRbyknRo0urlfKXx2maynXBNYC7ZOECWn2xXVdSR4L7Z5dE/eZNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nihGm1du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nihGm1du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F27F1F000FF;
	Thu, 17 Sep 2026 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668555;
	bh=EJIRY8uw8U2lrhsLeIRfJmPxD9TuXhiLACjUrjyxxOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nihGm1du3lLZtjiqnIWLLo72U6kRh9mJ80DdFoXviV5BTSaNJzuAE7JPlB+To4BN0
	 x0cmicyryc2WIm3mpIDLBAZnKftVlMXlojfzyOh52ioieVi4cjH1de/i3kqH4CsITD
	 mUGZrczRk5+IVq+rZMdfOyMeI7NOPRRqEDwc2Xzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0414/1102] btrfs: fix reloc root cleanup in merge_reloc_roots()
Date: Thu, 17 Sep 2026 16:05:57 +0100
Message-ID: <20260917151550.059727608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b78fe9563e2d5ae47805f1e5dc722c91fd30e1f8 ]

If the root we got has zero root refs in its root item, we are resetting
the root's ->reloc_root without using barriers like we do everywhere else.
Sashiko complained about this while reviewing another patch, and it's
correct (see the Link tag below).

Also, we should not clear BTRFS_ROOT_DEAD_RELOC_TREE from the root unless
the root points to the reloc root we have.

Fix this by using clear_reloc_root(), which issues the memory barrier
after setting the root's ->reloc_root to NULL and before clearing the bit
BTRFS_ROOT_DEAD_RELOC_TREE from the root.

Link: https://sashiko.dev/#/patchset/cf84f1a217c719e25b6b69e4298dd7afd36c9427.1781194426.git.fdmanana%40suse.com
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0d0d92f7935af..20774ba9d6ec0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1995,11 +1995,10 @@ void merge_reloc_roots(struct reloc_control *rc)
 		} else {
 			if (!IS_ERR(root)) {
 				if (root->reloc_root == reloc_root) {
-					root->reloc_root = NULL;
+					clear_reloc_root(root);
+					/* Drop the ref for root->reloc_root. */
 					btrfs_put_root(reloc_root);
 				}
-				clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE,
-					  &root->state);
 				btrfs_put_root(root);
 			}
 
-- 
2.53.0



