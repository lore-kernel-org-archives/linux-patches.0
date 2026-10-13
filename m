Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18829501F26;
	Tue, 13 Oct 2026 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893319; cv=none; b=SBamlFhDMC8DP8hxIGDRKXl8SptU0M6sdKyEmP1HitxYM++VOFeNodD4BjifLcS7pE1pPmkWJZjTmZAgDG8nsqjLUqeExN+mZw4LxNNoQdhcrT1JfeFmuNRied6qNunhwwwXC8UHkRx5uPjCLsXdBhSKn/Ziih22A0nXKio9gsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893319; c=relaxed/simple;
	bh=E5rjKEwjLCQkKOi7svWesBue4JoWCb0WSVC6Hvroq5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hm/kclz1MRFDKX+hYPehF0//bmV5Kl+O9F714jEUH5AHNhQ+gTjs8BPba4AQM51bTWDftPPKeNeg9NMV7IRw7ue2lMJFtkMR9QrcVL4yyL0tW70KMgle0gWmY0MAtC59KXOX6szi+OQcSF/2kTKRDxLcHoligzxsvRXIlWcvfSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlMWIb5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlMWIb5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E361F000FF;
	Tue, 13 Oct 2026 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893318;
	bh=G53khGJ/ffCcoTzIA8ZT79yOMav8waEvitGRAretfHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlMWIb5tElGJ+V3SxPw/cZyQ8d9YqIp9ewVN6SHprGb0/DQWJ4jH8lS1rlaTBThY5
	 axdLZgEqJHW3mb4poSh6qPvPjgwKONZicbt8Gc/x67IPi7QQxnZdRa7rayyQrpKunA
	 TPVUaYdxeWXKuW4R8MQ63FReuOmSb8ePNFOyGId4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/621] btrfs: dont BUG() on unexpected delayed ref type in run_one_delayed_ref()
Date: Tue, 13 Oct 2026 13:33:00 +0200
Message-ID: <20261013112925.252572960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c7d1d4ff56744074e005771aff193b927392d51f ]

There is no need to BUG(), we can just return an error and log an error
message.

Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cbd57c46d3244..4fbdb9542739b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1760,32 +1760,36 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       bool insert_reserved)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
 	if (TRANS_ABORTED(trans)) {
 		if (insert_reserved) {
 			btrfs_pin_extent(trans, node->bytenr, node->num_bytes);
-			free_head_ref_squota_rsv(trans->fs_info, href);
+			free_head_ref_squota_rsv(fs_info, href);
 		}
 		return 0;
 	}
 
 	if (node->type == BTRFS_TREE_BLOCK_REF_KEY ||
-	    node->type == BTRFS_SHARED_BLOCK_REF_KEY)
+	    node->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		ret = run_delayed_tree_ref(trans, href, node, extent_op,
 					   insert_reserved);
-	else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		 node->type == BTRFS_SHARED_DATA_REF_KEY)
+	} else if (node->type == BTRFS_EXTENT_DATA_REF_KEY ||
+		   node->type == BTRFS_SHARED_DATA_REF_KEY) {
 		ret = run_delayed_data_ref(trans, href, node, extent_op,
 					   insert_reserved);
-	else if (node->type == BTRFS_EXTENT_OWNER_REF_KEY)
+	} else if (node->type == BTRFS_EXTENT_OWNER_REF_KEY) {
 		ret = 0;
-	else
-		BUG();
+	} else {
+		ret = -EUCLEAN;
+		btrfs_err(fs_info, "unexpected delayed ref node type: %u", node->type);
+	}
+
 	if (ret && insert_reserved)
 		btrfs_pin_extent(trans, node->bytenr, node->num_bytes);
 	if (ret < 0)
-		btrfs_err(trans->fs_info,
+		btrfs_err(fs_info,
 "failed to run delayed ref for logical %llu num_bytes %llu type %u action %u ref_mod %d: %d",
 			  node->bytenr, node->num_bytes, node->type,
 			  node->action, node->ref_mod, ret);
-- 
2.53.0



