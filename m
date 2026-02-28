Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1A2346AF2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302047; cv=none; b=Wm2f8923N7ZgHFGxYS0tSd0IVui5BXHjPOvSkFxPMFR2pvVXNwPjSaV2FxHRVGGgjqq5YNJ6Q27ugST7PyO1mghZ6fiHt8hRMCZcv1u5XF6yQXgtfFMMyzXpNrD5L8/W8p6m+mda4RwlppUrtSIYO9aO5c3rFQ5TnuYCErrPhxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302047; c=relaxed/simple;
	bh=fTULu7FazzwCGS6l69cCbZdIzGcnBNZSnqqLtVUggIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHZHyBm5R9kypX6o/rK4sWcOIuccocM/SEn9FbQ2/G7XCpeeGKgo+Ih1AmHu4dGWfY5ISxRorpXscN47ksFAL8u1WTeeSngrn0xlz6UVTr3d05p+Sl86h5aW6Dip/jyipVDmY35pA+9qf0LXtCrU85mS1qRO4cDXVEYfQrnRmu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=syT4/bpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="syT4/bpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364CDC116D0;
	Sat, 28 Feb 2026 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302046;
	bh=fTULu7FazzwCGS6l69cCbZdIzGcnBNZSnqqLtVUggIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=syT4/bpzVyBfXHJ00SUPXc9WPRneF+TR/29/qHn10pRCPPTtF8lyNJMm6SqZbEuTW
	 GyDTMRoXPQozghgnLchzEdlqQOLjgPBaWG3mvnqUrrYQRxZfuhmQINwTrUpWYOB1c7
	 KDESQ4e8gqjlOqA/S3kmd6Kh/hDsM3kMi1ywQgrzL4u8f9C5v43P4hkWzeLKKQrh4q
	 45pIVmdYj/QGjVWBq8qDR5CnHiFwNFRbHTtyl0l7Gh8bYNqSw+UfVnYtGdU9iQXS3v
	 AYePHVmNYPcO9pG2dW61iyA+x6SMBL5LzM+Sn40nI19zmX++h93uCmkuTukXbECV1D
	 1u1UKZlbZyDxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/283] btrfs: qgroup: return correct error when deleting qgroup relation item
Date: Sat, 28 Feb 2026 13:02:42 -0500
Message-ID: <20260228180709.1583486-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 51b1fcf71c88c3c89e7dcf07869c5de837b1f428 ]

If we fail to delete the second qgroup relation item, we end up returning
success or -ENOENT in case the first item does not exist, instead of
returning the error from the second item deletion.

Fixes: 73798c465b66 ("btrfs: qgroup: Try our best to delete qgroup relations")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c46ea2ecf1881..d27b9e0fa229a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1601,8 +1601,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		goto out;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		ret = ret2;
 		goto out;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.51.0

