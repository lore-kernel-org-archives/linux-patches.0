Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5A3AD4B;
	Fri, 31 Oct 2025 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919325; cv=none; b=Fxnlk0vqDGVsPDA7hm4IhQrauuQ8lqbu5eF4dIpqWqEKZIOoTKCV/5oD5LKVP50aSXsqR0AP7KVIqAJmuNbkC0yj+k8D85E+/nJFPy4o2FzIEp/lkIoMYRLsh6GefJAsUWj2SICT64nFjle1dfQLgDim1q9Daz29SNCge4bSBtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919325; c=relaxed/simple;
	bh=eoKZOm/HbBDyol1DMGy32x3k2d9nNzErbPHyXxkoJmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljQXcMpLp/s3xJK0QgCq+5CM+HPKoAjhx4t6hAU4pRpofA1uogqDOV42n2K2b42HACLhmUQPZCH6inYt3ny4bphPWrzOjm8GNxopsLlGMb28N0YsBBqmePFyPxpkXAQaw2gJCjHVupol3OCYyQ25r6ybvMrA5YLhP6UVxMlowCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nibmNvfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nibmNvfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0662CC4CEE7;
	Fri, 31 Oct 2025 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919325;
	bh=eoKZOm/HbBDyol1DMGy32x3k2d9nNzErbPHyXxkoJmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nibmNvfLQfQYgunPA7Z4+bXStJIc9W/UgSr7+o6f5c9Sv8mzhYk4dlppfF6rXWpaO
	 bZlrqV8CjzSm4rbhSsRJPI9uQIhHqQ6FxhrOHf4qFv9ErDMKsmtT+LcH4r3HqZX486
	 WeAtpJKsnsQG7TLSRFOpsbk8/Pw7EE8qwiwi+vuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/32] btrfs: use level argument in log tree walk callback replay_one_buffer()
Date: Fri, 31 Oct 2025 15:01:07 +0100
Message-ID: <20251031140042.741733838@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6cb7f0b8c9b0d6a35682335fea88bd26f089306f ]

We already have the extent buffer's level in an argument, there's no need
to first ensure the extent buffer's data is loaded (by calling
btrfs_read_extent_buffer()) and then call btrfs_header_level() to check
the level. So use the level argument and do the check before calling
btrfs_read_extent_buffer().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e00298c6c30a1..5512991b24faa 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2493,15 +2493,13 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 	int i;
 	int ret;
 
+	if (level != 0)
+		return 0;
+
 	ret = btrfs_read_extent_buffer(eb, &check);
 	if (ret)
 		return ret;
 
-	level = btrfs_header_level(eb);
-
-	if (level != 0)
-		return 0;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-- 
2.51.0



