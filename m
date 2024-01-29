Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4239E15956D;
	Mon, 29 Jan 2024 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548389; cv=none; b=B8ufxYyOdZ1zQ8cUd9YXDHAzbse4iGZcxYEoNb0HwTdnWo8lGTq1OHD4BIH95D9SBNewfNC9LItw7VzPFjyRo8kiBl7cAnRk2hF+G4RnYyu8iq5X84sbcGeJhlNUDx5QGfseIshIEl3eKdGE/bADvroaM+76b5/mvUAIUrr0UeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548389; c=relaxed/simple;
	bh=ce3LbRlXs2vOumIugrHwmSdG45HZpPIyX3iL7/aCD8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQ/tKLqaNkcWk5KmSMk+PCZdZ3qP8//sXCdLl7krLtEALlKiRcn1JgtSa2MEw/UX/gco0Tw0HOeGSXReH8Pwcyu+gnVhXBPFfMNJnk8Yodx/2umqNSVItjp0M1OUoYMSzuPhUNvuBUJIKCLcjLg8O/qJEWC2NQX4ygTBBhWEYp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P7SqrgXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P7SqrgXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD2FC433F1;
	Mon, 29 Jan 2024 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548389;
	bh=ce3LbRlXs2vOumIugrHwmSdG45HZpPIyX3iL7/aCD8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7SqrgXcWZGCKEfxFgrV83GKlYJQ6g1wz67pW+F1XQc+El4ZDoQax5UHcAzKktWmo
	 uxlZ4jFnz9yGDkjxJ1Nu2o1SB1WZ4ciL3oFLMjhPDbiJgFjiI8hxNjodetrEbG+hS0
	 FCy4ng1vhKjgifWlpkql6KJcPTiAIqCIXrWtMQU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/185] btrfs: zoned: factor out prepare_allocation_zoned()
Date: Mon, 29 Jan 2024 09:06:02 -0800
Message-ID: <20240129170003.802197895@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit b271fee9a41ca1474d30639fd6cc912c9901d0f8 ]

Factor out prepare_allocation_zoned() for further extension. While at
it, optimize the if-branch a bit.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 02444f2ac26e ("btrfs: zoned: optimize hint byte for zoned allocator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7be3fcfb3f97..2832abe3a984 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4207,6 +4207,24 @@ static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
+				    struct find_free_extent_ctl *ffe_ctl)
+{
+	if (ffe_ctl->for_treelog) {
+		spin_lock(&fs_info->treelog_bg_lock);
+		if (fs_info->treelog_bg)
+			ffe_ctl->hint_byte = fs_info->treelog_bg;
+		spin_unlock(&fs_info->treelog_bg_lock);
+	} else if (ffe_ctl->for_data_reloc) {
+		spin_lock(&fs_info->relocation_bg_lock);
+		if (fs_info->data_reloc_bg)
+			ffe_ctl->hint_byte = fs_info->data_reloc_bg;
+		spin_unlock(&fs_info->relocation_bg_lock);
+	}
+
+	return 0;
+}
+
 static int prepare_allocation(struct btrfs_fs_info *fs_info,
 			      struct find_free_extent_ctl *ffe_ctl,
 			      struct btrfs_space_info *space_info,
@@ -4217,19 +4235,7 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
 		return prepare_allocation_clustered(fs_info, ffe_ctl,
 						    space_info, ins);
 	case BTRFS_EXTENT_ALLOC_ZONED:
-		if (ffe_ctl->for_treelog) {
-			spin_lock(&fs_info->treelog_bg_lock);
-			if (fs_info->treelog_bg)
-				ffe_ctl->hint_byte = fs_info->treelog_bg;
-			spin_unlock(&fs_info->treelog_bg_lock);
-		}
-		if (ffe_ctl->for_data_reloc) {
-			spin_lock(&fs_info->relocation_bg_lock);
-			if (fs_info->data_reloc_bg)
-				ffe_ctl->hint_byte = fs_info->data_reloc_bg;
-			spin_unlock(&fs_info->relocation_bg_lock);
-		}
-		return 0;
+		return prepare_allocation_zoned(fs_info, ffe_ctl);
 	default:
 		BUG();
 	}
-- 
2.43.0



