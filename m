Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10097332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301212; cv=none; b=IqUMXuwwaPXBjwkgD5JjTmRU2JFlNFejYodkYCk3zt69ky4mrlIGfHdD6Irn1EvSkBkY/xBjz9ZFXoe0RWQzJIjVc3lKHL6AcchdgXq6UZ0TPWO/oc1FHiGwD89wTdtW9LpSYq2i3lTqACpV/2XElwz4B4P5jHydyQKvDJuY6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301212; c=relaxed/simple;
	bh=QNJAmvurprybDStIbyUnN02wlnbyXz4+HSOrha8xwi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj/Lb6oJa+OMDvP5wi7w7Bmpe8O3yNwpikBVuB9T5Pyywxpy8lMfHxgnUQY3f9YSNMCsvKNeIe3KOvTkwgM4QH4Y1whXu3G628ubZp8ddO6UjOre6Fl7O4wdX8lnQ0e2SRkBjCASeXvaGV/i1tusQwi5zjy9eYvq/bp5EJgA1Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOMfxrrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOMfxrrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60055C116D0;
	Sat, 28 Feb 2026 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301211;
	bh=QNJAmvurprybDStIbyUnN02wlnbyXz4+HSOrha8xwi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOMfxrrH8730iA2L90k3GiWMlWeXYqXyjcbTfW50G0qZR+MNmEEertZPX4ocMIm+k
	 NIj0T2/kme3SXHMbEHpdQwY/ciUZvGBy7hmBHaaR3ERtWO8wfoznncDQA75PFm39wR
	 7O78wAb2mqaYwHrzkc3E2Q3qlOBh7ssnwunEnIo2dXxuAQGX/SjRESya1mi2atAtfz
	 qW4djxaHIoku95htV5VgAWw0FOn8fSM+eWNoodhobq3EO05sJOe+EJHEsdzIAmLAN3
	 WOKMNpC906U9hiANv/Lq08RQm0uSgcQjSgPH4HJK9FHKiMrbNW6728Hbil6u/OEQ3H
	 MGZaDg1SyJI4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Adarsh Das <adarshdas950@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 387/752] btrfs: replace BUG() with error handling in __btrfs_balance()
Date: Sat, 28 Feb 2026 12:41:38 -0500
Message-ID: <20260228174750.1542406-387-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Adarsh Das <adarshdas950@gmail.com>

[ Upstream commit be6324a809dbda76d5fdb23720ad9b20e5c1905c ]

We search with offset (u64)-1 which should never match exactly.
Previously this was handled with BUG(). Now logs an error
and return -EUCLEAN.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 645bf98a9571b..4a1dc4720a0ba 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4264,8 +4264,14 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		 * this shouldn't happen, it means the last relocate
 		 * failed
 		 */
-		if (ret == 0)
-			BUG(); /* FIXME break ? */
+		if (unlikely(ret == 0)) {
+			btrfs_err(fs_info,
+				  "unexpected exact match of CHUNK_ITEM in chunk tree, offset 0x%llx",
+				  key.offset);
+			mutex_unlock(&fs_info->reclaim_bgs_lock);
+			ret = -EUCLEAN;
+			goto error;
+		}
 
 		ret = btrfs_previous_item(chunk_root, path, 0,
 					  BTRFS_CHUNK_ITEM_KEY);
-- 
2.51.0

