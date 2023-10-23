Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6644E15492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dS/j2Pn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A6EC433C7;
	Mon, 23 Oct 2023 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060285;
	bh=GC23r4Wl8FKFwK6CVFE5jTfi8x5Fr1Mlq8Pp/DEoP64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dS/j2Pn1lU+Qmk02pqFdKlcJsB3tCGSZAoSe4u8YKp3hjaB4fsSL5D2IqX+90hRlI
	 g4+ZvsaeM6yOCy9TMObHXKiSofFafPYxnuHsoC4RFkyLe1BoR7NGLHI6/pFLKVFbCy
	 uYT4WOwEeqppzcuRMv3Eon4/J2G0s7GHmGEPkJqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/196] btrfs: error out when reallocating block for defrag using a stale transaction
Date: Mon, 23 Oct 2023 12:56:26 +0200
Message-ID: <20231023104831.930217530@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e36f94914021e58ee88a8856c7fdf35adf9c7ee1 ]

At btrfs_realloc_node() we have these checks to verify we are not using a
stale transaction (a past transaction with an unblocked state or higher),
and the only thing we do is to trigger two WARN_ON(). This however is a
critical problem, highly unexpected and if it happens it's most likely due
to a bug, so we should error out and turn the fs into error state so that
such issue is much more easily noticed if it's triggered.

The problem is critical because in btrfs_realloc_node() we COW tree blocks,
and using such stale transaction will lead to not persisting the extent
buffers used for the COW operations, as allocating tree block adds the
range of the respective extent buffers to the ->dirty_pages iotree of the
transaction, and a stale transaction, in the unlocked state or higher,
will not flush dirty extent buffers anymore, therefore resulting in not
persisting the tree block and resource leaks (not cleaning the dirty_pages
iotree for example).

So do the following changes:

1) Return -EUCLEAN if we find a stale transaction;

2) Turn the fs into error state, with error -EUCLEAN, so that no
   transaction can be committed, and generate a stack trace;

3) Combine both conditions into a single if statement, as both are related
   and have the same error message;

4) Mark the check as unlikely, since this is not expected to ever happen.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 98f68bd1383a3..e08688844f1e1 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -698,8 +698,22 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	int progress_passed = 0;
 	struct btrfs_disk_key disk_key;
 
-	WARN_ON(trans->transaction != fs_info->running_transaction);
-	WARN_ON(trans->transid != fs_info->generation);
+	/*
+	 * COWing must happen through a running transaction, which always
+	 * matches the current fs generation (it's a transaction with a state
+	 * less than TRANS_STATE_UNBLOCKED). If it doesn't, then turn the fs
+	 * into error state to prevent the commit of any transaction.
+	 */
+	if (unlikely(trans->transaction != fs_info->running_transaction ||
+		     trans->transid != fs_info->generation)) {
+		btrfs_abort_transaction(trans, -EUCLEAN);
+		btrfs_crit(fs_info,
+"unexpected transaction when attempting to reallocate parent %llu for root %llu, transaction %llu running transaction %llu fs generation %llu",
+			   parent->start, btrfs_root_id(root), trans->transid,
+			   fs_info->running_transaction->transid,
+			   fs_info->generation);
+		return -EUCLEAN;
+	}
 
 	parent_nritems = btrfs_header_nritems(parent);
 	blocksize = fs_info->nodesize;
-- 
2.40.1



