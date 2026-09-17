Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CE04E73D1;
	Thu, 17 Sep 2026 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659263; cv=none; b=MC93sdXI2PG/JdoqW4QSgtpm5OejzczRBgQOKEBzKkx4lthmbgFS6LYrR9uwFh0OT6+oEinIHD22y1+WOgQZJD893ILV9dun+h7bThimjF2ss3+tJ5/pvPOXb0ZFqQbf78Q/FnFtEeahkcprGvEO5EaD6HFkjwWVSWwcngpliOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659263; c=relaxed/simple;
	bh=GIpkshkCk/TFxsHveOuWWJfCaITfktVMwTfRuu7gU6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdC55qea2nJGJgX9pohM5YyRFkAVuyYzVI+czt3JZg+XZRGRdnWRDMF4TrEmhY1HRf4JoKFgHYB5O6ElDfWgS2Uf2388+jO1SiGHdnCVdEhNBy/Rktrxb9+wW3av9H07ptoP0Xa/8spoE5MZFC+qLuT3OGID7JNe9LEEHb3Oltk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD7TywTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD7TywTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CC91F00898;
	Thu, 17 Sep 2026 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659254;
	bh=ceIoBpw4jcOhGl8IpcgYi+setd4GT0p+Uohty0/IkbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD7TywTsxLYR+MlynrecsxSEFwbQHxHqKJoshP+YjMMHJvLRMC+qKl9z8v7HrEqA1
	 WL1EgwuhVA62CfPgBmgiNkQkzmmxBTCQ0+DEE2LNH25Qku8uMXbYXoMQHJRaqLGdse
	 ciCbYe4QqX+wNIiN2nYvN+gBgLtXiWDmM7CjldWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 194/733] btrfs: return proper negative error code for update_raid_extent_item()
Date: Thu, 17 Sep 2026 16:08:22 +0100
Message-ID: <20260917151355.988000326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a03fa65184545837d6461413275da71f30527385 ]

The function btrfs_abort_transaction() only accepts negative error code,
and have the macro VERIFY_NEGATIVE_ERROR() to verify that error code.

But inside update_raid_extent_item(), if there is such key found, we
return 1, breaking the negative error code scheme.

Furthermore if we hit some real error during the tree search, e.g. -EIO,
then the error code is always over-written to -EINVAL.

Fix both problems by following other call sites by overwriting @ret to
-ENOENT if the btrfs_search_slot() failed to locate the key.

This is very unlikely to hit, as we only enter update_raid_extent_item()
if there is a conflicting key already in the raid stripe tree.

This was reported by Sashiko when reviewing another patch.

Link: https://sashiko.dev/#/patchset/20260817021512.3010812-1-shuangpeng.kernel%40gmail.com
Fixes: 8c4cba2adbb0 ("btrfs: update stripe extents for existing logical addresses")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid-stripe-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 6291775dbe0e7..d9e660447205f 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -310,8 +310,10 @@ static int update_raid_extent_item(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, trans->fs_info->stripe_root, key, path,
 				0, 1);
-	if (ret)
-		return (ret == 1 ? ret : -EINVAL);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ret;
 
 	leaf = path->nodes[0];
 	slot = path->slots[0];
-- 
2.53.0



