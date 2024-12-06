Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38CF145A16;
	Fri,  6 Dec 2024 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498494; cv=none; b=UKAOeqUI8vWFQkOB1UPYlhVi/d3Ofo3/wsnJ/d8opf1Ukwd6k+O3hfgq/QmEj+L/aAalXbnHzwl9e666TO41aVa9ulkLd86g41QDrHYp/7gDGHr72Rfku2PN6Jv6yWbQwOoTvopV36Amk4oPONHJe9u6s2IDJpm5rJ8jaGkH64s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498494; c=relaxed/simple;
	bh=0Kcqzm3a04BCpXdXIx8mT1KkUkVW/qMNzNWGly4aakw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFxooDNf46T4OYP4YziY707JaAAD/hb02xtVfhB6vREUNAc3JW1mfMfsEPzQWf5kPnLmswH8c9ckZkN7WMdCN6HPUgreimWM2/rhHBQKr0W8K1vUKGiLqj0KeMTd1Jh08PhbACi8OI9j6YBl5oSxKBMcuadNGKzDUHQf71sjoGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vubSNXZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vubSNXZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F3DC4CED1;
	Fri,  6 Dec 2024 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498494;
	bh=0Kcqzm3a04BCpXdXIx8mT1KkUkVW/qMNzNWGly4aakw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vubSNXZlEo+USanWXzvPZuW3he639ipbvI/EQ6o1EC/XtZEtOKAUIjb2iE0qrKfju
	 c496qvGk4C3Zal5iOxu0abPjTRTIaSvysDSBFRCxOWZSmwC2KhXEfcVDehiJmnW4sS
	 4JDho7kfaL091crb44CQevBK57b97cjeJyE3gG4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 602/676] btrfs: dont loop for nowait writes when checking for cross references
Date: Fri,  6 Dec 2024 15:37:01 +0100
Message-ID: <20241206143716.886175562@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 94fc86c9c65e4..487697e8bc707 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2401,7 +2401,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 			goto out;
 
 		ret = check_delayed_ref(root, path, objectid, offset, bytenr);
-	} while (ret == -EAGAIN);
+	} while (ret == -EAGAIN && !path->nowait);
 
 out:
 	btrfs_release_path(path);
-- 
2.43.0



