Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5453502BD;
	Fri, 21 Nov 2025 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733532; cv=none; b=GRDdezcSs5xOw1X0xqteY4tmW9rNlSfvLyxFI4goTPNX4WdLMqItVJiwT+CKnDAGsQK7N/JzXF864iEvnDdIMv9kxM1ulpwDnPuZS8JxMF63FbX/ZcVwIxNqxoyfWKGYrUm/hojxnNU4vVK2VwdIJLEJ1rCmQkqglnf9L/CMMtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733532; c=relaxed/simple;
	bh=mSw7QtI3fJm7wZH/9fsEAdYECq6/WMOe7Nx9OXDwF5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6Nnh6mWpVvYkMRevPygYcv54aGgkBtJcLW4aH6YzyVfOxtd0rJ/UMpU/4p2Gy2HXkp3XWODaA1up/1JEE7L9GfVRE6v1aJ+6JyJypJyUecmcBnJFI0ZY/xxt+n0+Fy4BY/opuXA16/gqoWokJvrwAyFxLfCND3aYrjPE4zzRLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um08BDH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um08BDH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83C0C4CEF1;
	Fri, 21 Nov 2025 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733532;
	bh=mSw7QtI3fJm7wZH/9fsEAdYECq6/WMOe7Nx9OXDwF5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um08BDH0qJ5xga8mCDG8qrG8rZnuZt5eR02wmGjTgcjZJa62b66xuRGEgZRa0hbRM
	 mFHMh65NxWvk0OZaJsmgjPxR9x63Zanj9caynBx+DyWSl1OZK04OdpUvE+gZqcYhDb
	 y+PEVXVLxJpGGE8bH1eIuerZEAzGtEIJVffgw1aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.6 501/529] f2fs: fix to avoid overflow while left shift operation
Date: Fri, 21 Nov 2025 14:13:20 +0100
Message-ID: <20251121130248.841654695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0fe1c6bec54ea68ed8c987b3890f2296364e77bb ]

Should cast type of folio->index from pgoff_t to loff_t to avoid overflow
while left shift operation.

Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Modification: Using rpages[i]->index instead of folio->index due to
it was changed since commit:1cda5bc0b2fe ("f2fs: Use a folio in
f2fs_truncate_partial_cluster()") on 6.14 ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1209,7 +1209,7 @@ int f2fs_truncate_partial_cluster(struct
 		int i;
 
 		for (i = cluster_size - 1; i >= 0; i--) {
-			loff_t start = rpages[i]->index << PAGE_SHIFT;
+			loff_t start = (loff_t)rpages[i]->index << PAGE_SHIFT;
 
 			if (from <= start) {
 				zero_user_segment(rpages[i], 0, PAGE_SIZE);


