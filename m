Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B06F18026;
	Tue, 14 May 2024 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686465; cv=none; b=QzdnJmfr3qTwPBzsSVNAIHBxuoqjnybawJO3A3nHJPOw6f6JJT2UCLHNZdivO0HgCnxyDCRN8xQNNxi+ZLdD6pYZaiCPPq+aAEVghQpaqp4Z/vQUaOYh9g8sNvUVZlKS37rXNbYeLyp9pZw4DhJjfQ2SAeh7Q+cwZOhYloku8vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686465; c=relaxed/simple;
	bh=j28s8seJpLToiRjC2QT/6VNK6geIIqeOMGXHs7w4q84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5Oe1TMFYeTGraU4Ni5FVF9sJeW8gyBjliwmpn86/aENFAnTZWjghMHXMP89r2M3fI9gzVIv5YYeSCN8C//S8MdWduOIsKOP/pDF/7RydeW0Lzdp/9NEZFrEHdKkwLnMCappdj8WhNv/rxnQkiNQprmeToEBQcNwVrTakVhdFNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMfU2t2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMfU2t2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BBEC2BD10;
	Tue, 14 May 2024 11:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686465;
	bh=j28s8seJpLToiRjC2QT/6VNK6geIIqeOMGXHs7w4q84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMfU2t2QtXbARHl5we4GNiFDu1aFuniYl1Mu5SES7EIQlXJKD8ml9S2sc3F7C5ppA
	 5/LdZOW1gZIU+7yDyXlhq7vAYD1X/yqLmAqnLI0upEBuZ4vVRweBMVA6aNn3ddFaY6
	 O8/MQWNcrEKvd4+YOQ8FhHWJfjyQHM28PrWFvIOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/236] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:17:58 +0200
Message-ID: <20240514101024.776694840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index 5549c843f0d3f..a7853a3a57190 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1440,6 +1440,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1464,7 +1465,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



