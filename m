Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FBD235C3B;
	Thu, 12 Dec 2024 16:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020381; cv=none; b=pXjex7MwzJ8bF+GZMYSXJQoKLCTd16h4sdQ+0zopbLTbZGybm9UCIBy1xe00FxyFZjfusDZbcCkx3KR9qwm85X7S+6z5b/JXiCg9K/tfFvv4/bA7UC9vAYZQWqscIZ1GR6ztLUWcJwzkQT9Qd2XPH2S0FNYAMdQR27SHDmr82fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020381; c=relaxed/simple;
	bh=BwWQeu5WYgoNe3ZL0EvAi5/GgSGVwVh9DliZP3hBntQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odoXzK+WRZv0AlfBPaxWm6sKl7gUe3dq/1Qv0EEF1YimzKO3qfDT89O5M5SoExatzHBYsh2POCIY7GE4NxWrK4ZAvvybUT6QDtqAIzkGr7XE5DuNiCC49cDB+Ekg8hcmS3WezHcG+OEGKq/yGw40fZ0k97jg9QtP2/fFC7qC+Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2CfyBkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2CfyBkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E09C4CECE;
	Thu, 12 Dec 2024 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020381;
	bh=BwWQeu5WYgoNe3ZL0EvAi5/GgSGVwVh9DliZP3hBntQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2CfyBkkr+IVHP+RFy460F/LVfwK8Nth2Cz/Vl+T2kWbUl6TJJbGMdOllCayjx+2Z
	 h6QYc182C2iZOE8xZJgxE9tvDrZyenru18qyom8qP0+zp5/fhhXbnEOYXD8jyGvmLK
	 KO5n71ab8yi2I7LYMjLRDqJFAlJNF+Ke+Wgs+AvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 451/772] btrfs: dont loop for nowait writes when checking for cross references
Date: Thu, 12 Dec 2024 15:56:36 +0100
Message-ID: <20241212144408.564802633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ed67f2a913a4f0fc505db29805c41dd07d3cb356 ]

When checking for delayed refs when verifying if there are cross
references for a data extent, we stop if the path has nowait set and we
can't try lock the delayed ref head's mutex, returning -EAGAIN with the
goal of making a write fallback to a blocking context. However we ignore
the -EAGAIN at btrfs_cross_ref_exist() when check_delayed_ref() returns
it, and keep looping instead of immediately returning the -EAGAIN to the
caller.

Fix this by not looping if we get -EAGAIN and we have a nowait path.

Fixes: 26ce91144631 ("btrfs: make can_nocow_extent nowait compatible")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0d97c8ee6b4fb..2ac060dc65000 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2372,7 +2372,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 			goto out;
 
 		ret = check_delayed_ref(root, path, objectid, offset, bytenr);
-	} while (ret == -EAGAIN);
+	} while (ret == -EAGAIN && !path->nowait);
 
 out:
 	btrfs_release_path(path);
-- 
2.43.0



