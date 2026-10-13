Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C9A4E533A;
	Tue, 13 Oct 2026 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892079; cv=none; b=coQNGxyXLiKhjuDNCXy60qAbmQ3tpzlKegTJN4gjM0GNfqYdJv0K/VgScsC6tHRv7xVYEIJyEJlMqI7Hk0+mlGbbF6DNky+3o26ngeFfST1ymnWDCFcwk7692ezY4WlGhVIIzc5zC9Bn27F/Zuc/fPKu1ed6yY4fNBtk3p4mzX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892079; c=relaxed/simple;
	bh=+faK5tVqpgBIZIvTZ6LoeRFpvVY11kP1xK6w70gpmVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcwy5vhqMBGwi3kkeXbOejMwaFLlLHh3rrB286S6UnvCqNLL9XE2rtFokYoA2lX4sAnlISap+AX9L7/2b0wcSaiTkzt4/4EoQUHn/k58Qal395ok0bJ758kzXhLPO5Q9gSDEtSZgGybmgWk1v0klNQAp7uAjya407/UuFO/vCyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJazyb3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJazyb3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9DD1F000FF;
	Tue, 13 Oct 2026 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892078;
	bh=kQPcHPfHCSl9LvDQ9q3NVD1UTpQjzZ51+Y4+WlGrXsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJazyb3TOrCzL8A6B8qdP5snrgg+WZ6FgXUfMyNqNru9cCKheRwstg9pNS0OL3oM+
	 PPvPryJa8m7Gz1flbrm4uoC/IcTnX5QviW8mfID8C7QRvxTerd/qzTUThEAY4KiMqX
	 +uLLdz09fkbuNKvZ/jXUKqSQr0CbQUmtn8YQx0sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sandeep Dhavale <dhavale@google.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.2 053/281] fsverity: RCU-delay the freeing of struct fsverity_info
Date: Tue, 13 Oct 2026 13:36:09 +0200
Message-ID: <20261013112856.339213295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit e58c3805ed325fe2d4ae2dd467c0486cc860b733 upstream.

__fsverity_get_info() calls rhashtable_lookup_fast(), which just uses
rcu_read_lock() and doesn't directly synchronize with
fsverity_remove_info().

For the same inode this isn't a problem: its fsverity_info is removed
only at inode eviction time or upon failure to enable verity, when the
inode no longer needs its fsverity_info and it will no longer be
accessed via that inode.

However, this is broken and can cause a use-after-free for concurrent
__fsverity_get_info() for *different* inodes.  Those rely on following
fsverity_info::rhash_head in the rhashtable under rcu_read_lock() only.
They also use fsverity_info::inode to do the key comparison.

Fix this by RCU-delaying the freeing of 'struct fsverity_info' after
it's been removed from the rhashtable.

Fixes: f77f281b6118 ("fsverity: use a hashtable to find the fsverity_info")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sandeep Dhavale <dhavale@google.com>
Link: https://patch.msgid.link/20261001171349.81454-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/fsverity_private.h |   15 ++++++++++++++-
 fs/verity/open.c             |   13 ++++++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) "fs-verity: " fmt
 
 #include <linux/fsverity.h>
+#include <linux/rcupdate.h>
 #include <linux/rhashtable.h>
 
 /*
@@ -76,7 +77,19 @@ struct merkle_tree_params {
 struct fsverity_info {
 	struct rhash_head rhash_head;
 	struct merkle_tree_params tree_params;
-	u8 root_hash[FS_VERITY_MAX_DIGEST_SIZE];
+	union {
+		u8 root_hash[FS_VERITY_MAX_DIGEST_SIZE];
+
+		/*
+		 * Used for final freeing of the struct, in which case root_hash
+		 * is no longer needed.  Specifically, the only fields needed
+		 * besides the rcu_head are those needed by fsverity_free_info()
+		 * itself, and those that can be accessed by fsverity_get_info()
+		 * (rhash_head and inode) during the RCU-protected rhashtable
+		 * chain search trying to find another inode's fsverity_info.
+		 */
+		struct rcu_head rcu_head;
+	};
 	u8 file_digest[FS_VERITY_MAX_DIGEST_SIZE];
 	struct inode *inode;
 	unsigned long *hash_block_verified;
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -399,11 +399,22 @@ void fsverity_free_info(struct fsverity_
 	kmem_cache_free(fsverity_info_cachep, vi);
 }
 
+static void fsverity_free_info_rcu(struct rcu_head *head)
+{
+	fsverity_free_info(container_of(head, struct fsverity_info, rcu_head));
+}
+
 void fsverity_remove_info(struct fsverity_info *vi)
 {
 	rhashtable_remove_fast(&fsverity_info_hash, &vi->rhash_head,
 			       fsverity_info_hash_params);
-	fsverity_free_info(vi);
+	/*
+	 * The freeing must be RCU-delayed because __fsverity_get_info() for a
+	 * *different* inode's fsverity_info in the same rhashtable hash chain
+	 * can still be accessing *this* fsverity_info's rhash_head and inode
+	 * fields as part of the RCU-protected hash chain search.
+	 */
+	call_rcu(&vi->rcu_head, fsverity_free_info_rcu);
 }
 
 void fsverity_cleanup_inode(struct inode *inode)


