Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D84815EA0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vi55G+XB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C56C433BC;
	Mon, 23 Oct 2023 11:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061161;
	bh=SDA4XowiJzJhv/lfxQ051bO77OlsuWp1moUWa83Nny8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vi55G+XB92qCV0WBLT/dVKUnEBMSr3c1HccDeTLoxjaFZyReyt2yBDJueDQ7e6tUk
	 8Lq0v1L0mg56/atSiEhBHiXG1VZmnKiXqdBT3mgyWf7AHG7chFk2ETwSlNdPaGX0KC
	 Bk5w6TOXaF8uMnqJJZtzrJRrZ5R6NOMkx/STwLTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/137] btrfs: error when COWing block from a root that is being deleted
Date: Mon, 23 Oct 2023 12:57:30 +0200
Message-ID: <20231023104824.032449368@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a2caab29884397e583d09be6546259a83ebfbdb1 ]

At btrfs_cow_block() we check if the block being COWed belongs to a root
that is being deleted and if so we log an error message. However this is
an unexpected case and it indicates a bug somewhere, so we should return
an error and abort the transaction. So change this in the following ways:

1) Abort the transaction with -EUCLEAN, so that if the issue ever happens
   it can easily be noticed;

2) Change the logged message level from error to critical, and change the
   message itself to print the block's logical address and the ID of the
   root;

3) Return -EUCLEAN to the caller;

4) As this is an unexpected scenario, that should never happen, mark the
   check as unlikely, allowing the compiler to potentially generate better
   code.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 8bc1166215138..8fe6aaa7b11fd 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -545,9 +545,13 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	u64 search_start;
 	int ret;
 
-	if (test_bit(BTRFS_ROOT_DELETING, &root->state))
-		btrfs_err(fs_info,
-			"COW'ing blocks on a fs root that's being dropped");
+	if (unlikely(test_bit(BTRFS_ROOT_DELETING, &root->state))) {
+		btrfs_abort_transaction(trans, -EUCLEAN);
+		btrfs_crit(fs_info,
+		   "attempt to COW block %llu on root %llu that is being deleted",
+			   buf->start, btrfs_root_id(root));
+		return -EUCLEAN;
+	}
 
 	/*
 	 * COWing must happen through a running transaction, which always
-- 
2.40.1



