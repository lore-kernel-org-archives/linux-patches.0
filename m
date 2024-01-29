Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBC776037;
	Mon, 29 Jan 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548621; cv=none; b=VGjedv7Wm4d30K/RQZufR512KVVwOvF4h+Vdc0iAIYIKV+UxuUWyioX/TIaljoCqQcYc8JwKOvMZCMGZwVHUrY3Wq/1u1bkJiIFjFWAkMdye5PUbOf0fe4kdXJzXPhyJz34ZZG09ccZGBGoKc4GWBx3+hGqnGNErFLyZyZ2b+d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548621; c=relaxed/simple;
	bh=TWAZc+xEwsZvokyEKTmx1oWh60patQ/CHySeFkVqp5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWO58AKgmjYXYgMYc8z5m5Uku1DZf/QI2DSCxYhqiJlIlfB3yxIuX2bX87xuBodM+0XWJ3ENV2ugNBgTx6f6B8tdmWs9RQhsACur9Xs5dWK9MayzxHqYFbG2I5MSrm9CC54Acr9o6Wdh8N9jJZnx9qpJhvomg2dowJF/SkZGt84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pENj1vJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pENj1vJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3520EC43399;
	Mon, 29 Jan 2024 17:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548621;
	bh=TWAZc+xEwsZvokyEKTmx1oWh60patQ/CHySeFkVqp5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pENj1vJOMgk2rSAcW38ZyBnk2skEtZEiG4YOMWSGKGUuPSA/3bzqVnlpf/o+esyFe
	 IW86g7u+U1TndiadI2WDpVroMqnTW8G70urOf5iaGVq6c747P6AIt2y1wvqtzcAVhO
	 p0029Dkqn+aqwXLcD7u49l58pWsugjI1La6aUyOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/331] btrfs: zoned: factor out prepare_allocation_zoned()
Date: Mon, 29 Jan 2024 09:05:55 -0800
Message-ID: <20240129170023.371627498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d421e289dc73..69abb6eb81df 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4139,6 +4139,24 @@ static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
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
@@ -4149,19 +4167,7 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
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



