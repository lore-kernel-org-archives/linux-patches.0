Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B65200AB
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE52EC433C8;
	Tue,  1 Aug 2023 09:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882658;
	bh=HvztnuwF7w1fGTZ2N8H++pRHCr97hNp9DUOYsEQlZ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma2WhVirTwBEL1KlAkFTRUPFQLWl6Sj8UCCTkBi60/3U0SmGx7wcdhTjuzewmLEMg
	 3BcYoYt7SeRQUszJ5kbvKCORdiVtPWDw4FBNp9GTAyx+iaEppQyLeU2+iIPix2Dt6C
	 VHHEMXbEv8zXnSgR2JZExCr2BK8WE1XTHbVUq/GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 185/228] btrfs: check for commit error at btrfs_attach_transaction_barrier()
Date: Tue,  1 Aug 2023 11:20:43 +0200
Message-ID: <20230801091929.548739736@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

commit b28ff3a7d7e97456fd86b68d24caa32e1cfa7064 upstream.

btrfs_attach_transaction_barrier() is used to get a handle pointing to the
current running transaction if the transaction has not started its commit
yet (its state is < TRANS_STATE_COMMIT_START). If the transaction commit
has started, then we wait for the transaction to commit and finish before
returning - however we completely ignore if the transaction was aborted
due to some error during its commit, we simply return ERR_PT(-ENOENT),
which makes the caller assume everything is fine and no errors happened.

This could make an fsync return success (0) to user space when in fact we
had a transaction abort and the target inode changes were therefore not
persisted.

Fix this by checking for the return value from btrfs_wait_for_commit(),
and if it returned an error, return it back to the caller.

Fixes: d4edf39bd5db ("Btrfs: fix uncompleted transaction")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -814,8 +814,13 @@ btrfs_attach_transaction_barrier(struct
 
 	trans = start_transaction(root, 0, TRANS_ATTACH,
 				  BTRFS_RESERVE_NO_FLUSH, true);
-	if (trans == ERR_PTR(-ENOENT))
-		btrfs_wait_for_commit(root->fs_info, 0);
+	if (trans == ERR_PTR(-ENOENT)) {
+		int ret;
+
+		ret = btrfs_wait_for_commit(root->fs_info, 0);
+		if (ret)
+			return ERR_PTR(ret);
+	}
 
 	return trans;
 }


