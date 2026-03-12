Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49C3FF8AD;
	Thu, 12 Mar 2026 20:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346404; cv=none; b=tCPjn4tb+5qjKMJuQzYSwv8EX0yAENHZOozuKhGmTFlR2DakDLAUJb8h6G2ebMf89nnRqaiS9PGmLZs3zIbE4I8cwG1kw3jsbkryrpKYv1B2RvIVJG4b8pbQqWf3cMcLP9tItYcOMqwejB5f4pvD/lKR2qO+Re+4AsaNNPeYwg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346404; c=relaxed/simple;
	bh=LSM7DUWPhntXvzSGKz7SzNr0XWfZJOV2Ya3+ESc+Jfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5LTLQ9pHjHmwVb6ZNH37LLFqY+SCs+uBOc4Dhz4eD5/6PDhTsyMWgMrC4832E30a8FgrIvD8WRiSeN3rJvnqveFqLADtNjHrNJYcMSs6v8DGS7Onoeg5gu7qXQMVQoJdyUUwxgMc7trXZisUO0K4j35W4rQVqZmJbFRSDvjx0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5d9INSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5d9INSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF3EC4CEF7;
	Thu, 12 Mar 2026 20:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346404;
	bh=LSM7DUWPhntXvzSGKz7SzNr0XWfZJOV2Ya3+ESc+Jfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5d9INSHO8hiSHRnMZDZSZEYEpmTbFCCz64rMhLvYwScLnn5pSfZvYNbNRiDZHwK3
	 Fbu59MpQujxA/YfTeQUJsf7bl57xDQMh2IoVGRiTRt11Qpz4mSwE1T+ZIbJQTIFfOK
	 orhqVb949w8v50N/p701fy9Fo0mlzhUWhI2Fao9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/265] btrfs: fix objectid value in error message in check_extent_data_ref()
Date: Thu, 12 Mar 2026 21:07:01 +0100
Message-ID: <20260312201019.422321357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit a10172780526c2002e062102ad4f2aabac495889 ]

Fix a copy-paste error in check_extent_data_ref(): we're printing root
as in the message above, we should be printing objectid.

Fixes: f333a3c7e832 ("btrfs: tree-checker: validate dref root and objectid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 894136eb443ee..60bba7fbeb351 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1701,7 +1701,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 			     objectid > BTRFS_LAST_FREE_OBJECTID)) {
 			extent_err(leaf, slot,
 				   "invalid extent data backref objectid value %llu",
-				   root);
+				   objectid);
 			return -EUCLEAN;
 		}
 		if (unlikely(!IS_ALIGNED(offset, leaf->fs_info->sectorsize))) {
-- 
2.51.0



