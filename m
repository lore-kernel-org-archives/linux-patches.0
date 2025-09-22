Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810A25F780;
	Mon, 22 Sep 2025 19:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569659; cv=none; b=d/WDQO2eGEYkCiZyFdqo9JwJsmgB3cbyzEHajekAhP7G32geCqwoQOJBHr3zAnBKX/qkzu1YA12ZAM3KtK6qEo/qHgmp0DtO/ED8R455bBwPK9ahTX+2lp2VVvSl9FbkfBbJXxeLK4vpbsq9QW7Yq6KcXS8O8kt2BnmCuY/EuLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569659; c=relaxed/simple;
	bh=CSX3AooNSQURSKFQDmGAE0OJ6Ay417oG9gl0KZkixQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wqjimc9ceLtzmBDYrfkUjir7Aunj/aOOojuwlGRVrdLr2XZpjd/JTRqJxV8EV5xrB7udQC1SKDBb0NR2eTlLsMiRylKjsTH6dIbdO0FMbqZA6hhBlxveIIbA0Gtg2gj8oKQQBNyHUQdGy8kDIwKFNTm35fsvYSVMksaBh0LPIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HugmjQIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HugmjQIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8116AC4CEF0;
	Mon, 22 Sep 2025 19:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569658;
	bh=CSX3AooNSQURSKFQDmGAE0OJ6Ay417oG9gl0KZkixQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HugmjQIqAFFFlb6rSX6n0MholktYGykDwp5VNtSZtFvqOKdCDMLgFNwbz6LAr2BmT
	 I6g5oTJgxblbohj7k9jSK6lFjcuF5fZ6vuHBosJ4m5o635KBHCnp8H+Epnl9qE3SGS
	 88JhpbdvkhTX10cSKu7svRB2hmHZd3eRDhaAI1fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/70] btrfs: fix invalid extref key setup when replaying dentry
Date: Mon, 22 Sep 2025 21:29:07 +0200
Message-ID: <20250922192404.674106364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5d6bc1bb5e5d..4b53e19f7520f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1998,7 +1998,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 
 	search_key.objectid = log_key.objectid;
 	search_key.type = BTRFS_INODE_EXTREF_KEY;
-	search_key.offset = key->objectid;
+	search_key.offset = btrfs_extref_hash(key->objectid, name.name, name.len);
 	ret = backref_in_log(root->log_root, &search_key, key->objectid, &name);
 	if (ret < 0) {
 		goto out;
-- 
2.51.0



