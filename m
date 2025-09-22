Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42732F0C5F;
	Mon, 22 Sep 2025 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569864; cv=none; b=GxXWD8DCfPBFSIosL0PiF/ZLJ8BqtrXYc4ovs0gPXWNsI163stwhMQSJJ/nPywp6foVr4tpCk3ANq4PrBiGrpuxAaS4bYqwYc3sOOj622dacBPI+q1Fa1KjAKUb7/GDO+cvfCPzyxw2neeSUR92FGifD7Piy5MWsLaeTxY6PIlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569864; c=relaxed/simple;
	bh=AZ4mRvYvZdYVqBsX7uHUsg/8+mbXlOQRozTVHEnpBd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihDU+Sc/X3/1/B0Z1COwfXT2Ydhd7INcN+9M+7DgQjG8Z2NHVMYFeGkACk55FJQ5ad3Wo6GGtRQ3j3QpFfvuzuo5aHxk/88JZZtQ+k7gWLMXNVsR7dYNQt+8Jo252zvMWG19YlalUQHvBhr70aWJnjfdUZLrM82DJ4YS9KBVzmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AT/lUQ7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT/lUQ7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349D4C4CEF0;
	Mon, 22 Sep 2025 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569864;
	bh=AZ4mRvYvZdYVqBsX7uHUsg/8+mbXlOQRozTVHEnpBd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT/lUQ7bc6ysLTxh/cqQPF6JNT7N1U7CsxiicrufwVU3os7ecxpYpzsNc7KtIZFTP
	 kMWfUcNNWdx9GAtaywFrKL6DJ9+Of684w/j1mSLfVyALG/gaBlZgl6ECeEG8/Vl1Gl
	 0V5xNQygCiXjDpq0e5bKK4u6guchwioOhDTB95As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/105] btrfs: fix invalid extref key setup when replaying dentry
Date: Mon, 22 Sep 2025 21:28:51 +0200
Message-ID: <20250922192409.121629866@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit b62fd63ade7cb573b114972ef8f9fa505be8d74a ]

The offset for an extref item's key is not the object ID of the parent
dir, otherwise we would not need the extref item and would use plain ref
items. Instead the offset is the result of a hash computation that uses
the object ID of the parent dir and the name associated to the entry.
So fix this by setting the key offset at replay_one_name() to be the
result of calling btrfs_extref_hash().

Fixes: 725af92a6251 ("btrfs: Open-code name_in_log_ref in replay_one_name")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f917fdae7e672..0022ad003791f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1946,7 +1946,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 
 	search_key.objectid = log_key.objectid;
 	search_key.type = BTRFS_INODE_EXTREF_KEY;
-	search_key.offset = key->objectid;
+	search_key.offset = btrfs_extref_hash(key->objectid, name.name, name.len);
 	ret = backref_in_log(root->log_root, &search_key, key->objectid, &name);
 	if (ret < 0) {
 		goto out;
-- 
2.51.0



