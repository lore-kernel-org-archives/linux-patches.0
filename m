Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E17C139CE4;
	Tue, 14 May 2024 11:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687045; cv=none; b=iGYc7Sw1SVwLT8LBs+Yk8TzEvJKSUo95xXSlyOvbpk0kGKGnS3Yrb3sheLiGxbwDiGPNjOmcSQZ+ZdwmKbT/NQrcN4IIJfBo/Kcf1SAOEBe/BpNwSY1cRolnD9ejR7aOE1C+tQ+c06W8/Cwavs4n996uuhMux9/jwSbY8MnD5gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687045; c=relaxed/simple;
	bh=8Kfr/SLzsIQ/s097LwKvJ0FWsUVd/BFkc21q7/gYomQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUc0vtiFQaQ2ssi7upakN2F/3hG7seBaB5Q6Y5wYvY8XYyGMIXBDtlgfLwenAfGS6iPhgiYJzTheF+FkJ0x/r8sdnoCImvIjTsHAr34fhTVDS1OyUskmJwhA5UFNCWIRqwnGphPrTZ8DokBTVF3gNfGN6KSjvk9SvoqVxIHQHOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vre9wnNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vre9wnNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD55C2BD10;
	Tue, 14 May 2024 11:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687044;
	bh=8Kfr/SLzsIQ/s097LwKvJ0FWsUVd/BFkc21q7/gYomQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vre9wnNFc29rFewFrS0mXHJiIL9D6MO+KD2w7YEI6vn8Gyl9nWKnl51qfbuQzQ46F
	 1TVm2uSS5Umr7tz8WPUMKZeubbTuqxoCyG09qDf90Kpc7OEDtUgcMob/PfUzELxo0W
	 yUs9C3cPgR+FgndUqv3YL6It9UWsJGkmsJkP5scI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/84] btrfs: always clear PERTRANS metadata during commit
Date: Tue, 14 May 2024 12:19:57 +0200
Message-ID: <20240514100953.421113314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 89ffc02554069..1d25bf0c55ccf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1226,6 +1226,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			radix_tree_tag_clear(&fs_info->fs_roots_radix,
 					(unsigned long)root->root_key.objectid,
 					BTRFS_ROOT_TRANS_TAG);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
@@ -1250,7 +1251,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			if (ret2)
 				return ret2;
 			spin_lock(&fs_info->fs_roots_radix_lock);
-			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-- 
2.43.0



