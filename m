Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B13A12EBD4;
	Tue, 14 May 2024 11:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687418; cv=none; b=I9I/OAO78rrKhAysIK+duDQYUSOIsL2T1Rn1Ck6MEEzgZ7Wwae+KeZrPa64AsU0X1fCj8ckTyUEDOz94aqKlSzDheTQjfZ4DVYSHFZ/wkuiwv1kERTvapw9lJy0PPDsASPSbua1cgXjbkhMewyGosbr9JPJUF+G8J1yKrzkJxS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687418; c=relaxed/simple;
	bh=q/1cHAlpIuG27qe1RzhTVIiXD2pjUFIZXcmq3fLeknM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lT15qM3Pc2QGztv24m44FlTQOP3cUZYN9g+yElE02qyObveE+pkeXtbdzDPwlO0HaBGr2SLxQWWuyCeGU8rLI5yVQNPS8/dwNKue2yWZyDwsBeRNWlZeEj/hqFZvCZtTWwNrvISnxsxAMcS/Oy/5VJoE6M5dHv2bQl99c2iPYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsZAFHcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsZAFHcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85700C2BD10;
	Tue, 14 May 2024 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687417;
	bh=q/1cHAlpIuG27qe1RzhTVIiXD2pjUFIZXcmq3fLeknM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsZAFHcblZmOLJmLA1riCIInTA8jrJdn7aMXhxYL2M6LcTIxFk2RsYR7CNlelhHm+
	 KCPjfERaR48OcKzLZgrP4FBdZ7z5n6n6mjExSE9ITP7JVYSqO6yc9Tv+yPIEDGywZr
	 Oj7/Id3WxpsHXTX0r3+O3/0Sya5NCObbDHjgEB2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/111] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:19:56 +0200
Message-ID: <20240514100959.337718046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 6e68de0bb0ed59e0554a0c15ede7308c47351e2d ]

It is possible to clear a root's IN_TRANS tag from the radix tree, but
not clear its PERTRANS, if there is some error in between. Eliminate
that possibility by moving the free up to where we clear the tag.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d23047b23005c..8cefe11c57dbc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1343,6 +1343,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1367,7 +1368,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



