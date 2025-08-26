Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A82301486;
	Tue, 26 Aug 2025 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208605; cv=none; b=GeV9ykY7nrQNNcMRMDT4GF6ZB8IzwDfersRB+tYK2TaXbKhxmoN2xPvvP1lzaRWYXPmUgQz68NybJGXRzrfkJ6A9f3RUl6hfjFAPx7DpdA4SBN2hffQBFBX1bxAeIDtAiv1356XBydPsJAwY2CD25M52XWl+VJNMBCRTODjnv1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208605; c=relaxed/simple;
	bh=0iFuw9cJg/9Mn+pUjZnUZ0eC/1yJAR7Gca715vb8PX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1m8ZWxBzAER40a60YfYFPhY0HxFoklRlr5j0YFdHrD4aU7iRmGZUW7fpxtJCO/KFnYiaR3JkaKiX8XGFGio64vHAezOjAoZzmLdpDA4oViAbsAz20+CrXAgcmOURv81yRtJJwWP5rNM5mNcDf4iDwpivNmoWqcXuar370Yn3FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDVy5WjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDVy5WjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5894C4AF09;
	Tue, 26 Aug 2025 11:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208605;
	bh=0iFuw9cJg/9Mn+pUjZnUZ0eC/1yJAR7Gca715vb8PX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDVy5WjYRtGiVszdZ5LGoOmLl6U6bN+Wnn7/mAmzlzxb50Ri32/ehJT2NHNyUKDhu
	 tSCZP1YBqnO4VvA4yMCcO1ADtOJbbAWzsnRd+aTy6wI2y2CbTlgEDThVbVFNI7LgJ5
	 hV0w3dgmuH1+OGgNThq+Anpg+cLZswo76Bv5ksI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/322] btrfs: move transaction aborts to the error site in add_block_group_free_space()
Date: Tue, 26 Aug 2025 13:09:19 +0200
Message-ID: <20250826110919.360452375@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit b63c8c1ede4407835cb8c8bed2014d96619389f3 ]

Transaction aborts should be done next to the place the error happens,
which was not done in add_block_group_free_space().

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1f06c942aa70 ("btrfs: always abort transaction on failure to add block group to free space tree")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1404,16 +1404,17 @@ int add_block_group_free_space(struct bt
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
 	ret = __add_block_group_free_space(trans, block_group, path);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 
 out:
 	btrfs_free_path(path);
 	mutex_unlock(&block_group->free_space_lock);
-	if (ret)
-		btrfs_abort_transaction(trans, ret);
 	return ret;
 }
 


